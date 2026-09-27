plugins {
    kotlin("jvm") version "2.2.20"
}

repositories {
    mavenCentral()
}

// lint 用 CLI（既存 apps/kotlin には lint がないため、日本語識別子への反応を見る目的で追加）
val detekt by configurations.creating
val ktlint by configurations.creating

dependencies {
    testImplementation(kotlin("test"))
    detekt("io.gitlab.arturbosch.detekt:detekt-cli:1.23.8:all") { isTransitive = false }
    ktlint("com.pinterest.ktlint:ktlint-cli:1.8.0:all") { isTransitive = false }
}

tasks.test {
    useJUnitPlatform()
    testLogging {
        events("passed", "skipped", "failed")
    }
}

kotlin {
    jvmToolchain(21)
}

val detektCheck by tasks.registering(JavaExec::class) {
    group = "verification"
    description = "detekt（既定ルール + config/detekt.yml）を実行する"
    classpath = detekt
    mainClass.set("io.gitlab.arturbosch.detekt.cli.Main")
    args("--input", "src/main/kotlin,src/test/kotlin", "--config", "config/detekt.yml", "--build-upon-default-config")
}

val ktlintCheck by tasks.registering(JavaExec::class) {
    group = "verification"
    description = "ktlint（既定ルール + .editorconfig）を実行する"
    classpath = ktlint
    mainClass.set("com.pinterest.ktlint.Main")
    args("src/**/*.kt")
}
