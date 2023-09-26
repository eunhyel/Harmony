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
        $0.roundCorners(cornerRadius: 4, maskedCorners: [.allCorners])
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
        $0.setTitleColor(UIColor(rgbF: 32), for: .normal)
        $0.titleLabel?.setCharacterSpacing(-0.5)
        $0.titleLabel?.setLineHeight(22)
        $0.adjustsImageWhenHighlighted = false
    }
    
    let report = UIButton().then {
        $0.setImage(nil, for: .normal)
        $0.setTitle("Report", for: .normal)
        $0.setTitleColor(UIColor(rgbF: 32), for: .normal)
        $0.titleLabel?.setCharacterSpacing(-0.5)
        $0.titleLabel?.setLineHeight(22)
        $0.adjustsImageWhenHighlighted = false
    }
    
    let bookmark = UIButton().then {
        $0.setImage(nil, for: .normal)
        $0.setTitle("BookMark", for: .normal)
        $0.setTitleColor(UIColor(rgbF: 32), for: .normal)
        $0.titleLabel?.setCharacterSpacing(-0.5)
        $0.titleLabel?.setLineHeight(22)
        $0.adjustsImageWhenHighlighted = false
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.applySketchShadow(alpha: 0.2, x: 0, y: 0, blur: 6)
    }
    
    override func didMoveToSuperview() {
        
        if let superview = superview {
            self.snp.makeConstraints {
                $0.top.equalTo(superview.snp.bottom).offset(12)
                $0.trailing.equalToSuperview().offset(-16)
            }
        }
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
                log.d("삭제 클릭")
            }
            .disposed(by: disposeBag)
        
        block.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                log.d("차단 클릭")
            }
            .disposed(by: disposeBag)
        
        report.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                log.d("신고 클릭")
            }
            .disposed(by: disposeBag)
        
        bookmark.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                log.d("즐겨찾기 클릭")
            }
            .disposed(by: disposeBag)
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        disposeBag = DisposeBag()
    }
    
}
