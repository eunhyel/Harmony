//
//  AppSetting.swift
//  Shared
//
//  Created by eunhye on 2023/05/23.
//  Copyright © 2023 ModularArch. All rights reserved.
//

import Foundation
import WebKit
import KeychainAccess

public struct App {
    
    public static let startPage = "https://gen2-ag315.club5678.com"
    
    public static let processPool = WKProcessPool()
    
    public static var keychainService: Keychain = .init(service: Bundle.main.bundleIdentifier!)
    // 앱버전
    public static func getAppVersion() -> String {
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return "" }
        return version
    }
}
