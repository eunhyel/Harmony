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
    
    enum TypeOfLayout {
        case user
        case customerService
    }
    var typeOfLayout: TypeOfLayout = .user
    
    var layout = UIView().then {
        $0.backgroundColor = .white
    }
    
    var headBarView = MessageTopHeadView()
    
    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
        $0.backgroundColor = .white
        $0.register(MessageTextCell.self, forCellWithReuseIdentifier: MessageTextCell.identifier)
        $0.register(MessageDateDivisionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MessageDateDivisionView.reuseIdentifier)
//        $0.isHidden = true
        $0.contentInset = .init(top: 20, left: 0, bottom: 20, right: 0)
    }
    
    
    var userInputView = MessageInputView()
    
//    var userInputBottomConstraint: Constraint?
    
//    var dataSource: UICollectionViewDiffableDataSource<String, ChatMessage>!
    var dataSource: UICollectionViewDiffableDataSource<String, MockList>!
    weak var disposeBag: DisposeBag?
    
    init(_ type: TypeOfLayout = .user) {
        self.typeOfLayout = type
        super.init()
    }
    
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
            collectionView,
            userInputView,
            headBarView
        ].forEach(layout.addSubview(_:))
    }
    
    func setConstraints() {
        layout.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()//.offset(-DeviceManager.Inset.bottom)
        }
        
        headBarView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
//            $0.height.equalTo(56 + DeviceManager.Inset.top)
        }
        
        userInputView.snp.makeConstraints {
            $0.top.greaterThanOrEqualToSuperview()
            $0.leading.trailing.equalToSuperview()
//            userInputBottomConstraint = $0.bottom.equalTo(layout.safeAreaLayoutGuide).constraint
            $0.bottom.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(DeviceManager.Inset.top + 56)
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
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnv: NSCollectionLayoutEnvironment) in
            // section provider
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                sectionHeader.pinToVisibleBounds = false
            
                section.boundarySupplementaryItems = [sectionHeader]
            
            return section
        }
        
        return layout
    }
    
    func createCSLayout() -> UICollectionViewLayout {
        return UICollectionViewLayout()
    }
}
