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

let project = Project(
                    name: "Shared",
                    organizationName: DefaultSettings._PROJECT_NAME_,
                    settings: .settings(base: ["SDKROOT": "iphoneos"]),
                    targets: [Shared.Targets._SHARED]
                )
