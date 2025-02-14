Feature: Sample Feature File Structure
  This is a sample feature with parameterization. This just shows the structure for different API scenarios
  Values from karate-config.js "config" variable can be seen by this feature file as they are considered global values.

  Demo Goals:
  - different types of variables (global/feature/scenario level)
  - use of base.feature
  - different assertions
  - sample if conditions
  - using Scenario outline and passing it to parameterized fields

  Background:
    # feature level variables -- common to all scenarios
    * def f_body_upload = '/src/test/java/requests/body/upload.json'
    * def f_filePath = 'src/test/java/data/files/input/mySampleFile.pdf'

  @ignore
  Scenario: Call UPLOAD --- No available URL - just for discussion
    # scenario level variables - cannot be shared to other scenarios
    * def s_expected_response_status = 200

    ### CALL THE ENDPOINT
    * def UploadAction = call read('classpath:features/base.feature@Upload') {body_upload:#(f_body_upload), filePath:#(f_filePath), expected_responseStatus:#(s_expected_responseStatus)}

    ### sample validations
    * match UploadAction.responseStatus == s_expected_response_status

    * match UploadAction.responseHeaders.['Content-Type'][0] contains 'application/json'

    * match UploadAction.response contains { documentID: '#string'}
    * match UploadAction.response contains { documentID: '#notnull'}
    * match UploadAction.response contains { category: '#string'}
    * match UploadAction.response.category != null
    * match UploadAction.response contains { country: '#string'}

    ### sample for exact matching
    * match UploadAction.response.category == 'someValue'

    ### sample validation if getting a value from Scenario Outline Examples
    * match UploadAction.response.category == '<someValueThatComesFromScenarioOutlineExamples>'

    ### sample validation but will only run if condition is true
        ### for numeric fields or xml responses --- use karate.toString (_______);
    * def extractedValue = UploadAction.response.category
    * def valueIsABC = extractedValue.endsWith('ABC')
    * def valueIsXYZ = extractedValue.endsWith('XYZ')
    * if (valueIsABC) { karate.match(actual_value_fieldA,'some Expected value') }
    * if (valueIsXYZ) { karate.match(actual_value_fieldA,'XYZ 111111') }

    ### sample if statement with multiple conditions
    * def extractedValue_country = UploadAction.response.country
    * def extractedValue_country = extractedValue_country.toUpperCase();
    * def expected_overseasFlag = UploadAction.response.overseasFlag
    * if (extractedValue_country != 'AUSTRALIA' || extractedValue_country != 'AUS' || extractedValue_country != 'AU'){ karate.match(expected_overseasFlag,'Y')}

  @outlineDemo
  Scenario Outline: Call an Endpoint multiple times <ScenarioNo> - <ValidationType>
  # scenario level variables - cannot be shared to other scenarios
    * def s_value = '<ValidationType>'
    * print s_value

    # HTTP Check - default expected value is HTTP 200
    * def s_expected_statusCode = 200
    * if ('<ValidationType>' == 'Missing Optional') s_expected_statusCode = 200
    * if ('<ValidationType>' == 'Missing Mandatory') s_expected_statusCode = 400
    * if ('<ValidationType>' == 'Authorization Violation') s_expected_statusCode = 401

    * print s_expected_statusCode

     ### CALL THE ENDPOINT ---- intentionally disabled as we don't have a working URL--- for demo discussion only
    * def UploadAction = call read('classpath:features/base.feature@Upload') {body_upload:#(f_body_upload),filePath:#(f_filePath), fName:'<FirstName>',mName:'<MiddleName>',lName:'<LastName>', expected_responseStatus:#(s_expected_responseStatus)}

    ### ADD VALIDATIONS HERE
      # nothing added intentionally

    Examples:
    @set1
    |ScenarioNo |ValidationType         |FirstName|MiddleName|LastName|
    |TC1        |Positive               |Sam      |G         |Paul    |
    |TC2        |Missing Mandatory      |Sam      |G         |        |
    |TC3        |Missing Optional       |Sam      |          |Paul    |
    |TC4        |Authorization Violation|VIO      |LA        |TION    |
    |TC5        |Positive               |Bee      |W         |Paul    |
    |TC6        |Missing Mandatory      |Bee      |W         |        |
    |TC7        |Missing Optional       |Bee      |          |Paul    |
    |TC8        |Authorization Violation|VIO      |LA        |TION    |

