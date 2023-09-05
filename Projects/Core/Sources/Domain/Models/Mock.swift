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
struct MockUserV1: Codable {
    let product, version, releaseDate: String
    let demo: Bool
    let chatPartners: [ChatPartner]
}

// MARK: - ChatPartner
struct ChatPartner: Codable {
    let memNo: Int
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
