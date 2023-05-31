//
//  Cookie.swift
//  Core
//
//  Created by eunhye on 2023/05/31.
//  Copyright © 2023 Harmony. All rights reserved.
//

import Foundation
import WebKit


open class Cookie {
    
    public static let cookieDomain = ".club5678.com"
    
    public static func setAcceptPolicy(){
        HTTPCookieStorage.shared.cookieAcceptPolicy = HTTPCookie.AcceptPolicy.always
    }
    
    
    
    
    
    
    
    
    
    
    
    
    public static func checkAutoLoginInfo() {
        //if let autoLoginInfo = InforexKeyChain.shared.autoLogin {
            let cookieProps = [
                HTTPCookiePropertyKey.domain:  cookieDomain,
                HTTPCookiePropertyKey.path: "/",
                HTTPCookiePropertyKey.name: "setAutoLogin",
                //HTTPCookiePropertyKey.value: autoLoginInfo
            ]
            
            guard let cookie = HTTPCookie(properties: cookieProps) else{
                return
            }
            
            HTTPCookieStorage.shared.setCookie(cookie)
            WKWebsiteDataStore.default().httpCookieStore.setCookie(cookie, completionHandler: {
            })
//        }
//        else {
//            //Toast.show("자동로그인 정보가 없습니다.")
//        }
    }
    
    //쿠키 싱크
    public static func cookieSyncronization(_ completion: (()->Void)? = nil) {
        WKWebsiteDataStore.default().httpCookieStore.getAllCookies( { (cookies) -> Void in
            //log.d(cookies)
            HTTPCookieStorage.shared.cookies?.forEach( {cookie in
                HTTPCookieStorage.shared.deleteCookie(cookie)
            })
            cookies.forEach({cookie in
                HTTPCookieStorage.shared.setCookie(cookie)
            })
            if let completion = completion { completion() }
        })
    }
    
    /// 쿠키 가져와서 저장 or 갱신한다
    public static func getGCCV(_ completion: @escaping (String?) -> Void) {
        DispatchQueue.main.async {
            WKWebsiteDataStore.default().httpCookieStore.getAllCookies( { (cookies) -> Void in
                dump(cookies)
                cookies.forEach({cookie in
                    if cookie.domain == cookieDomain && cookie.name == "gCCV" {
                        completion(cookie.value)
                        return
                    }
                })
            })
        }
    }
}
