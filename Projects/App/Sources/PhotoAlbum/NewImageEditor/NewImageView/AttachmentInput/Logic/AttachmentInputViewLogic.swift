//
//  AttachmentInputViewLogic.swift
//  AttachmentInput
//
//  Created by daiki-matsumoto on 2018/02/28.
//  Copyright © 2018 Cybozu, Inc. All rights reserved.
//

import Foundation
import Photos
import RxSwift
import UIKit
import Shared

class AttachmentInputViewLogic {
    private static let PHOTO_TILE_THUMBNAIL_LENGTH: CGFloat = 128
    static let PHOTO_TILE_THUMBNAIL_SIZE = CGSize(width: PHOTO_TILE_THUMBNAIL_LENGTH, height:  PHOTO_TILE_THUMBNAIL_LENGTH)
    var isCamera = false
    
    private var disposeBag = DisposeBag()
    // imageManager is "lazy" because display the permission dialog at the first use timing
    lazy public var imageManager = PHImageManager()
    private let configuration: AttachmentInputConfiguration
    private var pHFetchResultSubject = BehaviorSubject<PHFetchResult<PHAsset>?>(value: nil)
    private var photosWithStatusSubject = BehaviorSubject<[(photo: AttachmentInputPhoto, status: AttachmentInputPhotoStatus, selectIndex: AttachmentInputPhotoSelectIndex)]>(value: [])
    private let fileManager = FileManager.default
    
    // Status and Photos are managed separately
    // Because Photos is changed every time an image stored in the terminal is updated,
    // Status is not updated when changing files in the terminal
    public var statusDictionary: Dictionary<String, AttachmentInputPhotoStatus> = [:]
    public var selectIndex: Dictionary<String, AttachmentInputPhotoSelectIndex> = [:]
    
    public var navigationController : UINavigationController = UINavigationController.defauleNavigation()
    
    weak var delegate: AttachmentInputDelegate?

    // input
    let pHFetchResultObserver: AnyObserver<PHFetchResult<PHAsset>?>
    
    // output
    var pHFetchResult: PHFetchResult<PHAsset>? {
        return self.pHFetchResultSubject.value(nil)
    }
    var photosWithStatus: Observable<[(photo: AttachmentInputPhoto, status: AttachmentInputPhotoStatus, selectIndex: AttachmentInputPhotoSelectIndex)]>
    
    init(configuration: AttachmentInputConfiguration) {
        self.configuration = configuration
        self.pHFetchResultObserver = self.pHFetchResultSubject.asObserver()
        self.photosWithStatus = self.photosWithStatusSubject.asObservable()
        self.pHFetchResultSubject.unwrap()
            .map { [weak self] fetchResult in
                return self?.loadPhotosWithStatus(pHFetchResult: fetchResult) ?? []
            }.subscribe(onNext: { [weak self] photosWithStatus in
                self?.photosWithStatusSubject.onNext(photosWithStatus)
            }).disposed(by: self.disposeBag)
    }

    func removeFile(identifier: String, isVideo: Bool) {
        if self.statusDictionary[identifier]?.status == nil {
            return
        }
        
        if self.statusDictionary[identifier]?.status != .unSelected {
            let search = self.selectIndex.filter({$0.value.index >= self.selectIndex[identifier]!.index })
            for i in search {
                i.value.input.onNext(i.value.index - 1)
            }
            
            if isVideo { //비디오를 선택했으면
                self.configuration.currentVideoCount -= 1
            }
            self.statusDictionary[identifier]?.input.onNext(.unSelected)
        }
    }

    func addNewImage(data: Data) {
        if let image = UIImage(data: data) {
            self.addNewImage(image: image, data: data)
        }
    }

    func addNewImageAfterCompress(image: UIImage) {
        if let imageData = AttachmentInputUtil.compressImage(image: image, photoQuality: self.configuration.photoQuality) {
            self.addNewImage(image: image, data: imageData)
        }
    }
    
    func isSelectExceed() -> Bool{
        if self.configuration.maxSelect <= self.statusDictionary.filter({$0.value.status == .selected}).count {
            Toast.show("최대 \(self.configuration.maxSelect)개까지 선택할 수 있습니다.", controller: navigationController)
            return true
        }
        else {
            return false
        }
    }
    
    
    func isVideoSelectExceed() -> Bool{
        if self.configuration.maxVideo <= self.configuration.currentVideoCount {
            Toast.show("동영상은 최대 \(self.configuration.maxVideo)개까지 선택할 수 있습니다.", controller: navigationController)
            return true
        }
        else{
            return false
        }
    }

