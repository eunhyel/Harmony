//
//  ChatDataModel.swift
//  Feature
//
//  Created by eunhye on 2023/09/13.
//  Copyright © 2023 Harmony. All rights reserved.
//

import Foundation


enum ChatType: Int {
    case system = 0
    case text
    case photo
}

public struct ChatDataModel : Hashable{
    
    var type : ChatType
    var text : String
    
    
    internal init(type : ChatType, text: String) {
        self.type = type
        self.text = text
    }
}
