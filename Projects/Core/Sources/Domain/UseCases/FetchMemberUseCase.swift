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
    
}

public protocol SearchMemberUseCase {
    
}

public protocol FetchMemberUseCase: SearchMemberUseCase, UpdateMemberUseCase {
    
    func mexecute(reqModel memNo: Int?) async throws -> ChatPartner?
}

public class DefaulMemberUseCase: FetchMemberUseCase {
    
    var memberRepository: MembersRepository!
    
    public init(memberRepository: MembersRepository!) {
        self.memberRepository = memberRepository
    }
    
    // TODO: Test Mock
    public func mexecute(reqModel memNo: Int? = nil) async throws -> ChatPartner? {
        // data -> ChatPartner
//        let member = try await memberRepository.getMsgUserInfo_Mock()
        let data = try await ApiService.parseData_MockJSON(resource: "MockUserV1")
        
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
}
