require(shiny)
shinyUI(fluidPage(
  titlePanel(HTML("Goodness-of-Fit: Randomization Distributions")),
  sidebarLayout(
    sidebarPanel(textInput("obs", 
                              label = h3("Observed Counts"), 
                              value = "c(85,90,79,78,68)"),br(),
                 textInput("nullProbs", 
                              label = h3("Null Probabilities"), 
                              value = "c(1/5,1/5,1/5,1/5,1/5)"),br(),
                 actionButton("action", label = "Regenerate")),
    mainPanel(
      tabsetPanel(
        tabPanel(HTML("&chi;<sup>2</sup> statistic"),
      plotOutput("distPlot", width="74%",height="300px"),
      textOutput("text1"),
      textOutput("text2"),
      textOutput("text3"),br(),
      fluidRow(
        column(12,
               tableOutput('table')
        )
  )),
  tabPanel(HTML("Modified statistic"),
           HTML("What appears here is a randomization distribution
                for a <b>non-standard</b> sample <b>statistic</b>
                (NSS), different from &chi;<sup>2</sup>, one
                computed via the formula"),br(),HTML("&nbsp;"),br(),
           HTML("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                NSS = &Sigma; |(observed count) - (expected count)|"),
           br(),br(),
           plotOutput("distPlot2", width="74%",height="300px"),
           textOutput("text4"),
           textOutput("text5"))
      )
    )
)))
