@ignore
Feature:
  To connect to S3 - make sure your pom has the s3 dependency
  This feature will not run as we don't have an actual S3 bucket for demo
  This only provides what is needed to be set to be able to check files from S3

  Background:
    * configure continueOnStepFailure = true

  @setup=s3_connect
  Scenario:
      # how to do an import in karate feature file
    * def AwsSdk = Java.type('software.amazon.awssdk.services.s3.s3Client')
    * def ListObjectsV2Request = Java.type('software.amazon.awssdk.services.s3.model.ListObjectsV2Request')
    * def GetObjectRequest = Java.type('software.amazon.awssdk.services.s3.model.GetObjectRequest')
    * def Paths = Java.type('java.nio.file.Paths')
    * def Region = Java.type('software.amazon.awssdk.regions.Region')
    * def FileUtils = Java.type('org.apache.commons.io.FileUtils')
    * def File = Java.type('java.io.File')
    * def file_utils = Java.type('common.utils')

      ### if you can use your own AWS IAM access, use the lines below:
    * def StaticCredentialsProvider = Java.type('software.amazon.awssdk.auth.credentials.StaticCredentialsProvider')
    * def AwsBasicCredentials =  Java.type('software.amazon.awssdk.auth.credentials.AwsBasicCredentials')

    * def accessKeyId = 'ask your devops'
    * def secretAccessKey = 'ask your devops'

    * def awsCreds = AwsBasicCredentials.create(accessKeyId,secretAccessKey)
    * def s3Client = AwsSdk.builder().region(Region.AP_SOUTHEAST_2).credentialsProvider().build()
      ### End of setup ---

      ### if you are using a 'shared access'
      # configure the credentials on jenkins or any pipeline and use the line below:
      # * def s3Client = AwsSdk.builder().region(Region.AP_SOUTHEAST_2).build()
      ### End of setup ---

    * print s3Client

      # if you want to learn more - read AWS SDK documentation online


      # from karate-config.js --- we have set the bucketname to use
    * print bucketName

    * def folderName = '________/______/'

      # for most companies, they use dates as folder name
      # this is a sample on how to navigate on S3 based on folder with a date
    * def LocalDate = Java.type('java.time.LocalDate');
    * def DateTimeFormatter = Java.type('java.time.format.DateTimeFormatter');
    * def yesterday = LocalDate.now().minusDays(1);
    * def formatter = DateTimeFormatter.ofPattern("yyyyMM");
    * def yesterday_formatted = yesterday.format(formatter);
    * def FolderNameWithDate = folderName + yesterday_formatted


      # how to check contents of that S3 path
    * def listObjectsV2Request = ListObjectsV2Request.builder().bucket(bucketName).prefix(FolderNameWithDate).build()
    * def listObjectsV2Response = s3Client.listObjectsV2(listObjectsV2Request)
    * def contents = listObjectsV2Response.contents()
    * print contents
      # note that only max 1000 entries will be captured

    * def contents_count = karate.sizeOf(contents)

      # to get last / most recent item
    * def latest_file = contents[contents_count-1]

      # determine the file you want to open, get its details
      # get full s3 path and full file name
    * def get_s3ObjectKey = latest_file.match(/__someRegexForFolderName____/)
    * def s3ObjectKey = get_s3ObjectKey[0]
    * def get_FileName = latest_file.match(/__someRegexForFileNameWithExtension____/)
    * def fileName = get_FileName[0]

      # Get the object
    * def getObjectRequest = GetObjectRequest.builder().bucket(bucketName).key(s3ObjectKey).build()
    * print getObjectRequest
    * def object = s3Client.getObject(getObjectRequest)
    * print object

      # Copy from S3 to your target folder
    * def filePath = 'target/output/' + s3ObjectKey
    * def downloadStep = FileUtils.copyInputStreamToFile(object, new File(filePath));
    * print "********* Downloaded " + s3ObjectKey

      # if it is a zip file, you can unzip it first then read the content
      #* def unzipStep = file_utils.UnzipFile(filePath)
      #* print "********* Unzipped " + s3ObjectKey

      # Define the file you want to test
    * def dir = java.lang.System.getProperty('user.dir')
    * def path_folder = '/target/output/'
    * def testFileName = fileName + '.xml'
      # or any file extension that you need to open

      # From here you can already start the assertions
      # check fileName
    * def checkFileName = testFileName.includes('MyCompanyName_')


      # Open the file
          # -- in this example, we want to open an xml file with multiple
    * def testFileContent = karate.readAsString('file': + dir + path_folder + testFileName);
    * def lines = testFileContent.split('__someDelimiterOrRegexToSplitaRecord__')

    * def transformed = []
    * karate.forEach(lines, function(x) { if (x != "") transformed.push({item: x}) })
    * print "************ Transformed as karate data for Scenario Outline"
    * def data = transformed
    * print data

    * print "SETUP COMPLETE"



  Scenario Outline:
       # this will get data from setup step above
    * string x = __row.item
    * def cleanLine = x.replace('<?xml version="1.0"?>','');
    * print cleanLine

       # cast a string to xml or any format you want
    * xml myXmlDocument = cleanLine

       # From here you can start your assertions
    * match myXmlDocument //someField != null

       # you can also cast an xml to string
    * def actual_value_description = karate.toString(myXmlDocument.catalog.book.description)
    * match actual_value_description == 'My Expected Description'

    Examples:
      |karate.setup('s3_connect').data|