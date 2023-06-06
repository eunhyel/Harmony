//
//  Auth.swift
//  HoneyGlobal
//
//  Created by inforex_imac on 2023/02/08.
//  Copyright © 2023 HoneyGlobal. All rights reserved.
//


import AVFoundation
import AppTrackingTransparency
import Photos
import CoreLocation
import UserNotifications
import UIKit

/**
 
 ```
 Task {
     let status = await App._AUTH_SERVICE.askAuthorization([.video, .audio])
     
     // 비어있다면 모든 권한이 들어있는것
     if status.isEmpty {
         self?.viewModel.didSendCallAccept(to: model.ptrMemNo)
     } else {
         let alertModel = PopupInfoModel_Authorization.video_audio.model
         
         App._CHANNEL_SERVICE._makeAlert(model: alertModel, on: .tabbarController)
         
         self?.viewModel.didSendCallDeny(to: model.ptrMemNo)
     }
 }
 ```
 */

public enum HarmonyAuthorization {
    
    case video
    case audio
    case microphone
    case photo
    case advertising
    case push
    
}

open class AuthorizationManager {
    
    static let shared = AuthorizationManager()
    
    public enum AuthorizationStatus {
        case justDenied
        case alreadyDenied
        case restricted
        case justAuthorized
        case alreadyAuthorized
        case unknown
    }
    
    public func askAuthorization(_ authorization: [HarmonyAuthorization]) async -> [HarmonyAuthorization] {

        var list: [HarmonyAuthorization] = []

        if authorization.contains(.video) {

            if let status = await askAuthorization(.video) {
                list.append(status)
            }
        }

        if authorization.contains(.audio) {

            if let status = await askAuthorization(.audio) {
                list.append(status)
            }
        }

        if authorization.contains(.microphone) {

            if let status = await askAuthorization(.microphone) {
                list.append(status)
            }
        }

        if authorization.contains(.photo) {

            if let status = await askAuthorization(.photo) {
                list.append(status)
            }
        }
        
        if authorization.contains(.push) {
            if let status = await askAuthorization(.push) {
                list.append(status)
            }
        }

        if authorization.contains(.advertising) {

            if let status = await askAuthorization(.advertising) {
                list.append(status)
            }
        }
        
        log.d(list)

        return list
    }

    public func askAuthorization(_ authorization: HarmonyAuthorization) async -> HarmonyAuthorization? {
        
        switch authorization {
        case .video:
            log.d("video")
            let status = await authorizeMediaType(mediaType: .video)
            
            if status != .authorized {
                return .video
            }
            
            return nil
            
        case .audio:
            log.d("audio")
            let status = await authorizeMediaType(mediaType: .audio)
            
            if status != .authorized {
                return .audio
            }
            
            return nil
            
        case .microphone:
            log.d("microphone")
            let status = await authorizeMicroPhone()
            
            if status != .granted {
                return .microphone
            }
            
            return nil
            
        case .photo:
            log.d("photo")
            let photoStatus = await authorizeAlbum()
            
            if photoStatus != .authorized {
                return .photo
            }
            
            return nil
            
        case .advertising:
            log.d("advertising")
            let advertisingStatus = await authorizeTracking()
            
            if advertisingStatus != .authorized {
                return .advertising
            }
            
            return nil
            
        case .push:
            log.d("push")
            let pushStatus = await authorizePush()
            
            if !pushStatus {
                return .push
            }
            
            return nil
        }
            
    }
    
    // 비디오 사용 권한을 물어본다 아직 선택하지 않은 경우 다시 물어본다
    public func authorizeVideo(completion: (( AVAuthorizationStatus) -> Void)?) {
        authorize(mediaType: AVMediaType.video, completion: completion)
    }
    
    // 오디오 사용 권한을 물어본다 아직 선택하지 않은 경우 다시 물어본다
    public func authorizeAudio(completion: (( AVAuthorizationStatus) -> Void)?) {
        authorize(mediaType: AVMediaType.audio, completion: completion)
    }
    
