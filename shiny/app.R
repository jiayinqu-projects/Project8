library(shiny)
library(DT)

ui <- fluidPage(
   
   titlePanel("week9_shiny"),
   
   sidebarLayout(
      sidebarPanel(
         selectInput("gender",
                     "Select gender",
                     c("All", levels(for_shiny_tbl$gender)), 
                     selected = "All"),
         checkboxInput("partTime", "Exclude data before August 1, 2017", FALSE)
      ),
      
      mainPanel(
         plotOutput("scatterplot"),
         DT::dataTableOutput("table")
      )
   )
)

server <- function(input, output) {
  filtered_data <- reactive({
    for_shiny_tbl <- readRDS("for_shiny.rds")
    
    if(!input$partTime && input$gender != "All"){
      for_shiny_tbl <- subset(for_shiny_tbl, 
                              for_shiny_tbl$gender %in% input$gender)
    }else if(input$partTime && input$gender == "All"){
      for_shiny_tbl <- subset(for_shiny_tbl, 
                              for_shiny_tbl$timeEnd >= as.POSIXct("2017-08-01"))
    }else if(input$partTime && input$gender != "All"){
      for_shiny_tbl <- subset(for_shiny_tbl, 
                              for_shiny_tbl$timeEnd >= as.POSIXct("2017-08-01") & 
                                for_shiny_tbl$gender %in% input$gender)
    }
    for_shiny_tbl
  })
  
  output$scatterplot <- renderPlot({
    data <- filtered_data()
    ggplot(data, aes(xMean, yMean)) + 
      geom_point() + 
      labs(x = "mean score of Q1 - Q5", y = "mean score of Q6 - Q10")
  })
  
  output$table <- DT::renderDataTable({
    data <- filtered_data()
    data
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

