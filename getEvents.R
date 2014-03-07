event.df <- data.frame()

for(i in 1:length(file)){
  event <- file[[i]]
  index <- nrow(event.df)+1
  event.df[index,1]  <- event$id
  event.df[index,2]  <- event$status
  event.df[index,3]  <- event$name
  event.df[index,4]  <- event$group$id
  event.df[index,5]  <- event$maybe_rsvp_count + event$yes_rsvp_count + event$waitlist_count
  if("fee" %in% names(event)){
    event.df[index,6]  <- TRUE
  } else {
    event.df[index,6]  <- FALSE
  }
  if("venue" %in% names(event)){
    event.df[index,7]  <- paste(event$venue$lat,event$venue$lon,sep=":")
  } else {
    event.df[index,7]  <- paste(event$group$group_lat,event$group$group_lon,sep=":")    
  }
  event.df[index,8]  <- event$event_url
  event.df[index,9]  <- event$description

}

names(event.df) <- c("ID", "STATUS","NAME","MEMBER","LAT","LON") #DONE!
save(event.df, file = "event.RData")


