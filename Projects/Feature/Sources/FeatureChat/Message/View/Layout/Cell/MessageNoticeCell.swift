//
//  MessageNoticeCell.swift
//  Feature
//
//  Created by root0 on 2023/09/14.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

import Core
import Shared

class MessageNoticeCell: ChatCell {
    
    var longPress: (() -> Void)?
    
    var resend: (() -> Void)?
    
    var openProfile: (() -> Void)?
    
    
    let container = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let profileView = ChatProfileView().then {
        $0.isHidden = false
    }
    
    let bubble = UIView().then {
        $0.backgroundColor = UIColor(rgbF: 245)
        $0.roundCorners(cornerRadius: 16, maskedCorners: [.allCorners])
    }
    
    let containerStack = UIStackView().then {
        $0.axis = .vertical
        $0.backgroundColor = .clear
        $0.spacing = 0
    }
    
    let imageWrapper = UIView().then {
        $0.roundCorners(cornerRadius: 6, maskedCorners: [.topLeft, .topRight])
        $0.clipsToBounds = true
    }
    
    let imageContent = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .white
    }
    
    let titleWrapper = UIView()
    
    let titleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
        $0.textAlignment = .natural
        $0.font = .b16
        $0.setCharacterSpacing(-0.5)
        $0.setLineHeight(22)
    }
    
    let contentsWrapper = UIView()
    
    let contentsLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textAlignment = .natural
        $0.lineBreakMode = .byWordWrapping
        $0.font = .r16
        $0.setCharacterSpacing(-0.5)
        $0.setLineHeight(22)
    }
    
    let customViewWrapper = UIView()
    
    let buttonWrapper = UIView().then {
        $0.isHidden = true
    }
    
    let buttonStack = UIStackView().then {
        $0.spacing = 6
    }
    
    let confirm = MainButton(.main, title: "Confirm")
    
    
    var model: PopupInfoModel = .init(type: .basic, buttonType: .one, titleText: "랜덤채팅 오픈!", contentsText: "여러사람들과 함께하는 두근두근 채팅을 지금 참여해보세요!")
    
    
    var clockView: ChatClockView = ChatClockView()
    
//    lazy var notice: PopupView = {
//        var notice = PopupView(frame: .zero, model: model)
//            notice.backgroundView.isHidden = true
//
//        return notice
//    }()
    
    private(set) var type: SendType = .receive
    
    private var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addComponents()
        
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addComponents() {
        contentView.addSubview(container)
        
        [profileView, bubble]
            .forEach(container.addSubview(_:))
        
        bubble.addSubview(containerStack)
        
        [imageWrapper, titleWrapper, contentsWrapper, customViewWrapper, buttonWrapper]
            .forEach(containerStack.addArrangedSubview(_:))
        
        imageWrapper.addSubview(imageContent)
        contentsWrapper.addSubview(contentsLabel)
        titleWrapper.addSubview(titleLabel)
        buttonWrapper.addSubview(buttonStack)
        
        [confirm]
            .forEach(buttonStack.addArrangedSubview(_:))
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
        
        
        
        type = .receive
        
        containerStack.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.top.bottom.equalToSuperview().inset(12)
        }
        
        imageContent.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(8)
            $0.height.equalTo(136)
            $0.width.lessThanOrEqualTo(224)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        contentsLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        buttonStack.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalToSuperview().inset(8)
        }
        
        confirm.snp.remakeConstraints {
            $0.width.equalTo(containerStack)
            $0.height.equalTo(40)
        }
    }
    
    func configUI() {
        profileView.name.text = "관리자"
        
        profileView.thumbnail.image = FeatureAsset.msgNotice.image
        
        bubble.backgroundColor = UIColor(rgbF: 245)
        
        setConstraints()
    }
    
    func makeContents(_ model: NoticeInfoModel) {
        
        imageWrapper.isHidden = model.imageName == nil
        if let imgName = model.imageName {
            if imgName.contains("://") {
//                imageContent.kf.setImage
            } else {
                imageContent.image = FeatureAsset.rectangle135.image
            }
        }
        
        titleLabel.text = model.titleText
        contentsLabel.text = model.contentsText
        
        if !model.confirmBtnText.isEmpty {
            buttonWrapper.isHidden = false
            confirm.setTitle(model.confirmBtnText, for: .normal)
        }
        
        
    }
    
    func bind(to viewModel: MessageViewModel) {
        confirm.rx
            .tap
            .bind { _ in
                print("더보기 클리")
            }
            .disposed(by: disposeBag)
    }
    
    
    func setIncomingCell(_ continuous: Bool) {
        
        bubble.snp.makeConstraints {
            $0.top.equalToSuperview().inset(continuous ? 0 : 60)
            $0.leading.equalToSuperview().inset(56)
            $0.trailing.lessThanOrEqualToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        profileView.isHidden = continuous
        _ = continuous ? profileView.snp.removeConstraints() : ()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        [profileView, bubble]
            .forEach { $0.snp.removeConstraints() }
        
        profileView.isHidden = false
        disposeBag = DisposeBag()
    }
}
