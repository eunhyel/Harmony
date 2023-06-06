//
//  PopupInfoModel.swift
//  GlobalYeoboya
//
//  Created by inforex on 2022/12/27.
//  Copyright © 2022 GlobalYeoboya. All rights reserved.
//

import Foundation

public typealias SimpleAction = (() -> Void)

public struct PopupInfoModel {
    
    public var type: PopupType
    public var buttonType: PopupButtonType
    public var titleText: String
    public var contentsText: String
    public var confirmBtnText: String
    public var cancelBtnText: String
    
    public var confirmAction: SimpleAction?
    public var cancelAction: SimpleAction?
    public var backgroundViewAction: SimpleAction?
    
    /// 팝업을 만들 정보입니다.
    /// - Parameters:
    ///   - type: basic >> 제목 + 내용 // simple >> 제목
    ///   - buttonType: 버튼 갯수
    ///   - titleText: 제목 text
    ///   - contentsText: 내용 text
    ///   - confirmBtnText: 버튼 text
    ///   - cancelBtnText: 버튼 text
    public init(type: PopupType,
         buttonType: PopupButtonType,
         titleText: String,
         contentsText: String,
         confirmBtnText: String = "Confirm",
         cancelBtnText: String = "Cancel",
         confirmAction: SimpleAction? = nil,
         cancelAction: SimpleAction? = nil,
         backgroundViewAction: SimpleAction? = nil) {
        self.type = type
        self.buttonType = buttonType
        self.titleText = titleText
        self.contentsText = contentsText
        self.confirmBtnText = confirmBtnText
        self.cancelBtnText = cancelBtnText
        self.confirmAction = confirmAction
        self.cancelAction = cancelAction
        self.backgroundViewAction = backgroundViewAction
    }
}
