//
//  WebViewManager.swift
//  GlobalYeoboya
//
//  Created by inforex on 2023/01/16.
//  Copyright © 2023 GlobalYeoboya. All rights reserved.
//

import Foundation
import WebKit
import Shared
import SwiftyJSON
import WebViewJavascriptBridge

public class WebViewManager: NSObject, UIScrollViewDelegate {
    weak var controller: UIViewController?  //토스트나, 뷰 올릴 컨트롤러
    weak var responseDelegate: ResponseBridgeDelegate?      //브릿지 처리하는곳
    
    var bridge: WebViewJavascriptBridge!                    // 통신 인터페이스
    var bridgeRouters: [String: (JSON, @escaping  WVJBResponseCallback) -> Void] = [:]
    
    var responseHandlerName: String = "callFromWeb"
    var requestHandlerName: String = "NativeCallJS"
    
    var webView: WKWebView = WKWebView()
    
    var isFirstLoad = false
    
    public init(controller: UIViewController?) {
        super.init()
        self.controller = controller
    }

    func createDefaultConfiguration() -> WKWebViewConfiguration {
        let webPreferencePool = WKPreferences()
            webPreferencePool.javaScriptCanOpenWindowsAutomatically = true
        
        let webConfiguration = WKWebViewConfiguration()
            webConfiguration.processPool = App.processPool // 웹뷰간 쿠키 공유 설정
            webConfiguration.preferences = webPreferencePool
            webConfiguration.websiteDataStore = WKWebsiteDataStore.default()// 쿠키저장소
            webConfiguration.allowsInlineMediaPlayback = true
            webConfiguration.mediaTypesRequiringUserActionForPlayback = .all
        let contentController = WKUserContentController()
            webConfiguration.userContentController = contentController
        
        return webConfiguration
    }
    
    /// 웹뷰를 리턴한다.
    public func createWebView(url : String) -> WKWebView {
        webView = WKWebView(frame: .zero, configuration: createDefaultConfiguration())
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.delegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.scrollView.bounces = false
        webView.allowsLinkPreview = false
        webView.allowsBackForwardNavigationGestures = true
        
        var page = URLRequest(url: URL(string: url)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        //page.cachePolicy = .returnCacheDataElseLoad
        
        putInfomation(webView){
            self.webView.customUserAgent = UserDefaultsManager.userAgent
            self.webView.load(page)
        }

        // 브릿지 등록
        registerHandlers()
        // 브릿지 핸들러 등록
        initBridgeHandlers()
        
        WKWebsiteDataStore.default().httpCookieStore.add(self)
        return webView
    }
    
    /**
     * userAgent  가져오기
     * wkwebivew 에서 navigator.userAgent 명령어로 userAgent 를 긁어 온다
     **/
    func getUserAgent(_ webview: WKWebView, completion :((String)->Void)? = nil){
        webview.evaluateJavaScript("navigator.userAgent") { (result, error) in
            guard let completion = completion else { return }
            if let result = result as? String{
                completion(result)
            }else if error != nil{
                completion("")
                //log.e(error)
            }else{
                completion("")
            }
        }
    }
    
    func putInfomation(_ webview: WKWebView, completionHandler : (() -> Void)? = nil){
        getUserAgent(webview){ userAgentString in
            let userAgentStr : String = "HONEY" // 강제문자열
            let userAgentDevice : String = "b" // 아이폰이냐? 안드로이냐?  아이폰('b')
            let deviceId : String = UIDevice.current.identifierForVendor!.uuidString // 디바이스 아이디
            let deviceToken: String = UserDefaultsManager.deviceToken ?? "" // 디바이스 토큰
            let appVersion: String = App.getAppVersion() // 앱 버전
            let osVersion: String = UIDevice.current.systemVersion // os 버전
            
            let userAgentArr = [
                userAgentStr,
                userAgentDevice,
                deviceId,
                deviceToken,
                appVersion,
                osVersion
            ]
            
            UserDefaultsManager.userAgent = userAgentString + "(\(UIDevice.modelName))" + userAgentArr.joined(separator: "|")
            
            
            //test
            var myAgent = " CLUB5678/" + "4.9.81" + "b_" + "0" + "_iOS_chatRadar"
            UserDefaultsManager.userAgent = userAgentString + myAgent
            
            if let completion = completionHandler {
                completion()
            }
        }
    }
    
    func removeWebView(){
        guard self.bridge != nil else {
            return
        }
        self.bridge.removeHandler(responseHandlerName)
    }
    
    deinit{
        log.d("WebViewManager deinit")
    }
}
