//
//  ImageBundleView.swift
//  Feature
//
//  Created by root0 on 2023/09/27.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift

class ImageBundleView: UIView, ImageBundleDataSourceDelegate {
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10
        view.isScrollEnabled = false
        view.register(ImageBundleCell.self, forCellWithReuseIdentifier: ImageBundleCell.reuseIdentifier)
        
        return view
    }()
    
    var clickImage: ((Int) -> Void)?
    
//    var imageBundleDataSource = imageBundleDataSource
    var manager: ImageBundleManager?
    
    required init() {
        super.init(frame: .zero)
        initView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    
    private func initView() {
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
    
    func configUI(data: [String]?) {
        self.manager = ImageBundleManager(["0", "1", "2", "3"])
        manager?.delegate = self
        collectionView.delegate = manager
        collectionView.dataSource = setImageDataSource()
        
        collectionView.collectionViewLayout = setBundleDisplayLayout(data?.count ?? 0)
        collectionView.reloadData()
        
        collectionView.snp.remakeConstraints {
            $0.directionalEdges.equalToSuperview()
            $0.height.equalTo(manager?.getHeight() ?? 120).priority(.high)
        }
    }
    
    func clickCell(index: Int) {
        clickImage?(index)
    }
    
    func setImageDataSource() -> UICollectionViewDiffableDataSource<String, ImageBundleItem> {
        return UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, item in
           guard let self = self else { return UICollectionViewCell() }
           
           guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageBundleCell.reuseIdentifier, for: indexPath) as? ImageBundleCell else {
               return UICollectionViewCell()
           }
           
           cell.bind()
           
           if let url = URL(string: item.url){
               cell.imageView.kf.setImage(with: url)
           } else {
               cell.imageView.image = item.image
           }
           
           cell.tap = {
               let idx = indexPath.item
               
               self.clickCell(index: idx)
           }
           
           
           return cell
       })
    }
    
    func setBundleDisplayLayout(_ itemLength: Int) -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (section, env) -> NSCollectionLayoutSection in
            
            switch itemLength {
            case 0:
                fallthrough
                
            case 1:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                
                return section
                
            case 2:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1 / 2), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                
                return section
                
            case 3:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1 / 3), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                
                return section
                
            default:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1 / 2), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1 / 2))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                
                return section
                
            }
            
        }
        
        return layout
    }
}

