@ignore
Feature: This feature is only created to generate an access_token to be used in testing the APIs
  # no runner as this will be called by karate-config.js
  # karate-config runs before executing all scenarios

  @setupCheck
  Scenario: TKN
    Given url tokenUrl
    * configure ssl = true
    And path 'v1/oauth/token'

    #define headers
    And header Content-Type = 'application/json'

    #define request body
    * def dir = java.lang.System.getProperty('user.dir')
    * print ">>> PROJECT DIRECTORY: ", dir
    * def path = '/src/test/java/requests/body/auth.json'

    #open file
    * def body = read('file:' + dir + path)

    # construct the body using the values from karate-config.js config variable
    # it will be detected as we passed 'config' in the parameters. See karate-config.js line 68
    * set body.client_id = clientIdValue
    * set body.client_secret = clientSecretValue
    * set body.scope = scopeValue
    * print body

    # set and finallize request
    And request body

    When method post
    And status 200
    * def generated_access_token = response.access_token
    * print generated_access_token

    # note that the variable 'generated_access_token' is being stored as a global value in karate-config.js line 68
    # with this approach, we can reuse the token repeatedly in different endpoint calls
