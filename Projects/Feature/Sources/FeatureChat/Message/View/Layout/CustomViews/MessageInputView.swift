//
//  MessageInputView.swift
//  Feature
//
//  Created by root0 on 2023/06/09.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import SnapKit
import Then

import Shared

class MessageInputView: CustomView {
    
    let containerStack = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .bottom
        $0.distribution = .fill
    }
    
    let menuContainer = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let gallery = UIButton().then {
        $0.setImage(UIImage(systemName: "xmark"), for: .normal)
//        $0.adjustsImageWhenHighlighted = false
    }
    
    let textViewPlate = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let textViewContainer = UIView().then {
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .grayE1
    }
    
    let inputTextView = UITextView().then {
        $0.font = .m15
        $0.textColor = .warmGrey
        $0.textContainerInset = .zero
        $0.isScrollEnabled = false
        $0.backgroundColor = .clear
    }
    
    let sendContainer = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let send = UIButton().then {
        $0.setImage(FeatureAsset.icoSendOn.image, for: .normal)
        $0.setImage(FeatureAsset.icoSendOff.image, for: .disabled)
        
        $0.roundCorners(cornerRadius: 4, maskedCorners: [.allCorners])
        
        let bgNormal = UIColor(rgbF: 232).image(CGSize(width: 28, height: 28))
        
        let bgDisable = UIColor(redF: 106, greenF: 242, blueF: 176).image(CGSize(width: 28, height: 28))
        $0.setBackgroundImage(bgNormal, for: .normal)
        $0.setBackgroundImage(bgDisable, for: .disabled)
    }
    
    var placeholderText = "INPUT TEXT VIEW"
    var userInputBottomConstraint: Constraint?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.applySketchShadow(color: .shadow, alpha: 0.14, x: 0, y: -6, blur: 12, spread: -4)
    }
    
    override func initView() {
        self.backgroundColor = .white
        addComponents()
        setConstraints()
        binding()
        
        inputTextView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    override func addComponents() {
        addSubview(containerStack)
        
        [
            menuContainer,
            textViewPlate,
            sendContainer
        ].forEach(containerStack.addArrangedSubview(_:))
        
        menuContainer.addSubview(gallery)
        textViewPlate.addSubview(textViewContainer)
        textViewContainer.addSubview(inputTextView)
        sendContainer.addSubview(send)
    }
    
    override func setConstraints() {
        containerStack.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
//            $0.top.bottom.equalToSuperview().inset(6)
            $0.top.equalToSuperview().inset(6)
            userInputBottomConstraint = $0.bottom.equalTo(safeAreaLayoutGuide).inset(6).constraint
        }
        
        gallery.snp.makeConstraints {
            $0.size.equalTo(44)
            $0.center.equalToSuperview()
        }
        
        menuContainer.snp.makeConstraints {
            $0.size.equalTo(44)
        }
        
        textViewContainer.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(2)
            $0.leading.trailing.equalToSuperview()
        }
        
        inputTextView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(9)
            $0.leading.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(10)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(22)
        }
        
        send.snp.makeConstraints {
            $0.size.equalTo(28)
            $0.center.equalToSuperview()
        }
        
        sendContainer.snp.makeConstraints {
            $0.size.equalTo(44)
        }
        
        
        
    }
}


extension MessageInputView: UITextViewDelegate {
    
    
}
