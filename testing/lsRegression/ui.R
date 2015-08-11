shinyUI(fluidPage(
  titlePanel("Choose a line to minimize the sum of squared residuals"),
  sidebarLayout(
    sidebarPanel(numericInput("yintcpt", 
                              label = h3("y-intercept"), 
                              value = 9),br(),
                 numericInput("slope", 
                              label = h3("slope"), 
                              value = 2.5)
    ),
    mainPanel(
      p("Manipulate the slope and intercept of the line of fit
        in order to minimize the sum of squared residuals."), br(),
      plotOutput("scatterPlot"),br(),
      textOutput("text1")
    )    
   )
))
