//
//  PushObservers.swift
//  NotificationService
//
//  Created by yeoboya on 2023/02/23.
//  Copyright © 2023 HoneyGlobal. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import SwiftyJSON

public class PushObservers: NSObject {
    enum PushStatus {
        case didReceive, willPresent
    }
    
    weak var appFlowCoordinator: AppFlowCoordinator?
    
    
    init(appFlowCoordinator: AppFlowCoordinator?) {
        super.init()
        self.appFlowCoordinator = appFlowCoordinator
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            guard granted else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
}

extension PushObservers: UNUserNotificationCenterDelegate {
    // 앱 푸쉬 선택하고 들어왔을 때 호출 됨
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        remotePushNotification(response.notification.request.content.userInfo, status: .didReceive)
        completionHandler()
    }
    
    // 앱이 active 상태일 때 willPresent호출 됨
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        remotePushNotification(notification.request.content.userInfo, status: .willPresent)
        completionHandler(.badge)
    }
}
