require(mosaic)

shinyServer(function(input, output) {
  
  # Expression that generates a histogram. The expression is
  # wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should re-execute automatically
  #     when inputs change
  #  2) Its output type is a plot
  
  ppln <- reactive({
    switch(input$dist,
           dist1 = rweibull(10000,shape=1.5,scale=8),    # Weibull population
           dist2 = c(rexp(5000,0.27),rnorm(5000,13,2)),  # bimodal population
           dist3 = runif(10000, 9,26.5))       # uniform population
  })
  pLims <- reactive({
    switch(input$dist,
           dist1 = c(0,25),    # Weibull population
           dist2 = c(0,18),  # bimodal population
           dist3 = c(8.5,27))       # uniform population
  })
  output$distPlot <- renderPlot({
    histogram(~ppln(), col = 'red', border = 'white',
              xlab="x values", main="Population",
              xlim=pLims(), n=25)
  })
  manyXBars <- reactive({
    do(2000) * mean(~ resample(ppln(), input$num))
  })
  output$nullDistPlot <- renderPlot({
    histogram(~result, data=manyXBars(), col = 'skyblue',
              xlim=pLims(), n=50,
              border = 'white', fit="normal", xlab="x-bar values",
              main="Approx. sampling distribution for sample means")
  })
  output$qqPlot <- renderPlot({
    qqmath(~result, data=manyXBars(), xlab="Normal quantile",
           pch=19, cex=0.4,
           ylab=expression(paste(bar(x), " values")),
           main="Quantile-quantile plot of sampling dist.")
  })
  output$text1 <- renderText({
    approxStdErr <- round(sd(~result,data=manyXBars()), digits=4)
    paste("The standard deviation of the approx. sampling dist. is ",
          approxStdErr)
  })
  output$text2 <- renderText({
    actualStdErr <- round(sd(ppln())/sqrt(input$num), digits=4)
    paste("The true standard error is ", actualStdErr)
  })
  
})
