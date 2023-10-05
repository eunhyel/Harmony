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
        view.isScrollEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.register(ImageBundleCell.self, forCellWithReuseIdentifier: ImageBundleCell.reuseIdentifier)
        
        return view
    }()
    
    var clickImage: ((Int) -> Void)?
    
    enum ImageBundleSection: Int {
        case main = 0
    }
    var imageBundleDataSource: UICollectionViewDiffableDataSource<ImageBundleSection, ImageBundleItem>!
    var manager: ImageBundleManager!
    
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
        self.backgroundColor = .systemPink
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
    
    func configUI(data: [String]?) {
        self.manager = ImageBundleManager(data)
        collectionView.delegate = self
        imageBundleDataSource = setImageDataSource()
        collectionView.dataSource = imageBundleDataSource
        
        collectionView.collectionViewLayout = setBundleDisplayLayout(data?.count ?? 0)
        
        var snapShot = imageBundleDataSource.snapshot()
        snapShot.appendSections([.main])
        
        if manager.items.count >= 4 {
            let slicesitems = Array(manager.items[0..<4])
            snapShot.appendItems(slicesitems, toSection: .main)
            
        } else {
            let sliceitems = Array(manager.items[manager.items.indices])
            snapShot.appendItems(sliceitems, toSection: .main)
        }
        imageBundleDataSource.apply(snapShot)
        
        collectionView.snp.remakeConstraints {
            $0.directionalEdges.equalToSuperview()
            $0.height.equalTo(manager.getHeight()).priority(.high)
            $0.width.equalTo(manager.getWidth())
        }
        
    }
    
    func clickCell(index: Int) {
        clickImage?(index)
    }
    
    func setImageDataSource() -> UICollectionViewDiffableDataSource<ImageBundleSection, ImageBundleItem> {
        let allPhotoCount = manager.items.count
        
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
            
            if indexPath.item == 3, manager.items.count > 4 {
                cell.extra.isHidden = false
                cell.extraCount.text = "+\(manager.items.count - 4)"
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
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(140), heightDimension: .absolute(140))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(140))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                
                return section
                
            case 2:
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(106), heightDimension: .absolute(106))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(106))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                    group.interItemSpacing = .fixed(2)
                
                let section = NSCollectionLayoutSection(group: group)
                
                return section
                
            case 3:
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(70), heightDimension: .absolute(70))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(70))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                    group.interItemSpacing = .fixed(2)
                
                let section = NSCollectionLayoutSection(group: group)
                
                return section
                
            default:
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(106), heightDimension: .absolute(106))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(106))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                    group.interItemSpacing = .fixed(2)
                
                let section = NSCollectionLayoutSection(group: group)
                    section.interGroupSpacing = 2
                
                return section
                
            }
            
        }
        
        return layout
    }
}

extension ImageBundleView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        clickCell(index: indexPath.item)
    }
}
