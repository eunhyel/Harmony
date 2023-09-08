//
//  DefaultMessageRepository.swift
//  Core
//
//  Created by root0 on 2023/09/05.
//  Copyright © 2023 Harmony. All rights reserved.
//

import Foundation

import Shared

public class DefaultMessageRepository: MessagesRepository {
    
    public init() {}
    
    public func fetchMessageList() async throws -> [ChatMessage] {
        return []
    }
    
    public func getMsgList_Mock() async throws -> Data {
        log.i("[API REPOSITORY]  ")
        
        let path = CoreResources.bundle.path(forResource: "MockChatV1", ofType: "json") ?? ""
        let jsonString = try? String(contentsOfFile: path)
        
        let decoder = JSONDecoder()
        let data = jsonString?.data(using: .utf8)
        
        guard let data = data  else {
            throw Exception.message("local json -> jsonString -> Data is nil")
        }
        
        return data
    }
    
    public func fetchMsgBoxList_Mock() async throws -> Data {
        log.i("[API REPOSITORY]  ")
        
        let path = CoreResources.bundle.path(forResource: "MockMsgBoxList", ofType: "json") ?? ""
        let jsonString = try? String(contentsOfFile: path)
        
        let data = jsonString?.data(using: .utf8)
        
        guard let data = data  else {
            throw Exception.message("local json -> jsonString -> Data is nil")
        }
        
        return data
    }
}
