
#creating a list assigning to variable x
x <- read.table(file.choose(),
                sep="\t", header=FALSE)
#adding the required library wordcloud
library(wordcloud)
#giving the header to the x with function names()
names(x)<-c("words","freq")

#finally workcloud funcction on the word and the frequency 
wordcloud(words = x$word, freq = x$freq, min.freq = 1,
          max.words=200, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))
