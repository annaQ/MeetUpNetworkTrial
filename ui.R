library(shiny)
load("city.RData")
states <- names(table(c.df$STATE))
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("What's up in town?"),
  
  # Sidebar with a slider input for number of observations
  sidebarPanel(
    selectInput("state", 
                "Choose your state:", 
                states),
    htmlOutput("cityUI"),
    br(),
    actionButton("run", "Get it!")
  ),
    
  # Show a plot of the generated distribution
  mainPanel(
    tabsetPanel(      
      tabPanel("Overview",htmlOutput("overview")),
      tabPanel("Events", htmlOutput("DataTable")),
      tabPanel("Location", plotOutput("eventPlot", height = 800))
    )
  )
))
