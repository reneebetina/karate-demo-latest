@xmlDemo
Feature: this is a sample on how to validate an XML

  Background:
    * configure continueOnStepFailure = true

  @setup=xml_reader
  Scenario:
    #define request body
    * def dir = java.lang.System.getProperty('user.dir')
    * def path = '/src/test/java/data/files/input/books.xml'

    #open file
    * def myTestFile = karate.readAsString('file:' + dir + path)

    # remove items that are not needed for testing
    * def myTestFile = myTestFile.replace('<?xml version="1.0"?>','');
    * def myTestFile = myTestFile.replace('<catalog>','');
    * def myTestFile = myTestFile.replace('</catalog>','');
    * print myTestFile

    * def lines = myTestFile.split('\r\n')

    * def transformed = []

    # each item will be saved and considered as 1 test case in scenario outline
    * karate.forEach(lines, function(x) { if (x != "") transformed.push({item: x}) })
    * print "************ Transformed as karate data for Scenario Outline"
    * def data = transformed
    * print data


  Scenario Outline: Sample XML Test to check attributes of every child element
       # this will get data from setup step above
    * string currentRow = __row.item

       # cast to xml or any format you want
    * xml myXmlEntry =  currentRow

       # From here you can start your assertions
    * match myXmlEntry //author != null


    * def actual_value_myCustomField = karate.toString(myXmlEntry.book.myCustomField)
    * match actual_value_myCustomField == 'Renee'

       # you can also cast an xml to string
    * def actual_value_price = karate.toString(myXmlEntry.book.price)
    * match actual_value_price == '#present'

    Examples:
      |karate.setup('xml_reader').data|