    // Create file name and add photo
    private func addNewImage(image: UIImage, data: Data) {
        let fileSize = Int64(data.count)
        if self.configuration.fileSizeLimit <= fileSize {
            self.onError(error: AttachmentInputError.overLimitSize)
            return
        }
        let fileName = "image " + AttachmentInputUtil.datetimeForDisplay(from: Date()) + ".jpeg"
        let id = NSUUID().uuidString
        if let _ = AttachmentInputUtil.resizeFill(image: image, size: AttachmentInputViewLogic.PHOTO_TILE_THUMBNAIL_SIZE) {
            self.inputImage(fileURL: URL(string: "")!, image: image, fileName: fileName, fileSize: fileSize, fileId: id, imageThumbnail: image)
        } else {
            self.inputImage(fileURL: URL(string: "")!, image: image, fileName: fileName, fileSize: fileSize, fileId: id, imageThumbnail: nil)
        }
    }

    // Create a file name and add a video
    func addNewVideo(url: URL) {
        let fileSize = AttachmentInputUtil.getSizeFromFileUrl(fileUrl: url) ?? 0
        if self.configuration.fileSizeLimit <= fileSize {
            self.onError(error: AttachmentInputError.overLimitSize)
            return
        }
        let fileName = "video " + AttachmentInputUtil.datetimeForDisplay(from: Date()) + ".MOV"
        let id = NSUUID().uuidString
        
        getThumbnailImageFromVideoUrl(url: url) { image in
            self.inputMedia(fileURL: url, fileName: fileName, fileSize: fileSize, fileId: id, imageThumbnail: image, isVideo: true)
        }
    }

    func onSelectPickerMedia(phAsset: PHAsset, videoUrl: URL?) {
        if let photo = AttachmentInputPhoto(asset: phAsset, uploadSizeLimit: self.configuration.fileSizeLimit, imageManager: self.imageManager) {
            photo.initializeIfNeed(loadThumbnail: false)
            _ = photo.properties.take(1).subscribe(onNext: { [weak self] properties in
                if properties.exceededSizeLimit {
                    self?.onError(error: AttachmentInputError.overLimitSize)
                    return
                }

                if let status = self?.statusDictionary[photo.identifier] {
                    if status.status != .unSelected {
                        // do nothing when inputting already or inputting
                        return
                    }
                    status.input.onNext(.selected)
                    if let videoUrl = videoUrl {
                        // Since the video is compressed on the premise that the video is called from the imagePickerController, there is no need to compress it
                        let fileSize = AttachmentInputUtil.getSizeFromFileUrl(fileUrl: videoUrl) ?? 0
                        self?.inputMedia(fileURL: videoUrl, fileName: properties.filename, fileSize: fileSize, fileId: photo.identifier, imageThumbnail: nil, isVideo: true)
                    } else {
                        self?.addImageAfterFetchAndCompress(photo: photo, fileName: properties.filename, status: status)
                    }
                } else {
                    self?.statusDictionary[photo.identifier] = AttachmentInputPhotoStatus()
                    self?.statusDictionary[photo.identifier]?.input.onNext(.selected)
                }
                }, onError: { [weak self] error in
                    self?.onError(error: error)
            })
        }
    }

    func onTapPhotoCell(photo: AttachmentInputPhoto, selectIndex : AttachmentInputPhotoSelectIndex) {
        _ = photo.properties.take(1).subscribe(onNext: { [weak self] properties in
            if properties.exceededSizeLimit {
                self?.onError(error: AttachmentInputError.overLimitSize)
                return
            }
            if let status = self?.statusDictionary[photo.identifier] {
                // Delete if already added
                if status.status == .selected {
                    self?.removeFile(fileId: photo.identifier)
                    
                    //현재 선택된 인덱스 보다 크면 하나씩 줄여준다.
                    let search = self!.selectIndex.filter({$0.value.index >= selectIndex.index })
                    for i in search {
                        i.value.input.onNext(i.value.index - 1)
                    }
                    
                    status.input.onNext(.unSelected)
                    return
                }
                else {
                    //최대갯수 다 선택했는지 체크
                    if self!.isSelectExceed() {
                        return
                    }

                }
                
                if status.status != .unSelected {
                    // do nothing when inputting already or inputting
                    return
                }

                if photo.isVideo {
                    //동영상최대 갯수 다 선택했는지 체크
                    if self!.isVideoSelectExceed(){
                        return
                    }
                    
                    self?.addVideoAfterFetchAndCompress(photo: photo, fileName: properties.filename, status: status)
                } else {
                    self?.addImageAfterFetchAndCompress(photo: photo, fileName: properties.filename, status: status)
                }
            }
        }, onError: { [weak self] error in
            self?.onError(error: error)
        })
    }

