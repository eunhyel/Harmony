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
        $0.isHidden = true
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
        
        clockView.snp.makeConstraints {
            $0.bottom.equalTo(imageBundle)
//            $0.leading.equalTo(imageBundle.snp.trailing).offset(4)
            $0.trailing.lessThanOrEqualToSuperview()
        }
        
        imageBundle.snp.makeConstraints {
            $0.top.equalToSuperview().inset(continuous ? 0 : 60)
            $0.leading.equalToSuperview().inset(72)
            $0.trailing.equalTo(clockView.snp.leading).offset(-4)
            $0.bottom.equalToSuperview()
            $0.width.lessThanOrEqualTo(214)
        }
        
        type = .receive
        
        if continuous {
            profileView.isHidden = true
            profileView.snp.removeConstraints()
        }
        
    }
    
    func setOutgoingCell(_ continuous: Bool) {
        
        clockView.snp.makeConstraints {
            $0.leading.greaterThanOrEqualToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        imageBundle.snp.makeConstraints {
            $0.top.equalToSuperview().inset(continuous ? 0 : 28)
            $0.trailing.equalToSuperview()
            $0.leading.equalTo(clockView.snp.trailing).offset(4)
            $0.bottom.equalToSuperview()
            $0.width.lessThanOrEqualTo(214)
        }
        
        type = .send
    }
    
    func configUI(info chatMessage: ChatUnit, isContinuous: Bool = false) {
        
//        let fileList = chatMessage.msgEtc?["multiPhotoDataUrl"].array.map { $0["url"].stringValue }
        
        imageBundle.configUI(data: ["0", "1", "2", "3"])
        
        imageBundle.clickImage = { [weak self] idx in
            guard let self = self else { return }
            self.openMedia?(idx)
        }
        
        clockView.date.text = chatMessage.minsDate.makeLocaleTimeDate()
        clockView.checkRead.text = chatMessage.readYn == "n" ? "1" : ""
        clockView.checkRead.isHidden = chatMessage.sendType == "0"
        
        setConstraints()
        
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
