//
//  MypageViewModel.swift
//  Feature
//
//  Created by root0 on 2023/06/01.
//  Copyright © 2023 Harmony. All rights reserved.
//

import Foundation
import Core
import Shared

public struct MypageActions {
    
}

public protocol MypageViewModelInput {
    func viewDidLoad()
}

public protocol MypageViewModelOutput {
    
}

public protocol MypageViewModel: MypageViewModelInput, MypageViewModelOutput {
    
    var actions: MypageActions? { get set }
//    var webViewManager: WebViewManager { get set }
}

open class DefaultMypageViewModel: MypageViewModel {
    
    public var actions : MypageActions?
    public var webViewManager: WebViewManager?
    var mypageType: MypageType
    
    public init(actions: MypageActions? = nil, mypageType: MypageType) {
        self.mypageType = mypageType
        
        self.actions = actions
    }
    
    // MARK: - OUTPUT
    
    deinit {
        log.d("\(#fileID) deinit")
    }

}

extension DefaultMypageViewModel {
    
    public func viewDidLoad() {
        
    }
    
}
