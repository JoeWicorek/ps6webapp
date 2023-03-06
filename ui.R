# Load required libraries
library(shiny)
library(ggplot2)

# Define UI
ui <- fluidPage(
  
  # Application title
  titlePanel("Railroad Accident & Incident App"),
  
  # Create tabset with three tabs
  tabsetPanel(
    
    # First tab - general information
    tabPanel("General Info",
            h1("Railroad Accident & Incident Data"),
            p("Safety data related to Railway Equipment Failures and Accidents"),
            a("https://www.kaggle.com/datasets/chrico03/railroad-accident-and-incident-data"),
            p("Dataset published by the Federal Railroad Administration, Office of Railroad Safety; contains data on railway incidents from 1975 to 2022."),
            p("Includes data on:"),
            tags$ul(
              tags$li("Railway company involved"),
              tags$li("Hazmat cars involved"),
              tags$li("Number of people evacuated"),
              tags$li("Number of employees on-duty")
            ),
            textOutput("nrow"),
            textOutput("ncol"),
            strong("Sample data"),
            tags$div(style="height: 600px; overflow-x: scroll; width: 1600px; overflow-y: scroll;", tableOutput("sample_table"))),
    # Second tab - plot
    tabPanel("Plot",
             sidebarLayout(
               sidebarPanel(
                 uiOutput("accidentcheckboxes")
               ),
               mainPanel(
                 plotOutput("accidentPlot")
               )
             )
          ),
    
    # Third tab - table
    tabPanel("Table",
             tableOutput("mytable"))
  )
)
