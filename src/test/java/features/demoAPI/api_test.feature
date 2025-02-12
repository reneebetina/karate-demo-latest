@demo
Feature: Sample Feature File Structure
  This is a sample feature with parameterization

  Values from karate-config.js "config" variable can be seen by this feature file as they are considered global values.

  Background:
    # feature level variables -- common to all scenarios
    * def f_body_create = '/src/test/java/requests/body/create.json'
    * def f_body_upload = '/src/test/java/requests/body/upload.json'
    * def f_filePath = '/src/test/java/data/files/input/mySampleFile.pdf'

  Scenario: [POST] CREATE USER --- using an actual working url
    # scenario level variables - cannot be shared to other scenarios
    * def s_expected_response_status = 201

    ### CALL THE ENDPOINT
    * def CreateAction = call read('classpath:features/base.feature@Create') {body_create:#(f_body_create), expected_responseStatus:#(s_expected_responseStatus)}

    ### sample validations
    * match CreateAction.responseStatus == s_expected_response_status

    * match CreateAction.responseHeaders.['Content-Type'][0] contains 'application/json'

    * match CreateAction.response contains { name: '#string'}
    * match CreateAction.response contains { job: '#notnull'}
    * match CreateAction.response contains { id: '#string'}
    * match CreateAction.response.createdAt != null
    * match CreateAction.response.createdAt contains '2025'


  Scenario: [GET] Get Single USER --- using an actual working url
    # scenario level variables - cannot be shared to other scenarios
    * def s_expected_response_status = 200

    ### CALL THE ENDPOINT
    * def GetAction = call read('classpath:features/base.feature@GetUser')

    ### sample validations
    * match GetAction.responseStatus == s_expected_response_status

    * match GetAction.responseHeaders.['Content-Type'][0] contains 'application/json'

    * match GetAction.response contains { data: '#object'}
    * match GetAction.response contains { support: '#object'}

    * match GetAction.response.data contains { id: '#number'}
    * match GetAction.response.support contains { url: '#string'}
    * match GetAction.response.support contains { text: '#string'}


  Scenario: [GET] Get ALL USERS --- using an actual working url
    # scenario level variables - cannot be shared to other scenarios
    * def s_expected_response_status = 200

    ### CALL THE ENDPOINT
    * def GetAction = call read('classpath:features/base.feature@GetAllUsers')

    ### sample validations
    * match GetAction.responseStatus == s_expected_response_status

    * match GetAction.responseHeaders.['Content-Type'][0] contains 'application/json'

    * match GetAction.response contains { someFieldTest: '#notpresent'}
    * match GetAction.response contains { page: '#number'}
    * match GetAction.response contains { per_page: '#number'}
    * match GetAction.response contains { total: '#number'}
    * match GetAction.response contains { total_pages: '#number'}

    * match GetAction.response contains { data: '#array'}
    * match GetAction.response contains { support: '#object'}

    * match GetAction.response.data[0] contains { id: '#number'}

    # should be an array of size 6
    * match GetAction.response.data == '#[6]'

    # should be an array of size of whatever value is in 'per_page' field
    * match GetAction.response.data[*] == '#[GetAction.response.per_page]'

    # should be an array size 6 with all ids as numbers
    * match GetAction.response.data[*].id == '#[6] #number'

    * match GetAction.response.support contains { url: '#string'}
    * match GetAction.response.support contains { text: '#string'}