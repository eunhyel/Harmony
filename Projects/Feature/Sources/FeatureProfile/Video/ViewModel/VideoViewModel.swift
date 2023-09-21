//
//  VideoViewModel.swift
//  Feature
//
//  Created by eunhye on 2023/09/04.
//  Copyright © 2023 Harmony. All rights reserved.
//

import Foundation
import Core
import SwiftyJSON
import UIKit

/// ========================================================
/// 코디네이터 액션 : 코디네이터 로 전달할 이벤트
/// ========================================================
public struct VideoViewActions {
    
}

/// ========================================================
/// 인풋
/// ========================================================
public protocol VideoViewModelInput {
  
    // coordinator actions :: E
}

/// ========================================================
/// 아웃풋
/// ========================================================
public protocol VideoViewModelOutput {
    
    func sendCallPacket(cmd: VideoServerPacketCommand.Send, data: [ String: String ], callback: @escaping (JSON) -> ())
}

/// ========================================================
/// 뷰모델
/// ========================================================
public protocol VideoViewModel: VideoViewModelInput, VideoViewModelOutput {
    var dataSource: UITableViewDiffableDataSource<Int, ChatDataModel>! { get set }
    var socket: SoketIOService? { get set }
    var chatModel : [ChatDataModel] { get set }
}


/// ========================================================
/// 뷰모델 구현부
/// ========================================================
public class DefaultVideoViewModel: VideoViewModel {
    
    public var dataSource: UITableViewDiffableDataSource<Int, ChatDataModel>!
    public var chatModel: [ChatDataModel] = []
    
    public func sendCallPacket(cmd: VideoServerPacketCommand.Send, data: [String : String] = [:], callback: @escaping (SwiftyJSON.JSON) -> ()) {
        var command = ["cmd" : cmd.rawValue]

//        socket.emitWithAck(command, params: data){ [weak self] ack in
//            guard let self = self else{ return }
//            self.serializeResponse(ack){ _,data in
//                if data["success"] == "y"{
//
//                }
//            }
//        }
    }
    
    
    public var socket: SoketIOService?
    
    var actions: VideoViewActions?
    
    public init(actions: VideoViewActions? = nil) {
        self.actions = actions
    }
    
}
