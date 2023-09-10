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
    
    let vMenuStack = UIStackView().then {
        $0.axis = .vertical
    }
    
    let inputContainer = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let hInputStack = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .bottom
        $0.distribution = .fill
    }
    
    let menu = UIButton().then {
        $0.setImage(UIImage(systemName: "xmark"), for: .normal)
//        $0.adjustsImageWhenHighlighted = false
    }
    
    let textViewPlate = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let textViewContainer = UIView().then {
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = UIColor(rgbF: 219).cgColor
        $0.layer.borderWidth = 1
    }
    
    let inputTextView = UITextView().then {
        $0.font = .r16
        $0.textColor = UIColor(rgbF: 199)
        $0.textContainerInset = .init(top: 12, left: 12, bottom: 12, right: 12)
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
        addSubview(vMenuStack)
        [inputContainer].forEach(vMenuStack.addArrangedSubview(_:))
        
        inputContainer.addSubview(hInputStack)
        
        [
            menu,
            textViewPlate,
            sendContainer
        ].forEach(hInputStack.addArrangedSubview(_:))
        
        
        textViewPlate.addSubview(textViewContainer)
        textViewContainer.addSubview(inputTextView)
        sendContainer.addSubview(send)
    }
    
    override func setConstraints() {
        vMenuStack.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview()
            userInputBottomConstraint = $0.bottom.equalTo(safeAreaLayoutGuide).constraint
        }
        
        inputContainer.snp.makeConstraints {
            $0.height.equalTo(56)
        }
        
        hInputStack.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
        
        menu.snp.makeConstraints {
            $0.size.equalTo(56)
        }
        
        textViewContainer.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.leading.trailing.equalToSuperview()
        }
        
        inputTextView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
        
        send.snp.makeConstraints {
            $0.size.equalTo(28)
            $0.center.equalToSuperview()
        }
        
        sendContainer.snp.makeConstraints {
            $0.size.equalTo(56)
        }
        
        
        
    }
}


extension MessageInputView: UITextViewDelegate {
    
    
}
