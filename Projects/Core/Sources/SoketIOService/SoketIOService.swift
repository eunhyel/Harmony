//
//  SocketIOConnector.swift
//  Core
//
//  Created by inforex_imac on 2023/03/29.
//  Copyright © 2023 Quest. All rights reserved.
//

import Foundation
import Shared
import SocketIO
import SwiftyJSON


public class SoketIOService {
    
    
    var manager: SocketManager!
    var socket: SocketIOClient?
    
    var connectInfo : ConnectModel
    
    public required init( connect : ConnectModel) {
        connectInfo = connect
        start()
    }
    
    
    public func start() {
        self.manager = nil
        self.socket = nil
        self.connect()
    }
    
    public func connect() {
        // TODO: @ 소켓 커넥트 시 쿠키
        setManager()
        setHandler()
    }
    
    public func setManager() {
        if let url = URL(string: connectInfo.pathUrl) {
            self.manager = SocketManager(socketURL: url, config: [
                .reconnects(false),                                  // 끊기면 자동으로 재접속 시도한다.
                //.reconnectAttempts(-1),                             // 재접속 시도는 무한히 시도한다.
                //.reconnectWait(10),                                 // 재접속 시도간 인터벌은 10초로 한다.
                .forceNew(true),                                    // 항상 커넥션은 새로 한다. 재사용안한다.
                .forceWebsockets(true),                             // transport 는 websocket 을 이용한다.
                //                .cookies(cookies),                                  // 쿠키
                .log(false),                                        // 로깅
                .extraHeaders([:]),
                .connectParams([:]),
            ])
            
            print("[SOCKETIO]   connectParam \(connectInfo)")
            self.socket =  manager?.defaultSocket
        }
    }
    
    
    
    public func setHandler() {
        socket?.on(clientEvent: .connect) { [weak self] data, ack in
            print("connect")
            print(data)
            print(ack)
        }
        
        socket?.on(clientEvent: .disconnect, callback: { [weak self] data, ack in
            print("disconnect")
            
        })
        
        
        socket?.on(clientEvent: .error, callback: { [weak self] data, ack in
            print("error")
            
        })
        
        socket?.on(clientEvent: .reconnectAttempt, callback: { [weak self] data, ack in
            print("reconnect")
        })
        
        manager?.defaultSocket.connect()
    }
    
    // 비디오, 오디오 패킷은 델리게잇에서 받는다
    public func onCallMessage(data: [Any], ack: SocketAckEmitter) {
        guard let data = data.first else {
            return
        }
        
        var json = JSON(data)
        let cmd = json["cmd"].stringValue
        

        log.d(cmd)
    }
    
    public func disconnect() {
        self.socket?.disconnect()
        self.manager?.disconnect()
        self.socket = nil
        self.manager = nil
    }
    
    deinit {
        print("socket deinit ???????? \(self.connectInfo)")
    }
}
