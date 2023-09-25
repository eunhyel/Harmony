//
//  MessageViewModel + Input.swift
//  Feature
//
//  Created by root0 on 2023/09/19.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON
import Then

import Core
import Shared


// MARK: Media Input
public extension DefaultMessageViewModel {
    
    func openPhoto(_ data: JSON) {
        Task {
            do {
                
                // member 상태 확인 후 성공이면
                
                // 권한 상태 체크
                if let photoAuth = await AuthorizationManager.shared.askAuthorization(.photo) {
                    // 실패 토스트 혹은 권한 알럿
                    return
                }
                
                
                await MainActor.run {
                    actions?.openPhotoAlbum?(data)
                }
                
            } catch {
                errorControl(error)
                log.e(error.localizedDescription)
            }
        }
    }
    
}
