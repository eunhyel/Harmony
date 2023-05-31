//
//  ProfileListViewModel.swift
//  GlobalYeoboya
//
//  Created by inforex_imac on 2022/12/19.
//  Copyright (c) 2022 All rights reserved.
//


import RxSwift
import RxCocoa
import UIKit
import SwiftyJSON

/// ========================================================
/// 코디네이터 액션 : 코디네이터 로 전달할 이벤트
/// ========================================================
public struct ProfileListActions {
    
}


/// ========================================================
/// 인풋
/// ========================================================
public protocol ProfileListViewModelInput {
  
    // coordinator actions :: E
}

/// ========================================================
/// 아웃풋
/// ========================================================
public protocol ProfileListViewModelOutput {
    
}

/// ========================================================
/// 뷰모델
/// ========================================================
public protocol ProfileListViewModel: ProfileListViewModelInput, ProfileListViewModelOutput {
    
}


/// ========================================================
/// 뷰모델 구현부
/// ========================================================
public class DefaultProfileListViewModel: ProfileListViewModel {
    public init(){
        print("")
    }
}

