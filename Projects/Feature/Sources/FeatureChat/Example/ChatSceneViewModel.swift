//
//  ChatSceneViewModel.swift
//  Feature
//
//  Created by inforex_imac on 2023/03/29.
//  Copyright (c) 2023 All rights reserved.
//

import Foundation
import Core

public protocol ChatSceneViewModelInput {
    
    func viewDidLoad()
}

public protocol ChatSceneViewModelOutput {
    
}

public protocol ChatSceneViewModel: ChatSceneViewModelInput, ChatSceneViewModelOutput { }

public class DefaultChatSceneViewModel: ChatSceneViewModel{
    
    
    var socketIO : SoketIOService

    public init(){
        socketIO = SoketIOService(connect: .init(url: "ws://123.121.11.22:3001", media: ""))

    }
    // MARK: - OUTPUT
    
    

}

// MARK: - INPUT. View event methods
extension DefaultChatSceneViewModel {
    public func viewDidLoad() {
    }
}