    private func addVideoAfterFetchAndCompress(photo: AttachmentInputPhoto, fileName: String, status: AttachmentInputPhotoStatus) {
        status.input.onNext(.loading)
        
        let options = PHVideoRequestOptions()
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .highQualityFormat
        options.version = .original
        
        options.progressHandler = { [weak self] (progress, error, stop, info) in
            // for debug print("progress: \(progress)")
            if let error = error {
                self?.onError(error: error)
                status.input.onNext(.none)
            } else {
                status.input.onNext(.downloading)
            }
        }

        let cachingManager = PHCachingImageManager()
        DispatchQueue.main.async {
            cachingManager.requestAVAsset(forVideo: photo.asset, options: options, resultHandler: { (avAsset, avAudioMix, _) in
                let fileUrl = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true).appendingPathComponent(NSUUID().uuidString + ".mp4")
                let urlAsset = avAsset as! AVURLAsset
                let fileName = AttachmentInputUtil.addFilenameExtension(fileName: fileName, extensionString: "MOV")
                let fileSize = AttachmentInputUtil.getSizeFromFileUrl(fileUrl: fileUrl) ?? 0
                
                DispatchQueue.main.async {
                    if self.isVideoSelectExceed() {
                        status.input.onNext(.none)
                        return
                    }
                    else {
                        photo.thumbnail
                            .map{$0}
                            .bind{
                            self.inputMedia(fileURL: urlAsset.url, fileName: fileName, fileSize: fileSize, fileId: photo.identifier, imageThumbnail: $0, isVideo: true)
                            }.disposed(by: self.disposeBag)
                        status.input.onNext(.selected)
                        //선택하면 동영상 카운트 업
                        self.configuration.currentVideoCount += 1
                        //선택됐으면 인덱스 올려주기
                        self.selectIndex[photo.identifier]?.input.onNext(self.statusDictionary.filter({$0.value.status == .selected}).count)
                    }
                }
            })
        }
    }

    private func addImageAfterFetchAndCompress(photo: AttachmentInputPhoto, fileName: String, status: AttachmentInputPhotoStatus) {
        status.input.onNext(.loading)
        photo.thumbnail
            .map{$0}
            .bind{
                let image = $0
                photo.asset.getURL(completionHandler: { url in
                    guard let fileURL = url else {
                        Toast.show("로드에 실패하였습니다.", controller: self.navigationController)
                        status.input.onNext(.none)
                        return
                    }
                    if self.isSelectExceed() {      //이미 최대갯수인데 로딩중이다가 선택되는거 체크
                        status.input.onNext(.none)
                        return
                    }
                    
                    status.input.onNext(.selected)
                    self.inputImage(fileURL: fileURL, image: image, fileName: "", fileSize: 0, fileId: photo.identifier, imageThumbnail: image)
                    self.selectIndex[photo.identifier]?.input.onNext(self.statusDictionary.filter({$0.value.status == .selected}).count)
                })
            }.disposed(by: self.disposeBag)

    }

    public func loadPhotosWithStatus(pHFetchResult: PHFetchResult<PHAsset>) -> [(AttachmentInputPhoto, AttachmentInputPhotoStatus, AttachmentInputPhotoSelectIndex)] {
        var items = [(AttachmentInputPhoto, AttachmentInputPhotoStatus, AttachmentInputPhotoSelectIndex)]()
        if 0 < pHFetchResult.count {
            
            let indexSet = IndexSet(integersIn: 0..<pHFetchResult.count)
            let photosItems = pHFetchResult.objects(at: indexSet)
            photosItems.forEach({ asset in
                if let photo = AttachmentInputPhoto(asset: asset, uploadSizeLimit: self.configuration.fileSizeLimit, imageManager: self.imageManager) {
                    // The photo is newly created every time
                    // but Status is reused if it is already stored
                    if self.statusDictionary[asset.localIdentifier] == nil {
                        if isCamera == true {
                            self.statusDictionary[asset.localIdentifier] = AttachmentInputPhotoStatus()
                            self.statusDictionary[asset.localIdentifier]?.input.onNext(.selected)
                        }
                        else {
                            self.statusDictionary[asset.localIdentifier] = AttachmentInputPhotoStatus()
                        }
                    }
                    
                    if self.selectIndex[asset.localIdentifier] == nil {
                        if isCamera == true {
                            self.selectIndex[asset.localIdentifier] = AttachmentInputPhotoSelectIndex()
                            
                            if photo.isVideo {  //비디오 촬영해서 하나 생겼으면
                                //configuration.currentVideoCount += 1
                            }
                            self.selectIndex[photo.identifier]?.input.onNext(self.statusDictionary.filter({$0.value.status == .selected}).count)
                            
                            
                            let manager = PHImageManager.default()
                            let option = PHImageRequestOptions()
                                option.isSynchronous = true
                                manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: option, resultHandler: {(image, info)->Void in
                                    if photo.isVideo {
                                        self.addVideoAfterFetchAndCompress(photo: photo, fileName: "", status: self.statusDictionary[asset.localIdentifier]!)
                                    }
                                    else{
                                        self.addImageAfterFetchAndCompress(photo: photo, fileName: "", status: self.statusDictionary[asset.localIdentifier]!)
                                    }
                                })
                            
                        }
                        else {
                            self.selectIndex[asset.localIdentifier] = AttachmentInputPhotoSelectIndex()
                        }
                    }
                    isCamera = false
                    items.append((photo, self.statusDictionary[asset.localIdentifier]!, self.selectIndex[asset.localIdentifier]!))
                }
            })
        }
        return items
    }
    
    
    
    func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?)->Void)) {
        DispatchQueue.global().async { //1
            let asset = AVAsset(url: url) //2
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
            avAssetImageGenerator.appliesPreferredTrackTransform = true //4
            let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
                let thumbNailImage = UIImage(cgImage: cgThumbImage) //7
                DispatchQueue.main.async { //8
                    completion(thumbNailImage) //9
                }
            } catch {
                print(error.localizedDescription) //10
                DispatchQueue.main.async {
                    completion(nil) //11
                }
            }
        }
    }
    
    
    func clearAll() {
        pHFetchResultSubject = BehaviorSubject<PHFetchResult<PHAsset>?>(value: nil)
        photosWithStatusSubject = BehaviorSubject<[(photo: AttachmentInputPhoto, status: AttachmentInputPhotoStatus, selectIndex: AttachmentInputPhotoSelectIndex)]>(value: [])
        imageManager = PHImageManager()
        disposeBag = DisposeBag()
        statusDictionary = [:]
        selectIndex = [:]
    }
}


