shinyUI(fluidPage(
  titlePanel("My Shiny App"),
  sidebarLayout(
    sidebarPanel(h3("Installation"),
                 p("Shiny is available on CRAN, so you can install it
                 the usual way for R console"),
                 code('install.packages("shiny")'),br(),br(),
                 p(
                 img(src="bigorb.png", height = 40, width = 40),
                HTML("shiny is a product of"),
                span("RStudio", style = "color:blue"))),
    mainPanel(
      h2("Introducing Shiny"),
      p("Shiny is a new package from RStudio that makes it",
        em("incredibly"),
        "easy to build web applications with R."),br(),
      p("For an introduction and live examples, visit the",
        a(href="shiny.rstudio.com", "shiny homepage.")),
      br(),p(),br(),h2("Features"),tags$ul(tags$li("Build useful
      web applications with only a few lines of code---no javascript
      required"),tags$li('Shiny applications are automatically "live"
      in the same way that',span("spreadsheets"), "are live.  Outputs
      change instantly as users modify inputs, without requiring a
      reload of the browser."))
    )
  )
))
