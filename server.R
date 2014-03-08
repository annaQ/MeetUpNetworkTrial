library(shiny)
library(ggplot2)
library(rjson)
load("city.RData")
suppressPackageStartupMessages(library(googleVis))
library(ggmap)
library(plyr)
state.member <- ddply(c.df,"STATE", summarise, 
                      Member.count = sum(MEMBER))
Th = theme_grey(base_size=16)

##################################START SERVER
shinyServer(function(input, output) {

# maintain reactive city ui 
  output$cityUI <- renderUI({ 
    selectInput("city", "Choose your city:", c.df$CITY[which(c.df$STATE == input$state)])
  })
  
  getCity <- reactive({
    input$city
  })
  getRegion <- reactive({
    paste("US","-",input$state,sep = "")
  })
 
  output$click <- renderText({
    input$run
  })
  
  output$overview <-renderGvis({
    gvisGeoChart(state.member, locationvar = "STATE", colorvar = "Member.count", 
                      options = list(width = 960, height = 550, 
                                     region = "US",  
                                     title='Where are people using meet-up?',
                                     displayMode='regions',resolution = 'provinces'))
  })
  
  output$DataTable <- renderGvis({
    event.df <- getEventDF(c.df[which(c.df$CITY == input$city),1])
    tb <- event.df[,c(3,2,5,6)]
    tb$NAME <- paste('<a href = ', event.df$URL, ' target="_blank">', tb$NAME, '</a>')
    gvisTable(data = tb, 
              options = list(page='enable', width = 1000, height = 350,allowHTML = TRUE))
    
  })
  
# This is for event distribution
  output$eventPlot <-  renderPlot({

    event.df <- getEventDF(c.df[which(c.df$CITY == input$city),1])
    
    if(nrow(event.df) > 1){
      map <- get_map(location = c(lon = median(event.df$LON), 
                                  lat = median(event.df$LAT)),
                     zoom = 12, messaging = FALSE)
      p <- ggmap(map, extent = 'panel') + geom_point(data=event.df, 
                                   aes(y=LAT, x=LON, size=MEMBER,color = PAY),
                                   alpha = 0.7, position = "jitter") + 
        ggtitle("Where are the events?\n") + Th
      print(p)
    } else {
      map <- get_map(input$city, zoom = 12, messaging = FALSE)
      p <- ggmap(map, extent = 'normal',legend = "none") + ggtitle("No events happen in the city\n...and I feel sorry too") + Th
      print(p)
    }
  })
  
    
})

#This is used to update the event dataframe based on the city selected
getEventDF <-function(zip){
  url = paste("https://api.meetup.com/2/open_events?&sign=true&zip=",
              zip,
              "&page=200&radius=10&key=452167153b2b67443e325d7a1b42343",
              sep = "")
  file <- fromJSON(file = url)[[1]]
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
      event.df[index,7]  <- event$venue$lat
      event.df[index,8]  <- event$venue$lon
    } else {
      event.df[index,7]  <- event$group$group_lat
      event.df[index,8]  <- event$group$group_lon
    }
    event.df[index,9]  <- event$event_url
  }
  
  names(event.df) <- c("ID", "STATUS","NAME","GROUP","MEMBER","PAY",
                       "LAT","LON","URL") #DONE!
  event.df
}
