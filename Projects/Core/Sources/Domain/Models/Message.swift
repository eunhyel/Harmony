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

public enum ChatType: String, Codable {
    case text = "0"
    case image = "1"
    case video = "2"
    case call = "3"
    
}

public struct ChatMessage: Codable, Hashable {
    typealias ID = UUID
    var id: ID = ID()
    
    var msgNo: Int
    var memNo: Int?
    var ptrMemNo: Int?
    
    /// 읽음 여부
    public var readYn: String?
    
    /// 메세지 발송 타입
    public var sendType: SendType?
    
    /// 메세지 타입
    public var msgType: ChatType?
    
    /// 메세지 내용
    public var content: String?
    
    /// 메세지 발송일자
    public var insDate: Int?
    
    /// Test Mock
    public var minsDate: String?
    
    // 사진, 비디오, 녹음?
    var media: Data?
    
    var occurError: Bool = false
    
    internal init(id: ChatMessage.ID = ID(),
                  msgNo: Int, memNo: Int? = nil, ptrMemNo: Int? = nil,
                  readYn: String? = nil, sendType: SendType? = nil, msgType: ChatType? = nil,
                  content: String? = nil, insDate: Int? = nil, minsDate: String? = nil, media: Data? = nil,
                  occurError: Bool = false) {
        self.id = id
        self.msgNo = msgNo
        self.memNo = memNo
        self.ptrMemNo = ptrMemNo
        self.readYn = readYn
        self.sendType = sendType
        self.msgType = msgType
        self.content = content
        self.insDate = insDate
        // test
        self.minsDate = minsDate
        self.media = media
        self.occurError = occurError
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.id = try container.decode(ChatMessage.ID.self, forKey: .id)
        self.msgNo = try container.decode(Int.self, forKey: .msgNo)
        self.memNo = try? container.decode(Int.self, forKey: .memNo)
        self.ptrMemNo = try? container.decode(Int.self, forKey: .ptrMemNo)
        
        self.readYn = try container.decodeIfPresent(String.self, forKey: .readYn)
        self.sendType = try container.decodeIfPresent(SendType.self, forKey: .sendType)
        self.msgType = try container.decodeIfPresent(ChatType.self, forKey: .msgType)
        
        self.content = try container.decodeIfPresent(String.self, forKey: .content)
        self.insDate = try container.decodeIfPresent(Int.self, forKey: .insDate)
        // test
        self.minsDate = try container.decodeIfPresent(String.self, forKey: .minsDate)
        self.media = try container.decodeIfPresent(Data.self, forKey: .media)
        
        self.occurError = try container.decode(Bool.self, forKey: .occurError)
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(msgNo)
        hasher.combine(memNo)
        hasher.combine(ptrMemNo)
        hasher.combine(readYn)
        hasher.combine(sendType)
        hasher.combine(msgType)
        hasher.combine(content)
        hasher.combine(insDate)
        //test
        hasher.combine(minsDate)
//        hasher.combine()
    }
}

public struct MockChat: Codable, Hashable {
    public let msgNo, memNo, ptrMemNo: Int
    public let readYn, sendType, msgType, content, minsDate: String
    public var showClocks: Bool
    
    public mutating func showClock() {
        showClocks = true
    }
}
