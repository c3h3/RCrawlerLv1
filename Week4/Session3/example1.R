 require(RSelenium)
 remDr <- remoteDriver(remoteServerAddr = "localhost" 
                       , port = 4444
                       , browserName = "firefox"
                      )
 
 remDr$open()
 remDr$navigate("https://www.google.com.tw")

 # 搜尋颱風
 webElem = remDr$findElement(using = "id", value = "lst-ib")
 webElem$sendKeysToElement(list("颱風", key = "enter"))

 Sys.sleep(3)

 webElem = remDr$findElements("xpath", "//h3/a")
 webElem[[1]]$getElementText()
 webElem[[2]]$getElementText()
 
 sapply(webElem, function(elem){elem$getElementText()})
 
 # 下一頁
 webElem = remDr$findElement("id", "pnnext")
 webElem$clickElement()
 
 # 相關搜尋
 webElem = remDr$findElements("xpath", "//p[@class='_e4b']/a")
 sapply(webElem, function(elem){elem$getElementText()})