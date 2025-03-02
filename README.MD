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
2. Install Apache Maven
   * Windows - download then update Environment Variables: PATH must point to the correct Maven bin folder
   * MacOS - `brew install maven`
3. Install IntelliJ IDE Community Edition
   * Plugins to Install: Gherkin, Cucumber for Java, Karate
4. Clone this repository
5. Open IntelliJ IDE and open this project

6. On IntelliJ Terminal/Console
    * Run command: `mvn clean`
    * Run command: `mvn install`

    * Then run command to execute demo tests:
      *  For default demo from Karate Labs: `mvn clean test -Dtest=ExamplesTest`
      *  For my demo using reqres.in endpoints: `mvn clean test -Dtest=TestRunner`
      *  Syntax tp run a specific tag: `mvn test -D test=TestRunner "-D karate.options=--tags @demo"`
      * Syntax for other command line variables: `mvn test -D test=TestRunner -D karate.ENV1=test01 -D karate.ENV2=someValue "-D karate.options=--tags @demo"`


  Expect:
   * ``BUILD SUCCESS``
   * a `target` directory to appear containing output of your run
       * Summary is seen under ```/target/karate-reports/karate-summary.html```


   
### If you wish to start a new Karate project from scratch
1. On IntelliJ -> File -> New -> Project
2. Select Maven Archetype and make sure you put JDK = Java 17
3. On Archetype -> click Add
4. Use the values below or check what is the latest archetype value on https://karatelabs.github.io/karate/
      * archetypeGroupId=io.karatelabs 
      * archetypeArtifactId=karate-archetype
      * archetypeVersion=1.5.1
5. Click Create - this should automatically create the default Karate files such as pom.xml, karate-config.js, logback-test.xml
and a few example tests.
7. After clicking create, it will also start an initial build which should give you a build success.
8. Create a test runner and define if you want to run in parallel
9. Create a test (feature file)


### POM dependencies added
commons-io : for common file operations
commons-codec : for encoders/decoders
cucumber-reporting : for cucumber reports to be generated
apache-poi : for reading MS formats (Word/Excel etc)
apache-poi-ooxml : to read latest formats such as .xlsx ; note that poi and poi-ooxml must be declared together
apache pdfbox and pdfbox tools : PDF operations
software.amazon.awssdk s3 : for S3 operations


### Available tags for demo
@basic --- default demo to check if repo is working
`mvn test -D test=ExamplesTest "-D karate.options=--tags @basic"`

All other tags use the "TestRunner"
`mvn test -D test=TestRunner "-D karate.options=--tags @demo"`
@demo --- renee demo test using API that is responding (reqres.in)
@outlineDemo --- demo scenario Outline
@xmlDemo --- demo for XML testing, expect 1 failure that is intended
@demo_with_wiremock   --- demo for wiremock, make sure that your wiremock is up first 