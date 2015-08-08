library(httr)
library(XML)
library(CSS)
library(stringr)
# 台北市
wantPageUrl <- GET('http://www.etwarm.com.tw/object_list.php?city=%E5%8F%B0%E5%8C%97%E5%B8%82')
wantPageUrl <- htmlParse(content(wantPageUrl, 'text', encoding='utf8'))
wantPage <- xpathApply(wantPageUrl, '//*[@id="select_2"]/table/tr/td[3]', xmlValue)[[1]]
wantPage <- str_replace(str_extract(wantPage, '/ [0-9]+'), '/ ','')

wantVisitPages <-paste0('http://www.etwarm.com.tw/object_list.php?city=%E5%8F%B0%E5%8C%97%E5%B8%82&view=10&orderby=commend&page=',1:wantPage)

wantUrlTp <-list()
for ( i in 1:30 ){
# for ( i in 1:length(wantVisitPages) ){
  wantVisitPage <- GET(wantVisitPages[i])
  wantVisitPage <- htmlParse(content(wantVisitPage, 'text', encoding='utf8'))
  wantUrl <-xpathApply(wantVisitPage, '//*[@id="object_inpage_list_photo"]/a', xmlAttrs)
  wantUrlTp[[i]] <- do.call(rbind,wantUrl)[,'href']
  if (i%%5==0) Sys.sleep(1)
  print(i)
}

wantUrlTp2 <- unlist(wantUrlTp)
length(wantUrlTp2)
wantUrl <- sprintf('http://www.etwarm.com.tw/%s', wantUrlTp2)

price <-list()
for( i in 1:length(wantUrl)){
  a=GET(wantUrl[i], encoding='utf8')
  a=htmlParse(content(a, 'text', encoding='utf8'))
  wantValue <-xpathApply(a, '//*[@id="object_inpage_data_content_right"]/table[1]/tr/td[2]/span',xmlValue)[[1]]
  price[[i]] <-str_replace_all(wantValue,'[:space:]', '')
  cat(i, price[[i]], '\n')
}


# when i=1XX then result will like below
htmlParse(content(a, 'text', encoding='utf8'))
# <!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
#     <html>
#     <head><title>400 Bad Request</title></head>
#     <body>
#     <h1>Bad Request</h1>
#     <p>Your browser sent a request that this server could not understand.<br>
#     Size of a request header field exceeds server limit.<br></p>
#     <pre>
#     Cookie
# </pre>/n
# </body>
#     </html>
