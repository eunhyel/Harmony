//
//  Dependency.swift
//  DefaultSetting
//
//  Created by inforex_imac on 2023/03/29.
//

import Foundation

import ProjectDescription




public enum DefaultSettings {
    // .relativeToRoot : 프로젝트 폴더 경로
    public static let _BUILD_ : SettingValue                         = "0"
    public static let _VERSION_ : SettingValue                       = "1.0.001"
    public static let _PLATFORM_ : Platform                          = .iOS
    public static let _OS_PLATFORM_VERSION_ : String                 = "14.0"
    public static let _TEAM_ : String                                = "GP9D94CZ57"
    public static let _BUNDLE_ID_ : String                           = "com.yeoboya.Harmony"

    public static let _PROJECT_NAME_ : String                        = "Harmony"
    public static let _PROJECT_PATH_: String                         = "Projects"

    public static let _RESOURCES_PATH_: String                       = "/Resources/**"
    public static let _SOURCES_PATH_: String                         = "/Sources/**"

    public static let _APP_PATH_: String                             = _PROJECT_PATH_ + "/App"
    public static let _FEATURE_PATH_: String                         = _PROJECT_PATH_ + "/Feature"
    public static let _CORE_PATH_: String                            = _PROJECT_PATH_ + "/Core"
    public static let _SHARED_PATH_: String                          = _PROJECT_PATH_ + "/Shared"
    public static let _COMMON_PATH_: String                          = _PROJECT_PATH_ + "/Common"

    public static let _TEST_PATH_: String                            = _APP_PATH_ + "/Tests"
    public static var _APP_EXTENSION_PATH_                           = _APP_PATH_ + "/NotificationService"

    public static let _ENTITLEMENTS_ : Path                        = .relativeToRoot(_APP_PATH_ + "/Supporting File/Entitlements/App.entitlements")

    public static let _INFOLIST_ : ProjectDescription.InfoPlist      =  .file(path: .relativeToRoot(_APP_PATH_ + "/Supporting File/InfoPlists/Harmony-Info.plist"))
//    public static var _PROJECT_HEADER_ : ProjectDescription.FileList = .list([.glob(.relativeToRoot(_APP_PATH_ + "/Supporting File/BridgingHeaders/Harmony-Bridging-Header.h"), excluding: nil)])
//    public static var _BRIDGING_HEADER_ : SettingValue               = .string("../Supporting File/BridgingHeaders/Harmony-Bridging-Header.h")




    // Setting
    public static var _DEFAULT_PROJECT_SETTING_ = SettingsDictionary().automaticCodeSigning(devTeam: DefaultSettings._TEAM_)
        .merging([
            "TARGETED_DEVICE_FAMILY" : "1,2",
            "IPHONEOS_DEPLOYMENT_TARGET" : .string(_OS_PLATFORM_VERSION_),
            "MARKETING_VERSION" : DefaultSettings._VERSION_,
            "CURRENT_PROJECT_VERSION" : DefaultSettings._BUILD_,
//            "SWIFT_OBJC_BRIDGING_HEADER" : DefaultSettings._BRIDGING_HEADER_,
            "SDKROOT" : "iphoneos",
            "OTHER_LDFLAGS" : "-ObjC",
            "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym"
        ])


    
    // NotificationService Setting
    public static var _DEFAULT_EXTENSION_SETTING_ : SettingsDictionary = SettingsDictionary().automaticCodeSigning(devTeam: DefaultSettings._TEAM_)
        .merging([
//            "SKIP_INSTALL":"YES",
            "MARKETING_VERSION" : DefaultSettings._VERSION_,
            "CURRENT_PROJECT_VERSION" : DefaultSettings._BUILD_,
            "TARGETED_DEVICE_FAMILY" : "1,2",
            "IPHONEOS_DEPLOYMENT_TARGET" : .string(_OS_PLATFORM_VERSION_)
        ])

    public static func makeDebugSetting() -> SettingsDictionary{
        return _DEFAULT_PROJECT_SETTING_.merging(["SWIFT_COMPILATION_MODE":"singlefile",
                                              "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG",
                                              "OTHER_SWIFT_FLAGS" : "$(inherited) -D DEBUG",
                                             ])
    }
}
