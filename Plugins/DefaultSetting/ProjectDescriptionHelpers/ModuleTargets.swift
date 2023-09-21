//
//  ModuleTargets.swift
//  DefaultSetting
//
//  Created by inforex_imac on 2023/03/29.
//

import Foundation
import ProjectDescription

public enum Harmony{
    public enum Targets {
        public static var _APP: [Target] {
            return Project._makeAppTargets(
                name: "Harmony",
                platform: .iOS,
                dependencies: [Dependency.Framework.shared, Dependency.Framework.feature]
            )
        }
    }
}

public enum Feature {
    public enum Targets {
        public static var _FEATURE : Target {
            return Project._makeFrameworkTargets(
                name: "Feature",
                moduleType: .feature,
                resources: [
                    .glob(pattern: .relativeToRoot(ModuleType.feature.MODULE_RESOURCE))
                ],
                dependencies: [Dependency.Framework.shared, Dependency.Framework.core]
            )
        }
    }
}

public enum Shared {
    public enum Targets {
        public static var _SHARED: Target {
            Project._makeFrameworkTargets(
                name: "Shared",
                moduleType: .shared,
                dependencies: Dependency.defaultFrameworks
            )
        }
    }
}

public enum Core {
    public enum Targets {
        public static var _CORE : Target {
            Project._makeFrameworkTargets(
                name: "Core",
                moduleType: .core,
                dependencies: [Dependency.Framework.shared],
                settings: .settings(base: ["SWIFT_OBJC_BRIDGING_HEADER":DefaultSettings._BRIDGING_HEADER_])
            )
        }
    }
}


