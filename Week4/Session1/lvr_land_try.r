library(httr)
# install.packages("jpeg")
library(jpeg)
library(CSS)
library(XML)
library(RCurl)
rm(list=ls())



##########################
#    lvr.land            #
##########################

#  連首頁
res1 = GET("http://lvr.land.moi.gov.tw/N11/login.action")
(needCookies=cookies(res1))

#  看驗證碼
res2 = GET("http://lvr.land.moi.gov.tw/N11/ImageNumberN13?")
(needCookies=cookies(res2))

if (packageVersion("httr") == "1.0.0"){
  needCookies = as.list(setNames(res2$cookies$value,res2$cookies$name))
}else{
  needCookies = res2$cookies
}

captcha <- content(res2)
plot(0:1, 0:1, type = "n")
rasterImage(captcha, 0, 0, 1, 1)

## key rand_code
res3 = POST("http://lvr.land.moi.gov.tw/N11/login.action",
            body=list(command='login',rand_code='9066',in_type='land'), 
            config=set_cookies('JSESSIONID'=needCookies$JSESSIONID, 
                               'slb_cookie'=needCookies$slb_cookie)
)
cookies(res3)



# 拿參數表
# install.packages("stringi")
library(stringi)
res <-  GET("http://lvr.land.moi.gov.tw/INC/js/city_town.js")
stri_enc_isutf16le(res$content)
stri_enc_isutf8(res$content)
para <- stri_encode(res$content,from="UTF-16LE",to="utf8")
para <- rjson::fromJSON(str_extract(para,'\\[.+\\]'))
library(data.table)
para <- lapply(para,function(x)
                    data.frame(x$id, 
                               x$name, 
                               x$lonlat,
                               rbindlist(x$AREA$DATA), stringsAsFactors = FALSE))
para <- do.call(rbind, para)
names(para) <- c('city', 'cityName', 'cityPseudoGis', 'town', 'townName', 'townPseudoGis')

#  查詢資料 回傳第一個頁籤
res4= GET("http://lvr.land.moi.gov.tw/N11/pro/setToken.jsp",
          config=set_cookies('JSESSIONID'=needCookies$JSESSIONID, 
                             'slb_cookie'=needCookies$slb_cookie))
getToken = content(res4, type='text', encoding='utf8')
getToken = str_extract_all(getToken, '[:alnum:]+')[[1]]
getToken = getToken[length(getToken)]


base64Decode('UXJ5ZGF0YQ==')
base64Decode('MQ==')
base64Decode('MTAz');base64Decode('MTA0')
base64Decode('Mw==');base64Decode('Mw==')
base64Decode('Mg==')


qryBody <- list(
    type = 'UXJ5ZGF0YQ==',
    Qry_city = base64Encode(para$city[1]),
    Qry_area_office = base64Encode(para$town[1]) ,
    Qry_paytype = 'MQ==',
    Qry_build = '',
    Qry_price_s = '',
    Qry_price_e = '',
    Qry_unit_price_s = '',
    Qry_unit_price_e = '',
    Qry_p_yyy_s = 'MTAz',
    Qry_p_yyy_e = 'MTA0',
    Qry_season_s = 'Mw==',
    Qry_season_e = 'Mw==',
    Qry_doorno = '',
    Qry_area_s = '',
    Qry_area_e = '',
    Qry_order = 'UUEwOCZkZXNj',
    Qry_unit = 'Mg==',
    Qry_area_srh = '',
    Qry_buildyear_s = '',
    Qry_buildyear_e = '',
    Qry_urban = '',
    Qry_nurban = '',
    Qry_pattern = '',
    Qry_origin = 'P',
    Qry_avg = 'off',
    struts.token.name = 'token',
    token = getToken
)


firstPost <- POST('http://lvr.land.moi.gov.tw/N11/QryClass_land.action',
                  body=qryBody,
                  config=set_cookies('JSESSIONID'=needCookies$JSESSIONID, 
                                     'slb_cookie'=needCookies$slb_cookie))

ResFirstPostText <- content(firstPost, type='text', encoding='utf8')
ResFirstPostText <- str_replace_all(ResFirstPostText,'\r|\t','')
ResFirstPostText <- str_replace_all(ResFirstPostText,'(\n)+','\n')
ResFirstPostParse <- htmlParse(ResFirstPostText, encoding = 'utf8')
writeLines(ResFirstPostText, 'look_first_post_result.txt')


wantData <- xpathSApply(ResFirstPostParse, '//table/tr', xmlValue)
wantData <- wantData[str_detect(wantData,'\n\n交易標的')]



str_extract_all(ResFirstPostText, "<div id='Address_[0-9]+' name=[0-9]+ .+</div>")[[1]]

#  拿之後的頁籤

(paraRowno <- str_replace_all(str_extract_all(content(firstPost, type='text', encoding='utf8'), '<option value=[0-9]+ >')[[1]], '(<option value=)| >', ''))
# [1] "200"  "400"  "600"  "800"  "1000" "1200"

qryBody2<- list(
    order = 'QA08',
    sort = '1',
    Qry_city = para$city[1],
    Qry_area_office = para$town[1],
    Qry_unit = '2',
    rowno=paraRowno[2]
)

secondPost=POST('http://lvr.land.moi.gov.tw/N11/LandBuildSort',
        body=qryBody2,
        config=set_cookies('JSESSIONID'=needCookies$JSESSIONID, 
                           'slb_cookie'=needCookies$slb_cookie)
)
ResSecondPostText <- content(secondPost, type='text', encoding='utf8')
ResSecondPostText <- str_replace_all(ResSecondPostText,'\r|\t','')
ResSecondPostText <- str_replace_all(ResSecondPostText,'(\n)+','\n')
ResSecondPostParse <- htmlParse(ResSecondPostText, encoding = 'utf8')
writeLines(ResSecondPostText, 'look_second_post_result.txt')
# ResSecondPostText <- readLines('look_first_post_result.txt')

wantData2 <- xpathSApply(ResSecondPostParse, '//table/tr', xmlValue)
wantData2 <- wantData2[str_detect(wantData2,'\n\n交易標的')]


wantData2[1]
str_extract(wantData2,'交易年月(.|\n)+交易總價')
str_extract(wantData2,'交易總價(.|\n)+元')
str_extract(wantData2,'建物移轉總面積(.|\n)+坪')
str_extract(wantData2,'交易筆棟數(.|\n)+建物區段門牌')
str_extract(wantData2,'建物區段門牌(.|\n)+建物型態')
str_extract(wantData2,'建物型態(.|\n)+建物現況格局')
str_extract(wantData2,'建物現況格局(.|\n)+車位總價')
str_extract(wantData2,'車位總價(.|\n)+管理組織')
str_extract(wantData2,'管理組織(.|\n)+屋齡')
str_extract(wantData2,'屋齡(.|\n)+樓別')
str_extract(wantData2,'樓別(.|\n)+')




