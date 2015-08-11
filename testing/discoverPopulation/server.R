require(mosaic)

shinyServer(function(input, output) {
  
  # Expression that generates a histogram. The expression is
  # wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should re-execute automatically
  #     when inputs change
  #  2) Its output type is a plot
  
  samp <- reactive({
    input$action
    switch(input$dist, 
           dist1 = rweibull(input$num,shape=1.5,scale=8),    # Weibull population
           dist2 = c(rexp(input$num/2,0.27),rnorm(input$num/2,13,2)),  # bimodal population
           dist3 = runif(input$num, 9,26.5))       # uniform population
  })
  output$distPlot <- renderPlot({
    x <- samp()
    bins <- seq(min(x), max(x), length.out = 25)
    
    # draw the histogram with the specified number of bins
    avg <- round(mean(samp()), digits=2)
    stddev <- round(sd(samp()), digits=2)
    med <- round(median(samp()), digits=2)
    intQR <- round(iqr(samp()), digits=3)
    infos <- NULL
    infos <- c(infos, "Mean: ", avg)
    infos <- c(infos, "Std.Dev.: ", stddev)
    infos <- c(infos, "Median: ", med)
    infos <- c(infos, "IQR: ", intQR)
    histogram(~x, breaks = bins, col = 'skyblue', border = 'white',
              v=c(mean(x),median(x)), main=list(label=infos, cex=1.2))
  })
  output$text1 <- renderText({
    avg <- round(mean(samp()), digits=2)
    stddev <- round(sd(samp()), digits=2)
    med <- round(median(samp()), digits=2)
    intQR <- round(iqr(samp()), digits=2)
    paste("The sample has mean ", avg, " standard deviation ", stddev,
          " median ", med, " and IQR ", intQR)
  })
  
})
