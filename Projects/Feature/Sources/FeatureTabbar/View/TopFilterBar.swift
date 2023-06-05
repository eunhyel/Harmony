//
//  TopFilterBar.swift
//  Feature
//
//  Created by root0 on 2023/06/05.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import RxGesture

import Shared

class TopFilterBar: CustomView {
    
    var didRounded = true
    
    var roundView = UIView().then {
        $0.roundCorners(cornerRadius: 12, maskedCorners: [.allCorners])
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(redF: 242, greenF: 193, blueF: 3).cgColor
    }
    
    var countryWrapper = UIView().then {
        $0.backgroundColor = .clear
    }
    
    var countryImage = UIImageView().then {
        $0.frame = .init(origin: .zero, size: CGSize(width: 24, height: 24))
        $0.image = FeatureAsset.boosterBasic.image
    }
    
    var countryLabel = UILabel.defaultLabel().then {
        $0.text = "Global"
        $0.textColor = .black
        $0.font = .m12
    }
    
    lazy var countryStack: UIStackView = {
        let cStack = UIStackView()
        cStack.axis = .horizontal
        cStack.alignment = .center
        cStack.distribution = .equalSpacing
        
        [countryImage, countryLabel].forEach(cStack.addArrangedSubview(_:))
        return cStack
    }()
    
    var genderWrapper = UIView().then {
        $0.backgroundColor = .clear
    }
    
    var genderImage = UIImageView().then {
        $0.frame = .init(x: 0, y: 0, width: 24, height: 24)
        $0.image = FeatureAsset.boosterBasic.image
    }
    
    var genderLabel = UILabel.defaultLabel().then {
        $0.text = "All"
        $0.textColor = .black
        $0.font = .m12
    }
    
    lazy var genderStack: UIStackView = {
        let gStack = UIStackView()
        gStack.axis = .horizontal
        gStack.alignment = .center
        gStack.distribution = .equalSpacing
        
        [genderImage, genderLabel].forEach(gStack.addArrangedSubview(_:))
        return gStack
    }()
    
    var ageWrapper = UIView().then {
        $0.backgroundColor = .clear
    }
    
    var ageImage = UIImageView().then {
        $0.frame = .init(x: 0, y: 0, width: 24, height: 24)
        $0.image = FeatureAsset.boosterBasic.image
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    var ageLabel = UILabel.defaultLabel().then {
        $0.text = "All Age"
        $0.textColor = .black
        $0.font = .m12
        $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
    lazy var ageStack: UIStackView = {
        let aStack = UIStackView()
        aStack.axis = .horizontal
        aStack.alignment = .center
        aStack.distribution = .equalSpacing
        
        [ageImage, ageLabel].forEach(aStack.addArrangedSubview(_:))
        return aStack
    }()
    
    lazy var wrapperStackView: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.spacing = 1
        
        [countryWrapper, genderWrapper, ageWrapper].forEach(stack.addArrangedSubview(_:))
        return stack
    }()
    
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(size: CGSize, status: Bool = false) {
        self.init(frame: CGRect(origin: .zero, size: size))
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.applySketchShadow(alpha: 0.24, x: 0, y: 2, blur: 6, radius: 12)
    }
    
    override func addComponents() {
        [roundView, wrapperStackView].forEach(addSubview(_:))
        
        countryWrapper.addSubview(countryStack)
        genderWrapper.addSubview(genderStack)
        ageWrapper.addSubview(ageStack)
        
        let lineView1 = UIView().then {
            $0.backgroundColor = .grayE0
        }
        let lineView2 = UIView().then {
            $0.backgroundColor = .grayE0
        }
        [lineView1, lineView2].forEach(genderWrapper.addSubview(_:))
        lineView1.snp.makeConstraints {
            $0.right.equalTo(genderWrapper.snp.left)
            $0.size.equalTo(CGSize(width: 1, height: 12))
            $0.centerY.equalToSuperview()
        }
        lineView2.snp.makeConstraints {
            $0.right.equalTo(genderWrapper.snp.right)
            $0.size.equalTo(CGSize(width: 1, height: 12))
            $0.centerY.equalToSuperview()
        }
    }
    
    override func setConstraints() {
        roundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        wrapperStackView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(5)
            $0.top.bottom.equalToSuperview().inset(5)
        }
        
        countryStack.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        genderStack.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        ageStack.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.lessThanOrEqualTo(ageWrapper).offset(-20)
        }
        
        [ countryImage, genderImage, ageImage ].forEach {
            $0.snp.makeConstraints {
                $0.width.height.equalTo(24)
            }
        }
    }
    
    func binding(to viewModel: ProfileListViewModel) {
        
    }
    
    func binding(to viewModel: VideoListViewModel) {
        
    }
}
