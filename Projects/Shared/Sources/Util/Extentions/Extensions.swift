//
//  Extensions.swift
//  Shared
//
//  Created by John Park on 2023/04/01.
//  Copyright © 2023 Quest. All rights reserved.
//

import Foundation
import UIKit


extension UINavigationController: UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    public static func defaultNavigation() -> UINavigationController{
        let navigation = UINavigationController()
            navigation.hidesBottomBarWhenPushed = true
            navigation.setToolbarHidden(true, animated: false)
//            navigation.setNavigationBarHidden(true, animated: false)
            navigation.navigationBar.isHidden = true
            navigation.interactivePopGestureRecognizer?.delegate = nil
        return navigation
    }
    
    public func removeViewController(_ controller: UIViewController.Type) {
        if let viewController = viewControllers.first(where: { $0.isKind(of: controller.self) }) {
            viewController.removeFromParent()
        }
    }
    
    // MARK :  Navigation Stack에 쌓인 뷰가 1개를 초과해야 제스처가 동작 하도록
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}


extension UIDevice {
    // 디바이스 모델 조회
   public static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return identifier
    }()
}
