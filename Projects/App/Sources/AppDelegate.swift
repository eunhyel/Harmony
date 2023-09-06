import UIKit
import UserNotifications
import Feature
import Shared
import Core

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    var appCoordinator: AppFlowCoordinator!
    var pushObserver: PushObservers?
    
    func application( _ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        UIFont.overrideInitialize()
        self.window         = UIWindow(frame: UIScreen.main.bounds)
        
        self.setDeviceSize()
        
        let di              = AppDIContainer()
        let viewController  = di.makeTabbarController()
        self.window?.rootViewController = viewController
        self.appCoordinator = .init(tabbarController: viewController, appDIContainer: di)
        self.window?.makeKeyAndVisible()
        
        //push setting
        pushObserver = PushObservers(appFlowCoordinator: appCoordinator)
        
        let devFlag: Bool = true
        !devFlag ? appCoordinator.moveToLogin() : appCoordinator.start()
        
        Cookie.setAcceptPolicy()
        Cookie.bake(key: "setAutoLogin")
        setDeviceID()
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenAsString = deviceToken.map{String(format:"%02.2hhx", $0)}.joined() // 토큰 파싱하고
        log.d(tokenAsString)
        UserDefaultsManager.deviceToken = tokenAsString
    }
    
    private func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        log.d(error)
        
    }
    
    func setDeviceID() {
        log.d(UIDevice.current.identifierForVendor?.uuidString)
        if App.keychainService[string: "deviceID"] == nil, let uuid = UIDevice.current.identifierForVendor?.uuidString {
            App.keychainService[string: "deviceID"] = uuid
            UserDefaultsManager.deviceID = uuid
        }
    }

    
    func setDeviceSize(){
        DeviceManager.statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.size.height ?? 0
        DeviceManager.Inset.top       = window?.windowScene?.windows.first?.safeAreaInsets.top ?? 0
        DeviceManager.Inset.bottom    = window?.windowScene?.windows.first?.safeAreaInsets.bottom ?? 0
        DeviceManager.Size.width = window?.frame.width ?? 0
        DeviceManager.Size.height = window?.frame.height ?? 0
        DeviceManager.Point.centerX = DeviceManager.Size.width / 2
        DeviceManager.Point.centerY = DeviceManager.Size.height / 2
    }
}
