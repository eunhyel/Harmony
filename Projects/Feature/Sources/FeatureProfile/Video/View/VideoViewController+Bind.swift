//
//  VideoViewController+Bind.swift
//  Feature
//
//  Created by eunhye on 2023/09/14.
//  Copyright © 2023 Harmony. All rights reserved.
//

import Foundation
extension VideoViewController {
    
    func bind() {
        videoLayout.exitBtn.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.removeVideoView()
        }.disposed(by: disposeBag)
    }
}
