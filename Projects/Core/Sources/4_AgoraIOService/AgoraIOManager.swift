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

public enum TypeOfAgoraConnect {
    case video
    case voice
    case multiVideo
    case multiAudio
}

public struct AgoraIOConnector {
    var appID: String = "717261f1ad4a4a54acc91f23b5b4a449"
    var channel: String
    var token: String

    var uid: Int
    var ptrUID: Int
    
    var audioProfile: Int
    var audioScenario: Int

    // EncoderConfig
    var videoWidth: Int
    var videoHeight: Int
    var videoFrameRate: Int

    var resolution: CGSize {
        get {
            return CGSize(width: videoWidth, height: videoHeight)
        }
    }
    var frameRate: AgoraVideoFrameRate {
        get {
            return AgoraVideoFrameRate(rawValue: videoFrameRate) ?? .fps15
        }
    }

    // BeautyOptions
    var lighteningLevel: Float
    var smoothnessLevel: Float
    var rednessLevel: Float

    var type: TypeOfAgoraConnect?
    
    public init(appID: String, channel: String, token: String, uid: Int, ptrUID: Int, audioProfile: Int, audioScenario: Int, videoWidth: Int, videoHeight: Int, videoFrameRate: Int,lighteningLevel: Float, smoothnessLevel: Float, rednessLevel: Float, type: TypeOfAgoraConnect) {
        self.appID = appID
        self.channel = channel
        self.token = token
        self.uid = uid
        self.ptrUID = ptrUID
        self.audioProfile = audioProfile
        self.audioScenario = audioScenario
        self.videoWidth = videoWidth
        self.videoHeight = videoHeight
        self.videoFrameRate = videoFrameRate
        self.lighteningLevel = lighteningLevel
        self.smoothnessLevel = smoothnessLevel
        self.rednessLevel = rednessLevel
        self.type = type
    }
}

open class AgoraIOManager: NSObject {
    public var agoraKit: AgoraRtcEngineKit?
    
    let connector: AgoraIOConnector
    
    weak var localView : UIView?
    
    weak var remoteView : UIView?
    
    var ptrUID: UInt?
    
    public init(connector: AgoraIOConnector, localView: UIView?, remoteView: UIView?) {
        
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
        
        agoraKit?.enableFaceDetection(true)

        
        agoraKit?.setLowlightEnhanceOptions(false, options:   getLightEnhanceOptions()   )
        
        
        agoraKit?.adjustRecordingSignalVolume(400)

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
            channelId: connector.channel,
            uid: UInt(connector.uid),
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
        
        let setting = AgoraVideoEncoderConfiguration(
            width: connector.videoWidth,
            height: connector.videoHeight,
            frameRate: connector.frameRate,
            bitrate: AgoraVideoBitrateStandard,
            orientationMode: .fixedPortrait, mirrorMode: .disabled)
        
        return setting
    }
    
    func getMediaOptions() -> AgoraRtcChannelMediaOptions {
        
        let option                        = AgoraRtcChannelMediaOptions()
            option.publishCameraTrack     = true
            option.publishMicrophoneTrack = true
            option.clientRoleType         = .broadcaster
        
        return option
    }
    
    public func exit() {
        agoraKit?.disableAudio()
        agoraKit?.disableVideo()
        agoraKit?.stopPreview()
        
        self.agoraKit?.leaveChannel { status in
            log.i("[AGORAIO]   leave chanel \(status)")
        }
        
        AgoraRtcEngineKit.destroy()
    }
    
    public func switchCamera(toBack: Bool) {
        let mirrorMode = toBack ? AgoraVideoMirrorMode.disabled : AgoraVideoMirrorMode.enabled
        DispatchQueue.main.async { [weak self] in
            
            guard let self else { return }
            
            self.agoraKit?.setLocalRenderMode(.hidden, mirror: mirrorMode)
            self.agoraKit?.switchCamera()
        }
    }
    
    public func switchCameraOnOff(isOff: Bool) {
        agoraKit?.muteLocalVideoStream(isOff)
    }
    
    public func switchMicOnOff(isOff: Bool) {
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
        //self.delegate?.didRemoteUserJoin()
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
        //AgoraAudioLocalError : 0 - 로컬 오디오 정상, 1 - 오디오 오류 이유 없음, 2- 권한 없음, 3 - 다른 프로그램이 사용중 or 채널에 다시 참여하기, 4 - 오디오 캡쳐 실패, 5 - 오디오 인코딩 실패, 8 - 시스템 호출에 의해 중단 (전화 끊어야 오디오 캡쳐 됨)
    }
    
    public func rtcEngine(_ engine: AgoraRtcEngineKit, didAudioMuted muted: Bool, byUid uid: UInt) {

    }
    
    public func rtcEngine(_ engine: AgoraRtcEngineKit, facePositionDidChangeWidth width: Int32, previewHeight height: Int32, faces: [AgoraFacePositionInfo]?) {
        log.d("얼굴 인식 \(faces)")
    }
    
    
}
