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

import Lottie
import Shared

class ProfileListLayout {
    
    var safetyLayer = UIView().then {
        $0.backgroundColor = .grayF1
    }
    
    var collectionViewFlowLayout = VideoCollectionViewFlowLayout()
    
    
    var refreshImage = LottieAnimationView(name: "refresh").then{
        $0.contentMode = .scaleAspectFit
        $0.loopMode    = .loop
        $0.alpha = 0
    }
    
    lazy var refreshControl : UIRefreshControl = UIRefreshControl().then{
        $0.addSubview(refreshImage)
        $0.tintColor = .clear
        $0.backgroundColor = .blue
        $0.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        refreshImage.snp.makeConstraints{
            $0.size.equalTo(CGSize(width: 32, height: 32))
            $0.top.equalToSuperview().offset(0)
            $0.centerX.equalToSuperview()
        }
    }
    
    lazy var collectionView: UICollectionView = { [unowned self] in
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        view.backgroundColor = .clear
        view.layer.borderWidth = 1
        view.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        view.refreshControl = refreshControl
        view.register(VideoCell.self, forCellWithReuseIdentifier: VideoCell.identifier)
        return view
    }()
    
    
    
    var topMenuBar: TopMenuBar = TopMenuBar(status: .quickMeet)
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
        safetyLayer.addSubview(collectionView)
    }
    
    func setConstraint() {
        
        safetyLayer.snp.makeConstraints {
            $0.top.equalToSuperview().inset(DeviceManager.Inset.top)
            $0.bottom.equalToSuperview().inset(DeviceManager.Inset.bottom)
            $0.left.right.equalToSuperview()
        }
        
        topMenuBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
//            $0.top.equalTo(-DeviceManager.Inset.top)
            $0.top.equalToSuperview()
        }
        
        topFilterBar.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.left.equalToSuperview().offset(12)
            $0.right.equalToSuperview().offset(-12)
            $0.top.equalTo(topMenuBar.snp.bottom).offset(10)
        }
        
        collectionView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(12)
            $0.right.equalToSuperview().offset(-12)
            $0.top.equalTo(topFilterBar.snp.bottom).offset(10)
            $0.bottom.equalTo(safetyLayer.snp.bottom).offset(0)
        }
    }
    
    func setProperty() {
        
    }
    
    func bind(to viewModel: ProfileListViewModel) {
        
    }
    
    func setInput(to viewModel: ProfileListViewModel) {
        
    }

}


protocol MyCollectionViewLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath) -> CGFloat
}

extension ProfileListLayout {
    class VideoCollectionViewFlowLayout: UICollectionViewFlowLayout {
        weak var delegate: MyCollectionViewLayoutDelegate?

        fileprivate var numberOfColumns: Int = 2
        fileprivate var cellPadding: CGFloat = 6.0
        fileprivate var cache: [UICollectionViewLayoutAttributes] = []
        fileprivate var contentHeight: CGFloat = 0.0

        fileprivate var contentWidth: CGFloat {
            guard let collectionView = collectionView else {
                return 0.0
            }
            let insets = collectionView.contentInset
            return collectionView.bounds.width - (insets.left + insets.right)
        }

        override var collectionViewContentSize: CGSize {
            return CGSize(width: contentWidth, height: contentHeight)
        }

        // 바로 다음에 위치할 cell의 위치를 구하기 위해서 xOffset, yOffset 계산
        override func prepare() {
            super.prepare()
            guard let collectionView = collectionView else { return }
            cache.removeAll()

            // xOffset 계산
            let columnWidth: CGFloat = contentWidth / CGFloat(numberOfColumns)
            var xOffset: [CGFloat] = []
            for column in 0..<numberOfColumns {
                let offset = CGFloat(column) * columnWidth
                xOffset += [offset]
            }

            // yOffset 계산
            var column = 0
            var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
            for item in 0..<collectionView.numberOfItems(inSection: 0) {
                let indexPath = IndexPath(item: item, section: 0)

                let imageHeight = delegate?.collectionView(collectionView, heightForImageAtIndexPath: indexPath) ?? 0
                let height = cellPadding * 2 + imageHeight
                let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
                let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)

                // cache 저장
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = insetFrame
                cache.append(attributes)

                // 새로 계산된 항목의 프레임을 설명하도록 확장
                contentHeight = max(contentHeight, frame.maxY)
                yOffset[column] = yOffset[column] + height

                // 다음 항목이 다음 열에 배치되도록 설정
                column = column < (numberOfColumns - 1) ? (column + 1) : 0
            }
        }

        // rect에 따른 layoutAttributes를 얻는 메서드 재정의
        override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
            return cache.filter { rect.intersects($0.frame) }
        }

        // indexPath에 따른 layoutAttribute를 얻는 메서드 재정의
        override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
            return cache[indexPath.item]
        }

    }
}

//refresh
extension ProfileListLayout {
    
    @objc func refresh() {
        self.refreshControl.beginRefreshing()

        //데이터 로드 완료 되면
        getMainList(page: 1) { [weak self] in
            guard let self = self else { return }
            self.refreshControl.endRefreshing()
            self.collectionView.reloadData()
        }
    }
    
    func getMainList(page: Int, completion: (() -> Void)? = nil ) {
        //API or socket
        if let completion = completion {
            completion()
        }
    }
    
}
