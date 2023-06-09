//
//  AttachmentInput.swift
//  AttachmentInput
//
//  Created by daiki-matsumoto on 2018/10/24.
//  Copyright © 2018 Cybozu. All rights reserved.
//

import Foundation
import UIKit
import RxDataSources
import RxSwift
import Photos
import MobileCoreServices

//앨범 호출 타입
enum galleryType {
    case photo
    case video
    case all
    case none
}

class AttachmentInputView: UIView {
    @IBOutlet public var collectionView: UICollectionView!
    
    private var dataSource: RxCollectionViewSectionedReloadDataSource<SectionType>!
    private var disposeBag = DisposeBag()
    private var logic: AttachmentInputViewLogic?
    private var initialized = false
    
    private var photoDictionary: [AttachmentInputPhoto] = []
    
    
    var navigationController : UINavigationController = UINavigationController.defaultNavigation()
    
    fileprivate enum SectionType {
        case PhotoListSection(items: [SectionItemType])
    }
    
    fileprivate enum SectionItemType {
        case ImagePickerItem
        case PhotoListItem(photo: AttachmentInputPhoto? = nil, status: AttachmentInputPhotoStatus = .init(), selectIndex: AttachmentInputPhotoSelectIndex)
    }
    
    public var delegate: AttachmentInputDelegate? {
        get {
            return self.logic?.delegate
        }
        set {
            self.logic?.delegate = newValue
        }
    }

    private var configuration: AttachmentInputConfiguration!

    static func createAttachmentInputView(configuration: AttachmentInputConfiguration) -> AttachmentInputView {
        let attachmentInputView = Bundle(for: self).loadNibNamed("AttachmentInputView", owner: self, options: nil)?.first as! AttachmentInputView
        attachmentInputView.configuration = configuration
        attachmentInputView.logic = AttachmentInputViewLogic(configuration: configuration)
        return attachmentInputView
    }
    
    private func initializeCollectionView() {
        let bundle = Bundle(for: self.classForCoder)
        self.collectionView.register(UINib(nibName: "ImagePickerCell", bundle: bundle), forCellWithReuseIdentifier: "ImagePickerCell")
        self.collectionView.register(UINib(nibName: "PhotoAlbumCell", bundle: bundle), forCellWithReuseIdentifier: "PhotoAlbumCell")
        
        self.dataSource = RxCollectionViewSectionedReloadDataSource<SectionType>(configureCell: { (_, _, indexPath, item) -> UICollectionViewCell in
            switch item {
            case .ImagePickerItem:
                let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "ImagePickerCell", for: indexPath) as! ImagePickerCell
                cell.delegate = self
                cell.galleryType = self.configuration.galleryType
                cell.setup()
                cell.jsonData = self.configuration.jsonData
                return cell
            case .PhotoListItem(let photo, let status, let selectIndex):
                let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoAlbumCell", for: indexPath) as! PhotoAlbumCell
                if status.status == .selected {
                    if self.configuration.maxSelect >= 20/*GlobalData.maxPhotoCount*/ {
                        cell.setup(photo: photo!, status: status, seleteIndex: selectIndex)
                        return cell
                    }
                    
                    if self.logic!.isCamera == true {
                        self.logic!.statusDictionary[photo!.identifier]?.input.onNext(.selected)
                    }
                }
                else {
                    
                }
                
                cell.setup(photo: photo!, status: status, seleteIndex: selectIndex)
                return cell
            }
        })
        self.requestAuthorizationIfNeeded { [weak self] authorized in
            if authorized {
                self?.fetchAssets(asset: nil)
            }
            PHPhotoLibrary.shared().register(self!)     //15.2 버그 사진 권한 받고 감지 옵저버 세팅해야함
        }

        // show collectionView
        self.collectionView.delegate = self
        
    
        
        // Add picker control and camera section
        var ret = [SectionType]()
        ret.append(SectionType.PhotoListSection(items: [SectionItemType.ImagePickerItem]))
        let controllerObservable = Observable.just(ret)

        Observable<[SectionType]>.combineLatest(controllerObservable, self.logic!.photosWithStatus) { controller, output in
            _ = output.map( { output in
                self.photoDictionary.append(output.photo)
            })
            var photoItems = output.map( { output in
                return SectionItemType.PhotoListItem(photo: output.photo, status: output.status, selectIndex: output.selectIndex)
            })
            photoItems.reverse()
            photoItems.append(contentsOf: [SectionItemType.ImagePickerItem])
            photoItems.reverse()
            return [SectionType.PhotoListSection(items: photoItems)]
            }.bind(to: self.collectionView.rx.items(dataSource: self.dataSource)).disposed(by: self.disposeBag)
        
