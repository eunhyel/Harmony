//
//  DefaultTabbarController.swift
//  GlobalYeoboya
//
//  Created by inforex_imac on 2022/12/19.
//  Copyright © 2022 GlobalYeoboya. All rights reserved.
//

import UIKit
import RxSwift
import SwiftyJSON


open class DefaultTabbarController: UITabBarController {
    
    var viewModel: TabbarViewModel!
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
            
        self.tabBar.isHidden = true
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public override func loadView() {
        super.loadView()
    }
    
    
    public class func create(with viewModel: TabbarViewModel) -> DefaultTabbarController {
        let vc = DefaultTabbarController()
            vc.viewModel = viewModel
        
        return vc
    }
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        
        self.view.backgroundColor = .green
        self.tabBar.isHidden                 = true
        self.tabBar.isUserInteractionEnabled = false
        self.tabBar.alpha = 0
        self.tabBar.layer.zPosition = -1
        self.tabBar.frame.size.height = 0
        
    }
    
}

extension DefaultTabbarController: UITabBarControllerDelegate {
    
}
