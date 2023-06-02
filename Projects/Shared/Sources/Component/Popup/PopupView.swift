//
//  Popup.swift
//  GlobalYeoboya
//
//  Created by inforex on 2022/12/27.
//  Copyright © 2022 GlobalYeoboya. All rights reserved.
//

import UIKit
import RxSwift
import RxGesture
import Then
import SnapKit

/*
// 팝업 만드는 예시
let title = "Delete message history?"
let contents = "You will no longer be able to open message history with #nick#"
let nick = "Ariv Roel Downey"

let model = PopupInfoModel(type: .basic,
                           buttonType: .two,
                           titleText: title,
                           contentsText: contents,
                           confirmBtnText: "Delete")
let testPopupView = PopupView(frame: .zero, model: model)

testPopupView.replaceContentsTextAndColor(target: "#nick#", range: nick, color: UIColor(redF: 151, greenF: 123, blueF: 15, alphaF: 1))

self.view.addSubview(testPopupView)

testPopupView.snp.makeConstraints {
    $0.edges.equalToSuperview()
}
*/

/**
 basic >> 제목 + 내용
 simple >> 제목
 */
public enum PopupType {
    case basic
    case simple
}

/**
 two >> 2 버튼
 one >> 1 버튼
 */
public enum PopupButtonType {
    case two
    case one
}

open class PopupView: UIView {

    open var model: PopupInfoModel!
    public var disposeBag = DisposeBag()

    let backgroundView = UIView().then {
        $0.backgroundColor = UIColor(rgbF: 0, a: 0.3)
    }

    let containerView = UIView().then {
        $0.backgroundColor = .white
        $0.roundCorners(cornerRadius: 12, maskedCorners: [.allCorners])
    }

    let containerStackView = UIStackView().then {
        $0.axis = .vertical
        $0.backgroundColor = .clear
        $0.spacing = 0
    }

    let titleWrapperView = UIView().then {
        $0.backgroundColor = .clear
    }

    let titleLabel = UILabel().then {
        $0.sizeToFit()
        $0.numberOfLines = 0
        $0.setLineHeight(21)
        $0.textAlignment = .center
        $0.textColor = .gray20
        $0.font = .m15
    }

    let contentsWrapperView = UIView().then {
        $0.backgroundColor = .clear
    }

    let contentsLabel = UILabel().then {
        $0.sizeToFit()
        $0.numberOfLines = 0
        $0.setLineHeight(21)
        $0.textAlignment = .center
        $0.textColor = .gray50
        $0.font = .m14
    }
    
    let customViewWrapperView = UIView().then {
        $0.backgroundColor = .clear
    }

    let buttonWrapperView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let buttonWrapperLine = UIView().then {
        $0.backgroundColor = .grayE0
    }
    
    let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 0
    }

    let confirmButton = MainButton(.main, title: "Confirm")

    let cancelButton = MainButton(.light, title: "Cancel")

    public required init(frame: CGRect,  model: PopupInfoModel) {
        super.init(frame: frame)
        self.model = model
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        containerView.layer.applySketchShadow(alpha: 0.36, x: 0, y: 2, blur: 4, radius: 12)
    }

    public func commonInit() {
        addConponents()
        setConstraints()
        setStructure()
        setText()
        bind()
    }

    public func addConponents() {
        [backgroundView, containerView].forEach(self.addSubview)

        containerView.addSubview(containerStackView)
        
        [
            titleWrapperView,
            contentsWrapperView,
            customViewWrapperView,
            buttonWrapperView
        ].forEach(containerStackView.addArrangedSubview(_:))
//        containerStackView.addArrangeSubviews("스택뷰 요소 추가"){
//            titleWrapperView
//            contentsWrapperView
//            customViewWrapperView
//            buttonWrapperView
//        }

        titleWrapperView.addSubview(titleLabel)
        contentsWrapperView.addSubview(contentsLabel)
        buttonWrapperView.addSubview(buttonStackView)
        buttonWrapperView.addSubview(buttonWrapperLine)
        buttonStackView.addArrangedSubview(cancelButton)
        buttonStackView.addArrangedSubview(confirmButton)
    }

    public func setConstraints() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
