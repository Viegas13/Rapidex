/*
 * This file was generated by the Gradle 'init' task.
 *
 * This project uses @Incubating APIs which are subject to change.
 */

plugins {
    `java-library`
    `maven-publish`
}

repositories {
    mavenLocal()
    maven {
        url = uri("https://repo.maven.apache.org/maven2/")
    }
}

dependencies {
    api(libs.org.eclipse.persistence.org.eclipse.persistence.core)
    api(libs.org.eclipse.persistence.org.eclipse.persistence.asm)
    api(libs.org.eclipse.persistence.org.eclipse.persistence.antlr)
    api(libs.org.eclipse.persistence.org.eclipse.persistence.jpa)
    api(libs.org.eclipse.persistence.org.eclipse.persistence.jpa.jpql)
    api(libs.org.eclipse.persistence.org.eclipse.persistence.moxy)
    api(libs.jakarta.persistence.jakarta.persistence.api)
    api(libs.org.postgresql.postgresql)
    compileOnly(libs.org.eclipse.persistence.org.eclipse.persistence.jpa.modelgen.processor)
}

group = "com.mycompany"
version = "1.0-SNAPSHOT"
description = "Rapidex"
java.sourceCompatibility = JavaVersion.VERSION_1_8

publishing {
    publications.create<MavenPublication>("maven") {
        from(components["java"])
    }
}

tasks.withType<JavaCompile>() {
    options.encoding = "UTF-8"
}

tasks.withType<Javadoc>() {
    options.encoding = "UTF-8"
}
