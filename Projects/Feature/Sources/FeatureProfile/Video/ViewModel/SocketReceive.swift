//
//  SocketReceive.swift
//  Feature
//
//  Created by eunhye on 2023/09/11.
//  Copyright © 2023 Harmony. All rights reserved.
//

import Foundation
import Shared
import SwiftyJSON
import UIKit


//서버에서 받은 패킷 처리
extension DefaultVideoViewModel: VideoPacketDelegate  {
    func didReceiveCallPacket(cmd: VideoServerPacketCommand.Receive, data: SwiftyJSON.JSON) {
        
        switch cmd {
            
        case .getToast:
            Toast.show(data["msg"].stringValue, controller: UINavigationController.defaultNavigation().navigationController)
        }
    }
}
