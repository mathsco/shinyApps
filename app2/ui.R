library(shiny)

shinyUI(pageWithSidebar(

headerPanel('iPED: The interactive ChIP-PED analysis platform'),

sidebarPanel(
    helpText("graph"),
    actionButton('closepolygon', 'Close the Polygon'),
    actionButton('reset', 'Reset')
),

mainPanel(
    plotOutput('diagPlot', clickId="coords", height="auto", width="100%")
)
))