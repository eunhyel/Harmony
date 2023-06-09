//
//  Scripts.swift
//  ProjectDescriptionHelpers
//
//  Created by root0 on 2023/04/26.
//

import Foundation
import ProjectDescription

public extension TargetScript {
    static let fbCrashlyticsScripts = TargetScript.post(script: "\"Tuist/Dependencies/SwiftPackageManager/.build/checkouts/firebase-ios-sdk/Crashlytics/run\"", name: "Firebase Crashlytics", inputPaths: [.dsymPath, .infoplistPath])
}

public extension Path {
    
    static let dsymPath = relativeToRoot("${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Resources/DWARF/${TARGET_NAME}")
    static let infoplistPath = relativeToRoot("$(SRCROOT)/$(BUILT_PRODUCTS_DIR)/$(INFOPLIST_PATH)")
}
