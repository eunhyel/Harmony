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
import Core

class MessageLayout: NSObject {
    var layout = UIView(frame: .zero).then {
        $0.backgroundColor = .grayE0
    }
    
    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
        $0.backgroundColor = .white
        $0.register(MessageTextCell.self, forCellWithReuseIdentifier: MessageTextCell.identifier)
    }
    
    
    var userInputView = MessageInputView()
    var dataSource: UICollectionViewDiffableDataSource<String, String>!
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
            userInputView,
            collectionView,
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
        
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(DeviceManager.Inset.top)
            $0.bottom.equalTo(userInputView.snp.top)
            $0.leading.trailing.equalToSuperview()
        }
        
    }
    
    func tapBind() {
        
    }
    
}
