Status: Draft
Date: Jan 2025
Author: @reneebetina

---
# Karate Demo
This is a high level demo of how to use Karate Automation for projects with multiple tenants (multi-tenancy).
You may use this as a base for your upcoming project.


### Installation and Running on your Local
1. Install Java 17 (or Open JDK 17)
2. Install Apache Maven
3. Install IntelliJ IDE Community Edition
4. Clone this repository
5. Open IntelliJ IDE and open this project

6. On IntelliJ Terminal/Console
    * Run command: `mvn clean`

    * Then run command: `mvn test -Dtest=ExamplesTest`

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
