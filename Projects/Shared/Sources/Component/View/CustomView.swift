//
//  ChatHeaderBarView.swift
//  GlobalYeoboya
//
//  Created by yeoboya on 2022/12/29.
//  Copyright © 2022 GlobalYeoboya. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Then
import RxSwift

open class CustomView: UIView {
    
    open var disposeBag = DisposeBag()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("없어요")
    }
    
    open override func removeFromSuperview() {
        super.removeFromSuperview()
        disposeBag = DisposeBag()
    }
    
    open func addComponents() {}
    open func setConstraints() {}
    open func binding() {}
    open func setDelegate() {}
    
    open func initView() {
        setDelegate()
        addComponents()
        setConstraints()
        binding()
    }
}

class ChatHeaderBarView: CustomView {
    enum Mode {
        case floating(String)
        case none
    }
    
    var stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
    }
    
    var backButton = UIView().then {
        let image = UIImageView().then {
            $0.image = nil
        }
        
        $0.addSubview(image)
        image.snp.makeConstraints {
            $0.width.height.equalTo(28)
            $0.center.equalToSuperview()
        }
    }
    
    var profileContainerView = UIView()
    
    var profileLayerView = UIView().then{
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 18
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.white.cgColor
    }
    
    var shadowView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    var profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    var nameLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = .gray20
        $0.font = .m16
        $0.text = ""
        $0.attributedText = $0.attributedText?.addCharacterSpacing(-0.48)
    }
    
    var moreButton = UIView().then {
        let image = UIImageView().then {
            $0.image = nil
        }
        
        $0.addSubview(image)
        image.snp.makeConstraints {
            $0.width.height.equalTo(28)
            $0.center.equalToSuperview()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        shadowView.layer.applySketchShadow(color: UIColor(redF: 1, greenF: 12, blueF: 48, alphaF: 1), alpha: 0.2, x: 1, y: 1, blur: 3, spread: 0, radius: 18)
    }

    required init(mode: Mode) {
        super.init(frame: .zero)
        
        switch mode {
        case .floating(let gender):
            self.backgroundColor = .white
            self.nameLabel.textColor = gender == "f" ? .nicknameF : .nicknameM
        case .none:
            self.backgroundColor = .clear
            self.nameLabel.textColor = .gray20
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addComponents() {
        [stackView].forEach(self.addSubview)
        
        [
            backButton,
            profileContainerView,
            nameLabel,
            moreButton
        ].forEach{ stackView.addArrangedSubview($0)}
        
        [
            shadowView,
            profileLayerView
        ].forEach{ profileContainerView.addSubview($0)}
        
        profileLayerView.addSubview(profileImageView)
    }
    
    override func setConstraints() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }
        
        backButton.snp.makeConstraints {
            $0.width.height.equalTo(44)
        }
        
        profileLayerView.snp.makeConstraints {
            $0.width.height.equalTo(36)
            $0.leading.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        shadowView.snp.makeConstraints{
            $0.size.equalTo(profileLayerView.snp.size)
            $0.left.right.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        moreButton.snp.makeConstraints {
            $0.width.height.equalTo(44)
        }
    }
    
    deinit {
//        log.d("deinit")
    }
}

