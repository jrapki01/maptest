server <- function(input, output, session){

    data1 <- reactive({
    if(input$detail == "Ward Level"){
    x <- mye_2017_wards %>% filter(LAD18NM %in% input$geography) %>%
                  filter(Sex == input$selected_sex) %>%
                  filter(Age >= input$age_group_1[1] & Age <= input$age_group_1[2])
    x <- dplyr::select(x, wd18cd, Sex, Count, input$selected_deprivation)
    colnames(x) <- c("wd18cd", "Sex", "Count", "CountDecile")
    x <- x %>%
      group_by(wd18cd, Sex) %>%
      summarise_all(funs(sum))
    x$PercDec <- round((x$CountDecile/x$Count)*100,2)
    
    y <- subset(Wards, LAD18NM %in% input$geography)
    names(y@data)[names(y@data)=="wd18nm"] <- "Names"
    
    z <- merge(y, x, by.x="wd18cd", by.y="wd18cd", duplicateGeoms = TRUE) 
    } 
      else if(input$detail == "Local Authority District"){
      x <- mye_2017_wards %>% filter(LAD18NM %in% input$geography) %>%
      filter(Sex == input$selected_sex) %>%
      filter(Age >= input$age_group_1[1] & Age <= input$age_group_1[2])
    x <- dplyr::select(x, LAD18CD, Sex, Count, input$selected_deprivation)
    colnames(x) <- c("LAD18CD", "Sex", "Count", "CountDecile")
    x <- x %>%
      group_by(LAD18CD, Sex) %>%
      summarise_all(funs(sum))
    x$PercDec <- round((x$CountDecile/x$Count)*100,2)
    
    y <- subset(District, LAD18NM %in% input$geography)
    names(y@data)[names(y@data)=="lad17nm"] <- "Names"
    
    z <- merge(y, x, by.x="LAD18CD", by.y="LAD18CD", duplicateGeoms = TRUE)   
      } 
      ## This part of the if else statement won't function at the moment. 
      ## The data has been hidden in the global.R file due to size limitations on the shinyapps.io free account
      ## To work straight from laptop uncomment out the relevant dataframe links in the global.R file
      else if(input$detail == "Lower Super Output Area"){
        x <- mye_2017_wards_lsoa %>% filter(LAD18NM %in% input$geography) %>%
          filter(Sex == input$selected_sex) %>%
          filter(Age >= input$age_group_1[1] & Age <= input$age_group_1[2])
        x <- dplyr::select(x, LSOA11CD, Sex, Count, input$selected_deprivation)
        colnames(x) <- c("LSOA11CD", "Sex", "Count", "CountDecile")
        x <- x %>%
          group_by(LSOA11CD, Sex) %>%
          summarise_all(funs(sum))
        x$PercDec <- round((x$CountDecile/x$Count)*100,2)
        
        y <- subset(LSOA, LAD18NM %in% input$geography)
        names(y@data)[names(y@data)=="lsoa11nm"] <- "Names"
        
        z <- merge(y, x, by.x="lsoa11cd", by.y="LSOA11CD", duplicateGeoms = TRUE)   
      }
      else {
      print("Not a valid option")
    }
    })
    
  output$mymap <- renderLeaflet({
    df <- data1()
    
    bins <- c(0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100)
    pal <- colorBin("RdYlGn", domain = df$PercDec, bins = bins, reverse=TRUE)
    
    labels <- sprintf(
      "<strong>%s</strong><br/>%s<br/>%s%%",
      df$Names, df$Sex, df$PercDec
    ) %>% lapply(htmltools::HTML)
    
    m <- leaflet(data = df) %>%
      addPolygons(fillColor = ~pal(PercDec),
                  weight=2,
                  opacity=1,
                  color="white",
                  dashArray= "3",
                  fillOpacity = 0.7,
                  highlight=highlightOptions(
                    weight = 5,
                    bringToFront = TRUE),
                  label= labels,
                  labelOptions = labelOptions(
                    style=list("font-weight" = "normal", padding ="3px 8px"),
                    textsize="15px",
                    direction="auto")) %>%
      addTiles() %>%
      addLegend(pal = pal, values = ~PercDec, opacity = 0.7, title="Percentage", position="bottomright")
  })
  
  output$source_desc1 <- renderText({
    paste(case_when(
      input$detail == "Local Authority District" ~ "Local Authority"
      ,input$detail == "Ward Level" ~ "Ward"
      ,input$detail == "Lower Super Output Area" ~ "LSOA")
      ," level population figures from 2017 mid year population estimate.")
  })
  
  output$dep_desc1 <- renderText({
    paste("Showing deprivation as: ", case_when(
      input$selected_deprivation == "Count_in_IMD2015_decile_1" ~ "10% most deprived (IMD decile 1), from 2015 English Indices of Deprivation"
      ,input$selected_deprivation == "Count_in_IMD2015_decile_1_to_2" ~ "20% most deprived (IMD decile 1 or 2), from 2015 English Indices of Deprivation"
      ,input$selected_deprivation == "Count_in_IMD2015_decile_1_to_3" ~ "30% most deprived (IMD decile 1, 2 or 3), from 2015 English Indices of Deprivation"))
  })
}