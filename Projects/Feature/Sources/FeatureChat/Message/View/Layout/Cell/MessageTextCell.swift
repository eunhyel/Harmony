//
//  TextCell.swift
//  Feature
//
//  Created by root0 on 2023/06/12.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift
import Core
import Shared

class MessageTextCell: ChatCollectionCell {
    static let identifier = "MessageTextCell" //reuseIdentifier
    
    let container = UIView().then {
        $0.backgroundColor = .clear
    }
    
    var profileView = ChatProfileView()
    
    let bubble = UIView().then {
        $0.backgroundColor = .lightGray
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
    }
    
    let chat = UILabel().then {
        $0.text = "Do you want to go with me?"
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = UIColor(rgbF: 99)
    }
    
    let translatedWrapper = UIView().then {
        $0.backgroundColor = .clear
        $0.isHidden = true
    }
    let translateDivideLine = UIView().then {
        $0.backgroundColor = UIColor(rgbF: 232)
    }
    let translatedChat = UILabel().then {
        $0.text = "Translate Chat Text"
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.textColor = UIColor(rgbF: 17)
    }
    
    let resendView = ChatResendView().then {
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .black
        $0.isHidden = true
    }
    
    var clockView = ChatClockView()
    
    
    var longPress: (() -> Void)?
    
    var resend: (() -> Void)?
    
    var openProfile: (() -> Void)?
    
    private(set) var type: SendType = .send
    
    private var dBag = DisposeBag()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addComponents()
//        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        var newFrame = layoutAttributes.frame
        
        newFrame.size.height = ceil(size.height)
        layoutAttributes.frame = newFrame
        
        return layoutAttributes
    }
    
    func addComponents() {
        contentView.addSubview(container)
        
        [clockView, resendView, profileView, bubble]
            .forEach(container.addSubview(_:))
        
        [chat, translatedWrapper]
            .forEach(bubble.addSubview(_:))
        
        [translateDivideLine, translatedChat]
            .forEach(translatedWrapper.addSubview(_:))
    }
    
    func setConstraints() {
        container.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        profileView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        translateDivideLine.snp.makeConstraints {
            $0.top.equalToSuperview().inset(7)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        translatedChat.snp.makeConstraints {
            $0.top.equalTo(translateDivideLine.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(8)
        }
    }
    
    func setIncomingCell() {
        bubble.backgroundColor = UIColor(rgbF: 245)
        bubble.roundCorners(cornerRadius: 16, maskedCorners: [.topRight, .bottomLeft, .bottomRight])
        
        resendView.isHidden = true
        profileView.isHidden = false
        
        clockView.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(16)
        }
        
        bubble.snp.makeConstraints {
            $0.top.equalTo(profileView.name.snp.bottom).offset(8)
            $0.leading.equalTo(profileView.thumbnailContainer.snp.trailing).offset(8)
            $0.trailing.equalTo(clockView.snp.leading).inset(4)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        chat.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.leading.trailing.equalToSuperview().inset(12)
        }
        
        type = .receive
        
    }
    
    func setOutgoingCell() {
        
    }
    
    func bind() {
        
    }
    
    func scrollingProfileView(offset: CGFloat) {
        let update4 = max(0, min(contentView.frame.size.height - profileView.frame.size.height, offset))
        
        profileView.snp.updateConstraints {
            $0.top.equalToSuperview().offset(update4)
        }
    }
    
    func configUI(info chatMessage: ChatMessage, isSameWithPrev: Bool = false) {
        if let sendType = chatMessage.sendType {
            clockView.checkRead.isHidden = sendType == .receive
        }
        
        chat.text = chatMessage.content
        clockView.checkRead.text = chatMessage.readYn == "n" ? "1" : ""
        clockView.date.text = "\(chatMessage.insDate)".makeLocaleTimeDate()
        
        
//        _ = isSameWithPrev ? hiddenLayout() : showLayout()
        setConstraints()
    }
    func translateYProfileView(distant: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.profileView.transform = CGAffineTransform(translationX: 0, y: distant)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        [bubble, clockView, resendView, chat,
//        translatedWrapper, translatedChat]
        
        profileView.thumbnail.image = nil
        profileView.name.text = nil
        
        clockView.checkRead.text = "1"
        clockView.date.text = nil
        
        chat.text = nil
        bubble.roundCorners(cornerRadius: 0, maskedCorners: [.allCorners])
        chat.font = .r16
        
        clockView.isHidden = false
        resendView.isHidden = true
        profileView.isHidden = true
        translatedWrapper.isHidden = true
        
        
    }
}
