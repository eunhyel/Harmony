//
//  Toast.swift
//  Shared
//
//  Created by eunhye on 2023/05/26.
//  Copyright © 2023 Harmony. All rights reserved.
//

import Foundation
import UIKit
import Toast

public struct ToastModel {
    var message: String
    var duration: TimeInterval = ToastManager.shared.duration
    var position: ToastPosition = ToastManager.shared.position
    
    init(message: String, duration: TimeInterval, position: ToastPosition) {
        self.message = message
        self.duration = duration
        self.position = position
    }
}

public class Toast{
    //센터에 기본으로 세팅된 Toast
    public static func defaultToast(_ msg : String, controller : UIViewController?){
        controller?.view.makeToast(msg, duration: 2.0, point: CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2), title: nil, image: UIImage(named: "")) { didTap in}
    }
    
    //영상대화용
    public static  func video(_ message : String,
                    controller : UIViewController?,
                    duration : Double = 2.0,
                    fontColor: UIColor? = UIColor(rgbF: 17),
                    backColor: UIColor? = UIColor(rgbF: 255, a: 0.8),
                    position : ToastPosition = .center,
                    title : String? = nil,
                    image: UIImage? = nil,
                    completion: ((Bool)->Void)? = nil){

        var style = ToastStyle()
        style.titleAlignment = .center
        style.messageAlignment = .center
        style.horizontalPadding = 20
        style.messageColor = fontColor ?? .white
        style.backgroundColor = backColor ?? .black
        style.cornerRadius = 20

        controller?.view.hideAllToasts()
        controller?.view.clearToastQueue()

        controller?.view.makeToast(message,
                          duration: duration,
                                   point: CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/1.2),
                          title: title,
                          image: image,
                          style: style,
                          completion: completion)
    }
    
    
    //기본
    public static  func show(_ message : String,
                    controller : UIViewController?,
                    duration : Double = 2.0,
                    fontColor: UIColor? = .white,
                    backColor: UIColor? = .black,
                    position : ToastPosition = .center,
                    title : String? = nil,
                    image: UIImage? = nil,
                    completion: ((Bool)->Void)? = nil){

        var style = ToastStyle()
        style.titleAlignment = .center
        style.messageAlignment = .center
        style.horizontalPadding = 20
        style.messageColor = fontColor ?? .white
        style.backgroundColor = backColor ?? .black

        controller?.view.hideAllToasts()
        controller?.view.clearToastQueue()

        controller?.view.makeToast(message,
                          duration: duration,
                          position: position,
                          title: title,
                          image: image,
                          style: style,
                          completion: completion)
    }
}
