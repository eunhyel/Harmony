//
//  Alert.swift
//  Shared
//
//  Created by eunhye on 2023/05/26.
//  Copyright © 2023 Harmony. All rights reserved.
//

import Foundation
import UIKit


public class SystemAlert{
    public static func ConfirmAlert(msg : String, controller : UIViewController?){
        
        // 메시지창 컨트롤러 인스턴스 생성
        let alert = UIAlertController(title: "알림", message: msg, preferredStyle: UIAlertController.Style.alert)
    
        // 메시지 창 컨트롤러에 들어갈 버튼 액션 객체 생성
        let defaultAction =  UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
        
        //메시지 창 컨트롤러에 버튼 액션을 추가
        alert.addAction(defaultAction)
        
        DispatchQueue.main.async {
            //메시지 창 컨트롤러를 표시
            controller?.present(alert, animated: false)
        }
    }
}
