//
//  MypageViewController.swift
//  Feature
//
//  Created by root0 on 2023/06/01.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import RxSwift
import Shared
import Core

open class MypageViewController: UIViewController {
    
    var viewModel: MypageViewModel!
    var webViewManager : WebViewManager?
    var disposeBag = DisposeBag()
    
    public class func create(with viewModel: MypageViewModel) -> MypageViewController {
        let vc = MypageViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setWebView()
    }
    
    func setWebView() {
        DispatchQueue.main.async {
            self.webViewManager = WebViewManager(controller: self)
            let webView = self.webViewManager?.createWebView(url: App.startPage)
            self.view.insertSubview(webView!, at: 0)
            webView!.snp.makeConstraints {
                $0.edges.equalTo(self.view.safeAreaLayoutGuide)
            }
        }
    }
    
    deinit {
        log.d("deinit")
    }
}
