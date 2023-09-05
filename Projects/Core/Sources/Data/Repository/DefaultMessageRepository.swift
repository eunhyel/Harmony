//
//  DefaultMessageRepository.swift
//  Core
//
//  Created by root0 on 2023/09/05.
//  Copyright © 2023 Harmony. All rights reserved.
//

import Foundation


public class DefaultMessageRepository: MessagesRepository {
    
    public init() {}
    
    public func fetchMessageList() async throws -> [ChatMessage] {
        return []
    }
    
}
