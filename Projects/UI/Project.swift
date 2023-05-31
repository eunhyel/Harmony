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
                    name: "CommonUI",
                    organizationName: DefaultSettings._PROJECT_NAME_,
                    settings: .settings(base: ["SDKROOT": "iphoneos"]),
                    targets: [Shared.Targets._SHARED]
                )