    public func authorizeMicroPhone() async -> AVAudioSession.RecordPermission {
        return await withCheckedContinuation{ continuation in
            
            let status = AVAudioSession.sharedInstance().recordPermission
            
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                
                if granted {
                    
                    let newStatus = AVAudioSession.sharedInstance().recordPermission
                    continuation.resume(returning: newStatus)
                    
                } else {
                    
                    continuation.resume(returning: status)
                }
            }
        }
    }
    
    public func authorizeTracking() async -> ATTrackingManager.AuthorizationStatus {
        
        let status = ATTrackingManager.trackingAuthorizationStatus
        
        switch status {
        case .notDetermined:
            
            let newStatus = await ATTrackingManager.requestTrackingAuthorization()
            
            return newStatus
            
        case .restricted:
            fallthrough
        case .denied:
            fallthrough
        case .authorized:
            fallthrough
        @unknown default:
            return status
        }
    }
    
    // 광고 수락
    public func authorizeTracking(completion: ((ATTrackingManager.AuthorizationStatus) -> Void)?){
        
        let status = ATTrackingManager.trackingAuthorizationStatus
        
        switch status {
        case .notDetermined:
            ATTrackingManager.requestTrackingAuthorization { result in
                completion?(result)
            }
        case .restricted:
            fallthrough
        case .denied:
            fallthrough
        case .authorized:
            fallthrough
        @unknown default:
            completion?(status)
        }
    }
    
    // 포토 라이브러리 권한 체크
    public func authorizeAlbum() async -> PHAuthorizationStatus {
        
        let status = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
        
        switch status {
        case .notDetermined:
            
            let status = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
            
            return status
            
        case .restricted:
            fallthrough
        case .denied:
            fallthrough
        case .authorized:
            fallthrough
        case .limited:
            fallthrough
        @unknown default:
            return status
        }
        
        
    }
    
    public func authorizePush() async -> Bool {
        do {
            let options: UNAuthorizationOptions = [.alert, .badge, .sound]
            let isSuccess = try await UNUserNotificationCenter.current().requestAuthorization(options: options)
            
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
            
            return isSuccess
        } catch {
            return false
        }
    }
    
    public func authorizeMediaType(mediaType: AVMediaType) async -> AVAuthorizationStatus{
        
        let cameraStatus = AVCaptureDevice.authorizationStatus(for: mediaType)
        
        switch cameraStatus {
        case .notDetermined:
            
            let granted = await AVCaptureDevice.requestAccess(for: mediaType)
            
            if granted {
                let newStatus = AVCaptureDevice.authorizationStatus(for: mediaType)
                
                return newStatus
            }
            
            return cameraStatus
        case .restricted:
            fallthrough
        case .denied:
            fallthrough
        case .authorized:
            fallthrough
        @unknown default:
            return cameraStatus
        }
        
    }
    
    public func authorizeLocation() async -> Bool {
        let locationManager = CLLocationManager()
        
        switch locationManager.authorizationStatus {
        case .authorized, .authorizedAlways, .authorizedWhenInUse:
            return true
        default: return false
        }
    }
    
    // 앱 설정으로 이동
    public func openURLToSetting(){
        DispatchQueue.main.async {
            UIApplication.shared.open(URL(string: "\(UIApplication.openSettingsURLString)")!)
        }
    }
    
    private func authorize(mediaType: AVMediaType, completion: ((AVAuthorizationStatus) -> Void)?) {
        let status = AVCaptureDevice.authorizationStatus(for: mediaType)
        
        switch status {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: mediaType, completionHandler: { (granted) in
                DispatchQueue.main.async {
                    let status = AVCaptureDevice.authorizationStatus(for: mediaType)
                    log.d(status)
                    completion?(status)
                }
            })
            
        case .authorized:
            fallthrough
        case .denied:
            fallthrough
        case .restricted:
            fallthrough
        @unknown default:
            completion?(status)
        }
    }
}
