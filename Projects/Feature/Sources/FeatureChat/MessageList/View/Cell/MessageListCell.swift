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

class MessageListCell: UITableViewCell, Reusable {
    
    var container = UIView().then {
        $0.backgroundColor = .clear
    }
    
    var thumbnailContainer = UIView().then {
        $0.backgroundColor = .clear
    }
    
    var thumbnail = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = FeatureAsset.recordAlbum.image
        $0.roundCorners(cornerRadius: 32, maskedCorners: [.allCorners])
    }
    
    var vInfoStack = UIStackView().then {
        $0.axis = .vertical
//        $0.spacing = 4
        $0.distribution = .fillEqually // top bottom 16 16
        $0.alignment = .leading
    }
    
    let name = UILabel().then {
        $0.text = "Name"
        $0.textColor = UIColor(rgbF: 17)
        $0.font = .m18
        $0.setCharacterSpacing(-0.5)
        $0.setLineHeight(18)
    }
    
    var hSenderInfoStack = UIStackView().then {
        $0.axis = .horizontal
        $0.backgroundColor = .clear
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
        $0.font = .m18
        $0.text = "Mauris vel feugiat sapien, vitae awaicm wiic"
        $0.lineBreakMode = .byTruncatingTail
        $0.setCharacterSpacing(-0.5)
        $0.setLineHeight(18)
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        thumbnail.image = nil
        name.text = "Name"
        gender.image = nil
        nation.image = nil
        location.text = ""
        lastMessage.text = "Message..."
        
        lastTime.text = "00:00"
        unReadBadge.isHidden = true
    }
    
    func commonInit() {
        setLayout()
        setConstraint()
    }
    
    func setLayout() {
        backgroundColor = .white
        
        contentView.addSubview(container)
        
        
    }
    func setConstraint() {
        container.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(12)
            $0.left.right.equalToSuperview().inset(12)
        }
        
        
        
    }
    
    func configUI(model: Any) {
        
    }
    
    func showDummyIndexPath(indexPath: IndexPath) {
        lastMessage.text = "section \(indexPath.section), row \(indexPath.row) => " + (lastMessage.text ?? "")
    }
    
    func setUnReadMsgCnt(count: Int?) {
        guard let count = count, count > -1 else { return }
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
}
