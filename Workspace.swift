import ProjectDescription
import ProjectDescriptionHelpers

let workspace = Workspace(
    name: "GlobalHarmony",
    projects: [
        .relativeToCurrentFile("Projects/App")
    ]
)
