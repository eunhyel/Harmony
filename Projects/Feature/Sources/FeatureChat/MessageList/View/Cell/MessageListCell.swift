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

import Core
import Shared

class MessageListCell: UITableViewCell, Reusable {
    
    var container = UIView().then {
        $0.backgroundColor = .clear
    }
    
    var thumbnailContainer = UIView().then {
        $0.backgroundColor = .clear
    }
    
    var thumbnail = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = FeatureAsset.rectangle135.image
        $0.roundCorners(cornerRadius: 32, maskedCorners: [.allCorners])
    }
    
    var vInfoStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
//        $0.distribution = .fillEqually // top bottom 16 16
        $0.alignment = .leading
    }
    
    let name = UILabel().then {
        $0.text = "Name"
        $0.textColor = UIColor(rgbF: 17)
        $0.font = .m18
        $0.setCharacterSpacing(-0.5)
//        $0.setLineHeight(18)
    }
    
    var hSenderInfoStack = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .center
        $0.isHidden = true
    }
    
    var gender = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.roundCorners(cornerRadius: 9, maskedCorners: [.allCorners])
    }
    
    var nation = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = FeatureAsset.icoNation.image
    }
    
    var location = UILabel().then {
        $0.font = .m14
        $0.text = "Santarosa, AR"
        $0.textColor = UIColor(rgbF: 150)
        $0.setCharacterSpacing(-0.5)
        $0.setLineHeight(14)
//        $0.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
    
    var lastMessage = UILabel().then {
        $0.textColor = UIColor(rgbF: 17)
        $0.font = .m16
        $0.text = "Mauris vel feugiat sapien, vitae awaicm wiic"
        $0.setCharacterSpacing(-0.5)
//        $0.setLineHeight(16)
    }
    
    var lastTime = UILabel().then {
        $0.textAlignment = .right
        $0.font = .r14
        $0.textColor = UIColor(rgbF: 150)
        $0.setCharacterSpacing(-0.5)
        $0.setLineHeight(14)
        
    }
    
    var unReadBadge = UIView().then {
        $0.backgroundColor = UIColor(redF: 106, greenF: 242, blueF: 176)
        $0.roundCorners(cornerRadius: 10, maskedCorners: [.allCorners])
    }
    
    var unReadMsgCnt = UILabel().then {
        $0.text = "new"
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = .m14
        $0.setCharacterSpacing(-0.5)
        $0.setLineHeight(14)
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
        super.draw(rect)
    }
    
    func commonInit() {
        setLayout()
        setConstraint()
    }
    
    func setLayout() {
        backgroundColor = .white
        
        contentView.addSubview(container)
        
        [thumbnailContainer, vInfoStack, lastTime, unReadBadge]
            .forEach(container.addSubview(_:))
        
        thumbnailContainer.addSubview(thumbnail)
        
        [name, hSenderInfoStack, lastMessage]
            .forEach(vInfoStack.addArrangedSubview(_:))
        
        [gender, nation, location]
            .forEach(hSenderInfoStack.addArrangedSubview(_:))
        
        unReadBadge.addSubview(unReadMsgCnt)
        
    }
    func setConstraint() {
        container.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        thumbnailContainer.snp.makeConstraints {
            $0.size.equalTo(64)
            $0.top.bottom.leading.equalToSuperview()
        }
        
        thumbnail.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
        
        vInfoStack.snp.makeConstraints {
            $0.leading.equalTo(thumbnailContainer.snp.trailing).offset(12)
            $0.top.bottom.equalToSuperview()
            $0.trailing.lessThanOrEqualToSuperview().inset(50)
        }
        
//        name.snp.makeConstraints {
//            $0.height.equalTo(18)
//        }

        hSenderInfoStack.snp.makeConstraints {
            $0.height.equalTo(18)
        }
        
        lastMessage.snp.makeConstraints {
            $0.height.equalTo(16)
        }
        
        lastTime.snp.makeConstraints {
            $0.centerY.equalTo(name.snp.centerY)
            $0.trailing.equalToSuperview()
        }
        
        unReadMsgCnt.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(3)
            $0.leading.trailing.equalToSuperview().inset(5)
            $0.height.equalTo(14)
        }
        
        unReadBadge.snp.makeConstraints {
            $0.centerY.equalTo(lastMessage.snp.centerY)
            $0.trailing.equalToSuperview()
        }
        
    }
    
    func configUI(model: BoxUnit) {
        thumbnail.image = FeatureAsset.recordAlbum.image
        
        name.text = model.memNick
        
        if model.memNo != 7777 && model.memNo != 8888 {
            hSenderInfoStack.isHidden = false
            
            gender.image = {
                switch model.gender {
                case "f", "F": return FeatureAsset.bageFemale.image
                case "m", "M": return FeatureAsset.bageMale.image
                default: return FeatureAsset.btnMmsVideo.image
                }
            }()
            nation.image = FeatureAsset.icoNation.image
            location.text = "\(model.country), \(model.location)"
        }
        
        lastMessage.text = model.lastMsg
        
        lastTime.text = model.lastTime.toDate()?.getElapsedTime().stringValue
    
        if model.memNo == 7777 || model.memNo == 8888 {
            setUnReadMsgCnt(count: -1)
        } else {
            setUnReadMsgCnt(count: model.noreadCnt)
        }
        
        
    }
    
    func setUnReadMsgCnt(count: Int?) {
        guard let count = count, count > -1 else {
            unReadBadge.isHidden = false
            unReadMsgCnt.text = "new"
            return
        }
        switch count {
        case 0:
            unReadBadge.isHidden = true
        case 1..<100:
            unReadBadge.isHidden = false
            unReadMsgCnt.text = "\(count)"
        default:
            unReadBadge.isHidden = false
            unReadMsgCnt.text = "99+"
        }
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        thumbnail.image = nil
        name.text = "Name"
        hSenderInfoStack.isHidden = true
        gender.image = nil
        nation.image = nil
        location.text = "country, location.."
        lastMessage.text = "Message..."
        
        lastTime.text = "00:00"
        unReadBadge.isHidden = true
        unReadMsgCnt.text = "new"
    }
    
    
    func imageLoad(stringURL: String) async -> UIImage? {
        guard let url = URL(string: stringURL) else { return nil }
        
        var image: UIImage?
        let urltoImage = Task {
            if let data = try? Data(contentsOf: url) {
                let jpegData = UIImage(data: data)?.jpegData(compressionQuality: 1)
                return UIImage(data: jpegData ?? data)
            } else {
                return nil
            }
        }
        image = await urltoImage.value
        
        return image
    }
}
