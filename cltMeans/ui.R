require(shiny)
shinyUI(fluidPage(
  titlePanel(HTML("Sampling distribution of x&#772")),
  sidebarLayout(
    sidebarPanel(radioButtons("dist", label = h3("Select population"),
                              choices = list("population 1" = "dist1", "population 2" = "dist2",
                                             "population 3" = "dist3"),selected = "dist1"),
                 numericInput("num", 
                              label = h3("Sample size n"), 
                              value = 1),br(),
                 plotOutput("distPlot", width="100%",height="200px")),
    mainPanel(
      plotOutput("nullDistPlot", width="74%",height="300px"),
      plotOutput("qqPlot", width="74%",height="300px"),
      textOutput("text1"),
      textOutput("text2")
  )    
    )
))
