library(httr)
library(XML)
library(CSS)
library(stringr)
library(rjson)
rm(list=ls())

URL <- 'http://www.giantcyclingworld.com/web/ajax_store.php'
res <- POST(URL, body=list(act='store_name_search'))
resText <- content(res,'text')
wantData <- fromJSON(resText)$content
wantDataParse <- htmlParse(wantData, encoding = 'utf8')

wantDataTp <- xpathSApply(wantDataParse, '//ol/li/dl/dd', xmlValue)
result<- matrix(wantDataTp, ncol=4, byrow=TRUE)
result <- as.data.frame(result)



library(RSQLite) 
library(tmcn)
db = dbConnect(SQLite(), dbname="giantcyc.sqlite") 
dbWriteTable(db, "giantcyc", result) 
# dbSendQuery(db, ‘SQL_Query') 
dbListTables(db) 
giantcyc2 = dbGetQuery(db,  
                    "select * from result") 
giantcyc2 = sapply(giantcyc2, toUTF8) 
dbDisconnect(db) #  關閉 db 連結  
