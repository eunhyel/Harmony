//
//  SocketCmd.swift
//  Feature
//
//  Created by eunhye on 2023/09/11.
//  Copyright © 2023 Harmony. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol VideoPacketDelegate: AnyObject {
    func didReceiveCallPacket(cmd: VideoServerPacketCommand.Receive, data: JSON)
}

struct VideoServerConnector: Codable {
    var isCaller   : String
    var chatMember : String
    var memNo      : String
    var lang       : String = "en"
    var apiDomain  : String
    var origin     : String = "LovTok.com"
}

public enum VideoServerPacketCommand {
    public enum Send: String {
        /// agora 연결 정보 요청
        case getConnectionInfo     = "getConnectionInfo"
        
        /// 전화 On,Off
        case phonecallReceived     = "phonecallReceived"
        case phonecallEnded        = "phonecallEnded"
    }
    
    public enum Receive: String {
        /// 토스트 수신
        case getToast                     = "getToast"

    }
}
