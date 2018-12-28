ui <- fluidPage(
    titlePanel("Percentage of population living in deprived areas"),
    sidebarLayout(
    sidebarPanel(
    # Select Level of Detail
    selectInput(inputId = "detail",
                  label = "Level of Detail",
                  choices = c("Local Authority District",
                              "Ward Level",
                              "Lower Super Output Area"),
                  selected = "Ward Level",
                  multiple = FALSE),
    # Select Area
    selectInput(inputId = "geography",
                label = "Local Authority",
                choices = c(levels(mye_2017_wards$LAD18NM)),
                selected = "Southend-on-Sea",
                multiple = TRUE),
    # Select Sex
    selectInput(inputId = "selected_sex",
                label = "Sex",
                choices = c("Persons",
                            "Males",
                            "Females"),
                selected = "Persons"),
    # Select age
    wellPanel(
      h3("Define age groups"),
      h5("Use sliders to define different age groups"),
      h6("Note: 90 = 90+"),
      sliderInput(inputId = "age_group_1"
                  ,label = "Age group 1"
                  ,min = 0
                  ,max = 90
                  ,value = c(0,90)
                  ,ticks = TRUE)
    ),
      radioButtons(inputId = "selected_deprivation"
                   ,label = "Choose level of deprivation (from IMD 2015)"
                   ,choices = c("10% most deprived (IMD decile 1)" = "Count_in_IMD2015_decile_1"
                                ,"20% most deprived (IMD deciles 1,2)" = "Count_in_IMD2015_decile_1_to_2"
                                ,"30% most deprived (IMD decile 1,2,3)" = "Count_in_IMD2015_decile_1_to_3"
                   )
                   #,selected = "30% most deprived (IMD decile 1,2,3)"
                   ,selected = "Count_in_IMD2015_decile_1_to_3"
    )
  ),
  # Select definition of deprivation to use

  mainPanel(
  p(textOutput("source_desc1")),
  p(textOutput("dep_desc1")),
  leafletOutput("mymap", height=500)
)
)
)