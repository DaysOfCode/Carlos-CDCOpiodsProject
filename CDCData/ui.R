
library(shiny)
library(DT)




navbarPage(
  "Deaths attribute to Opioid overdose",
  id = "nav",
  
  tabPanel(
    "Interactive map",
    div(
      class = "outer",
      tags$head(# Include our custom CSS
        includeCSS("styles.css"),
        includeScript("gomap.js")),
      
      # If not using custom CSS, set height of leafletOutput to a number instead of percent
      leafletOutput("map", width = "100%", height = "100%"),
      
      # Shiny versions prior to 0.11 should use class = "modal" instead.
      absolutePanel(
        id = "controls",
        class = "panel panel-default",
        fixed = TRUE,
        draggable = TRUE,
        top = 60,
        left = "auto",
        right = 20,
        bottom = "auto",
        width = 400,
        height = "auto",
        
        h2("CDC"),
        selectInput("year", "Year", Years, selected ="2016"),
        selectInput("monthlyState", "State", States, selected ="Texas"),
        selectInput("choropleth", "Choropleth", c("PercentChange","Crude.Rate"), selected ="2016"),
        
        plotOutput("scatterDeaths", height = 300)
      ),
      
      tags$div(
        id = "cite",
        'Data are from the Multiple Cause of Death Files, 1999-2016, as ',
        'compiled from data provided by the 57 vital statistics jurisdictions through the Vital Statistics Cooperative Program.',
        'Accessed at http://wonder.cdc.gov/ucd-icd10.html '
      )
    )
  ),
  
  tabPanel(
    "State explorer",
    fluidRow(column(
      3,
      selectInput(
        "usstates",
        "States",
        States,
        selected = "US Aggregated",
        multiple = TRUE
      )
    )),

    hr(),
    plotOutput("scatterExplorerStateRate", height = 400),
    hr(),
    plotOutput("scatterExplorerStateDeaths", height = 300),    
    hr(),
    DT::dataTableOutput("cdcStatetable")
    
  ),
  tabPanel("Data explorer",
           fluidRow(
             column(3,
                    selectInput("states", "States", c("All states"="", States), selected="US Aggregated", multiple=FALSE)
             )
           ),
           hr(),
           DT::dataTableOutput("cdctable"),
           hr(),
           
           plotOutput("scatterExplorerDeaths", height = 300)
  ),
  tabPanel(
    "Data Sources",
    fluidRow(    
      column(12,includeMarkdown("Data/datasources.md")
    ))
  ),
  
  conditionalPanel("false", icon("crosshair"))
)
