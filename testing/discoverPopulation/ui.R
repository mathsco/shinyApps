shinyUI(fluidPage(
  titlePanel("Sampling from an Unknown Population Distribution"),
  sidebarLayout(
    sidebarPanel(radioButtons("dist", label = h3("Mystery population"),
                              choices = list("population 1" = "dist1", "population 2" = "dist2",
                                             "population 3" = "dist3"),selected = "dist1"), br(),
                 numericInput("num", 
                              label = h3("Sample size"), 
                              value = 30),br(),
                 actionButton("action", label = "Resample")),
    mainPanel(
      plotOutput("distPlot"),br(),
      h4("Consider these questions:"),
      tags$ol(
        tags$li("How small can the sample be so that it still allows you to see
                the true shape of the population?"),
        tags$li("How much do the various measures of center/spread vary amongst
                samples of size 30?  50?  100?  500?"),
        tags$li("Concerning means, is the displayed value", HTML("x&#772; or &mu;?"),
                "How well can you estimate the population mean with samples of
                size 30? 50? 100? 500?"),
        tags$li("Is the displayed standard deviation", HTML("<i>s</i> or &sigma;?"),
                "How well can you estimate the population sd with samples of size
                30? 50? 100? 500?"),
        tags$li("For each population, think about whether the mean or median
                seems better as a measure of", em("center."), "Likewise, does the
                standard deviation or IQR seem a better measure of spread?")
        )
  )    
    )
))
