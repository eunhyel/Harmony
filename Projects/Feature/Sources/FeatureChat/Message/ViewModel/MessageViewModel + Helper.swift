//
//  MessageViewModel + Helper.swift
//  Feature
//
//  Created by root0 on 2023/09/05.
//  Copyright © 2023 Harmony. All rights reserved.
//

import Foundation
import SwiftyJSON
import Core
import Shared

extension DefaultMessageViewModel {
    
    
    func errorControl(_ error: Error) {
        
        switch error {
        default:
            // 조금 있다가 다시 시도해주세요. toast
            break
        }
        log.e("error -> \(error.localizedDescription)")
    }
    
}
