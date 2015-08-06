library(httr)
packageVersion("httr")

h = HEAD("https://kktix.com/")
h$all_headers
res1 = GET("https://kktix.com/")
res1$cookies

library(rvest)

content(res1) %>% html_nodes(".dropdown-menu")


headers = add_headers("User-Agent"="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2272.76 Safari/537.36",
                      "Referer" = "https://kktix.com/")
                      
res2 = GET("https://kktix.com/users/sign_in?back_to=http%3A%2F%2Fkktix.com%2F")
res2$cookies

if (packageVersion("httr") == "1.0.0"){
  cookies = as.list(setNames(res2$cookies$value,res2$cookies$name))
}else{
  cookies = res2$cookies
}

userAcc = ""
password = ""

headers = add_headers("User-Agent"="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2272.76 Safari/537.36",
                      "Referer" = "https://kktix.com/users/sign_in?back_to=http%3A%2F%2Fkktix.com%2F")


postBody = sprintf("utf8=%s&authenticity_token=%s&%s=%s&%s=%s&%s=0&commit=%s",
                   "%E2%9C%93", cookies[["XSRF-TOKEN"]], 
                   "user%5Blogin%5D", URLencode(userAcc), 
                   "user%5Bpassword%5D", URLencode(password), 
                   "user%5Bremember_me%5D", "%E7%99%BB%E5%85%A5")


res3 = POST("https://kktix.com/users/sign_in",
            headers, do.call(set_cookies,cookies),
            body = postBody)

content(res3)


headers = add_headers("User-Agent"="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2272.76 Safari/537.36",
                      "Referer" = "https://kktix.com/",
                      "X-CSRF-Token" = cookies[["XSRF-TOKEN"]])


res4 = GET("https://kktix.com/g/user_info",headers)
content(res4)
