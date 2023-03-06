# Define server
server <- function(input, output) {
  
  library(tidyverse)
  
  #load data
  rrdata <- read_csv("Rail_Equipment_Accident_Incident_Data.csv", col_types = cols("Persons Evacuated" = col_character(), "Total Injured Form 54" = col_character()))
  #problems(rrdata)
  
  #add new columns for numberic data with commas in it
  rrdata <- rrdata %>%
    mutate("Persons Evacuated Int" = as.integer(gsub(",","", rrdata$`Persons Evacuated`)),"Total Injured Form 54 Int" = as.integer(gsub(",","", rrdata$`Total Injured Form 54`)))
  
  output$dataInfo <- renderPrint({
    summary(rrdata)
  })
  
  #calc the number of rows and columns and their output functions
  nrow <- nrow(rrdata)
  output$nrow <- renderText(paste("The number of rows is:", nrow))
  ncol <- ncol(rrdata)
  output$ncol <- renderText(paste("The number of columns is:", ncol))
  
  #get some data to display with output function
  sample_data <- rrdata[sample(nrow(rrdata), 10), ]
  output$sample_table <- renderTable(sample_data, options = list(scrollX = TRUE, scrollY = "300px"))
  
  #get the list of accident types to show in the ui checkbox list
  accidentTypes <- reactive({
    if (is.null(input$accidentTypes)) {
      # Return all types if none selected
      unique(rrdata$`Accident Type`)
    } else {
      # Return only the selected types
      input$accidentTypes
    }
  })
  output$accidentcheckboxes <- renderUI({
    checkboxGroupInput("accidentcheckboxes", "Select Accident Types:", choices = accidentTypes())
  })
  
  # Create a reactive expression for the filtered data
  filteredData <- reactive({
    rrdata %>% filter(`Accident Type` %in% selectedTypes())
  })
  
  # Create a reactive expression for the plot data
  plotData <- reactive({
    filteredData() %>% 
      mutate(year = substr(Date,nchar(Date)-3,nchar(Date))) %>%
      group_by(year, `Accident Type`) %>% 
      summarise(n = n()) %>% 
      filter(`Accident Type` %in% selectedTypes()) %>%
      arrange(year)
  })
  
  # Render the plot
  output$accidentPlot <- renderPlot({
    ggplot(plotData, aes(year, n, color = `Accident Type`)) +
      geom_line(aes(group=`Accident Type`)) +
      xlab("Year") +
      ylab("Number of Accidents") +
      ggtitle("Accidents Over Time") +
      theme(plot.title = element_text(hjust = 0.5))
  })
  
  # Render table
  output$mytable <- renderTable({
    head(data)
  })
}

