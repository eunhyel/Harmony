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


public enum HarmonyTapMenu: Int {
    case quickMeet = 0
    case videoChat = 1
    case message   = 2
    case myPage    = 3
    
    public var title: String {
        switch self {
        case .quickMeet:
            return "빠른만남"
        case .videoChat:
            return "영상통화"
        case .message:
            return "메세지챗"
        case .myPage:
            return "내페이지"
        }
    }
    
    public var image: UIImage {
        switch self {
        case .quickMeet:
            return FeatureAsset.rectangle135.image
        case .videoChat:
            return FeatureAsset.rectangle135.image
        case .message:
            return FeatureAsset.rectangle135.image
        case .myPage:
            return FeatureAsset.rectangle135.image
        }
    }
    
    public var selectedImage: UIImage {
        switch self {
        case .quickMeet:
            return FeatureAsset.boosterBasic.image
        case .videoChat:
            return FeatureAsset.boosterBasic.image
        case .message:
            return FeatureAsset.boosterBasic.image
        case .myPage:
            return FeatureAsset.boosterBasic.image
        }
    }
    
}


open class DefaultTabbarController: UITabBarController {
    
    var layout: DefaultTabbarLayout
    var viewModel: TabbarViewModel!
    
//    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        super.init(nibName: nil, bundle: nil)
//        self.tabBar.isHidden = false
//    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: TabbarViewModel) {
        self.viewModel = viewModel
        self.layout = DefaultTabbarLayout()
        super.init(nibName: nil, bundle: nil)
        self.tabBar.backgroundColor = .white
        self.tabBar.unselectedItemTintColor = .black
        self.tabBar.tintColor = .systemPink
        self.tabBar.isHidden = false
    }
    
    public override func loadView() {
        super.loadView()
    }
    
    
    public class func create(with viewModel: TabbarViewModel) -> DefaultTabbarController {
        let vc = DefaultTabbarController(viewModel: viewModel)
        return vc
    }
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        
        self.view.backgroundColor = .green
        self.tabBar.isHidden                 = false
        
        self.tabBar.backgroundColor = .white
        self.tabBar.unselectedItemTintColor = .black
        self.tabBar.tintColor = .systemPink
//        self.tabBar.isUserInteractionEnabled = false
//        self.tabBar.alpha = 0
//        self.tabBar.layer.zPosition = -1
//        self.tabBar.frame.size.height = 0
        
    }
    
}

extension DefaultTabbarController: UITabBarControllerDelegate {
    
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let selected = HarmonyTapMenu(rawValue: tabBarController.selectedIndex)
        
        print("\(#file) Should Select ViewController: \(tabBarController.selectedIndex) \(selected?.title ?? "none")")
        return true
    }
    
    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let selected = HarmonyTapMenu(rawValue: tabBarController.selectedIndex)
        print("\(#file) Did Select ViewController: \(tabBarController.selectedIndex) \(selected?.title ?? "none")")
    }
}
