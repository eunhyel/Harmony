//
//  VideoViewModel.swift
//  Feature
//
//  Created by eunhye on 2023/09/04.
//  Copyright © 2023 Harmony. All rights reserved.
//

import Foundation

/// ========================================================
/// 코디네이터 액션 : 코디네이터 로 전달할 이벤트
/// ========================================================
public struct VideoViewActions {
    
}

/// ========================================================
/// 인풋
/// ========================================================
public protocol VideoViewModelInput {
  
    // coordinator actions :: E
}

/// ========================================================
/// 아웃풋
/// ========================================================
public protocol VideoViewModelOutput {
    
}

/// ========================================================
/// 뷰모델
/// ========================================================
public protocol VideoViewModel: VideoViewModelInput, VideoViewModelOutput {
    
}


/// ========================================================
/// 뷰모델 구현부
/// ========================================================
public class DefaultVideoViewModel: VideoViewModel {
    
    var actions: VideoViewActions?
    
    public init(actions: VideoViewActions? = nil) {
        self.actions = actions
    }
    
}
