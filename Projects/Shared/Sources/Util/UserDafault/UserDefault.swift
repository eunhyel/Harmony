//
//  UserDefault.swift
//  Shared
//
//  Created by eunhye on 2023/05/23.
//  Copyright © 2023 ModularArch. All rights reserved.
//

import Foundation

@propertyWrapper
public struct OptinalUserDefaults<T> {
    let key: String
    
    var defaultValue: T?
    
    public var projectedValue: T? {
        self.defaultValue
    }
    
    public var wrappedValue: T? {
        get { UserDefaults.standard.object(forKey: self.key) as? T ?? self.defaultValue }
        set { UserDefaults.standard.set(newValue, forKey: self.key)}
    }
}

public class UserDefaultsManager {
    
    // 유저에이전트
    @OptinalUserDefaults(key: "userAgent", defaultValue: nil)
    public static var userAgent: String?
    
    // 디바이스 토큰
    @OptinalUserDefaults(key: "deviceToken", defaultValue: "")
    public static var deviceToken: String?
    
    //푸시 데이터 저장
    @OptinalUserDefaults(key: "receivedPushData", defaultValue: nil)
    public static var receivedPushData: String?
    
}


