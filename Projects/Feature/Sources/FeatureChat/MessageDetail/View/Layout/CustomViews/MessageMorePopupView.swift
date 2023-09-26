//
//  MessageMorePopupView.swift
//  Feature
//
//  Created by root0 on 2023/09/26.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift

import Shared

class MessageMorePopupView: CustomView {
    
    let container = UIView().then {
        $0.backgroundColor = .white
    }
    
    let vMenuStack = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
    }
    
    let delete = UIButton().then {
        $0.setImage(nil, for: .normal)
        $0.setTitle("Delete", for: .normal)
        $0.setTitleColor(UIColor(rgbF: 32), for: .normal)
        $0.titleLabel?.setCharacterSpacing(-0.5)
        $0.titleLabel?.setLineHeight(22)
        $0.adjustsImageWhenHighlighted = false
    }
    
    let block = UIButton().then {
        $0.setImage(nil, for: .normal)
        $0.setTitle("Block", for: .normal)
    }
    
    let report = UIButton().then {
        $0.setImage(nil, for: .normal)
        $0.setTitle("Report", for: .normal)
    }
    
    let bookmark = UIButton().then {
        $0.setImage(nil, for: .normal)
        $0.setTitle("BookMark", for: .normal)
    }
    
    override func initView() {
        
        addComponents()
        setConstraints()
    }
    override func addComponents() {
        self.addSubview(container)
        
        container.addSubview(vMenuStack)
        
        [delete, block, report, bookmark]
            .forEach(vMenuStack.addArrangedSubview(_:))
    }
    
    override func setConstraints() {
        
        container.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
        
        vMenuStack.snp.makeConstraints {
            $0.width.equalTo(127)
            $0.height.equalTo(150)
            $0.directionalEdges.equalToSuperview()
        }
        
    }
    
    func bind(to viewModel: MessageViewModel) {
        delete.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
            }
            .disposed(by: disposeBag)
        
        block.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
            }
            .disposed(by: disposeBag)
        
        report.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
            }
            .disposed(by: disposeBag)
        
        bookmark.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
            }
            .disposed(by: disposeBag)
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        disposeBag = DisposeBag()
    }
    
}
