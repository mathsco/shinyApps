# By default, the file size limit is 5MB. It can be changed by
# setting this option. Here we'll raise limit to 9MB.
require(shiny)
require(mosaic)
require(Lock5withR)
require(latticeExtra)
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
             "iris"=iris,
             "SandwichAnts"=SandwichAnts,
             "StudentSurvey"=StudentSurvey,
             "HollywoodMovies2011"=HollywoodMovies2011,
             "LightatNight"=LightatNight,
             "FishGills3"=FishGills3)
    }
  })
  sampleFval <- reactive({
    input$explVar
    anova(lm(eval(as.name(input$respVar)) ~ eval(as.name(input$explVar)), data=dFrame()))[["F value"]][1]
  })
  manyFvals <- reactive({
    do(2000) * (anova(lm(eval(as.name(input$respVar)) ~ shuffle(eval(as.name(input$explVar))), data=dFrame()))[["F value"]][1])
  })

  output$contents <- renderTable({ dFrame() })
  output$grpPlots <- renderPlot({
    plot(eval(as.name(input$respVar)) ~ eval(as.name(input$explVar)), data=dFrame(), xlab="", ylab="")
  })
  output$randDistPlot <- renderPlot({
    #sampleFval <- anova(lm(eval(as.name(input$respVar)) ~ eval(as.name(input$explVar)), data=dFrame()))[["F value"]][1]
    plotA <- histogram(~result, data=manyFvals(),
                       v=sampleFval(), n=40,
                       groups=(result>=sampleFval()),
                       xlab="Randomized F-statistics")
    grpsCnt <- dim(xtabs(~eval(as.name(input$explVar)), data=dFrame()))
    dfNum <- grpsCnt - 1
    dfDen <- dim(dFrame())[1] - grpsCnt
    myFpdf <- function(x) {df(x,dfNum,dfDen)}
    plotB = plotFun(myFpdf(x)~x, lwd=2)
    plotA + as.layer(plotB)
  })
  output$text <- renderUI({
    sampleFval = anova(lm(eval(as.name(input$respVar)) ~ eval(as.name(input$explVar)), data=dFrame()))[["F value"]][1]
    approxPval = sum(manyFvals()$result >= sampleFval) / 2000
    grpsCnt <- dim(xtabs(~eval(as.name(input$explVar)), data=dFrame()))
    dfNum <- grpsCnt - 1
    dfDen <- dim(dFrame())[1] - grpsCnt
    modelPval = 1 - pf(sampleFval, dfNum, dfDen)
    
    str1 <- paste("The data has F statistic: ", round(sampleFval,digits=4))
    str2 <- paste("The approximate P-value is ", round(approxPval,digits=4))
    str3 <- paste("The P value from approximating F distribution (area
                  under blue curve): ", round(modelPval,digits=4))
    HTML(paste(str1, "<br/>", str2, "<br/> &nbsp; <br/>", str3))
  })
  output$anovaResult <- renderPrint({
    anova(lm(eval(as.name(input$respVar)) ~ eval(as.name(input$explVar)), data=dFrame()))
  })
  output$tukeyHSDResult <- renderPrint({
    TukeyHSD(aov(eval(as.name(input$respVar)) ~ eval(as.name(input$explVar)), data=dFrame()))
  })

})