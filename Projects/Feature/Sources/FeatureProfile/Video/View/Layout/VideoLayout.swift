//
//  VideoLayout.swift
//  Feature
//
//  Created by eunhye on 2023/09/04.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import Shared
import RxSwift


class VideoLayout {
    
    weak var disposeBag: DisposeBag?
    
    var safetyLayer = UIView().then {
        $0.backgroundColor = .blue
    }
    
    func viewDidLoad(view: UIView, viewModel: VideoViewModel) {
        
        view.addSubview(safetyLayer)
        
        setLayout()
        setConstraint()
    }
    
    func setLayout() {
        [
        ].forEach(safetyLayer.addSubview(_:))
    }
    
    func setConstraint() {
        
        safetyLayer.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.left.right.equalToSuperview()
        }
    }
}
