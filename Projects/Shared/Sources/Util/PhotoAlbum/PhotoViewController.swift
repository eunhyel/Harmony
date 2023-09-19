//
//  PhotoViewController.swift
//  Example
//
//  Created by daiki-matsumoto on 2018/08/08.
//  Copyright © 2018 Cybozu. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import SwiftyJSON
import AVKit
import Alamofire


open class PhotoViewController: UIViewController, StoryboardBased {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var photo_view: UIView!
    @IBOutlet weak var albums_btn: UIButton!
    @IBOutlet weak var back_btn: UIButton!
    @IBOutlet weak var next_btn: UIButton!
    @IBOutlet weak var photo_stackView: UIStackView!
    
    @IBOutlet weak var albums_imageView: UIImageView!
    @IBOutlet weak var title_view: UIView!
    
    private var disposeBag = DisposeBag()
    private var attachmentInput: AttachmentInput!
    public var viewModel = PhotoViewModel()
    private var dataSource: RxCollectionViewSectionedAnimatedDataSource<PhotoViewController.SectionOfPhotoData>!
    
    internal var albumsManager = PLAlbumManager()
    
    var uploadSelect: ((String) -> Void)?
    var pageData = [UIImage]()
    
    var galleryType : galleryType?
    
    var jsonData = JSON()
    
    var albmList : PhotoAlbumView? = nil
    let albmUpImage = UIImage(named: "bulletUp")
    let albmDownImage = UIImage(named: "bulletDown")
    
    deinit {
        log.d("사진뷰 해제")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionView()
        self.setupAttachmentInput()
    }
    
    public static func open(controller : UIViewController, data : JSON = JSON()){
        guard let vc = UIStoryboard(name: "PhotoMain", bundle: Bundle(for: Shared.self)).instantiateViewController(withIdentifier: "PhotoViewController") as? PhotoViewController else { return }
            vc.jsonData = data
            controller.present(vc, animated: false, completion: nil)
    }

