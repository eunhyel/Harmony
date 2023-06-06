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
    var openMessageView: (() async -> Void)?
    var openProfileView: (() -> Void)?
}

public protocol MessageListViewModelInput {
    func viewDidLoad()
}
public protocol MessageListViewModelOutput {
    
}

public protocol MessageListViewModel: MessageListViewModelInput, MessageListViewModelOutput {
    
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

extension DefaultMessageListViewModel {
    
    public func viewDidLoad() {
        
    }
    
}
