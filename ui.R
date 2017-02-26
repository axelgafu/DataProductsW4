#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# http://www.stat.umn.edu/geyer/old/5101/rlook.html
PROBABILITY_DISTRUBUTIONS<-c(
  "Normal", "Beta", "Binomial", "Cauchy", "Exponential", 
  "Poisson")

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Central Limit Theorem Tester"),
  a(href="http://rpubs.com/axelg/253810", "See Documentation here"),
  p(" and description of what the central limit theorem is "),
  a(href="https://www.khanacademy.org/math/statistics-probability/sampling-distributions-library/sample-means/v/central-limit-theorem", "here"),
  p("Data is expected to concentrate towards the mean as sample size increases. Move the sliders to see the effect of the central limit theorem"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      h4("Sample Controls"),
      sliderInput("bins",
                  "Number of Samples:",
                  min = 1,
                  max = 10000,
                  value = 50,
                  animate=TRUE),
      sliderInput("ssize",
                  "Sample Size:",
                  min = 1,
                  max = 1000,
                  value = 1,
                  animate=TRUE),
      
      br(), h4("Plot Controls"),
      numericInput("height", "Plot Height (px)", value = 1500),
    
      br(), h4("Chose Probability distributions to Compare"),
      wellPanel(
      checkboxGroupInput(
        "choices",
        "Probability Distributions",
        choices=PROBABILITY_DISTRUBUTIONS,
        selected=c("Normal", "Poisson")))),
      #https://www.khanacademy.org/math/statistics-probability/sampling-distributions-library/sample-means/v/central-limit-theorem

    # Show a plot of the generated distribution
    mainPanel(
      uiOutput("plot.ui")
    )
  )
))