        // onTapPhotoCell
        self.collectionView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            if let item = self?.dataSource.sectionModels[indexPath.section].items[indexPath.item] {
                switch item {
                case .PhotoListItem(let photo, let status, let selectIndex):
                    if status.status == .selected {     //선택된 셀을 해제하려고 눌렀을 때
                        if photo!.isVideo { //비디오를 선택했으면
                            self!.configuration.currentVideoCount -= 1
                        }
                    }
                    else {
                    }
                    self?.logic?.onTapPhotoCell(photo: photo!, selectIndex: selectIndex)
                default:
                    // do nothing
                    break
                }
            }
        }).disposed(by: self.disposeBag)
    }

    private func requestAuthorizationIfNeeded(completion: @escaping (_ authorized: Bool) -> Void) {
        let status: PHAuthorizationStatus
        if #available(iOS 14, *) {
            status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        } else {
            status = PHPhotoLibrary.authorizationStatus()
        }
        switch (status) {
        case .authorized, .limited:
            completion(true)
        case .denied, .restricted:
            completion(false)
        case .notDetermined:
            if #available(iOS 14, *) {
                PHPhotoLibrary.requestAuthorization(for: .readWrite, handler: { status in
                    completion(status == .authorized || status == .limited)
                })
            } else {
                PHPhotoLibrary.requestAuthorization({ (status) in
                    completion(status == .authorized)
                })
            }
        @unknown default:
            fatalError()
        }
    }

    //앨범사진 세팅하는 부분
    func fetchAssets(asset: PHAssetCollection?) {
        // postpone heavy processing to first display the keyboard
        DispatchQueue.main.async {
            // add Photos
            let photosOptions = PHFetchOptions()
            photosOptions.fetchLimit = self.configuration.photoCellCountLimit
            
            if self.configuration.galleryType == .all {
                photosOptions.predicate = NSPredicate(format: "mediaType == %d || mediaType == %d && (duration > %f && duration < %f)",
                                                      PHAssetMediaType.image.rawValue,
                                                      PHAssetMediaType.video.rawValue, self.configuration.minVideoTime, self.configuration.maxVideoTime + 0.99)        //비디오풀기 1분 이하만 가능
            }
            else if self.configuration.galleryType == .video {
                photosOptions.predicate = NSPredicate(format: "mediaType == %d && (duration > %f && duration < %f)",
                                                      PHAssetMediaType.video.rawValue, self.configuration.minVideoTime , self.configuration.maxVideoTime + 0.99)        //비디오풀기 10초이상 1분 이하만 가능
            }
            else {
                photosOptions.predicate = NSPredicate(format: "mediaType == %d",
                                                      PHAssetMediaType.image.rawValue)
            }
            
            
            photosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            
            if asset == nil {
                self.logic?.pHFetchResultObserver.onNext(PHAsset.fetchAssets(with: photosOptions))
            }
            else {
                self.logic?.pHFetchResultObserver.onNext(PHAsset.fetchAssets(in: asset!, options: photosOptions))
            }
        }
    }
    
    func initializeIfNeed() {
        guard !self.initialized else {
            return
        }
        self.initialized = true
        //PHPhotoLibrary.shared().register(self)
        self.initializeCollectionView()

    }
    
    func removeFile(identifier: String, isVideo: Bool) {
        self.logic?.removeFile(identifier: identifier, isVideo: isVideo)
    }
    
    func clearAll() {
        dataSource = RxCollectionViewSectionedReloadDataSource<SectionType>(configureCell: { (_, _, indexPath, item) -> UICollectionViewCell in
            let cell = UICollectionViewCell()
            return cell
        })
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
        photoDictionary = []
        disposeBag = DisposeBag()
        self.logic?.clearAll()
    }
}

extension AttachmentInputView: ImagePickerCellDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // If you double tap a photo, it will be called many times
        // so check isBeingDismissed
        if picker.isBeingDismissed {
            return
        }
        
        if let phAsset = info[.phAsset] as? PHAsset {
            // When selecting from the photo library
            if let mediaType = info[.mediaType] as? String {
                if mediaType == kUTTypeImage as String {
                    self.logic?.onSelectPickerMedia(phAsset: phAsset, videoUrl: nil)
                } else if mediaType == kUTTypeMovie as String {
                    if let mediaUrl = info[.mediaURL] as? URL {
                        self.logic?.onSelectPickerMedia(phAsset: phAsset, videoUrl: mediaUrl)
                    }
                }
            }
        } else {
            // When took a picture
            if let _ = info[.originalImage] as? UIImage {
                //이부분에 사진 추가
                self.logic?.isCamera = true
            } else if let videoUrl = info[.mediaURL] as? URL {
                self.logic?.addNewVideo(url: videoUrl)
            }
        }
        
        DispatchQueue.main.async {
            picker.dismiss(animated: true, completion: nil)
            self.delegate?.imagePickerControllerDidDismiss()
        }
    }
        
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        DispatchQueue.main.async {
            picker.dismiss(animated: true, completion: nil)
            self.delegate?.imagePickerControllerDidDismiss()
        }
    }
    
    var videoQuality: UIImagePickerController.QualityType {
        return self.configuration.videoQuality
    }
    
    func isSelectExceed() -> Bool {
        if self.logic!.isSelectExceed() {
            return true
        }
        else {
            return false
        }
    }
    
    
    func isVideoSelectExceed() -> Bool {
        if self.logic!.isVideoSelectExceed() {
            return true
        }
        else {
            return false
        }
    }
}

extension AttachmentInputView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.frame.width/3.04
        return CGSize(width: width, height: width)
    }
}


extension AttachmentInputView.SectionType: SectionModelType {
    typealias Item = AttachmentInputView.SectionItemType
    
    var items: [AttachmentInputView.SectionItemType] {
        switch self {
        case .PhotoListSection(items: let items):
            return items.map {$0}
        }
    }
    
    init(original: AttachmentInputView.SectionType, items: [Item]) {
        switch original {
        case .PhotoListSection:
            self = .PhotoListSection(items: items)
        }
    }
}

extension AttachmentInputView: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.async {
//            guard let _ = self.navigationController.viewControllers.first as? PhotoViewController else {
//                return
//            }
            if let photosFetchResult = self.logic?.pHFetchResult, let changeDetails = changeInstance.changeDetails(for: photosFetchResult) {
                self.logic?.isCamera = true
                self.logic?.pHFetchResultObserver.onNext(changeDetails.fetchResultAfterChanges)
             }
        }
    }
}
