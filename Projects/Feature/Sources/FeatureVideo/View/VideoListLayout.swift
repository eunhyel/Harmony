//
//  VideoListLayout.swift
//  Feature
//
//  Created by root0 on 2023/06/05.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift

import Shared

class VideoListLayout {
    
    var safetyLayer = UIView().then {
        $0.backgroundColor = .grayF1
    }
    
    var topMenuBar: TopMenuBar = TopMenuBar(size: .init(width: .zero, height: 76), status: .videoChat)
    var topFilterBar : TopFilterBar = TopFilterBar(size: .init(width: 1, height: 40))
    
    weak var disposeBag: DisposeBag?
    
    func viewDidLoad(view: UIView, viewModel: VideoListViewModel) {
        
        view.addSubview(safetyLayer)
        
        setLayout()
        setConstraint()
        setProperty()
        bind(to: viewModel)
    }
    
    func setLayout() {
        
        [
            topMenuBar,
            topFilterBar
        ].forEach(safetyLayer.addSubview(_:))
        
        
    }
    
    
    
    func setProperty() {
        // add tableview refresh
    }
    
    /// Binding Subviews <-> ViewModel
    func bind(to viewModel: VideoListViewModel) {
        
    }
    
    /// Binding TapGesture <-> ViewModel
    func setInput(to viewModel: VideoListViewModel) {
        
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
    
    func removeViews() {
        safetyLayer = .init()
    }
    
    deinit {
        log.d("VideoListLayout Deinit")
    }
}
