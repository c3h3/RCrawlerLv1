 require(RSelenium)
 remDr <- remoteDriver(remoteServerAddr = "localhost" 
                      , port = 4444
                      , browserName = "firefox"
                      )
 remDr$open()
 remDr$navigate("https://www.facebook.com/login/?next=%2Fdocs%2Fgraph-api")

# enter your accounts number
 webElem <- remDr$findElement(using = 'id', value = "email")
 webElem$sendKeysToElement(list('YOUR ACCOUNTS'))

# enter your password and press enter
 webElem <- remDr$findElement(using = 'id', value = "pass")
 webElem$sendKeysToElement(list('YOUR PASSWORD', key='enter'))


# go back to API page
 fbID = 'YOUR FACEBOOK ID'
 url = paste0('https://developers.facebook.com/tools/explorer/', fbID)

 remDr$navigate(url)

 webElem = remDr$findElement("xpath", "//a[@data-reactid='.0.0.2:$token.$=10:0']")
 webElem$clickElement()
 
 webElem = remDr$findElement("xpath", "//a[@class='_54nc']")
 webElem$clickElement()

 webElem = remDr$findElement("xpath", "//button[@class='_42ft _42fu layerConfirm uiOverlayButton selected _42g- _42gy']")
 webElem$clickElement()


# press submit
 webElem = remDr$findElement("xpath", "//button[@class='_1pw0 _4jy0 _4jy3 _4jy1 _51sy selected _42ft']")
 webElem$clickElement()

# get the token value
 webElem = remDr$findElement("xpath", "//input[@class='_58al']")
 webElem$getElementAttribute('value')
