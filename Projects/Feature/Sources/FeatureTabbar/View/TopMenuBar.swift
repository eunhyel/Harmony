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
    
    var roundView = UIView().then {
        $0.backgroundColor = .white
        $0.roundCorners(cornerRadius: 16, maskedCorners: [.bottomLeft, .bottomRight])
    }
    
    var titleLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 28)
        $0.textColor = UIColor(rgbF: 32)
        $0.text = "Harmony"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(size: CGSize, status: HarmonyTapMenu = .message) {
        self.init(frame: CGRect(origin: .zero, size: size))
        titleLabel.text = status.title
    }
    
    override func didMoveToSuperview() {
        let frame = self.frame
        if superview != nil {
//            self.backgroundColor = .clear
            self.snp.makeConstraints {
                if frame.width != .zero {
                    $0.width.equalTo(frame.width)
                }
                $0.height.equalTo(frame.height + DeviceManager.Inset.top)
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.applySketchShadow(alpha: 0.24, x: 0, y: 2, blur: 6, radius: 16)
    }
    
    override func addComponents() {
        self.addSubview(roundView)
        roundView.addSubview(titleLabel)
    }
    
    override func setConstraints() {
        roundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.left.equalToSuperview().offset(12)
            $0.centerY.equalTo(roundView.snp.bottom).offset(-34)
        }
    }
}
