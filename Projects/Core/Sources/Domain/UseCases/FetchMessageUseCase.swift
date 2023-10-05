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
//    func fetchMsgBoxList(reqModel: Any) async throws -> MessageList
}

public protocol FetchMessageUseCase: UpdateMessageUseCase, SearchMessageUseCase {
    // TODO: Delete Test Methods.
    func mexecute_chat() async throws -> [MockList]
    func fetchMsgs_Mock() async throws -> [MockChat]
    func fetchMsgBoxList_Mock() async throws -> [BoxList]
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
    
    public func fetchMsgs_Mock() async throws -> [MockChat] {
        let data = try await fetchMsgRepo.getMsgList_Mock()
//        let data = try await ApiService.parseData_MockJSON(resource: "MockChatV1")
        
        var model = [MockChat]()
        do {
            let decoder = JSONDecoder()
            let parseJSON = try decoder.decode(MockChatV1.self, from: data)
            
            var chats = parseJSON.list
            
            // update MockList -> MockChat
            let seta = Set(chats.map { $0.minsDate })
//            let dic = Dictionary(grouping: chats, by: { $0.minsDate })
            
            model = chats.map { MockChat(msgNo: $0.msgNo,
                                         memNo: $0.memNo,
                                         ptrMemNo: $0.ptrMemNo,
                                         readYn: $0.readYn,
                                         sendType: $0.sendType,
                                         msgType: ChatType(rawValue: $0.msgType.rawValue) ?? .text,
                                         content: $0.content,
                                         minsDate: $0.minsDate,
                                         showClocks: false) }
            
            
            
        } catch {
            log.e("error -> \(error.localizedDescription)")
            throw Exception.message("chatMessages decode fail")
        }
        
        return model
    }
    
    public func fetchMsgBoxList_Mock() async throws -> [BoxList] {
        let data = try await fetchMsgRepo.fetchMsgBoxList_Mock()
        
        var model = [BoxList]()
        do {
            let decoder = JSONDecoder()
            let parseJSON = try decoder.decode(MockBoxListV1.self, from: data)
            model = parseJSON.boxs
        } catch {
            log.e("error -> \(error.localizedDescription)")
            throw Exception.message("Message Box List decode fail")
        }
        
        return model
    }
}
