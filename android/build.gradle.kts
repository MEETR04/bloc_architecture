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

    // Must be registered BEFORE evaluationDependsOn(":app").
    // afterEvaluate fires after the subproject's build script runs, so it correctly
    // overrides whatever compileSdk the plugin set (e.g. file_picker sets 35).
    // If placed in a separate subprojects{} block after evaluationDependsOn, Gradle
    // will have already evaluated the projects, causing an "already evaluated" error.
    afterEvaluate {
        extensions.findByType<com.android.build.gradle.BaseExtension>()?.compileSdkVersion(37)
    }

    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    description = "Deletes the build directory."
    group = "build"
    delete(rootProject.layout.buildDirectory)
}
