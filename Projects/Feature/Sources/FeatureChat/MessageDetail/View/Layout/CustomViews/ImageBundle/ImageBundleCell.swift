//
//  ImageBundleCell.swift
//  Feature
//
//  Created by root0 on 2023/09/27.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift

import Shared

struct ImageBundleItem: Hashable {
    var size: CGSize
    var weight: Int
    var image: UIImage? = nil
    var base64EncodedString: String = ""
    var url: String = ""
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(image)
        hasher.combine(url)
    }
}

class ImageBundleCell: UICollectionViewCell, Reusable {
    
    var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    var disposeBag = DisposeBag()
    
    var tap: (() -> Void)?
    
    var longPress: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addComponents()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addComponents() {
        contentView.addSubview(imageView)
    }
    
    func setConstraints() {
        imageView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
    
    func bind() {
        let tap = UITapGestureRecognizer()
        let long = UILongPressGestureRecognizer()
        
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
        imageView.addGestureRecognizer(long)
        
        tap.rx.event
            .filter { $0.state == .recognized }
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.tap?()
            }
            .disposed(by: disposeBag)
        
        long.rx.event
            .filter { $0.state == .began }
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.longPress?()
            }
            .disposed(by: disposeBag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        disposeBag = DisposeBag()
    }
    
    
}
