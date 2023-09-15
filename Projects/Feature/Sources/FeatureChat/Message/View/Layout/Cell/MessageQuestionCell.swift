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

class MessageQuestionCell: UITableViewCell, Reusable {
    
    let container = UIView()
    
    var profileView = ChatProfileView().then {
        $0.isHidden = false
    }
    
    let bubbleStack = UIStackView().then {
        $0.axis = .horizontal
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
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        [profileView]
            .forEach { $0.snp.removeConstraints() }
        
    }
    
}
