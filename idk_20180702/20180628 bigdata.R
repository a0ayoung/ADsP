
text_all = c()

#ctrl+i´Â for¹® Á¤¸®

#´Ù¸¥ ÆäÀÌÁö¿¡ °¬´Ù°¡ ¿Í¼­ urlÀ» º¹»çÇÒ °Í
base_url <- "http://news.naver.com/main/list.nhn?mode=LSD&mid=sec&sid1=101&date=20180628&page="


for(j in 1:10){
  
  
  url_news <- print(paste(base_url,j,sep =""))
  
  
  #getÇÔ¼ö´Â urlÅë½Å¶§ ¾²´Â °Í?
  
  http_news <- GET(url_news)
  
  
  
  html_news <- read_html(http_news)
  
  
  
  link_news <- html_nodes(html_news, "div.list_body a")
  
  #link°¡ href¿¡ ÀÖ±â ¶§¹®
  
  #»çÁø°ú ¸µÅ©¿¡ °°Àº ¸µÅ©°¡ µé¾î°¡ ÀÖÀ¸¹Ç·Î À¯´ÏÅ© ÇÔ¼ö·Î Áßº¹À» Àâ¾ÆÁÜ
  
  link_news01 <- unique(html_attr(link_news, "href"))
  
  #grepÇÔ¼ö´Â ""¾È¿¡ µé¾îÀÖ´Â °Ô µé¾îÀÖ´Â ¸ğµç ¸µÅ©¸¦ Àâ¾ÆÁÜ
  
  link_news02 <- grep("news.naver.com", link_news01, value = T)
  
  
  
  for(i in 1: length(link_news02)){
    
    http_contents <- GET(link_news02[i])
    
    html_contents <- read_html(http_contents)
    
    
    
    contents_area <- html_nodes(html_contents, "div#articleBodyContents") 
    
    text <- html_text(contents_area)
    
    text_all <- c(text_all, text)#Àü ÅØ½ºÆ®¿Í ¿ä¹ø ÅØ½ºÆ®¸¦ °°ÀÌ º¤ÅÍ·Î
    
  }
 # write.csv(text_all,"news.csv")
  #sep = , row.names=)#¿­¹Ù²Ù°í ½Í´Ù
  
}


#getwd() #R°ú¿¬°áµÇ¾îÁø ÀÛ¾÷°ø°£, ¿öÅ·µğ·ºÅä¸®
#setwd("")#ÁÖ¼Ò¹Ù²Ù°í ½Í´Ù¸é
clz_news = gsub("^.+\\{\\}"," ", text_all)#{}µµÆ¯¼ö¹®ÀÚ¶ó¼­ ÀÏÅØ½ºÆ® Å»Ãâ 

clz_news = gsub("[[:punct:]¢º[]"," ", clz_news)#[]¾È¿¡´Â ¾È¿¡µé¾î°¡´Â°Í ´Ù 
clz_news = gsub("[¢º[[:punct:]]"," ", clz_news)#[]¾È¿¡´Â ¾È¿¡µé¾î°¡´Â°Í ´Ù 

clz_news = gsub("[A-Za-z0-9]"," ", clz_news )#¾ËÆÄºª ÀüºÎ, ¼Ò¹®ÀÚÓÆÄºªÀüºÎ, ¼ıÀÚ Àü 
clz_news = gsub("[°¡-ÆR]{1-6}´º½º"," ", clz_news )#[°¡-ÆR]ÇÑ±Û¿¡ ´ëÇÑ ¸ğµç ÆĞÅÏ {2,5} 2¹øÀÌ»ó, 5¹øÀÌÇÏ·Î ¹İº¹

clz_news = gsub("[[:space:]]+"," ", clz_news )#¾ËÆÄºª ÀüºÎ, ¼Ò¹®ÀÚÓÆÄºªÀüºÎ, ¼ıÀÚ Àü 

text_all[1]
clz_news[1]

getwd()
n_news =clz_news[nchar(clz_news) <1000]
write.csv(n_news, "n_news.csv")


con = dbConnect (drv = MySQL(),
                 dbname = "test",
                 user = 'root',
                 password ='asas1515',
                 host = "localhost",
                 port = 3306,
                 client.flag = CLIENT_MULTI_RESULTS)

dbListTables(con)
dbListFields(con,  "news")
db_news = dbGetQuery(con,"SELECT * FROM news")
db_news[1, 2]
library(rvest)

db_news$text[1] <- repair_encoding(db_news$text)
############
dbSendQuery(con, "SET character_set_client= 'euckr'") #mysql±âº»¼³Á¤ÀÌÁö¸¸ r¿¡¼­´Â Á÷Á¢
dbSendQuery(con, "SET character_set_results= 'euckr'")
dbSendQuery(con, "SET connection='utf8_unicode_ci'")


Encoding(db_news$text)
repair_encoding(db_news$text)#±ÛÀÚ°¡ ±úÁ³À»¶§
iconv(db_news$text,
      from = "UTF-8" ,
      to = "EUC-KR"
      )#¹®ÀÚ¿­À» ¿øÇÏ´Â ¹®ÀÚ¿­·Î 

dbDisconnect(con)
library(KoNLP)
useNIADic()
extractNoun(text)

#install.packages("tm")
library(tm)
Corpu
cps = VCorpus(VectorSource(db_news$text))#µ¥ÀÌÅÍ ÇÁ·¹ÀÓ¿¡¼­ µÎ¹øÂ° ¿­ ÅØ½ºÆ®¸¸
#corpus ´Â ¸ŞÅ¸µ¥ÀÌÅÍ °®°íÀÖ¾î¼­ ºÎ°¡ÀûÀÎ Á¤º¸ ÀÔ·Â°¡´É
ko_word = function(input){
  text = as.character(input)
  extractNoun(text)
}

ko_tdm <- TermDocumentMatrix(cps,
                             control = list(
                               tokenize= ko_word,
                               #wordLengths = c(3, Inf) #¿µ¾îÀÇ °æ¿ì
                               wordLengths = c(2, 7) #ÇÑ±Û
                             ))

ko_tdm

ko_mat <- as.matrix(ko_tdm)
ko_mat

word_freq <- rowSums(ko_mat)
str(word_freq)
word_name = names(word_freq)
df_wc = data.frame( word = word_name,
            freq = word_freq)

#install.packages("wordcloud2")
#install.packages("htmlwidgets")

library(wordcloud2)
library(htmlwidgets)
wc <- wordcloud2(df_wc, color = "random-dark")
saveWidget(wc, "wc.html", selfcontained = F)


#order(c(10,11,1,7,4), decreasing = T) #order indexing ¿¹Á¦ 


word_order = order(word_freq, decreasing = T)[1:50] #»óÀ§ 50°³ÀÇ ÀÎµ¦½Ì ¹øÈ£
occ_mat = ko_mat[word_order, ]
occ_mat2 = occ_mat %*% t(occ_mat) #¸¹ÀÌ °°ÀÌ ÀÖÀ»¼ö·Ï °Å¸®Çà·Ä °è¼ö Ä¿Áö°í. . . 

#install.packages("qgraph")
library(qgraph)
png("associ.png", 
    width = 1980,
    height = 1250)

qgraph(occ_mat2,
       layout = "spring",
       color = "blue",
       vsize = log(diag(occ_mat)),
       label.color= "white",
       labels = colnames(occ_mat2),
       diag= F)


dev.off()

