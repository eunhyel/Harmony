//
//  AgoraIOManager.swift
//  Core
//
//  Created by eunhye on 2023/06/09.
//  Copyright © 2023 Harmony. All rights reserved.
//

import Foundation
import AgoraRtcKit
import Shared

protocol AgoraIOManagerDelegate: AnyObject {
    func didRemoteUserJoin()
}

struct AgoraIOConnector {
    var appID: String
    var channelName: String
    var token: String

    // default : AgoraVideoDimension640x360
    var resolution: CGSize
    
    // default : .fps24,
    var frameRate: AgoraVideoFrameRate
    
    // default : .adaptative
    var orientation: AgoraVideoOutputOrientationMode
    
    var isCaller: Bool = false
    
    var uid : String    //memno
}

open class AgoraIOManager: NSObject {
    var agoraKit: AgoraRtcEngineKit?
    
    let connector: AgoraIOConnector
    
    weak var delegate: AgoraIOManagerDelegate?
    
    weak var localView : UIView?
    
    weak var remoteView : UIView?
    
    var ptrUID: UInt?
    
    init(connector: AgoraIOConnector, localView: UIView?, remoteView: UIView?) {
        
        self.connector  = connector
        self.localView  = localView
        self.remoteView = remoteView
        
        super.init()
        
        let config                = AgoraRtcEngineConfig()
            config.appId          = connector.appID
            config.areaCode       = .global
            config.channelProfile = .liveBroadcasting
        
        agoraKit = AgoraRtcEngineKit.sharedEngine(with: config, delegate: self)
        
        agoraKit?.setAudioProfile(AgoraAudioProfile.musicHighQualityStereo)
        
        agoraKit?.setVideoEncoderConfiguration(   getEncoderConfig(connector: connector)   )
        
//         뷰티 옵션
        agoraKit?.setBeautyEffectOptions(true, options:   getBeautyOption()   )
        
        agoraKit?.setClientRole(.broadcaster)
        
        agoraKit?.enableVideo()
        
        agoraKit?.enableAudio()

        
        agoraKit?.setLowlightEnhanceOptions(false, options:   getLightEnhanceOptions()   )
        
        
        agoraKit?.adjustRecordingSignalVolume(400)
        
        log.i("[AGORAIO]   resolution: \(connector.resolution), frameRate:  \( connector.frameRate) orientation: \( connector.orientation) \(AgoraVideoBitrateStandard)")

        // set up local video to render your local camera preview
        let videoCanvas            = AgoraRtcVideoCanvas()
            videoCanvas.uid        = 0
            // the view to be binded
            videoCanvas.view       = self.localView
            videoCanvas.renderMode = .hidden
        
        self.agoraKit?.setupLocalVideo(videoCanvas)
        
        self.agoraKit?.startPreview()
        

        
        // Set audio route to speaker
        agoraKit?.setDefaultAudioRouteToSpeakerphone(true)
        
        
        guard let result = self.agoraKit?.joinChannel(
            byToken: connector.token,
            channelId: connector.channelName,
            userAccount: connector.uid,
            mediaOptions:   getMediaOptions()  ) else {
            return
        }
        
        
        if result != 0 {
            log.e("[AGORAIO]   join fail :: \(result))")
            
        }
        
        
        //PhotoViewController.open(controller: self)
    }
    
    // 뷰티 옵션은 디폴트로 준다 LCL: .low, LL: 0.4, SL:0.2, RL : 0.2, ShL: 1.0
    func getBeautyOption() -> AgoraBeautyOptions {
        let beauty                         = AgoraBeautyOptions()
            beauty.lighteningContrastLevel = .low
            beauty.lighteningLevel         = 40
            beauty.smoothnessLevel         = 20
            beauty.rednessLevel            = 20
            beauty.sharpnessLevel          = 100
        
        return beauty
    }
    
    
    //
    func getLightEnhanceOptions() -> AgoraLowlightEnhanceOptions {
        
        let lowLightOption       = AgoraLowlightEnhanceOptions()
            lowLightOption.mode  = .manual
            lowLightOption.level = .quality
        
        return lowLightOption
    }
    
    // 인코더 컨피그
    func getEncoderConfig(connector: AgoraIOConnector) -> AgoraVideoEncoderConfiguration {
        
        return AgoraVideoEncoderConfiguration(
            size: connector.resolution,
            frameRate: connector.frameRate,
            bitrate: AgoraVideoBitrateStandard,
            orientationMode: connector.orientation,
            mirrorMode: .enabled)
    }
    
    func getMediaOptions() -> AgoraRtcChannelMediaOptions {
        
        let option                        = AgoraRtcChannelMediaOptions()
            option.publishCameraTrack     = true
            option.publishMicrophoneTrack = true
            option.clientRoleType         = .broadcaster
        
        return option
    }
    
    func exit() {
        agoraKit?.disableAudio()
        agoraKit?.disableVideo()
        agoraKit?.stopPreview()
        
        self.agoraKit?.leaveChannel { status in
            log.i("[AGORAIO]   leave chanel \(status)")
        }
        
        AgoraRtcEngineKit.destroy()
    }
    
    func switchCamera(toBack: Bool) {
        let mirrorMode = toBack ? AgoraVideoMirrorMode.disabled : AgoraVideoMirrorMode.enabled
        DispatchQueue.main.async { [weak self] in
            
            guard let self else { return }
            
            self.agoraKit?.setLocalRenderMode(.hidden, mirror: mirrorMode)
            self.agoraKit?.switchCamera()
        }
    }
    
    func switchCameraOnOff(isOff: Bool) {
        agoraKit?.muteLocalVideoStream(isOff)
    }
    
    func switchMicOnOff(isOff: Bool) {
        agoraKit?.muteLocalAudioStream(isOff)
    }
    
    deinit {
        log.d(#function)
    }
    
}


extension AgoraIOManager: AgoraRtcEngineDelegate{
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurWarning warningCode: AgoraWarningCode) {
        log.i("[AGORAIO]   warning: \(warningCode.rawValue.description)")
    }
    
    public func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        log.e("[AGORAIO]   error: \(errorCode)")
    }
    
    public func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        log.i("[AGORAIO]   Join \(channel) with uid \(uid) elapsed \(elapsed)ms")
    }
    
    public func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        log.i("[AGORAIO]   remote user join: \(uid) \(elapsed)ms")
        
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        self.ptrUID = uid
        
        
        videoCanvas.view = remoteView
        videoCanvas.renderMode = .hidden
        self.agoraKit?.setupRemoteVideo(videoCanvas)
        self.delegate?.didRemoteUserJoin()
    }
    
    public func rtcEngine(_ engine: AgoraRtcEngineKit, didRejoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        log.d("[AGORAIO]  rejoin")
        
    }
    
    public func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        log.i("[AGORAIO]   remote user left: \(uid) reason \(reason)")
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        // the view to be binded
        videoCanvas.view = nil
        videoCanvas.renderMode = .hidden
        agoraKit?.setupRemoteVideo(videoCanvas)
    }
    
    public func rtcEngine(_ engine: AgoraRtcEngineKit, localAudioStateChanged state: AgoraAudioLocalState, error: AgoraAudioLocalError) {

    }
    
    public func rtcEngine(_ engine: AgoraRtcEngineKit, didAudioMuted muted: Bool, byUid uid: UInt) {

    }
    
}
