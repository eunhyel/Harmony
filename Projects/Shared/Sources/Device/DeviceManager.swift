//
//  DeviceManager.swift
//  Shared
//
//  Created by inforex_imac on 2023/04/04.
//  Copyright © 2023 ModularArch. All rights reserved.
//


import UIKit
import AudioToolbox

public enum DeviceManager {
    
    public enum Inset {
        // 상단 인셋 :: 노치 영역
        public static var top    : CGFloat     = 0
        // 하단 인셋 :: 홈바 영역
        public static var bottom : CGFloat     = 0
    }
    
    public enum Size {
        public static var width: CGFloat = 0
        public static var height: CGFloat = 0
    }
    
    public enum Point {
        public static var centerX: CGFloat = 0
        public static var centerY: CGFloat = 0
    }
    // 스테이터스 바 크기
    public static var statusBarHeight : CGFloat = 0
    
    
    public enum Vibration {
            case error
            case success
            case warning
            case light
            case medium
            case heavy
        
            @available(iOS 13.0, *)
            case soft
            @available(iOS 13.0, *)
        
            case rigid
            case selection
            case oldSchool

            public func vibrate() {
                switch self {
                case .error:
                    UINotificationFeedbackGenerator().notificationOccurred(.error)
                case .success:
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                case .warning:
                    UINotificationFeedbackGenerator().notificationOccurred(.warning)
                case .light:
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                case .medium:
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                case .heavy:
                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                case .soft:
                    if #available(iOS 13.0, *) {
                        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                    }
                case .rigid:
                    if #available(iOS 13.0, *) {
                        UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                    }
                case .selection:
                    UISelectionFeedbackGenerator().selectionChanged()
                case .oldSchool:
                    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                }
            }
        }
    
    
    public static func setScreenSaver( turnOff : Bool) {
       
        // true 라면 스크린 화면을 끄지 않는다
        UIApplication.shared.isIdleTimerDisabled = turnOff
    }

}
