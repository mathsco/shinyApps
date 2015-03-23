require(mosaic)

shinyServer(function(input, output) {
  
  # Expression that generates a histogram. The expression is
  # wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should re-execute automatically
  #     when inputs change
  #  2) Its output type is a plot
  
  manyTries <- reactive({
    do(5000) * rflip(input$num, prob=input$true.p)
  })
  output$distPlot <- renderPlot({
    binWidth = 1/input$num
    histogram(~prop, data=manyTries(), width = binWidth, col = 'skyblue',
              border = 'white', fit="normal")
  })
  output$qqPlot <- renderPlot({
    qqmath(~prop, data=manyTries())
  })
  output$text1 <- renderText({
    approxStdErr <- round(sd(~prop,data=manyTries()), digits=4)
    paste("The bootstrapped approximate standard error is ",
          approxStdErr)
  })
  output$text2 <- renderText({
    stdErr <- round(sqrt(input$true.p*(1-input$true.p)/input$num), digits=4)
    paste("The true standard error is ", stdErr)
  })
  
})
