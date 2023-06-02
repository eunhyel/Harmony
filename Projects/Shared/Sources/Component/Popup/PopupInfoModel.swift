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
    
    var type: PopupType
    var buttonType: PopupButtonType
    var titleText: String
    var contentsText: String
    var confirmBtnText: String
    var cancelBtnText: String
    
    var confirmAction: SimpleAction?
    var cancelAction: SimpleAction?
    var backgroundViewAction: SimpleAction?
    
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
