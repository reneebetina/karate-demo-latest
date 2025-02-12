@ignore
Feature:
  This is the base feature and serves as a reusable template for your tests

  This feature has an @ignore tag so that it will not be included by the test runner
  Tags will only run if called by your actual tests.

  Variables in 'Background' section can be overridden by feature files who will call the base.feature

  Background: Get and set feature variables. Background runs every start of a scenario or before the tag
  * configure continueOnStepFailure = true
    * configure ssl = true

    # ENVIRONMENT VARIABLES  -- already set on karate-config.js

    # BASE LEVEL VARIABLES --- can be seen by feature files who call this base.feature

    # AUTHORIZATION -- already set on karate-config.js

    # PRE-REQUEST --- set this first
    * def correlationID = java.util.UUID.randomUUID();
    * print correlationID

    # SET HEADERS
    * def dir = java.lang.System.getProperty('user.dir')
    * def path_requestHeaderFile = '/src/test/java/requests/headers/requestHeaders.json'
    * def myHeader = read('file:'+ dir + path_requestHeaderFile);

    * configure charset = null
    * print myHeader


    # DEFINE BASE URL which is common to all operations
    And url baseUrl
    * print baseUrl

    # Add Polling Feature (best practice) --- try every 20 seconds, 10 times
    * configure retry = {count: 11, interval: 20000}


    @Create
    Scenario: [POST] upload something
      Given path 'api/users'
      And headers myHeader

      * def body = read('file:'+ dir + body_create);

      And request body
      * print body

      When method post
      * print response

  @GetUser
  Scenario: [GET] Get user info - responds instantly
    Given path 'api/users/2'
    And headers myHeader

    When method get
    * print response

  @GetAllUsers
  Scenario: [GET] Get all users -- this endpoints responds after 3 seconds (designed for delayed response/ polling demo)
    Given path '/api/users?delay=3'
    And headers myHeader

    #### def expected_responseStatus = required to be set on feature level as s_expected_responseStatus
    #And retry until responseStatus == expected_responseStatus

    # since this demo endpoint is just a mock and won't really give us a response when we do polling, we will do the wait approach for demo only
   * java.lang.Thread.sleep(2000);

    When method get
    * print response


  @Upload
    Scenario: [POST] upload something
      #this is a demo on how to use the utilities you created
      Given path '_____/____'
      And headers myHeader

      * def body = read('file:'+ dir + body_upload);

      * def my_utils = Java.type('common.utils')
      * def convertedFile = my_utils.fileToBase64(filePath);
      ## insert it to the json file
      * set body.document.file.data = convertedFile

      * def extractedFileName = my_utils.getFileName(filePath);
      ## Below is an example of setting/inserting a JSON value, only if condition is met
      #* if (_____ == 'something') karate.set('body', '$.document.metadata.fileName', extractedFileName)

      And request body
      * print body

      ## Intentionally turning off as we don't have a url that will respond
      # When method post
      # * print response


    @UploadMultipart
    Scenario: [POST] multipart approach
      Given path '_____/____'
      * set myHeader.Content-Type = 'multipart/form-data'
      * set myHeader.Accept = '*/*'
      * set myHeader.Accept-Encoding = 'gzip, deflate, br'
      And headers myHeader


      # def filePath = 'set on feature level'
      * def file_holder = 'file' + dir + body_upload
      And multipart file metadata = {read:#(metadata_holder)}

      When method post
      * print responseStatus
      * print response


  @Download
  Scenario: [GET] Download identifier and id
    #* def identifier = 'set on feature level'
    #* def idValue = 'set on feature level'
    * def pathVariable = '________/' + identifier + '/' + idValue

    Given path pathVariable
    And headers myHeader

    # def expected_responseStatus = required to be set on feature level as s_expected_responseStatus
    And retry until responseStatus == expected_responseStatus
    # you can disable retry if data is available to be fetched instantly.

    When method get
    * print response

  @Search
  Scenario: [POST] Search with a request body
    * def pathVariable = '________/search'

    Given path pathVariable
    And headers myHeader

    * def body = read('file:'+ dir + body_search);
    # you may also override the request on feature level

    And request body
    * print body

    When method post
    * print response


  @UploadDirect
  Scenario: [POST] calling an endpoint with certificates
    * configure ssl = { keyStore: 'classpath:certificates/sample.p12', keyStorePassword: '______', keyStoreType: 'pkcs12' }

    Given url base_demoUrl_ENV2
    And path '___/___/___'

    * set myHeader.Authorization = 'Basic ________'
    * set myHeader.Accept = '*/*'
    And headers myHeader

    * def body = read('file:'+ dir + body_upload);
    # you may also override the request on feature level

    And request body
    * print body

    When method post
    * print response