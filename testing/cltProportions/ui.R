require(shiny)
shinyUI(fluidPage(
  titlePanel(HTML("Sampling Distribution for p&#770")),
  sidebarLayout(
    sidebarPanel(numericInput("num", 
                              label = h3("Sample size n"), 
                              value = 5),br(),
                 sliderInput("true.p","True population proportion",
                             0.05,0.95,0.5,0.01)),
    mainPanel(
      plotOutput("distPlot", width="74%",height="300px"),
      plotOutput("qqPlot", width="74%",height="300px")
  )    
    )
))
