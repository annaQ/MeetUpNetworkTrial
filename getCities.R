#For efficiency concern, retrieved 1000 cities info locally
library(rjson)
cityRoster <- list()[1:5]
for(i in 0:4){
  url = paste("http://api.meetup.com/2/cities?radius=50&order=size&desc=false&offset=",
              i,
              "&format=json&page=200&country=us&sig_id=117271872&sig=452167153b2b67443e325d7a1b42343", sep = "")
  file <- fromJSON(file = url)
  cityRoster[i+1] <- file[1]
}

c.df <- data.frame()

for(page in 1:length(cityRoster)){
  
  city200 <- cityRoster[page]
  
  for(i in 1:200){
    
    record <- city200[[1]][i][[1]]
      
    c.df[i+(page-1)*200,1] <- record$id
    c.df[i+(page-1)*200,2] <- record$city
    c.df[i+(page-1)*200,3] <- record$state
    c.df[i+(page-1)*200,4] <- record$member_count
    c.df[i+(page-1)*200,5] <- record$lat
    c.df[i+(page-1)*200,6] <- record$lon
  }
}

names(c.df) <- c("ZIP", "CITY","STATE","MEMBER","LAT","LON") #DONE!

#For efficiency concern, retrieved categories info locally
file <- fromJSON(file= "http://api.meetup.com/2/categories?
                 order=shortname&desc=false&offset=0&format=json&page=50&
                 sig_id=117271872&sig=9385f8fa6fe8d445ba0011161f85853e5b4dfdfd")[[1]]

cate.df <- data.frame()

for(i in 1:length(file)){
  
  record <- file[[i]]
  
  cate.df[i,1] <- record$id
  cate.df[i,2] <- record$name
  cate.df[i,3] <- record$shortname
  
}
names(cate.df) <- names(record)


save(c.df, cate.df, file = "city.RData")
