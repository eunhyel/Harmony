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
        $0.backgroundColor = .systemPink
    }
    
    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
        $0.backgroundColor = .white
        $0.register(MessageTextCell.self, forCellWithReuseIdentifier: MessageTextCell.identifier)
//        $0.isHidden = true
    }
    
    
    var userInputView = MessageInputView()
    
    var userInputBottomConstraint: Constraint?
    
    var dataSource: UICollectionViewDiffableDataSource<String, ChatMessage>!
    weak var disposeBag: DisposeBag?
    
    func viewDidLoad(superView: UIView) {
        addComponents(superView: superView)
        setConstraints()
        tapBind()
    }
    
    func bind(to viewModel: MessageViewModel) {
        bind_keyboard(to: viewModel)
        bind_userInput(to: viewModel)
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
            $0.leading.top.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()//.offset(-DeviceManager.Inset.bottom)
        }
        
        userInputView.snp.makeConstraints {
            $0.top.greaterThanOrEqualToSuperview()
            $0.leading.trailing.equalToSuperview()
            userInputBottomConstraint = $0.bottom.equalTo(layout.safeAreaLayoutGuide).constraint
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(DeviceManager.Inset.top)
            $0.bottom.equalTo(userInputView.snp.top)
            $0.leading.trailing.equalToSuperview()
        }
        
    }
    
    func tapBind() {
        
    }
    
    func setCollectionViewLayout() {
        collectionView.setCollectionViewLayout(createChattingLayout(), animated: true)
    }
    
    func createChattingLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
