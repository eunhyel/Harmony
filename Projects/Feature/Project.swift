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

// 메인 앱
let project = Project(
                    name: "Feature",
                    organizationName: DefaultSettings._PROJECT_NAME_,
                    settings: .settings(base: ["SDKROOT": "iphoneos"]),
                    targets: [ Feature.Targets._FEATURE ]
                )


//// 데모 앱 타겟 __DEMO_CHAT 에 의존
//let project = Project(
//                    name: "FeatureDemo",
//                    organizationName: DefaultSettings._PROJECT_NAME_,
//                    settings: .settings(base: ["SDKROOT": "iphoneos"]),
//                    targets: [ Feature.Targets.__DEMO_CHAT ]
//                )
