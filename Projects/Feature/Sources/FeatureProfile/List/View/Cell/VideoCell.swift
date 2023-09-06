//
//  VideoCell.swift
//  Feature
//
//  Created by eunhye on 2023/09/04.
//  Copyright © 2023 Harmony. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import SnapKit

class VideoCell: UICollectionViewCell {
    
    static var id: String {
        return NSStringFromClass(Self.self).components(separatedBy: ".").last ?? ""
    }
    
    var videoModel: VideoModel?
    
    lazy var containerView = UIImageView().then {
        //$0.image =
        $0.backgroundColor = .yellow
        $0.contentMode = .scaleAspectFit
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.borderWidth = 2
    }
    
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setCommonCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    func setCommonCell() {
        addComponent()
        setConstraints()
    }
    
    func addComponent() {
        contentView.addSubview(containerView)
    }
    
    func setConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func bind(to viewModel: ProfileListViewModel, indexPath: IndexPath) {
        contentView.tapGesture
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                viewModel.didVideoCellTap()
            }).disposed(by: disposeBag)
    }
    
    func setUI(){
        
    }
}
