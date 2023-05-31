//
//  WebViewManager + Delegate.swift
//  Core
//
//  Created by eunhye on 2023/05/30.
//  Copyright © 2023 Harmony. All rights reserved.
//

import Foundation
import WebKit
import Shared

//webview handler setting
class CompletionHandlerWrapper<Element> {
  private var completionHandler: ((Element) -> Void)?
  private let defaultValue: Element

  init(completionHandler: @escaping ((Element) -> Void), defaultValue: Element) {
    self.completionHandler = completionHandler
    self.defaultValue = defaultValue
  }

  func respondHandler(_ value: Element) {
    completionHandler?(value)
    completionHandler = nil
  }

  deinit {
    respondHandler(defaultValue)
  }
}


extension WebViewManager: WKUIDelegate {
    public func webViewDidClose(_ webView: WKWebView) {}
    
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        _ = CompletionHandlerWrapper(completionHandler: completionHandler, defaultValue: Void())
        SystemAlert.ConfirmAlert(msg: message, controller: controller)
    }
    private func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        _ = CompletionHandlerWrapper(completionHandler: completionHandler, defaultValue: Void())
        SystemAlert.ConfirmAlert(msg: message, controller: controller)
    }
    public func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        completionHandler(nil)
    }
}


extension WebViewManager: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Toast.show("웹뷰로드 완료", controller: controller)
        
        //push에서 들어왔는데 웹뷰가 뒤늦게 로드 됐을때 저장했다가 로드 다 되면 전송
        if let data = UserDefaultsManager.receivedPushData {
            Toast.defaultToast("저장해둔 푸시 데이터 전송", controller: self.controller)
            self.callPushHandler(data: data)
            UserDefaultsManager.receivedPushData = nil
        }
        
        //처음 실행 됐을때 웹에 웹 브릿지 리스트 주기
        if isFirstLoad {
            self.webView.evaluateJavaScript("localStorage.setItem('bridgeCmdList', '\(self.bridgeRouters.keys)')") { (result, error) in
                log.d(self.bridgeRouters.keys)
            }
            isFirstLoad = false
        }
    }
}
