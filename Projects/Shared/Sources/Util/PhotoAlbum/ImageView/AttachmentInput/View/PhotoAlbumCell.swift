//
//  PhotoCell.swift
//  AttachmentInput
//
//  Created by daiki-matsumoto on 2018/02/14.
//  Copyright © 2018 Cybozu, Inc. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class PhotoAlbumCell: UICollectionViewCell {
    @IBOutlet private var gradationView: UIView!
    @IBOutlet private var thumbnailView: UIImageView!
    @IBOutlet private var movieIconView: UIImageView!
    @IBOutlet private var movieTime_label: UILabel!
    @IBOutlet private var checkIconView: UIImageView!
    @IBOutlet private var indicatorView: UIActivityIndicatorView!
    @IBOutlet private var disableView: UIView!
    
    @IBOutlet weak var select_view: UIView!
    @IBOutlet weak var count_label: UILabel!
    
    private var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        labelShadow()
    }
    
    func setup(photo: AttachmentInputPhoto, status: AttachmentInputPhotoStatus, seleteIndex: AttachmentInputPhotoSelectIndex) {
        self.disposeBag = DisposeBag()
        self.movieIconView.isHidden = !photo.isVideo
        self.movieTime_label.isHidden = !photo.isVideo
        self.gradationView.isHidden = !photo.isVideo
        photo.initializeIfNeed(loadThumbnail: true)
        photo.properties
            .map{!$0.exceededSizeLimit}
            .asDriver(onErrorJustReturn: false)
            .drive(self.disableView.rx.isHidden)
            .disposed(by: self.disposeBag)
        
        photo.videoTime
            .map{$0}
            .asDriver(onErrorDriveWith: Driver.empty())
            .drive(self.movieTime_label.rx.text)
            .disposed(by: self.disposeBag)
        
        photo.thumbnail
            .map{$0}
            .asDriver(onErrorDriveWith: Driver.empty())
            .drive(self.thumbnailView.rx.image)
            .disposed(by: self.disposeBag)
        
        //사진 선택 인덱스 입력
        seleteIndex.output.map{String($0)}
            .asDriver(onErrorDriveWith: Driver.empty())
            .drive(self.count_label.rx.text)
            .disposed(by: self.disposeBag)
            
        status.output.distinctUntilChanged().map { inputStatus in
            switch inputStatus {
            case .loading:
                DispatchQueue.main.async {
                    self.count_label.isHidden = true
                    self.indicatorView.isHidden = false
                    self.select_view.isHidden = false
                    self.layer.borderWidth = 2
                    self.layer.borderColor = UIColor(red: 255/255, green: 68/255, blue: 114/255, alpha: 1).cgColor
                }
                return 0
            case .selected:
                DispatchQueue.main.async {
                    self.count_label.isHidden = false
                    self.select_view.isHidden = false
                    self.indicatorView.isHidden = true
                    self.layer.borderWidth = 2
                    self.layer.borderColor = UIColor(red: 255/255, green: 68/255, blue: 114/255, alpha: 1).cgColor
                }
                return 1
            case .unSelected:
                DispatchQueue.main.async {
                    self.select_view.isHidden = true
                    self.count_label.isHidden = true
                    self.indicatorView.isHidden = true
                    self.layer.borderWidth = 2
                    self.layer.borderColor = UIColor(red: 255/255, green: 68/255, blue: 114/255, alpha: 0).cgColor
                }
                return 0
            case .compressing, .downloading:
                return 0
            case .none :
                self.indicatorView.isHidden = true
                self.select_view.isHidden = true
                return 0
            }
        }.bind(to: self.checkIconView.rx.alpha).disposed(by: self.disposeBag)

        status.output.distinctUntilChanged().map { inputStatus in
            switch inputStatus {
            case .compressing, .downloading:
                return false
            default:
                return true
            }
        }.bind(to: self.indicatorView.rx.isHidden).disposed(by: self.disposeBag)
    }

    func labelShadow(){
        movieTime_label.layer.shadowColor = UIColor.black.cgColor
        movieTime_label.layer.shadowRadius = 3.0
        movieTime_label.layer.shadowOpacity = 1.0
        movieTime_label.layer.shadowOffset = CGSize(width: 3, height: 3)
        movieTime_label.layer.masksToBounds = false
        
        let bounds = movieTime_label.bounds
        let shadowPath = UIBezierPath(rect: CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.width, height: bounds.height)).cgPath
        movieTime_label.layer.shadowPath = shadowPath
        movieTime_label.layer.shouldRasterize = true
        movieTime_label.layer.rasterizationScale = UIScreen.main.scale
    }
    
    
    override func prepareForReuse() {
        // thumbnailView is not updated at the timing of setup, so clear it
        self.thumbnailView.image = nil
    }
}
