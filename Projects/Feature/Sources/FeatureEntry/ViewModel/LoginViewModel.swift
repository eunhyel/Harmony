//
//  LoginViewModel.swift
//  GlobalYeoboya
//
//  Created by inforex_imac on 2022/12/19.
//  Copyright (c) 2022 All rights reserved.
//

import Foundation
import SwiftyJSON
import RxSwift
import Shared
import WebKit
import Core
import SwiftyJSON

public struct LoginViewModelActions {
    var loginDidSuccess: () -> Void
    
    public init(loginDidSuccess: @escaping () -> Void) {
        self.loginDidSuccess = loginDidSuccess
    }
}

public protocol LoginViewModelInput {
    
}

public protocol LoginViewModelOutput {
    
}

public protocol LoginViewModel: LoginViewModelInput, LoginViewModelOutput {
    
}

public class DefaultLoginViewModel: LoginViewModel {

    public init(){
        
    }

    deinit {
        log.d("\(#fileID) deinit")
    }
}


extension DefaultLoginViewModel: ResponseBridgeDelegate{
    public func socialLogin(data: JSON, callBack: WVJBResponseCallback) {
        
        switch data["service"].stringValue {
        case SocialLogin.apple.rawValue:
            Core.apple.signIn()
//        case SocialLogin.kakao.rawValue:
//            Kakao.shared.signIn()
//        case SocialLogin.google.rawValue:
//            Google.shared.signIn()
            
        default: break
        }
    }
    
    public func stateLogin(data: JSON, callBack: WVJBResponseCallback) {
        saveLoginInfo(data)
        Cookie.getGCCV(){_ in }
    }
}

extension DefaultLoginViewModel {
    /// 로그인 정보 저장
    func saveLoginInfo(_ data: JSON){
        UserDefaultsManager.sessKey = data["data"]["sessKey"].stringValue
        
        doLoginSuccessAction()
    }
    
    /// 로그인 성공했고 메인으로 보낸다
    func doLoginSuccessAction(){
    }
}
