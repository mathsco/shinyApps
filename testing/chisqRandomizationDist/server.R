require(mosaic)
require(latticeExtra)

shinyServer(function(input, output) {
  
  # Expression that generates a histogram. The expression is
  # wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should re-execute automatically
  #     when inputs change
  #  2) Its output type is a plot
  
  obsCnts <- reactive({ 
    input$action
    eval(parse(text=input$obs))
    })
  nullProbs <- reactive({ 
    input$action
    eval(parse(text=input$nullProbs))
    })
  expCnts <- reactive({ 
    input$action
    nullProbs() * sum(obsCnts())
  })

  manyChisqStats <- reactive({
    enn = sum(obsCnts())
    bag = c(1:length(obsCnts()))
    chisqStats = c()
    for (jj in 1:3000) {
      myRes = sample(bag, size=enn, replace=TRUE, prob=nullProbs())
      thisRun = c()
      for (kk in bag) {thisRun = c(thisRun, sum(myRes==kk))}
      newChisqStat = sum((thisRun - expCnts())^2 / expCnts())
      chisqStats = c(chisqStats, newChisqStat)
    }
    chisqStats
  })
  
  manyModStats <- reactive({
    enn = sum(obsCnts())
    bag = c(1:length(obsCnts()))
    modStats = c()
    for (jj in 1:3000) {
      myRes = sample(bag, size=enn, replace=TRUE, prob=nullProbs())
      thisRun = c()
      for (kk in bag) {thisRun = c(thisRun, sum(myRes==kk))}
      newModStat = sum(abs(thisRun - expCnts()))
      modStats = c(modStats, newModStat)
    }
    modStats
  })
  
  output$distPlot <- renderPlot({
    enn = sum(obsCnts())
    ourChisqStat = sum((obsCnts() - expCnts())^2 / expCnts())
    plota <- histogram(~manyChisqStats(), v=ourChisqStat, n=40,
              groups=(manyChisqStats()>=ourChisqStat),
              col = 'skyblue', border = 'white',
              xlab=expression(paste(chi^2, " values")),
              main=expression(paste("Randomization distribution of ", chi^2)))
    mydfs = length(obsCnts()) - 1
    myChisqPDF <- function(x) {dchisq(x,mydfs)}
    plotb = plotFun(myChisqPDF(x)~x, lwd=2)
    plota + as.layer(plotb)
  })
  
  output$distPlot2 <- renderPlot({
    ourModStat = sum(abs(obsCnts() - expCnts()))
    histogram(~manyModStats(), v=ourModStat, n=40,
                       groups=(manyModStats()>=ourModStat),
                       col = 'skyblue', border = 'white',
                       xlab="NSS values",
                       main="Randomization distribution of NSS")
  })
  
  output$text1 <- renderText({
    ourChisqStat = round(sum((obsCnts()-expCnts())^2/expCnts()),digits=4)
    paste("The data has chi-square statistic ",
          ourChisqStat)
  })
  output$text2 <- renderText({
    ourChisqStat = sum((obsCnts() - expCnts())^2 / expCnts())
    myP = prop(~(manyChisqStats() >= ourChisqStat))
    approxPval <- round(myP, digits=4)
    paste("The approximate P value (area in pink region): ", approxPval)
  })
  output$text3 <- renderText({
    binCnt = length(obsCnts())
    ourChisqStat = sum((obsCnts() - expCnts())^2 / expCnts())
    thP = 1 - pchisq(ourChisqStat, df=binCnt-1)
    approxPval <- round(thP, digits=4)
    paste("The P value based on chi-square distribution (blue curve): ",
          approxPval)
  })
  output$text4 <- renderText({
    ourModStat = sum(abs(obsCnts() - expCnts()))
    ourModStat <- round(ourModStat, digits=4)
    paste("The NSS for sample data: ", ourModStat)
  })
  output$text5 <- renderText({
    ourModStat = sum(abs(obsCnts() - expCnts()))
    approxPval <- prop(~(manyModStats() >= ourModStat))
    approxPval <- round(approxPval, digits=4)
    paste("The approximate P value (based on NSS distribution): ",
          approxPval)
  })
  output$table <- renderTable(data.frame(expectedCounts=expCnts()))
})
