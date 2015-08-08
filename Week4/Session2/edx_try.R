library(httr)

res1 = GET("https://www.edx.org/")

res2 = GET("https://www.edx.org/login")
res2$cookies


headers = add_headers("User-Agent"="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2272.76 Safari/537.36",
                      "Referer" = "https://courses.edx.org/login",
                      "X-CSRFToken" = res2$cookies[which(res2$cookies$name=="csrftoken"),]$value)


if (packageVersion("httr") == "1.0.0"){
  headers = add_headers("User-Agent"="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2272.76 Safari/537.36",
                        "Referer" = "https://courses.edx.org/login",
                        "X-CSRFToken" = res2$cookies[which(res2$cookies$name=="csrftoken"),]$value)
  
  print(headers$headers)
}else{
  headers = add_headers("User-Agent"="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2272.76 Safari/537.36",
                        "Referer" = "https://courses.edx.org/login",
                        "X-CSRFToken" = res2$cookies$csrftoken)
  
  print(headers$httpheader)
}

if (packageVersion("httr") == "1.0.0"){
  cookies = as.list(setNames(res2$cookies$value,res2$cookies$name))
}else{
  cookies = res2$cookies
}

res3 = POST("https://courses.edx.org/user_api/v1/account/login_session/",
            headers,do.call(set_cookies,cookies),
            body = list(email="",
                        password="",
                        remember="false"),
            encode="form"
            )

res3$status_code
res3$content
content(res3,"text")
res3$cookies


headers = add_headers("User-Agent"="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2272.76 Safari/537.36",
                      "Referer" = "https://courses.edx.org/login")

res4 = GET("https://courses.edx.org/dashboard", headers, do.call(set_cookies,res3$cookies))
res4
content(res4)

library(rvest)
library(stringr)

courses = content(res4) %>% html_nodes("li.course-item")

courseName = courses[[1]] %>% html_node(".course-title") %>% html_text %>% str_trim
courseURL = courses[[3]] %>% html_node(".course-title > a") %>% html_attr(name = "href") 
!is.null(courseURL)

library(XML)

extractCourseData = function(course){
  courseName = course %>% html_node(".course-title") %>% html_text %>% str_trim
  courseURL = course %>% html_node(".course-title > a") 
  if (!is.null(courseURL)){
    courseURL = courseURL %>% html_attr(name = "href")   
    return(data.frame(name=courseName,url=courseURL))
  }
  
  return(data.frame(name=courseName,url="NO-URL"))
}

extractCourseData(courses[[1]])


df = do.call(rbind,xmlApply(courses,extractCourseData))
View(df)


