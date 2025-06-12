import org.jetbrains.changelog.Changelog
import org.jetbrains.changelog.markdownToHTML
import org.jetbrains.intellij.platform.gradle.TestFrameworkType

fun prop(key: String) = providers.gradleProperty(key)
fun env(key: String) = providers.environmentVariable(key)

plugins {
    id("java")
    kotlin("jvm") version "1.8.21"
    id("org.jetbrains.intellij.platform") version "2.5.0"
    id("org.jetbrains.changelog") version "2.2.1"
    id("org.jetbrains.qodana") version "2024.3.4"
    id("org.jetbrains.kotlinx.kover") version "0.9.1"
}

group = prop("pluginGroup").get()
version = prop("pluginVersion").get()

kotlin {
    jvmToolchain(17)
}

repositories {
    mavenCentral()
    intellijPlatform {
        defaultRepositories()
    }
}

dependencies {
    implementation(kotlin("stdlib"))
    testImplementation("org.junit.jupiter:junit-jupiter-api:5.9.2")
    testRuntimeOnly("org.junit.jupiter:junit-jupiter-engine:5.9.2")

    intellijPlatform {
        create(prop("platformType"), prop("platformVersion"), useInstaller = false)
        bundledPlugins(prop("platformPlugins").map { it.split(',').filter(String::isNotEmpty) })
        testFramework(TestFrameworkType.Platform)
    }
}

intellijPlatform {
    pluginConfiguration {
        name = prop("pluginName")
        version = prop("pluginVersion")

        description = providers.fileContents(layout.projectDirectory.file("README.md")).asText.map {
            val start = "<!-- Plugin description -->"
            val end = "<!-- Plugin description end -->"
            val lines = it.lines()
            if (!lines.contains(start) || !lines.contains(end)) {
                throw GradleException("Plugin description section not found in README.md:\n$start ... $end")
            }
            lines.subList(lines.indexOf(start) + 1, lines.indexOf(end)).joinToString("\n").let(::markdownToHTML)
        }

        val changelog = project.changelog
        changeNotes = prop("pluginVersion").map { pluginVersion ->
            with(changelog) {
                renderItem(
                    (getOrNull(pluginVersion) ?: getUnreleased())
                        .withHeader(false)
                        .withEmptySections(false),
                    Changelog.OutputType.HTML,
                )
            }
        }

        ideaVersion {
            sinceBuild = prop("pluginSinceBuild")
            untilBuild = prop("pluginUntilBuild")
        }
    }

    signing {
        certificateChain = env("CERTIFICATE_CHAIN")
        privateKey = env("PRIVATE_KEY")
        password = env("PRIVATE_KEY_PASSWORD")
    }

    publishing {
        token = env("PUBLISH_TOKEN")
        channels = prop("pluginVersion").map { listOf(it.substringAfter('-').substringBefore('.').ifEmpty { "default" }) }
    }

    pluginVerification {
        ides {
            recommended()
        }
    }
}

changelog {
    groups.empty()
    repositoryUrl = prop("pluginRepositoryUrl")
}

kover {
    reports {
        total {
            xml {
                onCheck = true
            }
        }
    }
}

tasks {
    wrapper {
        gradleVersion = prop("gradleVersion").get()
    }

    publishPlugin {
        dependsOn(patchChangelog)
    }
}

tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile> {
    kotlinOptions.jvmTarget = "17"
}

tasks.test {
    useJUnitPlatform()
}
