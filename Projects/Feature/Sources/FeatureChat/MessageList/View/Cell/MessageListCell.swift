//
//  MessageListCell.swift
//  Feature
//
//  Created by root0 on 2023/06/05.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import SnapKit
import Then

import Shared

class MessageListCell: UITableViewCell {
    static let identifier = "MesssageListCell"
    
    var containerView = UIView().then {
        $0.backgroundColor = .white
    }
    
    var contentStack = UIStackView().then {
        $0.axis = .horizontal
        $0.backgroundColor = .clear
    }
    
    var profileView = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.applySketchShadow(alpha: 0.24, x: 0, y: 2, blur: 6)
    }
    
    var profileImageView = UIImageView().then {
        $0.backgroundColor = .gray
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(rgbF: 225).cgColor
        $0.roundCorners(cornerRadius: 28, maskedCorners: [.allCorners])
    }
    
    var messageView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    var msgTopView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    var senderInfoStack = UIStackView().then {
        $0.axis = .horizontal
        $0.backgroundColor = .clear
    }
    
    var sexView = UIView().then {
        $0.backgroundColor = .nicknameF
    }
    
    var ageLabel = UILabel().then {
        $0.font = .b12
    }
    
    var flagImageView = UIImageView().then {
        $0.image = FeatureAsset.rectangle135.image
        $0.roundCorners(cornerRadius: 10, maskedCorners: [.allCorners])
    }
    
    var locationLabel = UILabel().then {
        $0.font = .r12
        $0.text = "Earth, "
        $0.textColor = .black
        $0.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
    
    var nameLabel = UILabel().then {
        $0.text = "Dummy NameNameNames"
        $0.textColor = .nicknameF
        $0.font = .b14
        $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    var msgMiddleView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    var lastMsgLabel = UILabel().then {
        $0.textColor = .darkGray
        $0.font = .r12
    }
    
    var additionalStack = UIStackView().then {
        $0.backgroundColor = .clear
        $0.axis = .vertical
        $0.alignment = .trailing
    }
    
    var timeLabel = UILabel().then {
        $0.textAlignment = .right
        $0.font = .m12
    }
    
    var unReadMsgView = UIView().then {
        $0.isHidden = false
        $0.backgroundColor = .errorNotice
    }
    
    var unReadMsgCnt = UILabel().then {
        $0.text = "new"
        $0.textColor = .white
        $0.textAlignment = .center
        $0.font = .b12
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.layer.applySketchShadow(alpha: 0.24, x: 0, y: 2, blur: 6)
        unReadMsgView.layer.cornerRadius = unReadMsgView.frame.height / 2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        profileImageView.image = nil
//        flagImageView.image = nil
        
//        nameLabel.text = nil
//        locationLabel.text = nil
        lastMsgLabel.text = nil
//        timeLabel.text = nil
        unReadMsgCnt.text = nil
        
//        unReadMsgView.isHidden = true
    }
    
    func commonInit() {
        setLayout()
        setConstraint()
    }
    
    func setLayout() {
        backgroundColor = .white
        
        [containerView].forEach(contentView.addSubview(_:))
        
        [profileView, messageView].forEach(containerView.addSubview(_:))
        
        [profileImageView].forEach(profileView.addSubview(_:))
        
        [msgTopView, msgMiddleView].forEach(messageView.addSubview(_:))
        
        [senderInfoStack, timeLabel].forEach(msgTopView.addSubview(_:))
        [flagImageView, locationLabel, nameLabel].forEach(senderInfoStack.addArrangedSubview(_:))
        
        [unReadMsgView, lastMsgLabel].forEach(msgMiddleView.addSubview(_:))
        unReadMsgView.addSubview(unReadMsgCnt)
        
        
    }
    func setConstraint() {
        containerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(12)
            $0.left.right.equalToSuperview().inset(12)
        }
        
        profileView.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview()
            $0.width.equalTo(56)
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(4)
            $0.bottom.equalToSuperview().inset(-1)
            $0.leading.trailing.equalToSuperview()
        }
        
        messageView.snp.makeConstraints {
            $0.left.equalTo(profileView.snp.right).offset(15)
            $0.right.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
        
        msgTopView.snp.makeConstraints {
            $0.height.equalTo(21)
            $0.leading.trailing.top.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.height.equalTo(17)
            $0.width.greaterThanOrEqualTo(timeLabel.frame.size.width)
        }
        
        flagImageView.snp.makeConstraints {
            $0.width.equalTo(19)
        }
        
        senderInfoStack.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.trailing.lessThanOrEqualTo(timeLabel.snp.leading).inset(25)
        }
        
        msgMiddleView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(msgTopView.snp.bottom).offset(1)
        }
        
        unReadMsgView.snp.makeConstraints {
            $0.height.equalTo(18)
            $0.width.greaterThanOrEqualTo(18)
            $0.top.equalToSuperview().inset(3)
            $0.trailing.equalToSuperview().inset(8)
        }
        
        unReadMsgCnt.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(5)
            $0.top.bottom.equalToSuperview().inset(3)
        }
        
        lastMsgLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(2)
            $0.leading.bottom.equalToSuperview()
            $0.trailing.lessThanOrEqualToSuperview().inset(75)
        }
        
    }
    
    func configure(model: Any) {
        if let str = model as? String {
            lastMsgLabel.text = str
            nameLabel.text = str.components(separatedBy: " ").first ?? ""
        }
    }
    
    func showDummyIndexPath(indexPath: IndexPath) {
        lastMsgLabel.text = "section \(indexPath.section), row \(indexPath.row) => " + (lastMsgLabel.text ?? "")
    }
    
    func setUnReadMsgCnt(count: Int?) {
        guard let count = count, count > -1 else { return }
        switch count {
        case 0:
            unReadMsgView.isHidden = true
        case 1..<100:
            unReadMsgView.isHidden = false
            unReadMsgCnt.text = "\(count)"
        default:
            unReadMsgView.isHidden = false
            unReadMsgCnt.text = "99+"
        }
    }
}
