plugins {
    kotlin("jvm") version "2.2.21"
    kotlin("plugin.serialization") version "2.2.21"
    application
}

application {
    mainClass.set("McpServerExampleKt")
}

group = "com.example"
version = "1.0.0"

repositories {
    mavenCentral()
}

dependencies {
    implementation("io.modelcontextprotocol:kotlin-sdk-server:0.10.0")
    implementation("org.slf4j:slf4j-simple:2.0.17")
    implementation("io.ktor:ktor-client-cio:3.2.3")
}

kotlin {
    jvmToolchain(17)
}
