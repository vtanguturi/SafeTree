library(shiny)
library(dplyr)
library(plotly)
library(csvread)
library(randomForest)
library(party)
set.seed(400)

source("random_forest.R")
df <- read.csv("~/PATH TO data_grouped.csv",header = TRUE,
               colClasses = c("integer", "character","character","character","character","character","numeric","character"))
industry <- unique(df$industry)
predictors <- unique(df$predictor)

ui <- fluidPage(theme = "bootstrap.css",
  
  # Application title
  titlePanel("SafeTree: Workplace Injury Data Visualization and Prediction Tool"),
  
  tabsetPanel(
    tabPanel("National Average Days Away From Work",
             sidebarLayout(position = "right",
                           sidebarPanel(tags$head(tags$style(type="text/css", "#loadmessage {
               position: fixed;
               top: 0px;
               left: 0px;
               width: 100%;
               padding: 5px 0px 5px 0px;
               text-align: center;
               font-weight: bold;
               font-size: 100%;
               color: #000000;
               background-color: #ADD8E6;
               z-index: 105;
             }
          ")),tags$style(type="text/css",
                         ".shiny-output-error { visibility: hidden; }",
                         ".shiny-output-error:before { visibility: hidden; }"
          ),
                             selectInput("Industry",label = "Select Industry",
                                         choices = industry,
                                         selected = "Accommodation and Food Services"),
                             selectInput("Predictor", label = "Select Predictor",
                                         choices = predictors,
                                         selected = "Age"),
                             uiOutput("valueSelection"),
                             conditionalPanel(condition="$('html').hasClass('shiny-busy')",
                                              tags$div("Loading...",id="loadmessage"))
                           ),
                             mainPanel(plotlyOutput("map"),height = 6)
                           #tableOutput("values")
             )
    ),
    tabPanel("Days Away From Work Prediction Tool",
             sidebarLayout(position = "left",
                           sidebarPanel(
                             selectInput("Industry2",label = "Select Industry",
                                         choices = industry,
                                         selected = "Accommodation and Food Services"),
                             selectInput("Predictor2", label = "Select Predictor",
                                         choices = predictors,
                                         selected = "Age"),
                             uiOutput("valueSelection2"),
                             sliderInput("ntrees","Select Number of Trees",min = 100,max = 1000,
                                         value = 1000,step = 100),
                             uiOutput("mtry"),
                             conditionalPanel(condition="$('html').hasClass('shiny-busy')",
                                              tags$div("Loading...",id="loadmessage"))
                           ),
                           mainPanel(verticalLayout(htmlOutput("prediction"),
                                                    verbatimTextOutput("rf"),
                                                    plotOutput("error_plot"),
                                                    plotOutput("imp_plot")))
             )
    )
  ))


server <- function(input, output) {
  
  #Update Value select box
  output$valueSelection <- renderUI({
    selectInput("Value","Select Attribute",choices = unique(df[df$industry == input$Industry & df$predictor == input$Predictor,]$attribute),
                selected = "16-19")
  })
  
  output$valueSelection2 <- renderUI({
    selectInput("Value2","Select Attribute",choices = unique(df[df$industry == input$Industry2 & df$predictor == input$Predictor2,]$attribute),
                selected = "16-19")
  })
  
  output$mtry <- renderUI({
    sliderInput("mtry","Select No. of Variables Sampled",min=1,max=length(unique(df[df$industry == input$Industry2 & df$predictor == input$Predictor2,]$attribute))-1,
                                                                          value=length(unique(df[df$industry == input$Industry2 & df$predictor == input$Predictor2,]$attribute))-1,
                                                                                       step = 1)
  })
  
  filteredData <- reactive({
    df.filter <-  df %>% filter(industry == input$Industry, predictor == input$Predictor,attribute == input$Value) #%>%
    
  })
  
  rf_output <- reactive({safeTree_predict(input$Industry2, input$Predictor2, input$Value2,input$ntrees,input$mtry)})
  
  output$error_plot <- renderPlot({plot(rf_output()$rf,main="Error Plot for Random Forest Regression"
                                      )})
  output$imp_plot <- renderPlot({varImpPlot(rf_output()$rf,main="Variable Importance Plot")})
  
  output$prediction <- renderText(paste("<font size=\"5\">","The predicted days away from work is: ","</font>","<font size=\"5\"><b>",round(rf_output()$prediction,3),"</b></font>",sep=""))
  
  output$rf <- renderText(print(rf_output()$rf))
    
  output$map <- renderPlotly({
    
    l <- list(color = toRGB("white"), width = 2)
    
    g <- list(
      scope = 'usa',
      projection = list(type = 'albers usa'),
      showlakes = TRUE,
      lakecolor = toRGB('white')
    )
    
    plot_geo(filteredData(), locationmode = 'USA-states') %>%
      add_trace(
        z = ~average, text = ~hover, locations = ~state_code,
        color = ~average, colors = 'YlOrRd'
      ) %>%
      colorbar(title = "Days") %>%
      layout(margin = list(t=105),height = 500,
        title = 'Median DAFW By State<br>(Hover for breakdown)',
        geo = g
      )
    
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)

