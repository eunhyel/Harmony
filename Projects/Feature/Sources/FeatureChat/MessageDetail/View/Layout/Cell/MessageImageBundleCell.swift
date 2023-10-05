//
//  MessageImageBundleCell.swift
//  Feature
//
//  Created by root0 on 2023/09/27.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift

import Core

class MessageImageBundleCell: ChatCell {
    
    var imageBundle = ImageBundleView().then {
        $0.backgroundColor = .blue
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    var profileView = ChatProfileView().then {
        $0.isHidden = true
    }
    
    var clockView = ChatClockView()
    
    var openMedia: ((Int) -> Void)?
    
    var longPress: (() -> Void)?
    
    var resend: (() -> Void)?
    
    var openProfile: (() -> Void)?
    
    private(set) var type: SendType = .send
    
    private var dBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addComponents()
        
        self.selectionStyle = .none
        self.contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addComponents() {
        
        [clockView, profileView, imageBundle]
            .forEach(contentView.addSubview(_:))
    }
    
    func setConstraints() {
        profileView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(12)
            $0.trailing.equalToSuperview().inset(16)
        }
    }
    
    func setIncomingCell(_ continuous: Bool) {
        profileView.isHidden = false
        
        imageBundle.snp.makeConstraints {
            $0.top.equalToSuperview().inset(continuous ? 0 : 44)
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview().inset(72)
//            $0.trailing.equalTo(clockView.snp.leading).offset(-4)
        }
        
        clockView.snp.makeConstraints {
            $0.bottom.equalTo(imageBundle)
            $0.leading.equalTo(imageBundle.snp.trailing).offset(4)
            $0.trailing.lessThanOrEqualToSuperview()
        }
        
        type = .receive
        
        if continuous {
            profileView.isHidden = true
            profileView.snp.removeConstraints()
        }
        
    }
    
    func setOutgoingCell(_ continuous: Bool) {
        
        imageBundle.snp.makeConstraints {
            $0.top.equalToSuperview().inset(continuous ? 0 : 28)
            $0.bottom.equalToSuperview()
            $0.trailing.equalToSuperview()
//            $0.leading.equalTo(clockView.snp.trailing).offset(4)
        }
        
        clockView.snp.makeConstraints {
            $0.trailing.equalTo(imageBundle.snp.leading).offset(-4)
            $0.bottom.equalTo(imageBundle)
            $0.leading.greaterThanOrEqualToSuperview()
        }
        
        
        type = .send
    }
    
    func configUI(info chatMessage: ChatUnit, isContinuous: Bool = false) {
        
//        let fileList = chatMessage.msgEtc?["multiPhotoDataUrl"].array.map { $0["url"].stringValue }
        
        imageBundle.configUI(data: [
            "https://photo.dallalive.com/profile_0/21704342400/20221128115903057239.png?292x292",
            "https://photo.dallalive.com/profile_0/21753716400/20230111025537454786.png?700X700",
            "https://photo.dallalive.com/profile_0/21740284800/20221230113049637482.png?700X700",
            "https://photo.dallalive.com/profile_0/21744824400/20230103234157125626.png?700X700",
            "https://photo.dallalive.com/profile_0/21752640000/20230110154634333987.png?700X700"
        ])
        
        imageBundle.clickImage = { [weak self] idx in
            guard let self = self else { return }
            self.openMedia?(idx)
        }
        
        clockView.date.text = chatMessage.minsDate.makeLocaleTimeDate()
        clockView.checkRead.text = chatMessage.readYn == "n" ? "1" : ""
        clockView.checkRead.isHidden = chatMessage.sendType == "0"
        
        setConstraints()
        
    }
    
    func setProfile(info member: ChatPartner?) {
        let defaultProfileImage: UIImage = member?.gender == .male ? FeatureAsset.rectangle135.image : FeatureAsset.recordAlbum.image
        profileView.name.text = member?.memNick
        profileView.thumbnail.image = defaultProfileImage
    }
    
    func bind() {
        imageBundle.rx.longPressGesture()
            .when(.began)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.longPress?()
            }
            .disposed(by: dBag)
        
        Observable.merge(profileView.thumbnailContainer.tapGesture, profileView.name.tapGesture)
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.openProfile?()
            }
            .disposed(by: dBag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        [imageBundle, clockView]
            .forEach { $0.snp.removeConstraints() }
        
        profileView.thumbnail.image = nil
        profileView.name.text = nil
        
        clockView.checkRead.text = ""
        clockView.date.text = nil
        
        clockView.isHidden = false
        profileView.isHidden = true
        
        dBag = DisposeBag()
    }
}
