//
//  NoticeInfoModel.swift
//  Shared
//
//  Created by root0 on 2023/09/15.
//  Copyright © 2023 Harmony. All rights reserved.
//

import Foundation



public struct NoticeInfoModel {
    
    public var titleText: String
    public var imageName: String?
    public var contentsText: String
    public var confirmBtnText: String
    public var cancelBtnText: String
    public var confirmAction: SimpleAction?
    public var cancelAction: SimpleAction?
    
    public init(titleText: String, imageName: String?, contentsText: String, confirmBtnText: String, cancelBtnText: String, confirmAction: SimpleAction? = nil, cancelAction: SimpleAction? = nil) {
        self.titleText = titleText
        self.imageName = imageName
        self.contentsText = contentsText
        self.confirmBtnText = confirmBtnText
        self.cancelBtnText = cancelBtnText
        self.confirmAction = confirmAction
        self.cancelAction = cancelAction
    }
}

public enum NoticeInfoModel_Teams {
    
    case notice(custom: NoticeInfoModel)
    case photoAuthFailure
    case photoAuthComplete
//    case feedbackReport
//    case warn
//
//    case guidePayment
//    case guideDiscount
//
//    case guideTakeMoney
    
    public var model: NoticeInfoModel {
        switch self {
        case .notice(let custom):
            return custom
        case .photoAuthFailure:
            return NoticeInfoModel(titleText: "사진이 인증되지 않았어요! 😅",
                                   imageName: nil,
                                   contentsText: "인증사진 주의사항을 참고해서 다시 시도해주세요!\n - 얼굴이 드러나야해요.", confirmBtnText: "다시 등록하기", cancelBtnText: "")
        case .photoAuthComplete:
            return NoticeInfoModel(titleText: "사진인증이 완료되었어요! 😊",
                                   imageName: nil,
                                   contentsText: "인증된 사진은 프로필 사진으로 등록이 가능합니다. 사진을 여러장 등록하면 다양한 매력을 보여줄 수 있어요!", confirmBtnText: "채팅 바로가기", cancelBtnText: "")
//        case .feedbackReport:
//            return NoticeInfoModel(titleText: <#T##String#>,
//                                   imageName: <#T##String?#>,
//                                   contentsText: <#T##String#>,
//                                   confirmBtnText: <#T##String#>)
//        case .warn:
//            return NoticeInfoModel(titleText: <#T##String#>,
//                                   imageName: <#T##String?#>,
//                                   contentsText: <#T##String#>,
//                                   confirmBtnText: <#T##String#>)
//        case .guidePayment:
//            return NoticeInfoModel(titleText: <#T##String#>,
//                                   imageName: <#T##String?#>,
//                                   contentsText: <#T##String#>,
//                                   confirmBtnText: <#T##String#>)
//        case .guideDiscount:
//            return NoticeInfoModel(titleText: <#T##String#>,
//                                   imageName: <#T##String?#>,
//                                   contentsText: <#T##String#>,
//                                   confirmBtnText: <#T##String#>)
//        case .guideTakeMoney:
//            return NoticeInfoModel(titleText: <#T##String#>,
//                                   imageName: <#T##String?#>,
//                                   contentsText: <#T##String#>,
//                                   confirmBtnText: <#T##String#>)
        }
    }
}
