//
//  ModuleTypes.swift
//  DefaultSettingAA
//
//  Created by inforex_imac on 2023/03/29.
//

import Foundation

import ProjectDescription

public enum ModuleType {
    case feature
    case core
    case shared
    case common
    case app
    
    public var MODULE_SOURCE : String {
        switch self {
        case .feature:
            return DefaultSettings._FEATURE_PATH_ + DefaultSettings._SOURCES_PATH_
        case .core:
            return DefaultSettings._CORE_PATH_ + DefaultSettings._SOURCES_PATH_
        case .shared:
            return DefaultSettings._SHARED_PATH_ + DefaultSettings._SOURCES_PATH_
        case .common:
            return DefaultSettings._COMMON_PATH_ + DefaultSettings._SOURCES_PATH_
        case .app:
            return DefaultSettings._APP_PATH_ + DefaultSettings._SOURCES_PATH_
        }
    }
    
    public func make(modules: [String]) -> [String] {
        
        switch self {
        case .feature:
            return modules.map{DefaultSettings._FEATURE_PATH_ + "/Sources/\($0)/**"}
        case .core:
            return modules.map{DefaultSettings._CORE_PATH_ + "/Sources/\($0)/**"}
        case .shared:
            return modules.map{DefaultSettings._SHARED_PATH_ + "/Sources/\($0)/**"}
        case .common:
            return modules.map{DefaultSettings._COMMON_PATH_ + "/Sources/\($0)/**"}
        case .app:
            return modules.map{DefaultSettings._APP_PATH_ + "/Sources/\($0)/**"}
        }
        
    }
    
    public var MODULE_RESOURCE: String {
        switch self {
        case .feature:
            return DefaultSettings._FEATURE_PATH_ + DefaultSettings._RESOURCES_PATH_
        case .core:
            return DefaultSettings._CORE_PATH_ + DefaultSettings._RESOURCES_PATH_
        case .shared:
            return DefaultSettings._SHARED_PATH_ + DefaultSettings._RESOURCES_PATH_
        case .common:
            return DefaultSettings._COMMON_PATH_ + DefaultSettings._RESOURCES_PATH_
        case .app:
            return DefaultSettings._APP_PATH_ + DefaultSettings._RESOURCES_PATH_
        }
    }
    
}
