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
import RxSwift

import Core
import Shared

class MessageTopHeadView: CustomView {
    
    let hStack = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .center
    }
    
    let close = UIButton().then {
        $0.setImage(FeatureAsset.icoArrowBack.image, for: .normal)
    }
    
    let more = UIButton().then {
        $0.setImage(FeatureAsset.icoExclamation.image, for: .normal)
    }
    
    let sendVideo = UIButton().then {
        $0.setImage(FeatureAsset.btnMmsVideo.image, for: .normal)
    }
    
    let infoView = UIView().then {
        $0.backgroundColor = .white
    }
    
    // top info
    let connectingStat = ConnectionStatView(fontSize: 12)
    
    let ptrName = UILabel().then {
        $0.text = "Chat Partner's Name"
        $0.textColor = UIColor(rgbF: 17)
        $0.font = .systemFont(ofSize: 18, weight: .medium)
        $0.setCharacterSpacing(-0.5)
//        $0.setLineHeight(18)
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
    
    lazy var headTitle: UILabel = {
        var label = UILabel()
        label.text = "Team LuvTok"
        label.textAlignment = .center
        label.setCharacterSpacing(-0.5)
        label.isHidden = true
        return label
    }()
    
    let moreView = MessageMorePopupView().then {
        $0.isHidden = true
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        initView()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        disposeBag = DisposeBag()
    }
    
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
        [hStack, moreView]
            .forEach(addSubview(_:))

        
        [close, infoView, sendVideo, more]
            .forEach(hStack.addArrangedSubview(_:))
        
        [headTitle, vInfoStack]
            .forEach(infoView.addSubview(_:))
        
    }
    
    override func setConstraints() {
        
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
        ptrName.snp.makeConstraints {
            $0.height.equalTo(18)
        }
        
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
        
        headTitle.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
        
    }
    
    func setNoUserLayout(_ member: Member?) {
        
        if let member = member {
            switch member.no {
            case 7777:
                headTitle.text = "Customer Service"
                sendVideo.isHidden = true
                vInfoStack.isHidden = true
            case 8888:
                headTitle.text = "Team LuvTok"
                sendVideo.isHidden = true
                vInfoStack.isHidden = true
            default:
                sendVideo.isHidden = false
                vInfoStack.isHidden = false
            }
        } else {
            headTitle.text = "Team LuvTok - Test"
            
            sendVideo.isHidden = true
            vInfoStack.isHidden = true
        }
        
    }
    
    func bind(to viewModel: MessageViewModel) {
        close
            .rx.tap
            .withUnretained(self)
            .bind { (this, tap) in
                viewModel.didTapClose()
            }
            .disposed(by: disposeBag)
        
        more.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                
                self.moreView.isHidden = false
            }
            .disposed(by: disposeBag)
        
    }
    
    func removeMoreView() {
        
    }
    
    deinit {
        log.d("MessageTopHeadView Deinit")
    }
}
