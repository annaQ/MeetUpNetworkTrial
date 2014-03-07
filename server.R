library(shiny)
load("city.RData")
load("event.RData")
suppressPackageStartupMessages(library(googleVis))
library(plyr)
state.member <- ddply(c.df,"STATE", summarise, 
                      Member.count = sum(MEMBER))

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
  
  output$usMap <- renderPlot({
    map <- get_map(location = 'united states', zoom = 4)
    ggmap(map)
  })
  
  output$click <- renderText({
    input$run
  })
  
  output$overview <-renderGvis({
    gvisGeoChart(state.member, locationvar = "STATE", colorvar = "Member.count", 
                      options = list(width = 960, height = 550, 
                                     region = "US",  displayMode='regions',resolution = 'provinces'))
  })
    
})
