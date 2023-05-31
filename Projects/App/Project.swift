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

//// Local plugin loaded

// Creates our project using a helper function defined in ProjectDescriptionHelpers\

//let target = Project._makeAppTargets(name: "App", platform: .iOS, dependencies: [Dependency.Framework.feature , Dependency.Framework.shared] )

let project = Project(name: "Harmony",
                       organizationName: DefaultSettings._PROJECT_NAME_,
                      targets: Harmony.Targets._APP)