//            $0.width.equalTo(270)
        }

        containerStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(0)
            $0.top.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
            $0.width.equalTo(270)
        }

        titleLabel.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().inset(16)
        }

        contentsLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(16)
        }

        buttonStackView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalToSuperview().inset(21) // 1
        }

        cancelButton.snp.makeConstraints {
            $0.width.equalTo(135)
        }

        confirmButton.snp.makeConstraints {
            $0.width.equalTo(135)
        }
        
        buttonWrapperLine.snp.makeConstraints {
            $0.leading.trailing.equalTo(buttonStackView)
            $0.bottom.equalTo(buttonStackView.snp.top)
            $0.height.equalTo(1)
        }
    }

    /// 타입 별 구조 변경 함수
    public func setStructure() {
        switch model.type {
        case .simple: contentsWrapperView.isHidden = true
        default: break
        }

        switch model.buttonType {
        case .one:
            cancelButton.isHidden = true
            confirmButton.snp.remakeConstraints {
                $0.width.equalTo(containerStackView)
            }
        default: break
        }
    }

    public func setText() {
        titleLabel.text = model.titleText
        contentsLabel.text = model.contentsText
        confirmButton.title = model.confirmBtnText
        cancelButton.title = model.cancelBtnText
    }

    /// titleLabel의 텍스트와 컬러를 바꾸고 싶을 때
    /// range를 target으로 바꾸고 target의 색을 color로 바꾸겠다.
    public func replaceTitleTextAndColor(target: String, range: String, color: UIColor) {
        titleLabel.replace(target: target, range: range)
        titleLabel.textColorChange(color: color, range: target)
    }
    
    /// titleLabel의 특정문자 컬러를 바꾸고 싶을 때
    /// range의 색을 color로 바꾸겠다
    public func replaceTitleColor(range: String, color: UIColor) {
        titleLabel.textColorChange(color: color, range: range)
    }

    /// contentsLabel의 텍스트와 컬러를 바꾸고 싶을 때
    /// range를 target으로 바꾸고 target의 색을 color로 바꾸겠다.
    public func replaceContentsTextAndColor(target: String, range: String, color: UIColor) {
        contentsLabel.replace(target: target, range: range)
        contentsLabel.textColorChange(color: color, range: target)
    }
    
    /// contentsLabel의 특정문자 컬러를 바꾸고 싶을 때
    /// range의 색을 color로 바꾸겠다
    public func replaceContentsColor(range: String, color: UIColor) {
        contentsLabel.textColorChange(color: color, range: range)
    }

    public func bind() {
        backgroundView.tapGesture
            .bind{[weak self] _ in
                self?.model.backgroundViewAction?()
                self?.removeFromSuperview()
            }.disposed(by: disposeBag)

        confirmButton.tapGesture
            .bind{[weak self] _ in
                self?.model.confirmAction?()
                self?.removeFromSuperview()
            }.disposed(by: disposeBag)

        cancelButton.tapGesture
            .bind{[weak self] _ in
                self?.model.cancelAction?()
                self?.removeFromSuperview()
            }.disposed(by: disposeBag)
    }
    
    public func addListView(popupListView: PopupListView) {
        customViewWrapperView.addSubview(popupListView)
        
        popupListView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    public func addCustomView(customView: UIView, useTitle: Bool = false, useContents: Bool = false) {
        titleWrapperView.isHidden = !useTitle
        contentsWrapperView.isHidden = !useTitle
        
        customViewWrapperView.addSubview(customView)
        customView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    public override func removeFromSuperview() {
        super.removeFromSuperview()
        model.confirmAction = nil
        model.cancelAction = nil
        model.backgroundViewAction = nil
    }

    deinit{
        log.d("popup deinit")
    }
}
