# Data Story 5: data collection app for Bi Boo tree measurements

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(shiny)
library(lubridate)
library(DT)

# Function for saving data to a CSV file
log_line <- function(newdata, filename = 'app_data.csv'){
  (dt <- Sys.time() %>% round %>% as.character)
  (newline <- c(dt, newdata) %>% paste(collapse = ',') %>% paste0('\n'))
  cat(newline, file = filename, append = TRUE)
  print('Data stored!')
}

#measurements <- read.csv(file.choose())

################################################################################
################################################################################

ui <- fluidPage(
  titlePanel(h4("Forest Data Entry App")),
  br(),
  tabsetPanel(
    tabPanel(h4("Entry"),
             br(),
             br(),
             fluidRow(
               column(4, selectInput('site',
                                     label = 'Site',
                                     choices = c('control forest', 'OSS dump', 'breakfield dump'),
                                     width = '95%')),
               
               column(4, numericInput('point',
                                      label = 'Point',
                                      value = 1, 
                                      min = 1, 
                                      max = 100,
                                      width = '95%')),
               
               column(4, textInput('basal_area',
                                   label='Basal area',
                                   value='enter basal area',
                                   width = '95%'))),
             br(),
             br(),
             fluidRow(
               column(4, radioButtons('quadrant',
                                      label = 'Quadrant',
                                      choices = c('NW', 'SW', 'SE', 'NE'),
                                      inline = TRUE,
                                      width = '95%')), 
               
               column(4, radioButtons('size_class',
                                      label = 'Size class',
                                      choices = c('small', 'large'),
                                      inline = TRUE,
                                      width = '95%'))),
             br(),
             br(),
             fluidRow(
               column(4, textInput('distance',
                                   label='Distance (m)',
                                   value='enter distance',
                                   width = '95%')),
               
               column(4, textInput('dbh',
                                   label='DBH (cm)',
                                   value='enter dbh',
                                   width = '95%')),
               
               column(4, textInput('species',
                                   label = 'Species',
                                   value='enter species',
                                   width = '95%'))),
             br(),
             br(),
             fluidRow(
               column(12, textInput('comments',
                                    label='Comments',
                                    value='n/a',
                                    width = '95%'))),
             br(),
             br(),
             fluidRow(column(2),
                      # Save button!
                      column(8, actionButton('save',
                                             h2('Save'),
                                             width='100%')),
                      column(2))
    ),
    
    tabPanel(h4("Raw Data"),
             fluidRow(column(12, 
                             DTOutput("datatable")))),
    
  )
)

################################################################################
################################################################################

server <- function(input, output) {
  
  rv <- reactiveValues()
  rv$mr <- read.csv('tree_data.csv', header = TRUE)
  
  # Save button ================================================================
  observeEvent(input$save, {
    newdata <- c(input$site, input$point, input$basal_area, input$quadrant, 
                 input$size_class, input$distance, input$dbh, input$species, 
                 input$comments)
    log_line(newdata)
    rv$mr <- read.csv('tree_data.csv', header = TRUE)
    showNotification("Save successful!")
  })
  #=============================================================================
  
  output$datatable <- renderDT({ rv$mr })

}

################################################################################
################################################################################

shinyApp(ui, server)