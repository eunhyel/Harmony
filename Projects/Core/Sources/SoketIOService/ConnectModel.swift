//
//  ConnectModel.swift
//  Core
//
//  Created by inforex_imac on 2023/03/29.
//  Copyright © 2023 Quest. All rights reserved.
//

import Foundation


public struct ConnectModel {
    var pathUrl : String = ""
    var media   : String = ""
    
    public init(url: String = "", media: String = "") {
        self.pathUrl = url
        self.media = media
    }
}
