//
//  MessageQuestionCell.swift
//  Feature
//
//  Created by root0 on 2023/09/15.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

import Core
import Shared

class QuestionSection: UIView {
    
    let container = UIView().then {
        $0.backgroundColor = UIColor(rgbF: 245)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addComponent() {
        self.addSubview(container)
    }
    
    func setConstraints() {
        container.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
            $0.width.equalTo(180)
            $0.height.equalTo(200)
        }
    }
}

class MessageQuestionCell: UITableViewCell, Reusable {
    
    let container = UIView()
    
    var profileView = ChatProfileView().then {
        $0.isHidden = false
    }
    
    let bubbleScroll = UIScrollView().then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        
    }
    
    
    
    private var dBag = DisposeBag()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addComponent()
        
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addComponent() {
        contentView.addSubview(container)
        
        container.addSubview(profileView)
        
        [bubbleScroll]
            .forEach(container.addSubview(_:))
    }
    
    func setConstraints() {
        profileView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(28)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
        
        container.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(2)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview()
        }
        
        [UIColor.red, .yellow, .blue, .purple].enumerated()
            .forEach {
                let qv = QuestionSection()
                qv.backgroundColor = $0.element
                
                let xOffset = 180 * CGFloat($0.offset)
                
                qv.frame = CGRect(x: xOffset, y: 0, width: 180, height: 200)
                bubbleScroll.addSubview(qv)
        }
        
        bubbleScroll.contentSize.width = 180 * 4
        
        bubbleScroll.snp.makeConstraints {
            $0.top.equalToSuperview().inset(60)
            $0.leading.equalToSuperview().inset(56)
            $0.trailing.equalToSuperview().inset(-16)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(200)
        }
    }
    
    func configUI() {
        profileView.name.text = "관리자"
        profileView.thumbnail.image = FeatureAsset.msgService.image
        
        setConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        [profileView]
            .forEach { $0.snp.removeConstraints() }
        
        profileView.isHidden = false
        
    }
    
}
