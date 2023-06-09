//
//  Dependency.swift
//  ProjectDescriptionHelpers
//
//  Created by inforex_imac on 2022/12/14.
//


import ProjectDescription


//
//
let dependencies = Dependencies(
    carthage: [],
    swiftPackageManager: .init(
        [
        .remote(url: "https://github.com/ReactiveX/RxSwift", requirement: .branch("main")),
        .remote(url: "https://github.com/RxSwiftCommunity/RxDataSources", requirement: .branch("main")),
        .remote(url: "https://github.com/Alamofire/Alamofire", requirement: .branch("master")),
        .remote(url: "https://github.com/Moya/Moya", requirement: .branch("master")),
        .remote(url: "https://github.com/kakao/kakao-ios-sdk", requirement: .branch("master")),
        .remote(url: "https://github.com/SnapKit/SnapKit", requirement: .upToNextMinor(from: "5.0.1")),
        .remote(url: "https://github.com/devxoul/Then", requirement: .upToNextMajor(from: "2.7.0")),
        .remote(url: "https://github.com/onevcat/Kingfisher", requirement: .upToNextMajor(from: "5.15.6")),
        .remote(url: "https://github.com/airbnb/lottie-ios.git", requirement: .upToNextMajor(from: "3.2.1")),
        .remote(url: "https://github.com/RxSwiftCommunity/RxGesture", requirement: .upToNextMajor(from: "4.0.4")),
        .remote(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", requirement: .upToNextMajor(from: "4.0.0")),
        
        .remote(url: "https://github.com/yonat/SweeterSwift", requirement: .upToNextMajor(from: "1.2.1")),
        
        .remote(url: "https://github.com/scalessec/Toast-Swift", requirement: .branch("master")),
        .remote(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", requirement: .upToNextMajor(from: "4.2.2")),

        .remote(url: "https://github.com/nextlevel/NextLevel", requirement: .exact("0.17.0")),
     
        .remote(url: "https://github.com/socketio/socket.io-client-swift", requirement: .upToNextMinor(from: "15.2.0")),
        .remote(url: "https://github.com/facebook/facebook-ios-sdk", requirement: .upToNextMajor(from: "15.1.0")),
        .remote(url: "https://github.com/firebase/firebase-ios-sdk.git", requirement: .upToNextMajor(from: "8.0.0")),
        .remote(url: "https://github.com/AgoraIO/AgoraRtcEngine_iOS", requirement: .upToNextMajor(from: "4.1.1")),
        
        //    //        .remote(url: "https://github.com/shogo4405/Logboard.git", requirement: .upToNextMajor(from: "2.3.0")),
        //        .remote(url: "https://github.com/SwiftyBeaver/SwiftyBeaver.git", requirement: .upToNextMajor(from: "1.9.0")),
        //        .remote(url: "https://github.com/ashleymills/Reachability.swift", requirement: .upToNextMajor(from: "4.1.0")),
        //        .remote(url: "https://github.com/krzyzanowskim/CryptoSwift.git", requirement: .upToNextMinor(from: "1.6.0")),
    ],
   productTypes: [
    "RxSwift" : .framework,
    "RxCocoa" : .framework,
    "RxDataSources" : .framework,
    "Alamofire" : .framework,
    "Moya" : .framework,
    "SnapKit" : .framework,
    "Then" : .framework,
    "Kingfisher" : .framework,
    "Lottie" : .framework,
    "RxGesture" : .framework,
    "SwiftyJSON" : .framework,
    "Toast" : .framework,
    "SwiftyBeaver" : .framework,
    "NextLevel" : .framework,
    "Reachability" : .framework,
    "SweeterSwift" : .framework,
    "SocketIO" : .framework,
    "FacebookLogin" : .framework,
    "FacebookCore" : .framework,
    "CryptoSwift" : .framework,
    "FirebaseMessaging" : .framework,
    "FirebaseCrashlytics" : .framework,
    "FirebaseAnalytics" : .framework,
    "FirebaseDynamicLinks" : .framework,
    "WebViewJavascriptBridge" : .framework,
   ]),
    platforms: [.iOS]
)

    
