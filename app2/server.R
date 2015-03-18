#server.R
library(shiny)
N = 30
x = sort(runif(N, 0, 10)); y = x + rnorm(N)
xval=NULL
yval=NULL
checker <- 1 #### CHANGE

shinyServer(function(input, output) {
get.coords <- reactive({
    data.frame(x=input$coords$x, y=input$coords$y)
})

actiontype <- reactiveValues()
actiontype$lastAction <- 'draw'

observe({
    if (input$reset != 0)
        actiontype$lastAction <- 'reset'
})
observe({
    if (input$closepolygon != 0)
        actiontype$lastAction <- 'closepolygon'
})

output$diagPlot = renderPlot({
    plot(x, y, xlim = range(x), ylim = range(y))
    grid()

    if (identical(actiontype$lastAction, 'reset')) {
        xval <<- NULL
        yval <<- NULL
        checker <<- 0 ####CHANGE
        actiontype$lastAction <- 'draw'

    } else if (identical(actiontype$lastAction, 'draw')){
        temp <- get.coords()
        xval <<- c(xval,temp$x)
        yval <<- c(yval,temp$y)

        ########### CHANGE...
        if(identical(checker, 0))
         {
           points(xval, yval, pch = 19, col = rgb(1,0,0,0), cex = 1.5)
           xval <<- NULL
           yval <<- NULL
           checker <<- 1
         }else
         {
          points(xval, yval, pch = 19, col = 'red', cex = 1.5)
         }
        ############# ...CHANGE

        for (i in 1:(length(xval)-1))
             lines(c(xval[i],xval[i+1]),c(yval[i],yval[i+1]),type="l",col="blue")
        if(identical(actiontype$lastAction, 'closepolygon'))
       lines(c(xval[1],xval[length(xval)]),c(yval[1],yval[length(yval)]),
              type="l",col="blue")
    }
}, width = 700, height = 600)
})