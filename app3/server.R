# server.R
library(shiny)
library(ggvis)

runApp(list(ui = pageWithSidebar(
  div(),
  sidebarPanel(
    sliderInput("n", "Number of points", min = 1, max = nrow(mtcars),
                value = 10, step = 1),
    uiOutput("plot_ui")
  ),
  mainPanel(
    ggvisOutput("plot"),
    tableOutput("mtc_table")
  )
)
, server= function(input, output, session) {
  # A reactive subset of mtcars
  mtc <- reactive({
    data = mtcars[1:input$n, ]
    data$long = as.character(paste0("A car with ",data$cyl," cylinders and ",data$gear," gears and ",data$carb, " carburators"))
    data
  })
  # A simple visualisation. In shiny apps, need to register observers
  # and tell shiny where to put the controls
  mtc %>%
    ggvis(~wt, ~mpg, key:= ~long) %>%
    layer_points(fill = ~factor(long)) %>%
    add_tooltip(function(data){
      paste0("Wt: ", data$wt, "<br>", "Mpg: ",as.character(data$mpg), "<br>", "String: ", as.character(data$long))
    }, "hover") %>%
    bind_shiny("plot", "plot_ui")

  output$mtc_table <- renderTable({
    mtc()[, c("wt", "mpg", "long")]
  })
})
)