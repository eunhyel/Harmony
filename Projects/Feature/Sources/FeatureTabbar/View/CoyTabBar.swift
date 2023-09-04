//
//  CoyTabBar.swift
//  Feature
//
//  Created by root0 on 2023/09/04.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

import Shared

final class CoyTabBar: CustomView {
    
    private let plate = UIView().then {
        $0.backgroundColor = .white
        $0.roundCorners(cornerRadius: 16, maskedCorners: [.topLeft, .topRight])
        
    }
    
    private let tabStack = UIStackView().then {
        $0.spacing = 1
        $0.axis = .horizontal
        $0.distribution = .fillEqually
    }
    
    let faceTok = UIButton().then {
        $0.setImage(FeatureAsset.icoHomeOff.image, for: .normal)
        $0.setImage(FeatureAsset.icoHomeOn.image, for: .selected)
        $0.adjustsImageWhenHighlighted = false
        $0.isSelected = true
    }
    
    let msgTok = UIButton().then {
        $0.setImage(FeatureAsset.icoMsg.image, for: .normal)
        $0.setImage(FeatureAsset.icoMsgOn.image, for: .selected)
        $0.adjustsImageWhenHighlighted = false
    }
    
    let msgBadge = BadgeToolTipView(badgeText: "99+", mode: .inactive,
                                    tipStartX: 16, tipStartY: 20, tipWidth: 8, tipHeight: 7.2)
    
    let myPage = UIButton().then {
        $0.setImage(FeatureAsset.icoMyOff.image, for: .normal)
        $0.setImage(FeatureAsset.icoMyOn.image, for: .selected)
        $0.adjustsImageWhenHighlighted = false
    }
    
    private let menuTap = PublishSubject<Int>()
    
    var menuTapped: Observable<Int> {
        return menuTap.asObservable()
    }
    
    var menus: [UIButton] {
        return [faceTok, msgTok, myPage]
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.applySketchShadow(color: .shadow,
                                     alpha: 0.14, x: 0, y: -6, blur: 24, spread: -4)
    }
    
    override func addComponents() {
        addSubview(plate)
        plate.addSubview(tabStack)
        [faceTok, msgTok, myPage].forEach(tabStack.addArrangedSubview(_:))
        addSubview(msgBadge)
    }
    
    override func setConstraints() {
        plate.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
        
        tabStack.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(64)
        }
        
        msgBadge.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(msgTok.snp.top).offset(6)
        }
    }
    
    private func selectItem(idx: Int) {
        menus.enumerated().forEach {
            $0.element.isSelected = $0.offset == idx
        }
        msgBadge.changeStatus(to: idx == 1 ? .active : .inactive)
        menuTap.onNext(idx)
        log.d("Select Custom Tabbar Menu \(idx)")
    }
    
    override func binding() {
        faceTok.rx.tap
            .withUnretained(self)
            .bind { (tabbar, _) in
                tabbar.selectItem(idx: HarmonyTapMenu.videoChat.rawValue)
            }
            .disposed(by: disposeBag)
        
        msgTok.rx.tap
            .withUnretained(self)
            .bind { (tabbar, _) in
                tabbar.selectItem(idx: HarmonyTapMenu.message.rawValue)
            }
            .disposed(by: disposeBag)
        
        myPage.rx.tap
            .withUnretained(self)
            .bind { (tabbar, _) in
                tabbar.selectItem(idx: HarmonyTapMenu.myPage.rawValue)
            }
            .disposed(by: disposeBag)
    }
    
}
