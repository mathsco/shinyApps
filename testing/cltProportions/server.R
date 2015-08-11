require(mosaic)

shinyServer(function(input, output) {
  
  # Expression that generates a histogram. The expression is
  # wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should re-execute automatically
  #     when inputs change
  #  2) Its output type is a plot
  
  manyPHats <- reactive({
    myfreq = round(10000*dbinom(0:input$num,input$num,input$true.p))
    myres = c()
    for (ii in 0:input$num) {
      myres = c(myres, rep(ii/input$num, myfreq[ii+1]))
    }
    myres
  })
  output$distPlot <- renderPlot({
    binWidth = 1/input$num
    histogram(~manyPHats(), width=binWidth,
              col = 'skyblue', border = 'white', fit="normal",
              xlab=expression(paste(hat(p), " values")),
              main=expression(paste("Sampling distribution of ", hat(p))))
  })
  output$qqPlot <- renderPlot({
    qqmath(~manyPHats(), xlab="qnorm values", pch=19, cex=.4,
           ylab=expression(paste(hat(p), " values")),
           main="Quantile-quantile plot of sampling dist.")
  })
  output$text1 <- renderText({
    approxStdErr <- round(sd(manyPHats()), digits=4)
    paste("The bootstrapped approximate standard error is ",
          approxStdErr)
  })
  output$text2 <- renderText({
    stdErr <- round(sqrt(input$true.p*(1-input$true.p)/input$num), digits=4)
    paste("The true standard error is ", stdErr)
  })
  
})
