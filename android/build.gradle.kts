allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// Force all plugin subprojects to compile against SDK 37.
// Required because flutter_plugin_android_lifecycle ≥ 0.10 mandates compileSdk ≥ 36,
// but several plugins (file_picker, flutter_image_compress, etc.) still pin compileSdk 34.
subprojects {
    afterEvaluate {
        extensions
            .findByType<com.android.build.gradle.BaseExtension>()
            ?.compileSdkVersion(37)
    }
}

tasks.register<Delete>("clean") {
    description = "Deletes the build directory."
    group = "build"
    delete(rootProject.layout.buildDirectory)
}
