import ProjectDescription

let config = Config(
    plugins: [
        .local(path: .relativeToManifest("../../Plugins/DefaultSetting")),
        .local(path: .relativeToManifest("../../Plugins/ModularArch")),
    ]
)

