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
    public init(memNo: Int, gender: Gender, memNick: String, country: String, contryCode: String, location: String, photoURL: String, status: MemberStatus) {
        self.memNo = memNo
        self.gender = gender
        self.memNick = memNick
        self.country = country
        self.contryCode = contryCode
        self.location = location
        self.photoURL = photoURL
        self.status = status
    }
    
    public let memNo: Int
    public let gender: Gender
    public let memNick, country, contryCode: String
    public let location: String
    public let photoURL: String
    public let status: MemberStatus

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
public struct MockList: Codable, Hashable {
    public let msgNo, memNo, ptrMemNo: Int
    public let readYn, sendType, msgType, content: String
    public let minsDate: String
}

// MARK: - MockBoxListV1
struct MockBoxListV1: Codable {
    let product: String
    let demo: Bool
    let code: String
    let box: [BoxList]
}

// MARK: - List
struct BoxList: Codable {
    let memNo: Int
    let memNick, gender, nation, country: String
    let location, photoURL, exitYn, restYn: String
    let lastMsg: String
    let msgCnt, noreadCnt: Int
    let lastTime: String

    enum CodingKeys: String, CodingKey {
        case memNo, memNick, gender, nation, country, location
        case photoURL = "photoUrl"
        case exitYn, restYn, lastMsg, msgCnt, noreadCnt, lastTime
    }
}
