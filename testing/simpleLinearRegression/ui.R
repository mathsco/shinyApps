require(shiny)
require(Lock5withR)
require(datasets)

shinyUI(fluidPage(
  titlePanel("Simple Linear Regression"),
  sidebarLayout(
    sidebarPanel(
      selectInput("datachoice", "Choose a data frame:",
                  choices = c("user-imported",
                              "faithful",
                              "InkjetPrinters",
                              "RestaurantTips",
                              "StudentSurvey",
                              "NBAPlayers2011",
                              "FacebookFriends",
                              "FloridaLakes",
                              "HomesForSaleCA",
                              "SampCountries",
                              "NBAStandings",
                              "AllCountries",
                              "Cereal",
                              "WaterStriders"),
                  selected="faithful"),
      fileInput('file1', 'Choose file to upload',
                accept = c(
                  'text/csv',
                  'text/comma-separated-values',
                  'text/tab-separated-values',
                  'text/plain',
                  '.csv',
                  '.tsv'
                )
      ),
      checkboxInput('header', 'Header', TRUE),
      radioButtons('sep', 'Separator',
                   c(Comma=',',
                     Semicolon=';',
                     Tab='\t'),
                   ','),
      tags$hr(),
      textInput("explVar",
                label="Explanatory variable (x)",
                value=""),
      textInput("respVar",
                label="Response variable (y)",
                value=""),
      checkboxInput("bands",
                    "include confidence/prediction interval bands",
                    FALSE)
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Data set",
                 tableOutput('contents')
        ),
        tabPanel("Plots",
                 plotOutput("scPlot",
                            width="74%",height="350px"),
                 plotOutput("scPlotResids",
                            width="74%",height="300px"),br(),
                 plotOutput("histResids",
                            width="74%",height="300px"),
                 plotOutput("qqplotResids",
                            width="74%",height="300px")
        ),
        tabPanel("Randomization dists",
                 plotOutput("corRandDistPlot",
                            width="74%",height="250px"),br(),
                 htmlOutput("text1"),br(),
                 plotOutput("slopeRandDistPlot",
                            width="74%",height="250px"),br(),
                 htmlOutput("text2")
        ),
        tabPanel("Summaries",
                 verbatimTextOutput("lsRegOutput1"),br(),
                 verbatimTextOutput("lsRegOutput2")
        ),
        tabPanel("More diagnostic plots",
                 plotOutput("residPlots",
                            width="80%",height="600px")
        )
      )
    )
  )
))