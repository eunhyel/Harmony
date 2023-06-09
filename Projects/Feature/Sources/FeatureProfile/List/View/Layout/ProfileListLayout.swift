//
//  ProfileLayoutModel.swift
//  GlobalYeoboya
//
//  Created by inforex_imac on 2022/12/21.
//  Copyright © 2022 GlobalYeoboya. All rights reserved.
//

import UIKit
import RxSwift
import RxGesture
import SnapKit
import Then

import Shared

class ProfileListLayout {
    
    var safetyLayer = UIView().then {
        $0.backgroundColor = .grayF1
    }
    
    var topMenuBar: TopMenuBar = TopMenuBar(size: .init(width: .zero, height: 76), status: .quickMeet)
    var topFilterBar : TopFilterBar = TopFilterBar(size: .init(width: 1, height: 40))
    
    weak var disposeBag: DisposeBag?
    
    func viewDidLoad(view: UIView, viewModel: ProfileListViewModel) {
        
        view.addSubview(safetyLayer)
        
        setLayout()
        setConstraint()
        setProperty()
        bind(to: viewModel)
        setInput(to: viewModel)
    }
    
    func setLayout() {
        [
            topMenuBar,
            topFilterBar
        ].forEach(safetyLayer.addSubview(_:))
    }
    
    func setConstraint() {
        
        safetyLayer.snp.makeConstraints {
            $0.top.equalToSuperview().inset(DeviceManager.Inset.top)
            $0.bottom.equalToSuperview().inset(DeviceManager.Inset.bottom)
            $0.left.right.equalToSuperview()
        }
        
        topMenuBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(-DeviceManager.Inset.top)
        }
        
        topFilterBar.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.left.equalToSuperview().offset(12)
            $0.right.equalToSuperview().offset(-12)
            $0.top.equalTo(topMenuBar.snp.bottom).offset(10)
        }
    }
    
    func setProperty() {
        
    }
    
    func bind(to viewModel: ProfileListViewModel) {
        
    }
    
    func setInput(to viewModel: ProfileListViewModel) {
        
    }
    
}

