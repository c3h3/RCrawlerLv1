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
  wantVisitPageRes <- GET(wantVisitPages[i])
  wantVisitPage <- htmlParse(content(wantVisitPageRes, 'text', encoding='utf8'))
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
  aHandle = handle(wantUrl[i], cookies=FALSE)
  aRes=GET(handle = aHandle, encoding='utf8')
  a=htmlParse(content(aRes, 'text', encoding='utf8'))
  wantValue <-xpathApply(a, '//*[@id="object_inpage_data_content_right"]/table[1]/tr/td[2]/span',xmlValue)[[1]]
  price[[i]] <-str_replace_all(wantValue,'[:space:]', '')
  cat(i, price[[i]], '\n')
}