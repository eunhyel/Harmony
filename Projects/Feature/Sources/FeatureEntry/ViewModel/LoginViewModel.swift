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

public struct LoginViewModelActions {
    
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
