require(RSelenium)
 remDr <- remoteDriver(remoteServerAddr = "localhost" 
                      , port = 4444
                      , browserName = "firefox"
                      )

 remDr$open()
 remDr$navigate("http://amusetaiwan.kktix.cc/events/walltaipei")

 webElem = remDr$findElement("xpath", "//div[@class='tickets']/a")
 webElem$clickElement()
 Sys.sleep(5)

 webElem = remDr$findElement("xpath", "//a[@class='btn btn-primary pull-left ng-binding']")
 webElem$clickElement()

 webElem = remDr$findElement("xpath", "//a[@class='fb btn-login']")
 webElem$clickElement()

 webElem = remDr$findElement("id", "email")
 webElem$sendKeysToElement(list("YOUR ACCOUNTS"))

 webElem = remDr$findElement("id", "pass")
 webElem$sendKeysToElement(list("YOUR PASSWORD", key="enter"))

 Sys.sleep(10)
 
 webElem = remDr$findElement("xpath", "//button[@class='btn-default plus ng-scope']")
 
 for(i in 1:3){
     webElem$clickElement()
 }
 
 Sys.sleep(3) 
 
 webElem = remDr$findElement("id", "person_agree_terms")
 webElem$clickElement()
 
 Sys.sleep(5)
 
 webElem = remDr$findElement("xpath", "//button[@class='btn btn-primary btn-lg ng-binding  ng-isolate-scope']")
 webElem$clickElement()
