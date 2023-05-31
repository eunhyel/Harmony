//
//  ChatGPTEndpoint.swift
//  Core
//
//  Created by John Park on 2023/03/24.
//  Copyright © 2023 GlobalHoneys. All rights reserved.
//

import Foundation
import Foundation
import Moya


enum GPTEndPoints {
    
    static func makeAskRequest(dto: APIParameter) throws -> URLRequest {
        
        let endpoint = try  MoyaProvider<AppAPI>().endpoint(.chatBot(dto)).urlRequest()
        
        return endpoint
    }
}
