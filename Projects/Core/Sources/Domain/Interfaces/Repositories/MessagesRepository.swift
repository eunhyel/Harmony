//
//  MessagesRepository.swift
//  Core
//
//  Created by root0 on 2023/09/05.
//  Copyright © 2023 Harmony. All rights reserved.
//

import Foundation

public protocol MessagesRepository {
    
    func fetchMessageList() async throws -> [ChatMessage]
    func getMsgList_Mock() async throws -> Data
    
    func fetchMsgBoxList_Mock() async throws -> Data
}
