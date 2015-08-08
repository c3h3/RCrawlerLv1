require(RSelenium)
remDr <- remoteDriver(remoteServerAddr = "localhost" 
                      , port = 4444
                      , browserName = "firefox"
                      )
remDr$open()
remDr$navigate("https://kktix.com/events")

# kktix 點擊下拉選單,  並點擊搜尋

# http://www.w3schools.com/cssref/sel_nth-child.asp
webElem <- remDr$findElement("css", "select[name='category_id'] option:nth-child(3)")
webElem$clickElement()

webElem <- remDr$findElement("xpath", "//form/div/input")
webElem$clickElement()