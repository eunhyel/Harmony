//
//  ProjectExtentions.swift
//  DefaultSetting
//
//  Created by inforex_imac on 2023/03/31.
//

import Foundation
import ProjectDescription



public extension Project {
    
    /// 프레임워크 타겟 리턴 Module/Source/** 을 대상으로 타겟을 만든다 리소스는 분리하지 않는다
    static func _makeFrameworkTargets(name: String, product: Product = .framework,
                                      moduleType: ModuleType,
                                      sources: ProjectDescription.SourceFilesList? = nil,
                                      resources: ProjectDescription.ResourceFileElements? = nil ,
                                      dependencies: [TargetDependency] = [] ,
                                      headers: ProjectDescription.Headers? = nil,
                                      settings: ProjectDescription.Settings? = nil) -> Target {
        
        let path = Path.relativeToRoot(moduleType.MODULE_SOURCE)
        
        let jsBridgeHeader = moduleType == .core ? Headers.headers(public: FileList.list([.glob("Sources/WebViewJavascriptBridge/**")])) : nil
        
        let target = Target(
            name: name,
            platform: .iOS,
            product: product,
            bundleId: "\(DefaultSettings._BUNDLE_ID_).\(name)",
            deploymentTarget: .iOS(targetVersion: DefaultSettings._OS_PLATFORM_VERSION_, devices: [.ipad, .iphone]),
            infoPlist: .default,
            sources: sources ?? [.glob(path, excluding: nil)],
            resources: resources ?? [.glob(pattern: path, excluding: [
                //                    .relativeToRoot(path.pathString.appending("/*.swift"))
            ])],
            headers: jsBridgeHeader,
            dependencies: dependencies,
            settings: settings
        )
        
        return target
    }
    
    static func _makeAppTargets(name: String, platform: Platform, dependencies: [TargetDependency]) -> [Target] {
        let platform: Platform = platform
        
        let mainTarget = Target(
            name: name,
            platform: DefaultSettings._PLATFORM_,
            product: .app,
            bundleId: "\(DefaultSettings._BUNDLE_ID_)",
            infoPlist: DefaultSettings._INFOLIST_,
            sources: [.glob(.relativeToRoot(DefaultSettings._APP_PATH_ + DefaultSettings._SOURCES_PATH_))],
            resources: [.glob(pattern: .relativeToRoot(DefaultSettings._APP_PATH_ + DefaultSettings._RESOURCES_PATH_))],
            entitlements: DefaultSettings._ENTITLEMENTS_,
            dependencies: dependencies,
            settings: .settings(base: DefaultSettings._DEFAULT_PROJECT_SETTING_, configurations: [], defaultSettings: .recommended)
        )
        
        return [mainTarget]
    }
}





public extension ProjectDescription.SourceFilesList {
    static func sources(path: [String]) -> ProjectDescription.SourceFilesList {
        let globs : [ProjectDescription.SourceFileGlob] = path.map{
            ProjectDescription.SourceFileGlob.glob(.relativeToRoot($0))
        }
        
        return ProjectDescription.SourceFilesList(globs: globs)
    }
}

public extension ProjectDescription.ResourceFileElements {
    
    static func resources(path: [String]) -> ProjectDescription.ResourceFileElements {
        let globs : [ProjectDescription.ResourceFileElement] = path.map{
            ProjectDescription.ResourceFileElement.glob(pattern: .relativeToRoot($0))
        }
        return ProjectDescription.ResourceFileElements(resources: globs)
        
    }
    
    
}
