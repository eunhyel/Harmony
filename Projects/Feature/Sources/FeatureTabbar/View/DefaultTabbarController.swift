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
    case quickMeet = -1
    case videoChat = 0
    case message   = 1
    case myPage    = 2
    
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
            return UIImage(named: "icoHomeOff")
        case .message:
            return UIImage(named: "icoMsg")
        case .myPage:
            return UIImage(named: "icoMyOff")
        }
    }
    
    public var selectedImage: UIImage? {
        switch self {
        case .quickMeet:
            return UIImage(systemName: "paperplane.fill")
        case .videoChat:
            return UIImage(named: "icoHomeOn")
        case .message:
            return UIImage(named: "icoMsgOn")
        case .myPage:
            return UIImage(named: "icoMyOn")
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
    open var viewModel: TabbarViewModel!
    
    open weak var coordinatorDelegate: AppFlowCoordinatorDelegate?
    
//    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        super.init(nibName: nil, bundle: nil)
//        self.tabBar.isHidden = false
//    }
    
    let dBag = DisposeBag()
    
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
        self.tabBar.isUserInteractionEnabled = false
        self.tabBar.alpha = 0
        self.tabBar.layer.zPosition = -1
        self.tabBar.frame.size.height = 0
        
        layout.viewDidLoad(superView: view)
        layout.bind(to: viewModel)
        
        viewModel._selectedTabBarItem
            .withUnretained(self)
            .bind { (owner, tabBarIdx) in
                owner.selectedIndex = tabBarIdx
            }
            .disposed(by: dBag)
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
