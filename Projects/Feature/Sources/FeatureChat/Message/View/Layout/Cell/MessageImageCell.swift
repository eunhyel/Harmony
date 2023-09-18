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
    
    var profileView = ChatProfileView()
    
    let bubble = UIView()
    
    let photo = UIImageView().then {
        $0.image = nil
        $0.contentMode = .scaleAspectFill
        $0.isUserInteractionEnabled = true
        $0.roundCorners(cornerRadius: 16, maskedCorners: [.allCorners])
    }
    
    var longPress: (() -> Void)?
    
    var resend: (() -> Void)?
    
    var openProfile: (() -> Void)?
    
    var openMedia: (() -> Void)?
    
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
    }
    
    func configUI(info chatMessage: ChatUnit) {
        photo.kf.setImage(with: URL(string: chatMessage.content))
        clockView.checkRead.isHidden = chatMessage.sendType == "0"
        clockView.checkRead.text = chatMessage.readYn == "n" ? "1" : ""
        
        if chatMessage.sendType == "0" {
            clockView.checkRead.isHidden = true
        }
    }
    
    func setProfile(info member: ChatPartner?) {
        let defaultProfileImage: UIImage = member?.gender == .male ? FeatureAsset.rectangle135.image : FeatureAsset.recordAlbum.image
        profileView.name.text = member?.memNick
        profileView.thumbnail.image = defaultProfileImage
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
