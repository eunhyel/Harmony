//
//  FetchMembeerUseCase.swift
//  Core
//
//  Created by root0 on 2023/09/05.
//  Copyright © 2023 Harmony. All rights reserved.
//

import Foundation
import SwiftyJSON

import Shared
public protocol UpdateMemberUseCase {
    func updateAboutMember(reqModel memNo: Int) async throws -> String?
}

public protocol SearchMemberUseCase {
    
}

public protocol FetchMemberUseCase: SearchMemberUseCase, UpdateMemberUseCase {
    
    func mexecute_user(reqModel memNo: Int?) async throws -> ChatPartner?
    
    
}

public class DefaulMemberUseCase: FetchMemberUseCase {
    
    var memberRepository: MembersRepository!
    
    public init(memberRepository: MembersRepository!) {
        self.memberRepository = memberRepository
    }
    
    // TODO: Test Mock
    public func mexecute_user(reqModel memNo: Int? = nil) async throws -> ChatPartner? {
        // data -> ChatPartner
        let data = try await memberRepository.getMsgUserInfo_Mock()
//        let data = try await ApiService.parseData_MockJSON(resource: "MockUserV1")
        
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
    
    // TODO: About Member in MessageDetail: Delete, Block, Report, Bookmark
    public func updateAboutMember(reqModel memNo: Int) async throws -> String? {
        let data = try await memberRepository.updateAboutMember(reqModel: memNo)
        
        var resultDescription: String?
        do {
            let decoder = JSONDecoder()
            
            // var parseData = try decoder.decode(.self, from: data)
            resultDescription = ""
            
            
        } catch {
            log.e("error -> \(error.localizedDescription)")
        }
        
        return resultDescription
    }
}
