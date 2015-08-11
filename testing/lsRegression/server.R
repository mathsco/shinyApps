shinyServer(function(input, output) {
  
  # Expression that generates a histogram. The expression is
  # wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should re-execute automatically
  #     when inputs change
  #  2) Its output type is a plot
  
  x <- runif(30,6,15)
  y <- 13.8 + 1.87*x + rnorm(30,0,1.9)
  
  output$scatterPlot <- renderPlot({
    a <- input$yintcpt
    b <- input$slope
    plot(x, y, pch=19, cex=.6, ylim=c(min(y)-3, max(y)+3))
    abline(a, b, col="blue")
    for (jj in 1:length(x)) {
      predVal = a + b * x[jj]
      lines(rep(x[jj], 2), c(y[jj], predVal))
    }
  })
  
  output$text1 <- renderText({
    a <- input$yintcpt
    b <- input$slope
    ssr = 0
    for (jj in 1:length(x)) {
      predVal = a + b * x[jj]
      ssr = ssr + (predVal - y[jj])^2
    }
    SSR <- round(ssr, digits=2)
    paste("The sum of squared residuals is", SSR)
  })
  
})
