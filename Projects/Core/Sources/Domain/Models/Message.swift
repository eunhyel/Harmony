//
//  Message.swift
//  Core
//
//  Created by root0 on 2023/06/08.
//  Copyright © 2023 Harmony. All rights reserved.
//

import Foundation
import SwiftyJSON

public enum SendType: String, Codable {
    case receive = "0"
    case send = "1"
}

enum ChatType: String, Codable {
    case text = "0"
    case image = "1"
    case video = "2"
    case call = "3"
    
}

public struct ChatMessage: Codable, Hashable {
    typealias ID = UUID
    var id: ID = ID()
    
    /// 읽음 여부
    var readYn: String?
    
    /// 메세지 타입
    var type: ChatType?
    
    /// 메세지 내용
    var content: String?
    
    /// 메세지 발송일자
    var insDate: Int?
    
    // 사진, 비디오, 녹음?
    var media: Data?
    
    var occurError: Bool = false
    
    init(id: ID, readYn: String? = nil, type: ChatType? = nil, content: String? = nil, insDate: Int? = nil, media: Data? = nil, occurError: Bool) {
        self.id = id
        self.readYn = readYn
        self.type = type
        self.content = content
        self.insDate = insDate
        self.media = media
        self.occurError = occurError
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(ChatMessage.ID.self, forKey: .id)
        self.readYn = try container.decodeIfPresent(String.self, forKey: .readYn)
        self.type = try container.decodeIfPresent(ChatType.self, forKey: .type)
        self.content = try container.decodeIfPresent(String.self, forKey: .content)
        self.insDate = try container.decodeIfPresent(Int.self, forKey: .insDate)
        self.media = try container.decodeIfPresent(Data.self, forKey: .media)
        self.occurError = try container.decode(Bool.self, forKey: .occurError)
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
