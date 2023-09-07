//
//  MessageTopHeadView.swift
//  Feature
//
//  Created by root0 on 2023/09/06.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import SnapKit
import Then

import Shared

class MessageTopHeadView: CustomView {
    
    let hStack = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .center
    }
    
    let close = UIButton().then {
        $0.setImage(FeatureAsset.icoArrowBack.image, for: .normal)
        $0.adjustsImageWhenHighlighted = false
    }
    
    let more = UIButton().then {
        $0.setImage(FeatureAsset.icoExclamation.image, for: .normal)
        $0.adjustsImageWhenHighlighted = false
    }
    
    let sendVideo = UIButton().then {
        $0.setImage(FeatureAsset.btnMmsVideo.image, for: .normal)
        $0.adjustsImageWhenHighlighted = false
    }
    
    let infoView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    // top info
    let connectingStat = ConnectionStatView(fontSize: 12)
    
    let ptrName = UILabel().then {
        $0.text = "Chat Partner's Name"
        $0.textColor = UIColor(rgbF: 17)
        $0.font = .systemFont(ofSize: 18, weight: .medium)
        $0.setCharacterSpacing(-0.5)
        $0.setLineHeight(18)
    }
    
    // bottom info
    let nation = UIImageView().then {
        $0.image = FeatureAsset.icoNation.image
    }
    
    let country = UILabel().then {
        $0.text = "COUNTRY"
        $0.textColor = UIColor(rgbF: 150)
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.setCharacterSpacing(-0.5)
        $0.setLineHeight(14)
    }
    
    let vSeparatorBar = UIView().then {
        $0.backgroundColor = UIColor(rgbF: 217)
    }
    
    let localTime = UILabel().then {
        $0.text = "a hh:mm"
        $0.textColor = UIColor(rgbF: 150)
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.setCharacterSpacing(-0.5)
        $0.setLineHeight(14)
    }
    
    lazy var hTopInfoStack: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [connectingStat, ptrName])
        stack.spacing = 4
        stack.alignment = .center
        return stack
    }()
    
    lazy var hBottomInfoStack: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [nation, country, vSeparatorBar, localTime])
        stack.spacing = 4
        stack.alignment = .center
        return stack
    }()
    
    lazy var vInfoStack: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [hTopInfoStack, hBottomInfoStack])
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .leading
        return stack
    }()
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        initView()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.applySketchShadow(color: .shadow, alpha: 0.14, x: 0, y: 10, blur: 32, spread: -4)
    }
    
    override func initView() {
        self.backgroundColor = .white
        addComponents()
        setConstraints()
    }
    
    override func addComponents() {
        addSubview(hStack)
        
        [close, infoView, sendVideo, more]
            .forEach(hStack.addArrangedSubview(_:))
        
        [vInfoStack]
            .forEach(infoView.addSubview(_:))
        
    }
    
    override func setConstraints() {
        
        log.d(self.bounds.size)
        hStack.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(56)
        }
        
        close.snp.makeConstraints {
            $0.size.equalTo(56)
        }
        
        infoView.snp.makeConstraints {
            $0.height.equalTo(56)
        }
        
        sendVideo.snp.makeConstraints {
            $0.width.equalTo(48)
            $0.height.equalTo(56)
        }
        
        more.snp.makeConstraints {
            $0.size.equalTo(56)
        }
        
        vInfoStack.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(4)
        }
        
//        hTopInfoStack.snp.makeConstraints {
//            $0.leading.trailing.equalToSuperview()
//        }
        
//        connectingStat
//
//        ptrName
        
        nation.snp.makeConstraints {
            $0.width.equalTo(22)
            $0.height.equalTo(18)
        }
        
//        country
        
        vSeparatorBar.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(14)
        }
        
//        localTime
    }
    
    
}
