//
//  WebViewManager + Request.swift
//  HoneyGlobal
//
//  Created by inforex on 2023/01/31.
//  Copyright © 2023 HoneyGlobal. All rights reserved.
//

import Foundation
import Shared
import WebViewJavascriptBridge
import SwiftyJSON

public enum SocialLogin: String {
    case apple
    case kakao
    case google
}

enum RequestBridgeCmd: String {
    case getPicture
}


//기본 핸들러 전송 폼
extension WebViewManager {
    
    //기본 Push 핸들러 전송 폼
    public func callPushHandler(name : String = "NativeCallPush", data: String) {
        if webView.url == nil || webView.isLoading {
            Toast.defaultToast("webView not setting", controller: self.controller)
            UserDefaultsManager.receivedPushData = data
        }
        else {
            guard let bridge = self.bridge else {
                Toast.defaultToast("bridge not setting", controller: self.controller)
                return
            }
            Toast.defaultToast(data, controller: self.controller)
            bridge.callHandler(name, data: data)
        }
    }
    
    //기본 핸들러 전송 폼
    public func callHandler(data: Dictionary<String, Any>) {
        self.bridge.callHandler(requestHandlerName, data: data)
    }
    
    //콜백 필요한 전송 폼
    public func  callBackHandler(data: Dictionary<String, Any>, responseCallback: WVJBResponseCallback?){
        self.bridge.callHandler(requestHandlerName, data: data, responseCallback: responseCallback)
    }
}


//웹쪽에 전달하는 함수들
extension WebViewManager {

    func requestGetPicture(data : JSON, responseCallback: WVJBResponseCallback?){
        
        let result = ["result" : Date().timeIntervalSince1970 ]
        let data = ["cmd": data["data"]["handlerCmd"].stringValue,
                    "data":result] as [String : Any]
        
        callHandler(data: data as Dictionary<String, Any>)
    }
    
    func requestSocialToken(service: SocialLogin, token: String, email: String = "", responseCallback: WVJBResponseCallback?){
//        log.i("Bridge Request CMD -> \(RequestBridgeCmd.socialToken.rawValue)")
//
//        var data = ["cmd": RequestBridgeCmd.socialToken.rawValue,
//                    "service": service.rawValue,
//                    "token": token,
//                    "email": email]
//
//        // 애플로그인이라면 firstName을 넣어준다. 심사 이슈
//        if service == .apple {
//            data["email"] = UserDefaultsManager.email
//            data["firstName"] = UserDefaultsManager.firstName
//        }
//
//        callHandler(data: data, responseCallback: responseCallback)
    }
}
