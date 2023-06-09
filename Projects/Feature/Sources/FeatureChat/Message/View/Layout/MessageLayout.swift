//
//  MessageLayout.swift
//  Feature
//
//  Created by root0 on 2023/06/09.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import Then
import SnapKit

import Shared

class MessageLayout: NSObject {
    var layout = UIView(frame: .zero).then {
        $0.backgroundColor = .grayE0
    }
    
    var userInputView = MessageInputView()
    
    weak var disposeBag: DisposeBag?
    
    func viewDidLoad(superView: UIView) {
        addComponents(superView: superView)
        setConstraints()
        tapBind()
    }
    
    func bind(to viewModel: MessageViewModel) {
        
    }
    
    func addComponents(superView: UIView) {
        superView.addSubview(layout)
        
        [
            userInputView
        ].forEach(layout.addSubview(_:))
    }
    
    func setConstraints() {
        layout.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        userInputView.snp.makeConstraints {
            $0.top.greaterThanOrEqualToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(layout.safeAreaLayoutGuide)
        }
    }
    
    func tapBind() {
        
    }
}
