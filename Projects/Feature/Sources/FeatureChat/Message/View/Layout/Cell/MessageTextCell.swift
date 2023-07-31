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

import Core
import Shared

class MessageTextCell: UICollectionViewCell, Reusable {
    static let identifier = "MessageTextCell" //reuseIdentifier
    
    let container = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let profileView = ChatProfileView()
    
    let bubble = UIView().then {
        $0.backgroundColor = .lightGray
        $0.layer.cornerRadius = 20.0
        $0.clipsToBounds = true
    }
    
    let chat = UILabel().then {
        $0.text = "Do you want to go with me?"
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.textColor = UIColor(rgbF: 99)
    }
    
    private(set) var type: SendType = .send
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addComponents()
        setConstraints()
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
        
        container.addSubview(profileView)
        
        container.addSubview(bubble)
        
        bubble.addSubview(chat)
    }
    
    func setConstraints() {
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        container.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.leading.trailing.equalToSuperview().inset(12)
        }
        
        profileView.snp.makeConstraints {
            $0.size.equalTo(42)
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        bubble.snp.makeConstraints {
            $0.bottom.equalToSuperview()
//            $0.height.greaterThanOrEqualTo(37)
            $0.trailing.equalToSuperview().offset(-73)
        }
        
        chat.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-24)
        }
    }
    
    func scrollingProfileView(offset: CGFloat) {
        let update4 = max(0, min(contentView.frame.size.height - profileView.frame.size.height, offset))
        
        profileView.snp.updateConstraints {
            $0.top.equalToSuperview().offset(update4)
        }
    }
    
    func bind(with: String = "aweifjaiwefjaie", isSameWithPrev: Bool = false) {
        //profileImage.kf.setImage(with: URL(string: with.photo))
        //name.text = with.name
        chat.text = Dummy.getContent()
        
        
//        _ = isSameWithPrev ? hiddenLayout() : showLayout()
        
    }
    
    func translateYProfileView(distant: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.profileView.transform = CGAffineTransform(translationX: 0, y: distant)
        }
    }
}
