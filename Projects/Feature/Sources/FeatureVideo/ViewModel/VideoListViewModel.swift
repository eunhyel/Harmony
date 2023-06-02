//
//  VideoListViewModel.swift
//  Feature
//
//  Created by root0 on 2023/06/01.
//  Copyright © 2023 Harmony. All rights reserved.
//

import Foundation

import Shared

public struct VideoListActions {
    
}

public protocol VideoListViewModelInput {
    
}
public protocol VideoListViewModelOutput {
    
}

public protocol VideoListViewModel {
    
}

public class DefaultVideoListViewModel: VideoListViewModel {
    
    public init(actions: VideoListActions) {
        
    }
    
    deinit {
        log.d("deinit")
    }
}
