library(shiny)
load("city.RData")
states <- names(table(c.df$STATE))
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Meet Ups in your city"),
  
  # Sidebar with a slider input for number of observations
  sidebarPanel(
    selectInput("state", 
                "Choose your state:", 
                states),
    htmlOutput("cityUI"),
    hr(),
    actionButton("run", "Get it!")
  ),
    
  # Show a plot of the generated distribution
  mainPanel(
    tabsetPanel(      
      tabPanel("Overview",htmlOutput("overview")),
      tabPanel("Events", 
               htmlOutput("DataTable"),hr(),hr(),
               plotOutput("eventPlot", height = 800))
    )
  )
))