// Extensions for running Callback on main thread
extension AttachmentInputViewLogic {
    private func inputImage(fileURL: URL, image: UIImage, fileName: String, fileSize: Int64, fileId: String, imageThumbnail: UIImage?) {
        DispatchQueue.main.async {
            self.delegate?.inputImage(fileURL: fileURL, image: image, fileName: fileName, fileSize: fileSize, fileId: fileId, imageThumbnail: imageThumbnail)
        }
    }
    
    private func inputMedia(fileURL: URL, fileName: String, fileSize: Int64, fileId: String, imageThumbnail: UIImage?, isVideo: Bool) {
        DispatchQueue.main.async {
            self.delegate?.inputMedia(fileURL: fileURL, fileName: fileName, fileSize: fileSize, fileId: fileId, imageThumbnail: imageThumbnail, isVideo: isVideo)
        }
    }
    
    private func removeFile(fileId: String) {
        DispatchQueue.main.async {
            self.delegate?.removeFile(fileId: fileId)
        }
    }
    
    private func onError(error: Error) {
        DispatchQueue.main.async {
            self.delegate?.onError(error: error)
        }
    }
}


extension PHAsset {
    func getURL(completionHandler : @escaping ((_ responseURL : URL?) -> Void)) {
        if self.mediaType == .image {
            let options = PHContentEditingInputRequestOptions()
            options.isNetworkAccessAllowed = true
            options.canHandleAdjustmentData = { (adjustmeta: PHAdjustmentData) -> Bool in
                return true
            }
            self.requestContentEditingInput(with: options, completionHandler: { (contentEditingInput: PHContentEditingInput?, info: [AnyHashable : Any]) in
                completionHandler(contentEditingInput?.fullSizeImageURL as URL?)
            })
        } else if self.mediaType == .video {
            let options = PHVideoRequestOptions()
            options.isNetworkAccessAllowed = true
            options.version = .original
            PHImageManager.default().requestAVAsset(forVideo: self, options: options, resultHandler: {(asset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) in
                if let urlAsset = asset as? AVURLAsset {
                    let localVideoUrl: URL = urlAsset.url as URL
                    completionHandler(localVideoUrl)
                } else {
                    completionHandler(nil)
                }
            })
        }
    }
}
