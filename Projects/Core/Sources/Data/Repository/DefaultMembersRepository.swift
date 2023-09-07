//
//  DefaultMembersRepository.swift
//  Core
//
//  Created by root0 on 2023/09/05.
//  Copyright © 2023 Harmony. All rights reserved.
//

import Foundation
import Moya
import Alamofire
import SwiftyJSON

import Shared

public class DefaultMembersRepository: MembersRepository {
    
    public init() {}
    
    public func getMsgUserInfo_Mock() async throws -> Data {
        log.i("[API REPOSITORY]  ")
        
        let path = CoreResources.bundle.path(forResource: "MockUserV1", ofType: "json") ?? ""
        let jsonString = try? String(contentsOfFile: path)
        
        let decoder = JSONDecoder()
        let data = jsonString?.data(using: .utf8)
        
        guard let data = data  else {
            throw Exception.message("local json -> jsonString -> Data is nil")
        }
        
        return data
    }
}
