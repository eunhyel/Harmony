//
//  ImagePickerCell.swift
//  AttachmentInput
//
//  Created by daiki-matsumoto on 2018/02/14.
//  Copyright © 2018 Cybozu, Inc. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import AVFoundation
import MobileCoreServices
import SwiftyJSON
import SnapKit

protocol ImagePickerCellDelegate: AnyObject {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any])
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    var videoQuality: UIImagePickerController.QualityType { get }
    func isSelectExceed() -> Bool
    func isVideoSelectExceed() -> Bool
}

class ImagePickerCell: UICollectionViewCell/*, CameraPermission*/{
    @IBOutlet var cameraButtonView: UIView!
    @IBOutlet var cameraButtonIcon: UIImageView!
    @IBOutlet var cameraButtonLabel: UILabel!

    private var imagePickerAuthorization = ImagePickerAuthorization()
    private var initialized = false
    private let disposeBag = DisposeBag()
    weak var delegate: ImagePickerCellDelegate?
    
    var galleryType : galleryType?
    var jsonData = JSON()

    @IBAction func tapCamera() {
        
        guard let delegate = delegate else {
            return
        }
        
        //사진 갯수 체크하고
        if delegate.isSelectExceed() {
            return
        }
        
        //카메라 권한 체크하고
        if self.imagePickerAuthorization.videoDisableValue {
            //self.requestManualyAuthorizationCamera()
            return
        }
        
        if galleryType == .all {        //사진이랑 동영상 팝업 호출
            let popup = GalleryPopupView(frame: .zero)
            popup.openType = { type in
                switch type {
                    case .photo:
                        self.openPhoto()
                    case .video:
                        self.openVideo()
                    case .all:
                        return
                    case .none:
                        return
                }
            }
            self.getTopViewController()?.view.addSubview(popup)
            popup.snp.makeConstraints{
                $0.edges.equalToSuperview()
            }
        }
        else if galleryType == .video{      //비디오 촬영 호출
            openVideo()
        }
        else {      //사진 촬영 호출
            openPhoto()
        }
    }
    
    func openPhoto(){
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.mediaTypes = [kUTTypeImage as String]//, kUTTypeMovie as String]
        if let videoQuality = self.delegate?.videoQuality {
            picker.videoQuality = videoQuality
        }
        picker.delegate = self
        picker.modalPresentationStyle = .fullScreen
        self.getTopViewController()?.present(picker, animated: true)
    }
    
    
    func openVideo() {
        guard let delegate = delegate else {
            return
        }
        
        //비디오 갯수 체크하고
        if delegate.isVideoSelectExceed() {
            return
        }

//        //마이크 권한 체크하고
//        askMicAuthorization(callback: { (micGranted) in
//            if micGranted {
//                DispatchQueue.main.async {
//                    guard let recorderVC = UIStoryboard(name: "NewVideoRegister", bundle: Bundle(for: Shared.self)).instantiateViewController(withIdentifier: "NewvideoRecorder") as? NewVideoRecordViewController else {
//                        return
//                    }
//
//                    recorderVC.viewData = self.jsonData
//                    self.getTopViewController()?.present(recorderVC, animated: true)
//                }
//            }
//            else {
//                Permission.sharedInstance.manualyAuthorization(.Microphone)
//            }
//        })
    }
    

    private func getTopViewController() -> UIViewController? {
        if var topViewControlelr = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topViewControlelr.presentedViewController {
                topViewControlelr = presentedViewController
            }
            return topViewControlelr
        }
        return nil
    }

    func setup() {
        initializeIfNeed()
    }

    override func awakeFromNib() {
        setupText()
        setupDesign()
    }
    
    private func initializeIfNeed() {
        guard !self.initialized else {
            return
        }
        self.initialized = true
        self.imagePickerAuthorization.checkAuthorizationStatus()
        self.imagePickerAuthorization.videoDisable.subscribe(onNext: { [weak self] disable in
            DispatchQueue.main.async {
                self?.setupDesignForCameraButton(disable: disable)
            }
        }).disposed(by: self.disposeBag)
    }

    private func setupText() {
        self.cameraButtonLabel.text = String(format: NSLocalizedString("카메라 촬영", comment: ""))
    }

    private func setupDesign() {
        self.setupDesignForCameraButton(disable: true)
    }
    
    private func setupDesignForCameraButton(disable: Bool) {
        if disable {
            self.cameraButtonIcon.alpha = 0.5
            self.cameraButtonLabel.alpha = 0.5
        } else {
            self.cameraButtonIcon.alpha = 1
            self.cameraButtonLabel.alpha = 1
        }
    }
}


extension ImagePickerCell: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            if picker.sourceType == UIImagePickerController.SourceType.camera {
                // 카메라로 찍은거였으면 사진을 저장한다.
                UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
            }
        }
        
        self.delegate?.imagePickerController(picker, didFinishPickingMediaWithInfo: info)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.delegate?.imagePickerControllerDidCancel(picker)
    }
}
