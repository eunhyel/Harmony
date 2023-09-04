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
            return "Video Chat 1"
        case .videoChat:
            return "Video Chat 2"
        case .message:
            return "Message"
        case .myPage:
            return "My Page"
        }
    }
    
    public var image: UIImage? {
        switch self {
        case .quickMeet:
            return UIImage(systemName: "paperplane")
        case .videoChat:
            return UIImage(systemName: "video")
        case .message:
            return UIImage(systemName: "message")
        case .myPage:
            return UIImage(systemName: "person")
        }
    }
    
    public var selectedImage: UIImage? {
        switch self {
        case .quickMeet:
            return UIImage(systemName: "paperplane.fill")
        case .videoChat:
            return UIImage(systemName: "video.fill")
        case .message:
            return UIImage(systemName: "message.fill")
        case .myPage:
            return UIImage(systemName: "person.fill")
        }
    }
    
}
extension HarmonyTapMenu {
    public var nav: UIViewController { return UINavigationController() }
}

public protocol AppFlowCoordinatorDelegate: AnyObject {
    
    func selectMenu(menu selected: HarmonyTapMenu)
}

open class DefaultTabbarController: UITabBarController {
    
    var layout: DefaultTabbarLayout
    var viewModel: TabbarViewModel!
    
    open weak var coordinatorDelegate: AppFlowCoordinatorDelegate?
    
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
        self.tabBar.isHidden = true
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
        
        
        self.tabBar.isHidden                 = true
        
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
