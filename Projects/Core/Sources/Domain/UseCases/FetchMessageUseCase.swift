//
//  FetchMessageUseCase.swift
//  Core
//
//  Created by root0 on 2023/09/05.
//  Copyright © 2023 Harmony. All rights reserved.
//

import Foundation

import Shared

public protocol UpdateMessageUseCase {
    
}

public protocol SearchMessageUseCase {
    
}

public protocol FetchMessageUseCase: UpdateMessageUseCase, SearchMessageUseCase {
    func mexecute_chat() async throws -> [MockList]
}

public class DefaultMessageUseCase: FetchMessageUseCase {
    
    var fetchMsgRepo: MessagesRepository
    
    public init(repository: MessagesRepository) {
        self.fetchMsgRepo = repository
    }
    
    // TODO: Test Mock
    public func mexecute_chat() async throws -> [MockList] {
        // data -> ChatPartner
        let data = try await fetchMsgRepo.getMsgList_Mock()
//        let data = try await ApiService.parseData_MockJSON(resource: "MockChatV1")
        
        var model = [MockList]()
        do {
            let decoder = JSONDecoder()
            let parseJSON = try decoder.decode(MockChatV1.self, from: data)
            
            var chats = parseJSON.list
            model = parseJSON.list
        } catch {
            log.e("error -> \(error.localizedDescription)")
            throw Exception.message("chatMessages decode fail")
        }
        
        return model
    }
}
