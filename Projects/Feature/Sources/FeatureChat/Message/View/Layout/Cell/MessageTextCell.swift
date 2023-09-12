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

/**
 container View의 inset을 연달아서 보내는 채팅 : 여백의 절반
 profileView 의 top을 프로필이 나올때의 여백의 절반
 */
class MessageTextCell: ChatCell {
    static let identifier = "MessageTextCell" //reuseIdentifier
    
    let container = UIView().then {
        $0.backgroundColor = .clear
    }
    
    var profileView = ChatProfileView().then {
        $0.isHidden = true
    }
    
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
    
    private let MarginShortWithCells = 2
    private let PaddingSideContainer = 16
    private let PaddingLongWithCells = 28
    private let PaddingTopWithoutProfile = 32
    private let PaddingLeadingWithoutProfile = 56
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        addComponents()
////        setConstraints()
//    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addComponents()
        
        
        self.selectionStyle = .none
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    
    func addComponents() {
        contentView.addSubview(container)
        
        container.addSubview(profileView)
        [clockView, resendView, bubble]
            .forEach(container.addSubview(_:))
        
        [chat, translatedWrapper]
            .forEach(bubble.addSubview(_:))
        
        [translateDivideLine, translatedChat]
            .forEach(translatedWrapper.addSubview(_:))
    }
    
    func setConstraints() {
        profileView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(PaddingLongWithCells)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
        
        container.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(MarginShortWithCells)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
    }
    
//    func configUI(info chatMessage: ChatMessage, isSameWithPrev: Bool = false) {
    func configUI(info chatMessage: MockList) {
//        if let sendType = chatMessage.sendType {
        clockView.checkRead.isHidden = chatMessage.sendType == "0"
//        }
        
        chat.text = chatMessage.content
        clockView.checkRead.text = chatMessage.readYn == "n" ? "1" : ""
        clockView.date.text = "\(chatMessage.minsDate)".makeLocaleTimeDate()
        
        setConstraints()
    }
    
    func setIncomingCell(_ continuous: Bool = false) {
        bubble.backgroundColor = UIColor(rgbF: 245)
        
        let maskedCorner: [Corners] = [.topRight, .bottomLeft, .bottomRight]
        bubble.roundCorners(cornerRadius: 16, maskedCorners: maskedCorner)
        
        resendView.isHidden = true
        profileView.isHidden = false
        
        chat.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.leading.trailing.equalToSuperview().inset(12)
        }
        
        clockView.snp.makeConstraints {
//            $0.trailing.equalToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
            $0.bottom.equalTo(bubble.snp.bottom).inset(2)
        }
        
        bubble.snp.makeConstraints {
//            $0.top.equalTo(profileView.name.snp.bottom).offset(8)
            $0.top.equalToSuperview().inset(continuous ? .zero : PaddingLongWithCells + PaddingTopWithoutProfile) // 28 + 32
//            $0.leading.equalTo(profileView.thumbnailContainer.snp.trailing).offset(8)
            $0.leading.equalToSuperview().inset(PaddingLeadingWithoutProfile)
            $0.trailing.equalTo(clockView.snp.leading).offset(-4)
            $0.bottom.equalToSuperview()//.inset(16)
            $0.width.lessThanOrEqualTo(238)
        }
        
        type = .receive
        
        if continuous {
            profileView.isHidden = true
            profileView.snp.removeConstraints()
        }
    }
    
    func setOutgoingCell(_ continuous: Bool = false) {
        let maskedCorner: [Corners] = [.topLeft, .bottomRight, .bottomLeft]
        bubble.roundCorners(cornerRadius: 16, maskedCorners: maskedCorner)
        
        profileView.snp.removeConstraints()
        
        chat.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.leading.trailing.equalToSuperview().inset(12)
        }
        
        clockView.snp.makeConstraints {
            $0.leading.greaterThanOrEqualToSuperview()
            $0.bottom.equalTo(bubble.snp.bottom).inset(2)
        }
        
        bubble.snp.makeConstraints {
            $0.top.equalToSuperview().inset(continuous ? .zero : PaddingLongWithCells)
            $0.trailing.equalToSuperview()
            $0.leading.equalTo(clockView.snp.trailing).offset(4)
            $0.bottom.equalToSuperview()
            $0.width.lessThanOrEqualTo(290)
        }
        
        bubble.backgroundColor = UIColor(redF: 106, greenF: 242, blueF: 176)
        type = .send
        
    }
    
    func continousLayout() {
        
    }
    
    func separateLayout() {
        
    }
    
    func bind() {
        
    }
    
    func scrollingProfileView(offset: CGFloat) {
        let update4 = max(0, min(contentView.frame.size.height - profileView.frame.size.height, offset))
        
        profileView.snp.updateConstraints {
            $0.top.equalToSuperview().offset(update4)
        }
    }
    
    
    func setProfile(info member: ChatPartner?) {
        let defaultProfileImage: UIImage = member?.gender == .male ? FeatureAsset.rectangle135.image : FeatureAsset.recordAlbum.image
        profileView.name.text = member?.memNick
        profileView.thumbnail.image = defaultProfileImage
    }
    
    func setPtrTranslateMsg(_ message: MockList) {
        
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
    
    func translateYProfileView(distant: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.profileView.transform = CGAffineTransform(translationX: 0, y: distant)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        [profileView, bubble, clockView, resendView, chat,
         translatedWrapper, translatedChat].forEach { $0.snp.removeConstraints() }
        
        profileView.thumbnail.image = nil
        profileView.name.text = nil
        
        clockView.checkRead.text = "1"
//        clockView.date.text = nil
        
        chat.text = nil
        bubble.backgroundColor = nil
        bubble.roundCorners(cornerRadius: 0, maskedCorners: [.allCorners])
        chat.font = .r16
        
        clockView.isHidden = false
        resendView.isHidden = true
        profileView.isHidden = true
        translatedWrapper.isHidden = true
        
        
    }
}
