//
//  ResponseBridgeCMD.swift
//  GlobalYeoboya
//
//  Created by inforex on 2023/01/16.
//  Copyright © 2023 GlobalYeoboya. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import SwiftyJSON
import Toast
import WebViewJavascriptBridge
import Shared

/**
 Response Command
*/
enum ResponseBridgeCMD : String, CaseIterable{
    case getToken
}

/**
 Response Delegate
*/
protocol ResponseBridgeDelegate: AnyObject {
    func getToken()
}
/// 프로토콜 채택 부분에서 필요한 것만 구현할 수 있도록 optional 처리
extension ResponseBridgeDelegate {
    func getToken() {}
}

extension WebViewManager {
    
    /// 웹에서 보내는 데이타를 처리하기위한 메인 헨들러를 등록한다.
    func registerHandlers() {
        self.bridge = WebViewJavascriptBridge(forWebView: self.webView)
        self.bridge.setWebViewDelegate(self)

        let handler: WVJBHandler = { (data, responseCallback) -> Void in
            let json = JSON(data as Any)
            if let router = self.bridgeRouters[json["cmd"].stringValue] {
                router(json, responseCallback!)
                //log.i("Bridge Response CMD -> \(json["cmd"].stringValue)")
            } else {
            }
        }

        self.bridge.registerHandler(responseHandlerName, handler: handler)
    }


    /// 브릿지 커맨드에 따라 딕셔너리에 클로저를 등록
    func initBridgeHandlers() {
        //bridgeHandlers?[ResponseBridgeCMD.getToken.rawValue]              = responseDelegate?.getToken
        
        self.bridgeRouters["getPicture"] = { (jsonData, responseCallback) in
            Toast.defaultToast(jsonData.description, controller: self.controller)
            self.requestGetPicture(data : jsonData, responseCallback: responseCallback)
        }
        
        self.bridgeRouters["browserOpen"] = { (jsonData, responseCallback) in
            Toast.defaultToast(jsonData.description, controller: self.controller)
            responseCallback(jsonData["data"]["url"].stringValue)
        }
        
        self.bridgeRouters["closeWin"] = { (jsonData, responseCallback) in
            Toast.defaultToast(jsonData.description, controller: self.controller)
            if jsonData["handler"].exists() {
                self.bridge.callHandler(self.requestHandlerName, data: jsonData["handler"].object)
            }
        }
        
        self.bridgeRouters["getToken"] = { (jsonData, responseCallback) in
            Toast.defaultToast(jsonData.description, controller: self.controller)
            responseCallback(UserDefaultsManager.deviceToken)
        }
    }
}
