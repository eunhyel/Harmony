//
//  Dependency.swift
//  DefaultSettingAA
//
//  Created by inforex_imac on 2023/03/29.
//

import Foundation

import ProjectDescription




public enum Dependency{ // 메인 앱 프레임 워크
    public enum Framework {
        public static let feature = TargetDependency.project(target: "Feature", path: .relativeToRoot(DefaultSettings._FEATURE_PATH_))
        public static let core    = TargetDependency.project(target: "Core", path: .relativeToRoot(DefaultSettings._CORE_PATH_))
        public static let shared  = TargetDependency.project(target: "Shared", path: .relativeToRoot(DefaultSettings._SHARED_PATH_))
        public static let common  = TargetDependency.project(target: "Common", path: .relativeToRoot(DefaultSettings._COMMON_PATH_))
    }

    public enum Spm {
        public static let Rxswift: TargetDependency              = .external(name: "RxSwift")
        public static let Rxcocoa: TargetDependency              = .external(name: "RxCocoa")
        public static let Rxdatasources: TargetDependency        = .external(name: "RxDataSources")
        public static let Alamofire: TargetDependency            = .external(name: "Alamofire")
        public static let Moya: TargetDependency                 = .external(name: "Moya")
        public static let Snapkit: TargetDependency              = .external(name: "SnapKit")
        public static let Then: TargetDependency                 = .external(name: "Then")
        public static let Kingfisher: TargetDependency           = .external(name: "Kingfisher")
        public static let Lottie: TargetDependency               = .external(name: "Lottie")
        public static let Rxgesture: TargetDependency            = .external(name: "RxGesture")
        public static let Swiftyjson: TargetDependency           = .external(name: "SwiftyJSON")
        public static let Toast: TargetDependency                = .external(name: "Toast")
        public static let Beaverlog: TargetDependency            = .external(name: "SwiftyBeaver")
        public static let Nextlevel: TargetDependency            = .external(name: "NextLevel")
        public static let Reachability: TargetDependency         = .external(name: "Reachability")
        public static let Sweeterswift: TargetDependency         = .external(name: "SweeterSwift") // 슬라이더 사용하기 위해 다운로드
        public static let SocketIO: TargetDependency             = .external(name: "SocketIO") // socket io
        public static let Cryptoswift: TargetDependency          = .external(name: "CryptoSwift")
        
        public static let RtcBasic: TargetDependency             = .external(name: "RtcBasic")
        public static let AINS: TargetDependency                 = .external(name: "AINS")
        public static let AudioBeauty: TargetDependency          = .external(name: "AudioBeauty")
        public static let ClearVision: TargetDependency          = .external(name: "ClearVision")
        public static let ContentInspect: TargetDependency       = .external(name: "ContentInspect")
        public static let SpatialAudio: TargetDependency         = .external(name: "SpatialAudio")
        public static let VirtualBackground: TargetDependency    = .external(name: "VirtualBackground")
        public static let AIAEC: TargetDependency                = .external(name: "AIAEC")
        public static let DRM: TargetDependency                  = .external(name: "DRM")
        public static let FaceDetection: TargetDependency        = .external(name: "FaceDetection")
        public static let VQA: TargetDependency                  = .external(name: "VQA")
        public static let ReplayKit: TargetDependency            = .external(name: "ReplayKit")
        
        public static let Facebooklogin: TargetDependency        = .external(name: "FacebookLogin")
        public static let Facebookcore: TargetDependency         = .external(name: "FacebookCore")
        public static let Firebasemessaging: TargetDependency    = .external(name: "FirebaseMessaging")
        public static let Firebasecrashlytics: TargetDependency  = .external(name: "FirebaseCrashlytics")
        public static let Firebaseanalytics: TargetDependency    = .external(name: "FirebaseAnalytics")
        public static let Firebasedynamiclinks: TargetDependency = .external(name: "FirebaseDynamicLinks")
        
        public static let KeychainAccess: TargetDependency       = .external(name: "KeychainAccess")
//
        public static let KakaoCommon: TargetDependency          = .external(name: "KakaoSDKCommon")
        public static let KakaoAuth: TargetDependency            = .external(name: "KakaoSDKAuth")
        public static let KakaoUser: TargetDependency            = .external(name: "KakaoSDKUser")
        public static let KakaoTalk: TargetDependency            = .external(name: "KakaoSDKTalk")
        public static let KakaoShare: TargetDependency           = .external(name: "KakaoSDKShare")
        public static let KakaoTemplate: TargetDependency        = .external(name: "KakaoSDKTemplate")
        
        public static let GoogleSignIn: TargetDependency         = .package(product: "GoogleSignIn")
    }
    
    public enum AppExtension {
        public static let Notificationservice      : TargetDependency = .target(name: "Projects/App/NotificationService")
    }
    
    public enum Local {
        public static let WebViewJavascriptBridge: TargetDependency   = .framework(path: .relativeToRoot("Projects/Core/Frameworks/WebViewJavascriptBridge.framework"))
    }
    
    public static let defaultFrameworks: [TargetDependency] = [
        
//        Dependency.AppExtension.Notificationservice,
        Dependency.Spm.Rxswift,
        Dependency.Spm.Rxcocoa,
        Dependency.Spm.Rxgesture,
        Dependency.Spm.Alamofire,
        Dependency.Spm.Moya,
        Dependency.Spm.Snapkit,
        Dependency.Spm.Then,
        Dependency.Spm.Swiftyjson,
        Dependency.Spm.Sweeterswift,
        Dependency.Spm.SocketIO,
        Dependency.Spm.Toast,
        Dependency.Spm.Rxdatasources,
        
        Dependency.Spm.Lottie,
        Dependency.Spm.Nextlevel,
        Dependency.Spm.KeychainAccess,
        
        Dependency.Spm.RtcBasic,
        Dependency.Spm.Facebooklogin,
        Dependency.Spm.Facebookcore,
        Dependency.Spm.Firebasemessaging,
        Dependency.Spm.Firebaseanalytics,
        Dependency.Spm.Firebasecrashlytics,
        Dependency.Spm.Firebasedynamiclinks,
        
        Dependency.Spm.GoogleSignIn,
        
        Dependency.Spm.KakaoAuth,
        Dependency.Spm.KakaoTalk,
        Dependency.Spm.KakaoUser,
        Dependency.Spm.KakaoShare,
        Dependency.Spm.KakaoCommon,
        Dependency.Spm.KakaoTemplate,
        
//        Dependency.Spm.Beaverlog,
//        Dependency.Spm.Reachability,

//        Dependency.Spm.Kingfisher,
//        Dependency.Spm.Starscream,
        
//        Dependency.Spm.Cryptoswift,
//        Dependency.Spm.AINS,
//        Dependency.Spm.AudioBeauty,
//        Dependency.Spm.ClearVision,
//        Dependency.Spm.ContentInspect,
//        Dependency.Spm.SpatialAudio,
//        Dependency.Spm.VirtualBackground,
//        Dependency.Spm.AIAEC,
//        Dependency.Spm.DRM,
//        Dependency.Spm.FaceDetection,
//        Dependency.Spm.VQA,
//        Dependency.Spm.ReplayKit,
//        Dependency.Local.WebViewJavascriptBridge,
        ]
}

public extension Package {
    static let googleSignIn = Package.remote(url: "https://github.com/google/GoogleSignIn-iOS", requirement: .upToNextMajor(from: "7.0.0"))
}
