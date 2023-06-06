//
//  LoginViewController.swift
//  GlobalYeoboya
//
//  Created by inforex_imac on 2022/12/19.
//  Copyright (c) 2022 All rights reserved.
//

import UIKit
import WebKit
import SnapKit
import SwiftyJSON
import Core
import Shared


open class LoginViewController: UIViewController {
    
    var viewModel: LoginViewModel!
    var webViewManager : WebViewManager?
    
    open var Controller : UINavigationController = UINavigationController.defauleNavigation()
    open override func loadView() {
        super.loadView()
        self.view = UIView()
        self.view.backgroundColor = .white
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.webViewManager = WebViewManager(controller: self)
            let webview = self.webViewManager?.createWebView(url: App.startPage)
            self.view.insertSubview(webview!, at: 0)
            webview!.snp.makeConstraints {
                $0.edges.equalTo(self.view.safeAreaLayoutGuide)
            }
        }
    }
    
    
    public class func create(with viewModel: LoginViewModel) -> LoginViewController {
        return LoginViewController()
    }
    
    public func webPushSend(name: String, data : String){
        guard let webview = webViewManager else {
            UserDefaultsManager.receivedPushData = data
            return
        }
        webview.callPushHandler(name: name, data: data)
    }
}

