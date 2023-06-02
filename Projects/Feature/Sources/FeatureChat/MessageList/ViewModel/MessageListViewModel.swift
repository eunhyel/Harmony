//
//  MessageListViewModel.swift
//  Feature
//
//  Created by root0 on 2023/06/01.
//  Copyright © 2023 Harmony. All rights reserved.
//

import Foundation
import Shared

public struct MessageListActions {
    
}

public protocol MessageListViewModelInput {
    
}
public protocol MessageListViewModelOutput {
    
}

public protocol MessageListViewModel {
    
}

public class DefaultMessageListViewModel: MessageListViewModel {
    
    var actions: MessageListActions?
    
    public init(actions: MessageListActions? = nil) {
        self.actions = actions
    }
    
    deinit {
        log.d("deinit")
    }
}
