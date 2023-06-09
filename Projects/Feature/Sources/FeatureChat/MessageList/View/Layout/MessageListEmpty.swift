//
//  MessageListEmpty.swift
//  Feature
//
//  Created by root0 on 2023/06/07.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift

class MessageListEmpty: UIView {
    
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() {
        
    }
    
    func setConstraint() {
        
    }
    
    func bind(to viewModel: MessageListViewModel) {
        
    }
}
