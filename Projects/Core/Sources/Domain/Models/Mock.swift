//
//  Mock.swift
//  Core
//
//  Created by root0 on 2023/09/05.
//  Copyright © 2023 Harmony. All rights reserved.
//

import Foundation
import SwiftyJSON

// MARK: - Welcome
public struct MockUserV1: Codable {
    let product, version, releaseDate: String
    let demo: Bool
    public let chatPartners: [ChatPartner]
}

// MARK: - ChatPartner
public struct ChatPartner: Codable {
    public let memNo: Int
    let gender: Gender
    let memNick, country, contryCode: String
    let location: String
    let photoURL: String
    let status: MemberStatus

    enum CodingKeys: String, CodingKey {
        case memNo, memNick, gender, country, contryCode, location
        case photoURL = "photoUrl"
        case status
    }
}

// MARK: - MockChatV1
public struct MockChatV1: Codable {
    let product, version, releaseDate: String
    let demo: Bool
    let code: String
    public let list: [MockList]
}

// MARK: - List
public struct MockList: Codable {
    let msgNo, memNo, ptrMemNo: Int
    let readYn, sendType, msgType, content: String
    let insDate: String
}
