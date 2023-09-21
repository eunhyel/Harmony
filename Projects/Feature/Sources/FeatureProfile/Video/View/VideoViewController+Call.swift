//
//  VideoViewController+Call.swift
//  Feature
//
//  Created by eunhye on 2023/09/11.
//  Copyright © 2023 Harmony. All rights reserved.
//

import Foundation
import CallKit

extension VideoViewController : CXCallObserverDelegate{
    func setCXCallObserver(){
        callObserver = CXCallObserver()
        guard let observer = callObserver else {
            return
        }
        observer.setDelegate(self,queue : DispatchQueue.main)
    }
    
    public func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
        if call.hasEnded == true {
            //"callObserver : Disconnected"
            //포그라운드
        }

        //전화걸려옴, 백그라운드
        if  call.isOutgoing == false && call.hasConnected == false && call.hasEnded == false{
            //"callObserver : Incoming"
            //phonecallReceived
            viewModel.sendCallPacket(cmd: .phonecallReceived, data: [:], callback: {(_) in })
        }
        
        if call.isOutgoing == true && call.hasConnected == false && call.hasEnded == false {
            //"callObserver : Dialing"
            //백그라운드
            viewModel.sendCallPacket(cmd: .phonecallReceived, data: [:], callback: {(_) in })
        }
    }
}
