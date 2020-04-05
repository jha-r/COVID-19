body_overview <- dashboardBody(
  tags$head(
    tags$style(type = "text/css", "#overview_map {height: 88vh !important;}"),
    tags$style(type = 'text/css', ".slider-animate-button { font-size: 20pt !important; }"),
    tags$style(type = 'text/css', ".slider-animate-container { text-align: left !important; }"),
    tags$style(type = "text/css", "@media (max-width: 991px) { .details { display: flex; flex-direction: column; } }"),
    tags$style(type = "text/css", "@media (max-width: 991px) { .details .map { order: 1; width: 100%; } }"),
    tags$style(type = "text/css", "@media (max-width: 991px) { .details .summary { order: 3; width: 100%; } }"),
    tags$style(type = "text/css", "@media (max-width: 991px) { .details .slider { order: 2; width: 100%; } }"),
    tags$style(type = "text/css", ".panel {opacity: 0.75; cursor: move; zoom: 0.9; transition: opacity 500ms 1s;}}"),
    tags$style(type = "text/css", ".panel:hover {opacity: 0.90; transition-delay: 0;}"),
    tags$style(type = "text/css", ".stats {opacity: 1; }"),
    tags$style(type = "text/css", ".opa {opacity: 0.10; }"),
    tags$style(type = "text/css", ".slider {opacity: 1; }")
  ),
  fluidRow(
    fluidRow(
      class = "details",
      column(
        box(
          width = 12,
          leafletOutput("overview_map", width="100%", height="100%"),
          
          absolutePanel(class =  "stats",
                        top = 80, left = 40, width = 350, fixed=TRUE,
                        draggable = TRUE, height = "auto", 
                        uiOutput("box_statsPanel")
          ),

          
          absolutePanel(class =  "panel",
                        top = 80, right = 40, width = 250, fixed=TRUE,
                        draggable = TRUE, height = "auto", 
                        #uiOutput("summaryTables"),
                        selectInput("country", "Country/Region", "test Country"),
                        selectInput("state", "Province/State", "test state"),
          ),          
                    
          absolutePanel(class = "panel",
                        bottom = 40, left = 450, width = 1200, fixed=TRUE,
                        draggable = TRUE, height = "auto", 
                        column(
                          sliderInput(
                            "timeSlider",
                            label      = "Select date",
                            min        = min(data_evolution$date),
                            max        = max(data_evolution$date),
                            value      = max(data_evolution$date),
                            width      = "100%",
                            timeFormat = "%d.%m.%Y",
                            animate    = animationOptions(loop = TRUE)
                          ),
                          #class = "slider",
                          width = 12,
                          style = 'padding-left:15px; padding-right:15px;'
                        )
          )
        ),
        class = "map",
        width = 12,
        style = 'padding:0px;'
      )
    )
  )
)

page_overview <- dashboardPage(
  title   = "Overview",
  header  = dashboardHeader(disable = TRUE),
  sidebar = dashboardSidebar(disable = TRUE),
  body    = body_overview
)