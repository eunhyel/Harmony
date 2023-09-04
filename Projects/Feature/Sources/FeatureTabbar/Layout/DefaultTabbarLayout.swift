//
//  DefaultTabbarLayout.swift
//  HoneyGlobal
//
//  Created by inforex_imac on 2023/02/01.
//  Copyright © 2023 HoneyGlobal. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift


class DefaultTabbarLayout {
    
    var safetyView = UIView(frame: .zero)
    
    weak var layout: UIView?
    var dBag = DisposeBag()
    
    let indicator = UIView().then {
        $0.isUserInteractionEnabled = true
        $0.isHidden = true
        $0.backgroundColor = .black.withAlphaComponent(0.3)
    }
    
    let tabBar = CoyTabBar()
    
    func viewDidLoad(superView: UIView) {
        layout = superView
        setLayout()
        setConstraint()
    }
    
    func setLayout() {
        layout?.addSubview(tabBar)
        
    }
    
    func setConstraint() {
        tabBar.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    func bind(to viewModel: TabbarViewModel) {
        tabBar.menuTapped
            .bind { idx in
                viewModel._selectedTabBarItem.accept(idx)
            }
            .disposed(by: dBag)
        
        viewModel._countMessageBadge
            .withUnretained(self)
            .bind { (owner, count) in
                owner.tabBar.msgBadge.updateBadge(count)
            }
            .disposed(by: dBag)
    }
}



