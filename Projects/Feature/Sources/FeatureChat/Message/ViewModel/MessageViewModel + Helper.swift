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
    
    public func getSectionToIndex(index: Int) -> String? {
        return self.sectionList[safe: index]
    }
    
    // TODO: REMOVE TEST MOCK
    func mexecute_User(reqModel memNo: Int? = nil) async throws -> ChatPartner? {
        // data -> ChatPartner
        let data = try await parseFeatureData_MockJSON(resource: "MockUserV1")
        
        guard let data = data else {
            throw Exception.message("Mock User Data nil")
        }
        
        var model: ChatPartner?
        do {
            let decoder = JSONDecoder()
//            var users = try decoder.decode([ChatPartner].self, from: data)
            var parseJSON = try decoder.decode(MockUserV1.self, from: data)
            
            model = parseJSON.chatPartners.filter { $0.memNo == memNo }.first
        } catch {
            log.e("error -> \(error.localizedDescription)")
            throw Exception.message("Mock User Decoding Failed")
        }
        
        return model
    }
    public func mexecute_Chat() async throws -> [MockList] {
        // data -> ChatPartner
        let data = try await parseFeatureData_MockJSON(resource: "MockChatV1")
        
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
    
    public func parseFeatureData_MockJSON(resource name: String) async throws -> Data? {
        
        guard let path = FeatureResources.bundle.path(forResource: name, ofType: "json") else {
            return nil
        }
        
        guard let jsonString = try? String(contentsOfFile: path) else {
            return nil
        }
        
        let decoder = JSONDecoder()
        let data = jsonString.data(using: .utf8)
        
        return data
    }
    
}
