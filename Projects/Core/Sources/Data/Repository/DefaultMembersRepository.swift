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
    
    public func getMsgUserInfo_Mock() async throws -> ChatPartner {
        log.i("[API REPOSITORY]  ")
        
        let path = Bundle.main.path(forResource: "MockUserV1", ofType: "json") ?? ""
        let jsonString = try? String(contentsOfFile: path)
        
        let decoder = JSONDecoder()
        let data = jsonString?.data(using: .utf8)
        
        guard let data = data,
              let chatPtrs = try? decoder.decode(ChatPartner.self, from: data) else {
            
            throw Exception.Member.empty
        }
        
        return chatPtrs
    }
}
