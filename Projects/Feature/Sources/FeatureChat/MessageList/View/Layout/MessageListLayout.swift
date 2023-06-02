//
//  MessageListLayout.swift
//  Feature
//
//  Created by root0 on 2023/06/02.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift

import Shared

class MessageListLayout {
    
    var mainView = UIView().then {
        $0.backgroundColor = .white
    }
    
    var disposeBag = DisposeBag()
    
    func viewDidLoad(view: UIView) {
        view.addSubview(mainView)
        
        mainView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        setLayout()
        setConstraint()
    }
    
    func setLayout() {
        
    }
    
    func setConstraint() {
        
    }
    
    func bind(to viewModel: MessageListViewModel) {
        
    }
    
    func removeVies() {
        mainView = .init()
        
        disposeBag = .init()
    }
    
    deinit {
        log.d("MessageListLayout Deinit")
    }
}
