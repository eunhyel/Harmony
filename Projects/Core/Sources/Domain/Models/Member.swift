//
//  Member.swift
//  Core
//
//  Created by root0 on 2023/06/07.
//  Copyright © 2023 Harmony. All rights reserved.
//

import Foundation

public enum Gender: String, Codable {
    case male = "m"
    case female = "f"
    case `none` = "n"
    
    static func toGender(string: String) -> Gender {
        if string.hasPrefix("m") || string.hasPrefix("M") {
            return .male
        }
        else if string.hasPrefix("f") || string.hasPrefix("F") {
            return .female
        }
        else {
            return .none
        }
    }
}

/// 회원 상태값
public enum MemberStatus: Int, Codable {
    /// 탈퇴(본인)
    case withdrawed = -1
    
    /// 탈퇴(상대)
    case withdraw   = -2
    
    /// 차단(본인 -> 상대)
    case block      = -3
    
    /// 차단(상대 -> 본인)
    case blocked    = -4
    
    /// 정지(본인)
    case paused     = -5
    
    /// 정지(상대)
    case pause      = -6
    
    /// 휴면(본인)
    case rested     = -7
    
    /// 휴면(상대)
    case rest       = -8
    
    /// 나이정책 X
    case ageViolate  = -9
    
    /// 에러
    case error      = 0
    
    /// 정상
    case success    = 1
}

public struct Member: Identifiable, Hashable, Codable {
    public typealias ID = UUID
    
    public var id: ID = ID()
    
    public var nickName: String?
    public var no: Int = 0
    
    
}
