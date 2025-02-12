function fn() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  // env --- required to have a value. This should hold the "main" environment that you are testing

  // if you are calling multiple systems, you may add custom environment variables such like ENV1 ENV2 ENV3
  var ENV1 = karate.properties['karate.ENV1'];
  ENV1 = ENV1; //this line is used to 'save' the value. deleting this line will cause an error
  karate.log ('karate.ENV1 system property was: ', ENV1 );

  var ENV2 = karate.properties['karate.ENV2'];
  ENV2 = ENV2;
  karate.log ('karate.ENV1 system property was: ', ENV2 );

  var ENV3 = karate.properties['karate.ENV3'];
  ENV3 = ENV3;
  karate.log ('karate.ENV1 system property was: ', ENV3 );


  // set default values for the environment(s)
  if (!env) {
    env = 'test';
  }

  if (!ENV1) {
    ENV1 = 'test';
  }

  if (!ENV2) {
    ENV2 = 'test';
  }

  if (!ENV3) {
    ENV3 = 'test';
  }

  // initialize the config, you can add more to it later
  //any value that is "GLOBAL" or commonly used by your feature files can be added here
  var config = {
    env: env,
    ENV1: ENV1,
    ENV2: ENV2,
    ENV3: ENV3,
    baseUrl: 'https://reqres.in/',
    base_demoUrl_ENV1: 'https://'+ENV1+'someEndpoint.mycompany.com',
    base_demoUrl_ENV2: 'https://'+ENV2+'someEndpoint.mycompany.com',
    base_demoUrl_ENV3: 'https://'+ENV3+'someEndpoint.mycompany.com',
    base_auth: 'Basic _______________',
    access_token: 'Dynamic Token that will have a value on run time',
    env_data: ''
  }

  if (ENV1 == 'dev') {
    config.bucketName = 'sample-bucket-dev';
  }
  else if (ENV1 == 'test') {
    config.bucketName = 'sample-bucket-test';
    // customize
    config.tokenUrl= 'https://'+ENV1+'.someTokenEndpoint.mycompany.com';
    config.clientIdValue = 'someValue';
    config.clientSecretValue= 'someValue';
    config.scopeValue = 'someValue';
  }
  else if (ENV1 == 'sit') {
      config.bucketName = 'sample-bucket-sit';
      // customize
  }

  //Generate a token (that can be reused by all feature files
  //NOTE: This is commented out as we don't have an actual auth endpoint for demo
  var tokenGen = karate.callSingle('classpath:features/authentication/TKN.feature@demoToken', config)
  config.access_token = tokenGen.generated_access_token
  config.auth = "Bearer " + config.access_token


  // load all environment data
  var env_data_path = "classpath:data/environment/"+env+".json"
  config.env_data = read(env_data_path)

  // if your value comes from parameters from your jenkins run (in this example the jenkins variable name is 'dynamicId']
  var dynamicIdFromJenkins = karate.properties['karate.dynamicId'];
  dynamicIdFromJenkins = dynamicIdFromJenkins; //this line is used to 'save' the value. deleting this line will cause an error
  karate.log ('dynamicIdFromJenkins system property was: ', dynamicIdFromJenkins )
  config.myDynamicId = dynamicIdFromJenkins


 // don't waste time waiting for a connection or if servers don't respond within 5 seconds
  karate.configure('connectTimeout', 5000);
  karate.configure('readTimeout', 5000);

  return config;
}