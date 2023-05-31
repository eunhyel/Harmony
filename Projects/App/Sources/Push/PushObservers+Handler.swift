//
//  PushObservers+Handler.swift
//  HoneyGlobal
//
//  Created by yeoboya on 2023/02/23.
//  Copyright © 2023 HoneyGlobal. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit
import Shared
import Core

enum ReceivePushType: String {
    case push             = "1"
}

extension PushObservers {
    
    
    func remotePushNotification(_ userInfo: [AnyHashable: Any]?, status: PushStatus) {
        /// 푸시 코드: type
        /// 1: 운영자, 2: 관심수신, 3:전체열람됨, 4:일반메세지 수신, 5: 사진메세지 수신, 6: 동영상메세지 수신, 7: 일대일답변, 8: 회원정지, 9: 영상대화수신
        
        var retData: [String: String] = [:]
        let requestHandlerName: String = "NativeCallPush"
        
        if var data = userInfo {
            log.d("pushMessage: \(data)")
            
            let aps = JSON(data.removeValue(forKey: "aps"))
            
            UIApplication.shared.applicationIconBadgeNumber = aps["badge"].intValue
            
            for (key, value) in data {
                retData.updateValue(String(describing: value), forKey: key as! String)
            }
            
//            let type = retData["type"]
//            switch type {
//            default :   print("오류")
//            }
//
            
            
            //일단 무조껀 보내기
            //if status == .didReceive {
                let jsonString = JSON(retData).rawString(.utf8, options: []) ?? ""
                appFlowCoordinator?.didReceivePush(name: requestHandlerName , data: jsonString)
            //}
        }
    }
}
