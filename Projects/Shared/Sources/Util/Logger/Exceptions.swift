//
//  Exceptions.swift
//  GlobalYeoboya
//
//  Created by inforex_imac on 2022/12/16.
//  Copyright © 2022 GlobalYeoboya. All rights reserved.
//

import Foundation


enum Exception: Error {
    // 에러떨구고 메세지 주고 싶을때
    case message(String)
    
    // 에러떨구고 컨펌창 띄울 때
    case alert(String)
    
    public var errorDescription: String? {
        switch self {
        case .message(let string):
            return string
        case .alert(let string):
            return string
        }
    }
    
    enum Member {
        case empty
        case force(status: String)
        //case status(status: MemberStatus)
    }
    
    enum Network {
        case none
        case result(code: String, _ : String)
        case newMsg(code: String, errorCode: String, _ : String)
        case null
    }
    
    
    enum Init: LocalizedError {
        case failure
    }
    
    
    enum GuardBinding {
        case invalidData(name: Any?)
        case notMatchData(data: Any?)
        case failTypeCasting(name: Any?)
        case failDecode(name : Any?)
    }
    
    
    enum Actions: String {
        case startWin
    }
    
    
    enum Permission {
        case privateFile(url: URL)
    }
    
    enum File {
        case notExist(name: Any?)
        case overSize(name: Any?, size: Any?)
    }
}
extension Exception.Member: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .empty:
            return "can not file Member Data"
            
//        case .status(let status):
//            return "\(status.rawValue.toString())"
            
        case .force(let status):
            return "\(status)"
        }
        
    }
}
extension Exception.Network: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .none:
            return "connection is none"
        case .result(let code, _):
            return "return code is \(code)"
        case .newMsg(let code, let errorcode, _):
            return "return code is \(code) errorcode : \(errorcode)"
        case .null:
            return "return code is null"
        }
    }
}

extension Exception.GuardBinding: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidData(let name):
            return "\(name!) is nil"
        case .notMatchData(let data):
            return "\(self) -> \(data!)"
        case .failTypeCasting(let name):
            return "\(self) : name -> \(name!)"
        case .failDecode(let name):
            return "\(self) : name -> \(name!)"
        }
    }
}

extension Exception.Actions: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .startWin:
            return self.rawValue + "actions is nil"
        }
    }
}

extension Exception.Permission: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .privateFile(let url):
            return "\(url) operation not permitted -> Check startAccessingSecurityScopedResource()"
        }
    }
}

extension Exception.File: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .notExist(let data):
            return "\(self) : \(data!) is nil"
        case .overSize(let data, let size):
            return "\(self) : \(data!) is over \(size!)"
        }
    }
}