    private func setupCollectionView() {
        self.collectionView?.delegate = nil
        self.collectionView?.dataSource = nil
        self.collectionView?.isHidden = true
        
        self.dataSource = RxCollectionViewSectionedAnimatedDataSource<PhotoViewController.SectionOfPhotoData>(configureCell: {
            (_: CollectionViewSectionedDataSource<PhotoViewController.SectionOfPhotoData>, collectionView: UICollectionView, indexPath: IndexPath, item: PhotoData) in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
            cell.setup(data: item, delegate: self)
            return cell
        }, configureSupplementaryView: { _,_,_,_ in
            fatalError()
        })

        self.viewModel.dataList.map { data in
                var ret = [SectionOfPhotoData]()
                ret.append(SectionOfPhotoData.Photos(items: data))
                if data.count <= 0 {
                    UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: {
                        self.collectionView.isHidden = true
                        self.collectionView.layoutIfNeeded()
                    }, completion: nil)
                    self.next_btn.setTitleColor(UIColor(rgbF: 188), for: .normal)
                    self.next_btn.isEnabled = false
                }
                else {
                    if data.count == 1 {
                        UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: {
                            self.collectionView.isHidden = false
                            self.collectionView.layoutIfNeeded()
                        }, completion: nil)
                        self.next_btn.setTitleColor(UIColor(redF: 255, greenF: 68, blueF: 114), for: .normal)
                        self.next_btn.isEnabled = true
                    }
                    else if data.count > 5 {
                        self.collectionView.layoutIfNeeded()
                    }
                }
                return ret
            }.bind(to: self.collectionView!.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
        
        albums_btn.rx.tap
            .asDriver()
            .drive(onNext: { (_) in
                self.albums_btn.isSelected = !self.albums_btn.isSelected
                
                if self.albums_btn.isSelected {
                    self.albums_imageView.image = self.albmUpImage
                    self.albmList = PhotoAlbumView(frame: .zero)
                    self.albmList?.albumsManager = self.albumsManager
                    
                    //앨범 선택 닫기
                    self.albmList?.didSelectAlbum = { [weak self] album in
                        self!.albums_imageView.image = self?.albmDownImage
                        self?.setAlbum(album)
                        self?.albums_btn.setTitle(album.title, for: .normal)
                        self?.albums_btn.isSelected = false
                        self?.attachmentInput.collectionView.setContentOffset(CGPoint.zero, animated: false)
                    }
                    //그냥 닫기
                    self.albmList?.removeAlbm = {
                        self.albums_imageView.image = self.albmDownImage
                        self.albums_btn.isSelected = false
                    }
                    
                    self.view.addSubview(self.albmList ?? PhotoAlbumView(frame: .zero))
                    self.albmList?.snp.makeConstraints{
                        $0.top.equalTo(self.title_view.snp.bottom)
                        $0.left.right.bottom.equalToSuperview()
                    }
                }
                else {
                    self.albmList?.removeFromSuperview()
                }
            }).disposed(by: disposeBag)
        
        
        back_btn.rx.tap
            .asDriver()
            .drive(onNext: { (_) in
                if self.albums_btn.isSelected {
                    self.albmList?.removeFromSuperview()
                    self.albums_btn.isSelected = false
                    self.albums_imageView.image = self.albmDownImage
                }
                else {
                    self.close()
                    self.dismiss(animated: true, completion: nil)
                }
            }).disposed(by: disposeBag)
        
        
        next_btn.rx.tap
            .asDriver()
            .drive(onNext: { (_) in
                //1개 비디오만 있으면 비디오 편집으로 이동
                if self.viewModel.dataListValue.count == 1 && self.viewModel.dataListValue.first?.isVideo == true{
                    DispatchQueue.main.async {
                            guard let vc = UIStoryboard(name: "NewVideoRegister", bundle: Bundle(for: Shared.self)).instantiateViewController(withIdentifier: "NewvideoEditor") as? NewVideoEditorController else {
                                return
                            }

                            vc.isPhotoRecord = false
                            vc.videoURL = self.viewModel.dataListValue.first?.fileURL
                            vc.bridgeData = self.jsonData
                            self.present(vc, animated: true, completion: nil)
                    }
                }
                else {
                    let videoFound = self.viewModel.dataListValue.filter({$0.isVideo == true})

                    //비디오가 비어있으면 모두 사진이다
                    if videoFound.isEmpty {
                        self.cropOpen({ images in
                            if !self.jsonData["getCrop"].isEmpty {
                                log.d(self.jsonData)
                                guard let editorVC = UIStoryboard(name: "NewImageCrop", bundle: Bundle(for: Shared.self)).instantiateViewController(withIdentifier: "newimageEditor") as? NewImageEditorViewController else {
                                    return
                                }

                                editorVC.modalPresentationStyle = .fullScreen
                                editorVC.pageData = images
                                editorVC.photoVC = self
                                editorVC.bridgeData = self.jsonData
                                editorVC.didSelect = { [weak self] image in
                                    self?.pageData = image
                                    self?.uploadMuti()
                                }
                                self.present(editorVC, animated: true, completion: nil)
                            }
                            else {  //편집없이 업로드
                                self.uploadMuti()
                            }
                        })
                    }
                    else {      //비디오, 사진 같이 있으면 편집 없이 그냥 업로드
                        self.uploadMuti()
                    }

                }
            }).disposed(by: disposeBag)
    }
    
    
    func cropOpen(_ completion : (([UIImage]) -> Void)!){
        var images = [UIImage]()
            for i in 0..<viewModel.dataListValue.count {
                images.append(viewModel.dataListValue[i].image!)
            }
            if let completion = completion{
                completion(images)
            }
    }

    private func setupAttachmentInput() {
        let config = AttachmentInputConfiguration()
        config.jsonData = jsonData
        
        if jsonData["cmd"].stringValue == "getMedias"{
            config.maxVideo = jsonData["maxVideo"].intValue
            config.maxPhoto = jsonData["maxPhoto"].intValue
            config.maxSelect = jsonData["maxSelect"].intValue
            config.maxFiles = jsonData["maxFiles"].intValue
            
            config.curPhoto = jsonData["curPhoto"].intValue
            config.curVideo = jsonData["curVideo"].intValue
            
            
            config.minVideoTime = jsonData["minSec"].doubleValue
            config.maxVideoTime = jsonData["maxSec"].doubleValue
        }
        else {
            config.maxPhoto = jsonData["photoCount"].intValue
        }
        
        
        
        let uploadAbleNum = jsonData["maxFiles"].intValue - (jsonData["curPhoto"].intValue + jsonData["curVideo"].intValue)  //전체 가능 갯수에서 현재 올려진 사진 빼고 올릴수 있는 사진 갯수
        
        let selectVideo = jsonData["maxVideo"].intValue - jsonData["curVideo"].intValue
        
        //log.d(selectVideo)
        //log.d(uploadAbleNum)
        
        
        
        config.maxVideo = selectVideo
        if uploadAbleNum < jsonData["maxSelect"].intValue { //최대 선택 갯수보다 적게 선택 가능하면 그 값으로 바꿔줌
            config.maxSelect = uploadAbleNum
        }
        
        //log.d(config.maxSelect)
        

        //앨범 타입 설정
        switch jsonData["mode"].stringValue {
        case "image":
            config.galleryType = .photo
        case "video":
            config.galleryType = .video
        case "multi":
            config.galleryType = .all
        default:
            config.galleryType = .photo
        }
        
        
        attachmentInput = AttachmentInput(configuration: config)
        attachmentInput.delegate = self
        attachmentInput.view.frame = photo_view.bounds
        photo_view.addSubview(attachmentInput.view)
    }

    open override var canBecomeFirstResponder: Bool {
        return true
    }

    enum SectionOfPhotoData {
        case Photos(items: [PhotoData])
    }
    
    
    func setAlbum(_ album: PLAlbum) {
        self.albums_btn.titleLabel!.text = album.title
        self.attachmentInput.changeImage(asset: album.collection!)
    }
    
    
    func scrollMove(){
        if self.collectionView.contentSize.width > UIScreen.main.bounds.width {
            let point = self.collectionView.contentSize.width - self.collectionView.frame.size.width + 65
            self.collectionView.setContentOffset(CGPoint(x: point, y: self.collectionView.contentOffset.y), animated: true)
        }
    }
    
    
    //메모리 삭제
    func close() {
        guard let attachmentInput = attachmentInput else { return }
        attachmentInput.clearAll()
        attachmentInput.collectionView.removeFromSuperview()
        attachmentInput.view.removeFromSuperview()
        dataSource = RxCollectionViewSectionedAnimatedDataSource<PhotoViewController.SectionOfPhotoData>(configureCell: {
            (_: CollectionViewSectionedDataSource<PhotoViewController.SectionOfPhotoData>, collectionView: UICollectionView, indexPath: IndexPath, item: PhotoData) in
            let cell = UICollectionViewCell()
            return cell
        }, configureSupplementaryView: { _,_,_,_ in
            fatalError()
        })
        viewModel = PhotoViewModel()
        albumsManager = PLAlbumManager()
        disposeBag = DisposeBag()

        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    
    
    func uploadMuti(_ completion :( () -> Void)? = nil){
        //로딩바 호출
        let loading = UploadingView(frame: .zero)
        view.addSubview(loading)
        loading.snp.makeConstraints{
            $0.top.left.right.bottom.equalToSuperview()
        }
        
        //올릴거 없으면 끝내고
            if viewModel.dataListValue.isEmpty {
                if let completion = completion{
                    completion()
                }
            }
            else {
                //올릴꺼 있으면 올린다
                let myGroup = DispatchGroup()       //순차 실행을 위해
                DispatchQueue.global(qos: .userInitiated).async {
                    for i in 0..<self.viewModel.dataListValue.count {
                        let fileSlct = self.viewModel.dataListValue[i].isVideo == false ? "p" : "v"
                        let uploadURL = self.viewModel.dataListValue[i].fileURL?.path

                        log.d("컨버팅할꺼다")

                        myGroup.enter()

                        var videoData: Data!
                        self.chageResolution(sourceURL: URL(fileURLWithPath: uploadURL!), fileSlct: fileSlct, completion: { uploadURL in
                            if fileSlct == "v" {
                                do {
                                    videoData = try Data(contentsOf: URL(fileURLWithPath: uploadURL.path))
                                } catch let error {
                                    print(error)
                                    return
                                }
                            }

                        log.d("컨버팅 끝")
                        log.d("포토서버 업로드할꺼다")
                            
                                Task {
                                   await self.uploadMuti(data: self.jsonData,
                                                                  imageData: self.viewModel.dataListValue[i].image?.jpegData(compressionQuality: 1.0) ?? Data(),
                                                                  videoData: videoData ?? Data(),
                                                                  fileSlct: fileSlct,
                                                                  fileCurIdx: i + 1,
                                                                  fileMaxCount: self.viewModel.dataListValue.count,
                                                    captureTime: 0, {
                                        log.d("하나 끝")
                                    
                                    self.removeFileAtURLIfExists(url: uploadURL)
                                                            myGroup.leave()
                                       })
                                }

                        })

                        myGroup.wait()
                    }

                    
                        //마지막 업로드이면 닫아준다
                    myGroup.notify(queue: .main){
                        if let completion = completion{
                            completion()
                        }
                        //log.d("완전 끝")
                        self.close()
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
            
    }
    
    
    // 해상도 변환 1920 1080
    func chageResolution(sourceURL: URL, fileSlct: String, completion: ((URL) -> Void)?) {
        let asset = AVAsset(url: sourceURL)
        let maxSize = CGSize(width: 1920, height: 1080)
        let videoSize = sourceURL.resolutionForLocalVideo()
        //사진이면 리턴
        if fileSlct == "p" {
            if let completion = completion {
                completion(sourceURL)
            }
        }
        
        guard let size = videoSize else {
            return
        }
        
        //해상도 비교해서 크면 변환해주기
        if size.width > maxSize.width && size.height > maxSize.height {
            
            var destURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            destURL!.appendPathComponent("clubIosVideoFile.mp4")
            
            let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetMediumQuality)
            exportSession?.outputURL = destURL
            exportSession?.outputFileType = AVFileType.mp4
            exportSession?.shouldOptimizeForNetworkUse = true
            let start = CMTimeMakeWithSeconds(0.0, preferredTimescale: 0)
            let range = CMTimeRangeMake(start: start, duration: asset.duration)
            exportSession?.timeRange = range
            
            exportSession?.exportAsynchronously {
                if let completion = completion {
                    completion(destURL ?? sourceURL)
                }
            }
        }
        else {
            if let completion = completion {
                completion(sourceURL)
            }
        }

    }
        
}

extension PhotoViewController: ImageCellDelegate {
    func tapedRemove(fileId: String, isVideo: Bool) {
        self.attachmentInput.removeFile(identifier: fileId, isVideo: isVideo)
        self.viewModel.removeData(fileId: fileId)
    }
}

extension PhotoData: IdentifiableType {
    typealias Identity = String
    var identity: String {
        return self.fileId
    }
}

extension PhotoViewController.SectionOfPhotoData: AnimatableSectionModelType {
    typealias Item = PhotoData
    typealias Identity = String
    
    var identity: String {
        return "PhotoSection"
    }
    
    var items: [PhotoData] {
        switch self {
        case .Photos(items: let items):
            return items
        }
    }
    
    init(original: PhotoViewController.SectionOfPhotoData, items: [PhotoData]) {
        self = .Photos(items: items)
    }
}

extension PhotoViewController: AttachmentInputDelegate {
    
    public func inputImage(fileURL: URL, image: UIImage, fileName: String, fileSize: Int64, fileId: String, imageThumbnail: UIImage?) {
        scrollMove()
        self.viewModel.addData(fileURL: fileURL, fileName: fileName, fileSize: fileSize, fileId: fileId, imageThumbnail: imageThumbnail)
    }
    
    public func inputMedia(fileURL: URL, fileName: String, fileSize: Int64, fileId: String, imageThumbnail: UIImage?, isVideo: Bool) {
        scrollMove()
        self.viewModel.addData(fileURL: fileURL, fileName: fileName, fileSize: fileSize, fileId: fileId, imageThumbnail: imageThumbnail, isVideo: true)
    }
    
    public func removeFile(fileId: String) {
        self.viewModel.removeData(fileId: fileId)
    }
    
    public func imagePickerControllerDidDismiss() {
        // Do nothing
    }
    
    public func onError(error: Error) {
        let nserror = error as NSError
        if let attachmentInputError = error as? AttachmentInputError {
            print(attachmentInputError.debugDescription)
        } else {
            print(nserror.localizedDescription)
        }
    }
}

extension URL {
     func resolutionForLocalVideo() -> CGSize? {
        guard let track = AVURLAsset(url: self).tracks(withMediaType: AVMediaType.video).first else { return nil }
        let size = track.naturalSize.applying(track.preferredTransform)
        return CGSize(width: abs(size.width), height: abs(size.height))
    }
}


extension PhotoViewController {
    func uploadMuti(data : JSON, imageData: Data, videoData: Data, fileSlct : String, fileCurIdx: Int = 1, fileMaxCount : Int = 1,captureTime: Int, _ completion :( () -> Void)? = nil ) async {
            //포토서버 사용량 때문에 사진이랑 동영상 분기처리 URL
            let url = fileSlct == "p" ? data["photoUploadPath"] : data["mediaUploadPath"]
        
            let response = await AF.upload(
                multipartFormData: { (multipartFormData) -> Void in
                    multipartFormData.append(videoData, withName: "videofile", fileName: "clubIosVideoFile.mp4", mimeType: "application/octet-stream")
                    multipartFormData.append(imageData, withName: "imagefile", fileName: "clubIosImageFile.jpg", mimeType: "image/jpeg")
                    multipartFormData.append(data["memNo"].stringValue.data(using: .utf8) ?? Data(), withName:"memNo")
                    multipartFormData.append(data["uploadType"].stringValue.data(using: .utf8) ?? Data(), withName:"type")
                    multipartFormData.append(fileSlct.data(using: .utf8) ?? Data(), withName:"fileSlct")
                }, to: url.stringValue)
                .serializingResponse(using: .string).response
        
        
            switch response.result {
            case .success(_):
                if let result = response.value {
                    var jsonResult = JSON(result)
                    jsonResult["fileCurIdx"] = JSON(fileCurIdx)
                    jsonResult["fileMaxCount"] = JSON(fileMaxCount)
                    jsonResult["captureTime"] = JSON(captureTime)
                    
                    log.d(jsonResult)
                    do {
                        let rawData = try jsonResult.rawData()
                        let rawString = String(data: rawData, encoding: .utf8)!
                        
                        //포토서버에 올렸으니 스크립트 쏠 데이터 전송
                        self.uploadSelect?(rawString)
                        //getNavigationController().topViewController?.getBridge()?.callScript("javascript:\(data["funcName"].stringValue)('\(rawString)')")
                    } catch let error {
                        log.d(error)
                    }
                    
                    if let completion = completion{
                        completion()
                    }
                }
            case .failure(let error):
                log.d(error)
                if let completion = completion {
                    completion()
                }
            }
    }
    
    func removeFileAtURLIfExists(url: URL) {
        let filePath = url.path
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath) {
            do {
                try fileManager.removeItem(atPath: filePath)
            } catch let error {
                print("Couldn't remove existing destination file: \(error)")
            }
        }
    }
}
