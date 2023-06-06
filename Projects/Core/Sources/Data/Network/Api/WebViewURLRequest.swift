//
//  WebViewURLRequest.swift
//  Core
//
//  Created by root0 on 2023/06/02.
//  Copyright © 2023 Harmony. All rights reserved.
//

import Foundation
import Moya
import Shared

enum WebViewURLRequest {
    case myPage
}

extension WebViewURLRequest: TargetType {
    
    var baseURL: URL {
        return URL(string: App.startPage)!
    }
    
    var path: String {
        switch self {
        case .myPage: return ""
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        switch self {
        case .myPage:
            return .requestParameters(parameters: [:], encoding: URLEncoding.default)
        @unknown default:
            return .requestParameters(parameters: [:], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return [
            "Content-Type" : "application/json",
            "User-Agent" : UserDefaultsManager.userAgent ?? "",
            "Cookie" : ""
        ]
    }
}
