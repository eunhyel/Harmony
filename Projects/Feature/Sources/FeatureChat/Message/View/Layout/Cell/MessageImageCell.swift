//
//  MessageImageCell.swift
//  Feature
//
//  Created by root0 on 2023/09/18.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift
import Kingfisher

import Core
import Shared

class MessageImageCell: ChatCell {
    
    let container = UIView()
    
    var clockView = ChatClockView()
    
    let resendView = ChatResendView().then {
        $0.backgroundColor = .black
        $0.roundCorners(cornerRadius: 10, maskedCorners: [.allCorners])
        $0.isHidden = true
    }
    
    var profileView = ChatProfileView()
    
    let bubble = UIView().then {
        $0.roundCorners(cornerRadius: 16, maskedCorners: [.allCorners])
    }
    
    let photo = UIImageView().then {
        $0.image = nil
        $0.contentMode = .scaleAspectFill
        $0.isUserInteractionEnabled = true
    }
    
    var longPress: (() -> Void)?
    
    var resend: (() -> Void)?
    
    var openProfile: (() -> Void)?
    
    var openMedia: (() -> Void)?
    
    private(set) var type: SendType = .send
    
    var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addComponents()
        
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func addComponents() {
        backgroundColor = .white
        
        contentView.addSubview(container)
        
        container.addSubview(profileView)
        [clockView, resendView, bubble]
            .forEach(container.addSubview(_:))
        
        [photo]
            .forEach(bubble.addSubview(_:))
        
        setConstraints()
    }
    
    func setConstraints() {
        profileView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(28)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
        
        container.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(2)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        photo.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
    
    func configUI(info chatMessage: ChatUnit) {
        photo.kf.setImage(with: URL(string: chatMessage.content))
        clockView.checkRead.isHidden = chatMessage.sendType == "0"
        clockView.checkRead.text = chatMessage.readYn == "n" ? "1" : ""
        
        if chatMessage.sendType == "0" {
            clockView.checkRead.isHidden = true
        }
    }
    
    func setIncomingCell(_ continuous: Bool) {
        bubble.backgroundColor = UIColor(rgbF: 245)
        
        let maskedCorner: [Corners] = [.topRight, .bottomLeft, .bottomRight]
        bubble.roundCorners(cornerRadius: 16, maskedCorners: maskedCorner)
        
        resendView.isHidden = true
        profileView.isHidden = false
        
        clockView.snp.makeConstraints {
            $0.trailing.lessThanOrEqualToSuperview()
            $0.bottom.equalTo(bubble.snp.bottom).inset(2)
        }
        
        type = .receive
        
        if continuous {
            profileView.isHidden = true
            profileView.snp.removeConstraints()
        }
    }
    
    func setOutgoingCell(_ continuous: Bool) {
        let maskedCorner: [Corners] = [.topLeft, .bottomRight, .bottomLeft]
        bubble.roundCorners(cornerRadius: 16, maskedCorners: maskedCorner)
        
        profileView.snp.removeConstraints()
        
        clockView.snp.makeConstraints {
            $0.leading.greaterThanOrEqualToSuperview()
            $0.bottom.equalTo(bubble.snp.bottom).inset(2)
        }
        
        bubble.snp.makeConstraints {
            $0.top.equalToSuperview().inset(continuous ? 0 : 28)
            $0.trailing.equalToSuperview()
            $0.leading.equalTo(clockView.snp.trailing).offset(4)
            $0.bottom.equalToSuperview()
            $0.width.equalTo(168)
            $0.height.equalTo(120)
        }
        
        bubble.backgroundColor = UIColor(redF: 106, greenF: 242, blueF: 176)
        type = .send
    }
    
    func setProfile(info member: ChatPartner?) {
        let defaultProfileImage: UIImage = member?.gender == .male ? FeatureAsset.rectangle135.image : FeatureAsset.recordAlbum.image
        profileView.name.text = member?.memNick
        profileView.thumbnail.image = defaultProfileImage
    }
    
    func setResendView() {
        resendView.isHidden = false
        clockView.isHidden = true
        
        resendView.snp.remakeConstraints {
            $0.bottom.equalTo(bubble.snp.bottom)
            $0.trailing.equalTo(bubble.snp.leading).offset(-4)
        }
    }
    
    func bind() {
        let tap = UITapGestureRecognizer()
        let long = UILongPressGestureRecognizer()
        
        [tap, long]
            .forEach(photo.addGestureRecognizer(_:))
        
        tap.rx.event
            .filter { $0.state == .recognized }
            .subscribe { [weak self] _ in
                self?.openMedia?()
            }
            .disposed(by: disposeBag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        photo.image = nil
        profileView.thumbnail.image = nil
        profileView.name.text = nil
        
        clockView.checkRead.text = ""
        clockView.date.text = nil
        
        clockView.isHidden = false
        profileView.isHidden = true
        
        disposeBag = DisposeBag()
        
    }
}
