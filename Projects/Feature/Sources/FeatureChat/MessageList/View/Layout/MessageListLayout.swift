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
    
    var safetyLayer = UIView().then {
        $0.backgroundColor = .grayF1
    }
    
    var topMenuBar: TopMenuBar = TopMenuBar(size: .init(width: .zero, height: 76), status: .message)
    var listBody: MessageListBody = MessageListBody(frame: .zero)
    var listEmpty: MessageListEmpty = MessageListEmpty(frame: .zero)
    weak var disposeBag: DisposeBag?
    
    func viewDidLoad(view: UIView, viewModel: MessageListViewModel) {
        
        view.addSubview(safetyLayer)
        
        safetyLayer.snp.makeConstraints {
            $0.top.equalToSuperview().inset(DeviceManager.Inset.top)
            $0.bottom.equalToSuperview().inset(DeviceManager.Inset.bottom)
            $0.left.right.equalToSuperview()
        }
        
        setLayout()
        setConstraint()
        setProperty()
        bind(to: viewModel)
    }
    
    func setLayout() {
        
        [topMenuBar, listBody, listEmpty].forEach(safetyLayer.addSubview(_:))
        
        
    }
    
    
    
    func setProperty() {
        // add tableview refresh
    }
    
    /// Binding Subviews <-> ViewModel
    func bind(to viewModel: MessageListViewModel) {
        
    }
    
    /// Binding TapGesture <-> ViewModel
    func setInput(to viewModel: MessageListViewModel) {
        
    }
    
    func setConstraint() {
        
        topMenuBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(-DeviceManager.Inset.top)
        }
        
        listBody.snp.makeConstraints {
            $0.top.equalTo(topMenuBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(DeviceManager.Inset.bottom)
        }
        
        listEmpty.snp.makeConstraints {
            $0.top.equalTo(topMenuBar.snp.bottom)
            $0.bottom.leading.trailing.equalTo(listBody)
        }
    }
    
    func removeViews() {
        safetyLayer = .init()
        topMenuBar = .init(frame: .zero)
        listBody = .init(frame: .zero)
        
        
    }
    
    deinit {
        log.d("MessageListLayout Deinit")
    }
}
