//
//  AppDIContainer.swift
//  GlobalYeoboya
//
//  Created by inforex_imac on 2022/12/14.
//  Copyright © 2022 GlobalYeoboya. All rights reserved.
//

import UIKit
import Feature



public class AppDIContainer {
    
    func makeTabbarController() -> DefaultTabbarController {
        return DefaultTabbarController.create(with: makeTabbarViewModel())
    }
    
    func makeTabbarViewModel() -> TabbarViewModel {
        return DefaultTabbarViewModel()
    }
}
