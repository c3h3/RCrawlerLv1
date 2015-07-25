# live demo code for create link of link page
postUrl <- "https://www.ptt.cc/bbs/Gossiping/index.html"
res <- GET(postUrl, config=set_cookies('over18'='1'))
res <- content(res, 'text', encoding = 'utf8')
res <- htmlParse(res, encoding = 'utf8')
tmpIndex <-xpathSApply(res, '//*[@id="action-bar-container"]/div/div[2]/a[2]', xmlAttrs)
tmpIndex <-tmpIndex["href",]
tmpIndex <- str_extract(tmpIndex, '[0-9]+')
tmpIndex <- as.numeric(tmpIndex)+1

(tmpIndex-10):tmpIndex

sprintf("https://www.ptt.cc/bbs/Gossiping/index%s.html",(tmpIndex-10):tmpIndex)


# live demo code for data page crawler 
postUrl <- "https://www.ptt.cc/bbs/Gossiping/M.1431338763.A.1BF.html"
res <- GET(postUrl, config=set_cookies('over18'='1'))
res <- content(res, 'text', encoding = 'utf8')
res <- htmlParse(res, encoding = 'utf8')
push <-xpathSApply(res, '//*[@id="main-content"]/div/span[1]', xmlValue)
library(stringr)
str_detect(push, '作者|看板|標題|時間')
push[!str_detect(push, '作者|看板|標題|時間|')]


