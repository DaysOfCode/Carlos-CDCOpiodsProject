library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)
library(sf)


function(input, output, session) {
  ## Interactive Map ###########################################
  
  # Create the map
  output$map <- renderLeaflet({
    leaflet(cdcAnnualData)%>% addTiles() %>%
      
     # addTiles(urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
     #         attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>') %>%
      setView(lng = -93.85,
              lat = 37.45,
              zoom = 4)
  })
  
  yearFilter <- reactive({
    YearBy <- input$year
    cdcMonthlyStateData %>% filter(Year == YearBy)
  })
  
  gottoUpdatedMap <- reactive({
    StateBy <- input$monthlyState
    Year <- input$year
    if (nrow(MonthlyDataStateFilter()) == 0)
      return(NULL)
    row <- MonthlyDataStateFilter()[1,]
    state <- row$State
    lat <- row$Lat
    long <- row$Long

    gotoState(state, lat, long)

  })
  
  MonthlyDataStateFilter <- reactive({
    StateBy <- input$monthlyState
   #leafletProxy("map") %>% clearPopups()
    newfilter <- cdcMonthlyStateData %>%
      filter(
        input$monthlyState == "" | State == input$monthlyState  ,
        input$year == "" | Year == input$year
      )
    
    newfilter
  })
  
  selectchoropleth <- reactive({
    choropleth <- input$choropleth
    YearBy <- input$year
    cdcAnnualData %>% filter(Year == YearBy)

    df <- yearFilterAnnual() 
    df$PercentChange <- as.numeric(df$PercentChange)
    stategeomsJoined<- sp::merge(stategeoms,df,by.x='name',by.y='State')
    
    if (choropleth =="PercentChange" )
    {
      vals <- c(as.numeric(stategeomsJoined$PercentChange))
    }
    else{
      vals <- c(as.numeric(stategeomsJoined$Crude.Rate))
    }
    pal <- colorNumeric("OrRd", c(vals),n=6)    
    map <- leafletProxy("map")
    map %>%  clearControls() %>%
             addPolygons(data=stategeomsJoined,
                          fillColor = ~pal(vals),
                          weight = 2,
                          opacity = 1,
                          color = "white",
                          dashArray = "3",
                          fillOpacity = 0.7)  %>% 
              addLegend(pal = pal, values =  vals, opacity = 0.7, title = choropleth,
                        position = "bottomleft")
  })
  
  
  yearFilterAnnual <- reactive({
    YearBy <- input$year
    cdcAnnualData %>% filter(Year == YearBy)
  })
  
  yearAddPolyAnnual <- reactive({
    map <- leafletProxy("map")
    map %>%  clearControls() + selectchoropleth()
  })
  
  output$scatterDeaths <- renderPlot({
    shiny::validate(
      need(nrow(MonthlyDataStateFilter()) != 0,'No data Available for this Year/State')
    )
    
    plotdata <- MonthlyDataStateFilter() %>% group_by(Month.Code) %>% 
                select(Month.Code, Deaths) %>% summarise(Deaths = sum(Deaths))
    
    ggplot(plotdata, aes(x = Month.Code, y = Deaths, group = 1)) +
            geom_line(stat = "identity") +
            stat_smooth(method = "loess") +
            ggtitle(paste("Deaths attributed to opiod overdose in the state of" , input$monthlyState,sep = " "),
              input$year
            )
  })
      
      
  # This observer is responsible for maintaining the circles
  observe({
    selectchoropleth()
    #isolate({gottoUpdatedMap()})
    agg_data <- yearFilter() %>% group_by(State) %>%
                summarise(Deaths = sum(Deaths))  %>%
                left_join(state.geom, by = c('State' = 'name')) %>%
                select(State, Deaths, Lat = latitude, Long = longitude)
  
    radius <-  agg_data[["Deaths"]] / sum(agg_data[["Deaths"]]) * 2300000
    leafletProxy("map", data = agg_data) %>% 
                clearGroup("Circles") %>%
                addCircles(
                  ~ Long,
                  ~ Lat,
                  group = "Circles",
                  radius = radius,
                  layerId =  ~ State,
                  stroke = FALSE,
                  fillOpacity = 0.4)
    
  })
    
  PrettyNumbers <- function(val)
  {
    prettyNum(
      val,big.mark = ",", decimal.mark = ".",
      big.interval = 3,small.interval=2
    )
  }
  # Show a popup at the given location
  showStatePopup <- function(state, lat, lng) {
    selectedState <-yearFilterAnnual()[yearFilterAnnual()$State == state,]
    if (nrow(selectedState) != 1 ) 
      return (NULL)
    content <- as.character(tagList(
      tags$h2(state),
      tags$h3("Year:", as.integer(selectedState$Year)),
      tags$p("Deaths:", PrettyNumbers(as.integer(selectedState$Deaths))) ,
      tags$p("%change:", PrettyNumbers(selectedState$PercentChange)), 
      tags$p("Population:", PrettyNumbers(selectedState$Population)) ,
      tags$p("Crude Rate:", selectedState$Crude.Rate),
      tags$p("Age Adjusted Crude Rate:", selectedState$Age.Adjusted.Rate)
    ))
    leafletProxy("map") %>% addPopups(lng, lat, content, layerId = state)
  }
    
  # When map is clicked, show a popup with State info
  observe({
    leafletProxy("map") %>% clearPopups()
    event <- input$map_shape_click
    if (is.null(event))
      return()
    isolate({
      showStatePopup(event$id, event$lat, event$lng)
    })
  })
    
    
## State Data Explorer  #################
    
  explorestatedatafilter <- reactive({
    cdcAnnualData %>% filter(is.null(input$usstates) | State %in% input$usstates)
  })
    
  output$scatterExplorerStateRate <- renderPlot({
    plotdata <-  explorestatedatafilter() 
    
    p2 <- ggplot(plotdata) +
      geom_line(mapping = aes(
        x = Year,
        y = as.numeric(Crude.Rate),
        group = State,
        color = State
      )) +
      geom_smooth(mapping = aes(
        x = Year,
        y = as.numeric(Crude.Rate),
        
        group = State,
        color = State
      ),method='loess',se=FALSE) +
      ggtitle("Crude rate for opiod overdose")
    p2 
  })  
    
  output$scatterExplorerStateDeaths <- renderPlot({
    shiny::validate(need(
      nrow(explorestatedatafilter()) != 0,
      'No data Available for this Year/State'
    ))
  
    plotdata <-  explorestatedatafilter() 
    p1 <- ggplot(plotdata) +
      geom_line(mapping = aes(
        x = Year,
        y = (Deaths),
        group = State,
        color = State
      )) +
      geom_smooth(mapping = aes(
        x = Year,
        y = (Deaths),
        group = State,      
        color = State
      ),method= "loess",se=FALSE) +
      ggtitle("Deaths attributed to opiod overdose")
    p1
  })
  
  output$cdcStatetable <- DT::renderDataTable({
    if (NROW(explorestatedatafilter()) == 0)
      return(NULL)
  
    df <-   explorestatedatafilter() %>% arrange(desc(Year))%>%
      mutate(
        Action = paste(
          '<a class="go-map" href="" data-lat="',
          Lat,  '" data-long="',
          Long, '" data-state="',
          State,'" data-year="',
          Year, '"><i class="fa fa-crosshairs"></i></a>',
          sep = ""
        )
      )
    action <- DT::dataTableAjax(session, df)
    
    DT::datatable(df,
                  options = list(
                    lengthMenu  = c(18, 36, 72, 144),
                    ajax = list(url = action)
                  ),
                  escape = FALSE) %>% formatRound(
                    c("Deaths", "Population"),
                    interval = 3,
                    mark = ",",
                    digits = 0
                  )
  })
  
  ## Data Explorer ###########################################
  observe({
    if (is.null(input$goto))
      return()
    updateSelectInput(session, "year", selected = input$goto$year)
    if (input$goto$state != "US Aggregated")
    {
      updateSelectInput(session, "monthlyState", selected = input$goto$state)
      state <- input$goto$state
      lat <- input$goto$lat
      lng <- input$goto$lng
      isolate({ gotoState(state, lat, lng) })
    }
  })
  
  gotoState <- function (state, lat, lng) {
    isolate({
    map <- leafletProxy("map")
    map %>% clearPopups()
      dist <- 0.8
      if (state != "US Aggregated")
      {
        showStatePopup(state, lat, lng)
        map %>% fitBounds(lng - dist, lat - dist, lng + dist, lat + dist)
      }
    })
  }
  
  exploredatafilter <- reactive({
    
    cdcAnnualData %>% filter(input$states == "" | State == input$states)
    
  })
  
  output$scatterExplorerDeaths <- renderPlot({
    
    if (nrow(exploredatafilter()) == 0)
      return(NULL)
    
    plotdata <- exploredatafilter() %>%   group_by(Year) %>% 
                select(Year, Deaths) %>% summarise(Deaths = sum(Deaths))
    ggplot(plotdata, aes(x = Year, y = Deaths, group = 1)) +
          geom_line(stat = "identity") +
          stat_smooth(method = "loess", show.legend = TRUE) +
          ggtitle("Deaths attributed to opiod overdose")
  })
  
  output$cdctable <- DT::renderDataTable({

    df <-   exploredatafilter() %>% arrange(desc(Year)) %>% select (State,Year,Deaths,Population,Crude.Rate,Age.Adjusted.Rate,PercentChange)
    action <- DT::dataTableAjax(session, df)
    DT::datatable(df,
                  options = list(
                    lengthMenu  = c(18, 36, 72, 144),
                    ajax = list(url = action)
                  ),
                  escape = FALSE) %>% formatRound(
                    c("Deaths", "Population"),
                    interval = 3,
                    mark = ",",
                    digits = 0
                  )
  })
}
