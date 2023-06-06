//
//  AttachmentInputPhoto.swift
//  AttachmentInput
//
//  Created by daiki-matsumoto on 2018/02/26.
//  Copyright © 2018 Cybozu, Inc. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import Photos

class AttachmentInputPhoto {
    private let disposeBag = DisposeBag()
    private var initialized: Bool = false
    private let thumbnailSubject = AsyncSubject<UIImage?>()
    private let propertiesSubject = AsyncSubject<PhotoProperties?>()
    private let videoTimeSubject = AsyncSubject<String?>()
    private let uploadSizeLimit: Int64
    private let imageManager: PHImageManager

    // Output
    let asset: PHAsset
    let thumbnail: Observable<UIImage>
    let isVideo: Bool
    let identifier: String
    var videoTime: Observable<String>
    var selectIndex: Int = 0
    let properties: Observable<PhotoProperties>

    struct PhotoProperties {
        var filename: String
        var fileSize: Int64
        var exceededSizeLimit: Bool
    }

    /// @param asset: PHAsset
    /// @param uploadSizeLimit
    /// @param imageManager
    /// @return self or nil: Return nil if it is not a photo or video
    init?(asset: PHAsset, uploadSizeLimit: Int64, imageManager: PHImageManager) {
        if (asset.mediaType != .video && asset.mediaType != .image){
            return nil
        }
        
        self.asset = asset
        self.thumbnail = self.thumbnailSubject.unwrap().asObservable()
        self.properties = self.propertiesSubject.unwrap().asObservable()
        self.isVideo = (asset.mediaType == .video)
        self.videoTime = self.videoTimeSubject.unwrap().asObservable() //String(asset.duration)
        self.identifier = asset.localIdentifier
        self.uploadSizeLimit = uploadSizeLimit
        self.imageManager = imageManager
    }
    
    func initializeIfNeed(loadThumbnail: Bool) {
        if self.initialized == true {
            return
        }
        self.initialized = true
        self.loadProperties(phAsset: asset)
        if loadThumbnail {
            let _ = self.loadThumbnail(photoSize: AttachmentInputViewLogic.PHOTO_TILE_THUMBNAIL_SIZE, resizeMode: .none).take(1).bind(to: self.thumbnailSubject)
        }
    }
    
    func loadThumbnail(photoSize: CGSize, resizeMode: PHImageRequestOptionsResizeMode) -> Observable<UIImage?> {
        let dataSubject = AsyncSubject<UIImage?>()
        let option = PHImageRequestOptions()
        option.deliveryMode = .highQualityFormat        //앨범 썸네일 화질
        option.resizeMode = resizeMode
        option.isSynchronous = true
        option.isNetworkAccessAllowed = true
        
        let cachingManager = PHCachingImageManager()        //캐쉬로드 PHImageManager 하면 초느림
        cachingManager.requestImage(for: asset, targetSize: photoSize, contentMode: .aspectFill, options: option, resultHandler: { image, info in
            if let image = image {
                dataSubject.onNext(image)
                dataSubject.onCompleted()
            } else {
                dataSubject.onError(AttachmentInputError.thumbnailLoadFailed)
            }
        })
        return dataSubject.asObservable()
    }

    private static let serialDispatchQueue = DispatchQueue(label: "attachmentInputPhoto.dispatchqueue.serial")
    private func loadProperties(phAsset: PHAsset) {
        // get meta data
        // we acquire it asynchronously, Because "PHAssetResource.assetResources" are heavy
        //AttachmentInputPhoto.serialDispatchQueue.async {
            /*
            var fileName: String = ""
            var sizeOnDisk: Int64 = 0
            let resources = PHAssetResource.assetResources(for: phAsset)
            let exceededSizeLimit: Bool
            if let resource = resources.first {
                let unsignedInt64 = resource.value(forKey: "fileSize") as? CLong
                sizeOnDisk = Int64(bitPattern: UInt64(unsignedInt64!))
                fileName = resource.originalFilename
                if sizeOnDisk < self.uploadSizeLimit {
                    exceededSizeLimit = false
                } else {
                    exceededSizeLimit = true
                }
                
                self.propertiesSubject.onNext(PhotoProperties(
                    filename: fileName,
                    fileSize: sizeOnDisk,
                    exceededSizeLimit: exceededSizeLimit)
                )
                self.videoTimeSubject.onNext(phAsset.duration.minuteSecond)
                self.videoTimeSubject.onCompleted()
                self.propertiesSubject.onCompleted()
                return
            }
            self.propertiesSubject.onError(AttachmentInputError.propertiesLoadFailed)
            */
            
            
            self.propertiesSubject.onNext(PhotoProperties(
                filename: "",
                fileSize: 0,
                exceededSizeLimit: (0 != 0))
            )
            self.videoTimeSubject.onNext(phAsset.duration.minuteSecond)
            self.videoTimeSubject.onCompleted()
            self.propertiesSubject.onCompleted()
        //}
    }
}

extension TimeInterval {
    var toDate: String {
        let unixDate = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.string(from: unixDate)
    }
    var hourMinuteSecondMS: String {
        String(format:"%d:%02d:%02d.%03d", hour, minute, second, millisecond)
    }
    var minuteSecond: String {
        String(format:"%d:%02d", minute, second)
    }
    var hour: Int {
        Int((self/3600).truncatingRemainder(dividingBy: 3600))
    }
    var minute: Int {
        Int((self/60).truncatingRemainder(dividingBy: 60))
    }
    var second: Int {
        Int(truncatingRemainder(dividingBy: 60))
    }
    var millisecond: Int {
        Int((self*1000).truncatingRemainder(dividingBy: 1000))
    }
}
