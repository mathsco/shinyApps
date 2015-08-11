require(shiny)

shinyUI(fluidPage(
  titlePanel("1-Way ANOVA"),
  sidebarLayout(
    sidebarPanel(
      selectInput("datachoice", "Choose a data frame:",
                  choices = c("user-imported",
                              "iris",
                              "SandwichAnts",
                              "StudentSurvey",
                              "HollywoodMovies2011",
                              "LightatNight",
                              "FishGills3"),
                  selected="iris"),
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
                label="Categorical var. (explanatory)",
                value=""),
      textInput("respVar",
                label="Quantitative var. (response)",
                value="")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Data set",
          tableOutput('contents')
        ),
        tabPanel("Side-by-side plots",
                 plotOutput("grpPlots")
        ),
        tabPanel("Randomization dist",
                 plotOutput("randDistPlot"),br(),
                 htmlOutput("text")
        ),
        tabPanel("Summaries",
                 verbatimTextOutput("anovaResult")
        ),
        tabPanel("Tukey HSD",
                 verbatimTextOutput("tukeyHSDResult")
        )
      )
    )
  )
))