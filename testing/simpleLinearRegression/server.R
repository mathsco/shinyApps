# By default, the file size limit is 5MB. It can be changed by
# setting this option. Here we'll raise limit to 9MB.
require(shiny)
require(mosaic)
require(Lock5withR)
require(latticeExtra)
require(datasets)
options(shiny.maxRequestSize = 9*1024^2)

shinyServer(function(input, output) {
  
  dFrame <- reactive({
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, it will be a data frame with 'name',
    # 'size', 'type', and 'datapath' columns. The 'datapath'
    # column will contain the local filenames where the data can
    # be found.

    if (input$datachoice == "user-imported") {
      inFile <- input$file1

      if (is.null(inFile))
        return(NULL)

      read.csv(inFile$datapath, header = input$header,
               sep = input$sep, quote = input$quote)
    } else {
      switch(input$datachoice,
             "faithful"=faithful,
             "InkjetPrinters"=InkjetPrinters,
             "RestaurantTips"=RestaurantTips,
             "StudentSurvey"=StudentSurvey,
             "NBAPlayers2011"=NBAPlayers2011,
             "FacebookFriends"=FacebookFriends,
             "FloridaLakes"=FloridaLakes,
             "HomesForSaleCA"=HomesForSaleCA,
             "SampCountries"=SampCountries,
             "NBAStandings"=NBAStandings,
             "AllCountries"=AllCountries,
             "Cereal"=Cereal,
             "WaterStriders"=WaterStriders)
    }
  })
  sampleStats <- reactive({
    input$explVar
    myCor <- cor(eval(as.name(input$respVar)) ~ eval(as.name(input$explVar)), data=dFrame())
    mySlope <- coefficients(lm(eval(as.name(input$respVar)) ~ eval(as.name(input$explVar)), data=dFrame()))[2]
    c(myCor, mySlope)
  })
  manyCors <- reactive({
    do(2000) * cor(eval(as.name(input$respVar)) ~ shuffle(eval(as.name(input$explVar))), data=dFrame())
  })
  manySlopes <- reactive({
    do(2000) * (coefficients(lm(eval(as.name(input$respVar)) ~ shuffle(eval(as.name(input$explVar))), data=dFrame()))[2])
  })
  
  output$contents <- renderTable({ dFrame() })
  output$scPlot <- renderPlot({
    if (input$bands) {
      xyplot(eval(as.name(input$respVar)) ~ eval(as.name(input$explVar)),
             data=dFrame(), panel=panel.lmbands, cex=.6,
             pch=19, alpha=.5)
    } else {
      plot(eval(as.name(input$respVar)) ~ eval(as.name(input$explVar)),
         data=dFrame(), pch=19, cex=.4, xlab="", ylab="")
      lm.mod = lm(eval(as.name(input$respVar)) ~ eval(as.name(input$explVar)), data=dFrame())
      abline(lm.mod, col="red")
    }
  })
  output$scPlotResids <- renderPlot({
    lm.mod = lm(eval(as.name(input$respVar)) ~ eval(as.name(input$explVar)), data=dFrame())
    xyplot(lm.mod$residuals ~ eval(as.name(input$explVar)),
           data=dFrame(), pch=19, cex=.4, xlab="x-values",
           ylab="residuals")
  })
  output$histResids <- renderPlot({
    lm.mod = lm(eval(as.name(input$respVar)) ~ eval(as.name(input$explVar)), data=dFrame())
    numPts = length(residuals(my.model))
    numBins = min(numPts/3, 20)
    histogram(~lm.mod$residuals,xlab="residuals",
              main="Histogram of residuals", n=numBins)
  })
  output$qqplotResids <- renderPlot({
    lm.mod = lm(eval(as.name(input$respVar)) ~ eval(as.name(input$explVar)), data=dFrame())
    qqmath(~lm.mod$residuals,main="QQ-plot of residuals",
           xlab="",ylab="")
  })
  output$residPlots <- renderPlot({
    lm.mod = lm(eval(as.name(input$respVar)) ~ eval(as.name(input$explVar)), data=dFrame())
    par(mfrow=c(2,2))
    plot(lm.mod)
  })
  output$corRandDistPlot <- renderPlot({
    mySampStats = sampleStats()
    myCor = mySampStats[1]
    histogram(~result, data=manyCors(),
              v=c(-myCor,myCor), n=40,
              groups=(abs(result)>=abs(myCor)),
              xlab="Randomized correlations")
  })
  output$slopeRandDistPlot <- renderPlot({
    mySlope = sampleStats()[2]
    rDist = manySlopes()[,1]
    histogram(~rDist,
              v=c(-mySlope,mySlope), n=40,
              groups=(abs(rDist)>=abs(mySlope)),
              xlab="Randomized LS-regression slopes")
  })
  output$text1 <- renderUI({
    myCor = sampleStats()[1]
    approxPval = sum(abs(manyCors()$result) >= abs(myCor)) / 2000
    str1 <- paste("The sample correlation is ",
                  round(myCor))
    str2 <- paste("For two-sided alternative to null ",
          HTML("&rho;=0"), " the approximate P-value is ",
          round(approxPval, digits=4))
    HTML(paste(str1, "<br/>", str2))
  })
  output$text2 <- renderUI({
    mySlope = sampleStats()[2]
    rDist = manySlopes()[,1]
    approxPval = sum(abs(rDist) >= abs(mySlope)) / 2000
    str1 <- paste("The slope is ",
                  round(mySlope))
    str2 <- paste("For two-sided alternative to null ",
          HTML("&beta;=0"), " the approximate P-value is ",
          round(approxPval, digits=4))
    HTML(paste(str1, "<br/>", str2))
  })
  output$lsRegOutput1 <- renderPrint({
    summary(lm(eval(as.name(input$respVar)) ~ eval(as.name(input$explVar)), data=dFrame()))
  })
  output$lsRegOutput2 <- renderPrint({
    anova(lm(eval(as.name(input$respVar)) ~ eval(as.name(input$explVar)), data=dFrame()))
  })
})