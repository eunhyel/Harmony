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
        
    }
    
    func bind(to viewModel: MessageViewModel) {
        
    }
    
    func addComponents(superView: UIView) {
        
    }
    
    func setConstraints() {
        
    }
}
