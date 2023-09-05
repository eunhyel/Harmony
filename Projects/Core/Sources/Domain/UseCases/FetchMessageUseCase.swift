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
    func mexecute() async throws -> [MockList]
}

public class DefaultMessageUseCase: FetchMessageUseCase {
    
    var fetchMsgRepo: MessagesRepository
    
    public init(repository: MessagesRepository) {
        self.fetchMsgRepo = repository
    }
    
    // TODO: Test Mock
    public func mexecute() async throws -> [MockList] {
        // data -> ChatPartner
//        let member = try await memberRepository.getMsgUserInfo_Mock()
        let data = try await ApiService.parseData_MockJSON(resource: "MockChatV1")
        
        guard let data = data else {
            throw Exception.message("data nil")
        }
        
        var model = [MockList]()
        do {
            let decoder = JSONDecoder()
            var parseJSON = try decoder.decode(MockChatV1.self, from: data)
            
//            var chats = parseJSON.list
            model = parseJSON.list
        } catch {
            log.e("error -> \(error.localizedDescription)")
            throw Exception.message("chatMessages decode fail")
        }
        
        return model
    }
}
