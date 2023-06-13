import ProjectDescription
import ProjectDescriptionHelpers
import DefaultSetting

/*
                +-------------+
                |             |
                |     App     | Contains Quest App target and Quest unit-test target
                |             |
         +------+-------------+-------+
         |         depends on         |
         |                            |
 +----v-----+                   +-----v-----+
 |          |                   |           |
 |   Kit    |                   |     UI    |   Two independent frameworks to share code and start modularising your app
 |          |                   |           |
 +----------+                   +-----------+

 */

// MARK: - Project

// Local plugin loaded
//let localHelper = LocalHelper(name: "MyPlugin")

// Creates our project using a helper function defined in ProjectDescriptionHelpers

//let chatModule = Project._makeModuleTargets(name: "Core", moduleType: .feature, dependencies: [])
//let source = Project._makeFrameworkTargets(name: "Core", moduleType: .core, dependencies:  [Dependency.Framework.shared])
let project = Project(
                    name: "Core",
                    organizationName: DefaultSettings._PROJECT_NAME_,
                    packages: [.googleSignIn, .VonageClientSDKVideo],
                    settings: .settings(base: ["SDKROOT": "iphoneos"]),
                    targets: [Core.Targets._CORE]
                )
