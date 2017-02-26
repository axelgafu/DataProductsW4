#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
set.seed(2017-02-23)

# Creates the chart object.
#-------------------------------------------------------------------------------
chart <- function(x, titlePlot, xlab)
{
  #main=paste(input$bins, " ", titlePlot, "\nSample Size=",input$ssize))
  hist(x,  freq = FALSE, col = 'darkgray',
       border = 'white', 
       main=titlePlot,
       xlab=xlab)
  lines(density(x), col="red")
  legend("topright", c("Frequency", "Density"), fill=c("darkgray", "red"))
}



# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  #-------------------------------------------------------------------------------
  plot_data <- reactiveValues(
    xnorm=1, xbeta=1, xbino=1, xcauc=1, xexp=1, xpois=1,
    minimum=0, maximum=0, bins=1,
    norm_distx=0)
  
  
  #-------------------------------------------------------------------------------
  observe({
    plot_data$xnorm <- ctlvals(rnorm(input$bins*input$ssize, mean   = 1, sd=5))
    plot_data$xbeta <- ctlvals(rbeta(input$bins*input$ssize, shape1 = 1, shape2=2))
    plot_data$xbino <- ctlvals(rbinom(input$bins*input$ssize,prob   = 0.5, size=input$bins*input$ssize/0.5))
    plot_data$xcauc <- ctlvals(rcauchy(input$bins*input$ssize,location = 1))
    plot_data$xexp  <- ctlvals(rexp (input$bins*input$ssize, rate   = 1))
    plot_data$xpois <- ctlvals(rpois(input$bins*input$ssize, lambda = 1))
    
    plot_data$minimun = min(plot_data$xnorm, plot_data$xexp, plot_data$xpois,
                            plot_data$xbino, plot_data$xcauc,plot_data$xbeta)
    plot_data$maximum = max(plot_data$xnorm, plot_data$xexp, plot_data$xpois,
                            plot_data$xbino, plot_data$xcauc,plot_data$xbeta)
    
    plot_data$bins <- seq(plot_data$minimun, plot_data$maximum, 
                          length.out = log10(plot_data$maximum))
    
    plot_data$norm_distx=seq(-4, 4, length=input$bins) * 5 + 1
    plot_data$norm_disty=dnorm(plot_data$xnorm,mean=1, sd=5)
    
    plot_data$ssize <- input$ssize
  })
  
  # Generate final samples based on the dataset passed as parameter
  #-------------------------------------------------------------------------------
  ctlvals <- function(dataset)
  {
    finalSamples <- rowMeans(matrix(dataset, input$bins, input$ssize))
  }
  
  # Generates the output plot based on the user selections
  #-------------------------------------------------------------------------------
  output$plot <- renderPlot({
    par( mfrow=c(6,1) )
    
    if("Normal" %in% input$choices)
    {
      chart(plot_data$xnorm, "Normal", "mean = 1; sd=5")
    }
    if("Beta" %in% input$choices)
    {
      chart(plot_data$xbeta, "Beta", "shape1 = 1; shape2=2" )
    }
    if("Binomial" %in% input$choices)
    {
      chart(plot_data$xbino, "Binomial", "prob = 0.5; size=num_of_samples*sample_size/0.5" )
    }
    if("Cauchy" %in% input$choices)
    {
      chart(plot_data$xcauc, "Cauchy", "location = 1" )
    }
    if("Exponential" %in% input$choices)
    {
      chart(plot_data$xexp, "Exponential", "rate = 1")
    }
    if("Poisson" %in% input$choices)
    {
      chart(plot_data$xpois, "Poisson", "lambda = 1")
    }
  })
  
  #
  # Performs chart rendering with a dynamic heigh.
  #
  # References: 
  # - http://stackoverflow.com/questions/22408144/r-shiny-plot-with-dynamical-size
  #-------------------------------------------------------------------------------
  output$plot.ui <- renderUI({
    plotOutput("plot", height = input$height)
  })
  
})
