Status: Draft
Date: Jan 2025
Author: @reneebetina

---
# Karate Demo
This is a high level demo of how to use Karate Automation for projects with multiple tenants (multi-tenancy).
You may use this as a base for your upcoming project.

In this repo, I have used Karate v1.5.1 (Released Jan 7, 2025) https://github.com/karatelabs/karate/releases/tag/v1.5.1

### Installation and Running on your Local
1. Install Java 17 (or Open JDK 17)
   * Windows - Environment Variables: PATH and JAVA_HOME must point to Java 17 bin folder
   * MacOS - go to ~/.zshenv   -> export JAVA_HOME=$(/usr/libexec/java_home -v 17)
2. It can be an Apache Maven or Gradle project
  A) Install Apache Maven
   * Windows - download then update Environment Variables: PATH must point to the correct Maven bin folder
   * MacOS - `brew install maven`

   B) Install Gradle
   * Windows - download then update Environment Variables: PATH must point to the correct Gradle bin folder
   * MacOS - `brew install gradle`
3. Install IntelliJ IDE Community Edition
   * Plugins to Install: Gherkin, Cucumber for Java, Karate
3. Clone this repository
4. Open IntelliJ IDE and open this project
5. Run the tests on IntelliJ Terminal/Console
    * Using Gradle:
        * Run command: `./gradlew clean`
        * For default demo from Karate Labs: `./gradlew clean test --tests ExamplesTest`
        * For my demo using reqres.in endpoints and my own runner: `./gradlew clean test --tests TestRunner`
        * Syntax to run a specific tag: `./gradlew clean test --tests TestRunner '-Dkarate.options=--tags @demo'`
        * Syntax for other command line variables: `./gradlew clean test --tests TestRunner '-Dkarate.ENV1=test01' '-Dkarate.ENV2=someValue' '-Dkarate.options=--tags @demo'`
   
    * Using Maven:
      * Run command: `mvn clean`
      * Then run command to execute demo tests:
        *  For default demo from Karate Labs: `mvn clean test -Dtest=ExamplesTest`
        *  For my demo using reqres.in endpoints: `mvn clean test -Dtest=TestRunner`
        *  Syntax tp run a specific tag: `mvn test -D test=TestRunner "-D karate.options=--tags @demo"`
        * Syntax for other command line variables: `mvn test -D test=TestRunner -D karate.ENV1=test01 -D karate.ENV2=someValue "-D karate.options=--tags @demo"`


  Expect:
   * ``BUILD SUCCESS``
   * Output folder
       * For Gradle: see `build/reports` directory
       Summary is seen under ```build/karate-reports/karate-summary.html```
       
       * For Maven: `target` directory 
       Summary is seen under ```target/karate-reports/karate-summary.html```
     
   * Cucumber Report will be generated 
       * regardless if you use Gradle/Maven, we configured the TestRunner.java to always put the cucumber report under ```target/cucumber-html-reports```
   
### If you wish to start a new Karate project from scratch
1. On IntelliJ -> File -> New -> Project
2. You can either build using:
   * GRADLE: Select JavaFx -> Gradle and use Java 17
     * Gradle projects will have auto generated: gradle folder for the gradle-wrapper.jar, gradlew file, gradlew.bat file, settings.gradle file, build.gradle file
     * Add the karate test dependencies in build.gradle file
   * MAVEN: (recommended) Select Maven Archetype and make sure you put JDK = Java 17
 
3. For Maven Archetype -> click Add
4. Use the values below or check what is the latest archetype value on https://karatelabs.github.io/karate/
      * archetypeGroupId=io.karatelabs 
      * archetypeArtifactId=karate-archetype
      * archetypeVersion=1.5.1
5. Click Create - this should automatically create the default Karate files such as pom.xml(if Maven project) /build.gradle (if Gradle project), karate-config.js, logback-test.xml
and a few example tests.
7. After clicking create, it will also start an initial build which should give you a build success.
8. Create a test runner and define if you want to run in parallel
9. Create a test (feature file)


### Dependencies added
commons-io : for common file operations
commons-codec : for encoders/decoders
cucumber-reporting : for cucumber reports to be generated
apache-poi : for reading MS formats (Word/Excel etc)
apache-poi-ooxml : to read latest formats such as .xlsx ; note that poi and poi-ooxml must be declared together
apache pdfbox and pdfbox tools : PDF operations
software.amazon.awssdk s3 : for S3 operations


### Available tags for demo
@basic --- default demo to check if repo is working
Gradle: `./gradlew clean test --tests ExamplesTest '-Dkarate.options=--tags @basic'` 
Maven: `mvn clean test -D test=ExamplesTest "-D karate.options=--tags @basic"`

All other tags use the "TestRunner"
Gradle: `./gradlew clean test --tests TestRunner '-Dkarate.options=--tags @demo'`
Maven: `mvn clean test -D test=TestRunner "-D karate.options=--tags @demo"`

@demo --- renee demo test using API that is responding (reqres.in)
@outlineDemo --- demo scenario Outline
@xmlDemo --- demo for XML testing, expect 1 failure that is intended
@demo_with_wiremock   --- demo for wiremock, make sure that your wiremock is up first 