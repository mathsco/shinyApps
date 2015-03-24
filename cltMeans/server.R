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
  output$distPlot <- renderPlot({
    histogram(~ppln(), n=25, col = 'red', border = 'white',
              xlab="x values", main="Population")
  })
  manyXBars <- reactive({
    do(2000) * mean(~ resample(ppln(), input$num))
  })
  output$nullDistPlot <- renderPlot({
    histogram(~result, data=manyXBars(), n=50, col = 'skyblue',
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
    paste("The bootstrapped approximate standard error is ",
          approxStdErr)
  })
  output$text2 <- renderText({
    actualStdErr <- round(sd(ppln())/sqrt(input$num), digits=4)
    paste("The true standard error is ", actualStdErr)
  })
  
})
