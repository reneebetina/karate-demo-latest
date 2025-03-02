@demo_with_wiremock
Feature: Sample Only
  Make sure that your wiremock is up
  Instructions and sample are in :          https://github.com/reneebetina/wiremock-demo

  Background:
    # feature level variables -- common to all scenarios
    * def f_body_login = '/src/test/java/requests/body/login.json'

  Scenario: [POST] User Login - SUCCESS
    # scenario level variables - cannot be shared to other scenarios
    * def s_expected_response_status = 200

    * def s_username = 'testUser'
    * def s_password = 'testPass'

    ### CALL THE ENDPOINT
    * def LoginAction = call read('classpath:features/base.feature@userLogin_localhost') {body_login:#(f_body_login), dyn_username:#(s_username), dyn_password:#(s_password), expected_responseStatus:#(s_expected_responseStatus)}

    ### sample validations
    * match LoginAction.responseStatus == s_expected_response_status

    * match LoginAction.responseHeaders.['Content-Type'][0] contains 'application/json'

    * match LoginAction.response contains { status: '#string'}
    * match LoginAction.response contains { user_id: '#notnull'}
    * match LoginAction.response.message == 'Login successful'
    * match LoginAction.response contains { token: '#string'}
    * match LoginAction.response.timestamp != null
    * match LoginAction.response.timestamp contains '2025'


  Scenario Outline: <TC ID>- <TC Name>
    # scenario level variables - cannot be shared to other scenarios
    * def s_expected_response_status = <e_statusCode>

    * def s_username = '<e_username>'
    * def s_password = '<e_password>'

    ### CALL THE ENDPOINT
    * def LoginAction = call read('classpath:features/base.feature@userLogin_localhost') {body_login:#(f_body_login), dyn_username:#(s_username), dyn_password:#(s_password), expected_responseStatus:#(s_expected_responseStatus)}

    ### sample validations
    * match LoginAction.responseStatus == s_expected_response_status

    * match LoginAction.responseHeaders.['Content-Type'][0] contains 'application/json'

    * match LoginAction.response contains { status: '#string'}
    * match LoginAction.response contains { message: '#string'}
    * match LoginAction.response.message == '<e_message>'

    Examples:
      | TC ID | TC Name                            | e_username | e_password    | e_statusCode | e_message                                              |
      | NTC1  | Wrong Username                     | wrongUser  | testPass      | 401          | Invalid username or password.                          |
      | NTC2  | Wrong Password                     | testUser   | WRONGPASSWORD | 401          | Invalid username or password.                          |
      | NTC3  | Missing Username                   |            | testPass      | 401          | Invalid username or password.                          |
      | NTC4  | Missing Password                   | testUser   |               | 401          | Invalid username or password.                          |
      | NTC5  | Missing Username, Missing Password |            |               | 401          | Invalid username or password.                          |
      | NTC6  | Expired User                       | testUser   | expired       | 401          | Your password has expired. Please reset your password. |