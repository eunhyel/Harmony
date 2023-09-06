//
//  MembersRepository.swift
//  Core
//
//  Created by root0 on 2023/09/05.
//  Copyright © 2023 Harmony. All rights reserved.
//

import Foundation
import SwiftyJSON

public protocol MembersRepository {
    
//    func getMsgUserInfo_Mock() async throws -> ChatPartner
    func getMsgUserInfo_Mock() async throws -> Data
    
}
