//
//  MessageListHeader.swift
//  Feature
//
//  Created by root0 on 2023/06/05.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift

import Shared

class TopMenuBar: CustomView {
    
    var head = UIView().then {
        $0.backgroundColor = .white
    }
    
    var titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 22, weight: .bold)
        $0.textColor = UIColor(rgbF: 32)
        $0.text = "LuvTok"
        $0.setCharacterSpacing(-0.5)
        $0.setLineHeight(22)
    }
    
    var logoImage = UIImageView().then {
        // possible Lottie AnimationView
        $0.contentMode = .scaleAspectFill
        $0.image = UIColor.green.image(CGSize(width: 32, height: 32))
    }
    
    var previous = UIButton().then {
        $0.setImage(FeatureAsset.icoArrowBack.image, for: .normal)
        $0.adjustsImageWhenHighlighted = false
        $0.isHidden = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(status: HarmonyTapMenu = .message) {
        self.init(frame: .zero)
        titleLabel.text = status.title
    }
    
//    override func didMoveToSuperview() {
//        let frame = self.frame
//        if superview != nil {
////            self.backgroundColor = .clear
//            self.snp.makeConstraints {
//                if frame.width != .zero {
//                    $0.width.equalTo(frame.width)
//                }
//                $0.height.equalTo(frame.height + DeviceManager.Inset.top)
//            }
//        }
//    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.applySketchShadow(color: .shadow, alpha: 0.14, x: 0, y: 10, blur: 32, spread: -4)
    }
    
    override func initView() {
        self.backgroundColor = .white
        addComponents()
        setConstraints()
    }
    
    override func addComponents() {
        self.addSubview(head)
        
        [titleLabel, logoImage, previous]
            .forEach(head.addSubview(_:))
    }
    
    override func setConstraints() {
        head.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(56)
        }
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        logoImage.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(12)
            $0.size.equalTo(32)
        }
        
        previous.snp.makeConstraints {
            $0.size.equalTo(56)
            $0.top.leading.bottom.equalToSuperview()
        }
    }
}
