library(httr)

h <- HEAD("http://www.etwarm.com.tw/")
h$cookies

print(length(h))
print(length(unlist(h)))
