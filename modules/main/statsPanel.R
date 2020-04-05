sumData <- function(date) {
  if (date >= min(data_evolution$date)) {
    data <- data_atDate(date) %>% summarise(
      confirmed = sum(confirmed, na.rm = T),
      active = sum(active, na.rm = T),      
      recovered = sum(recovered, na.rm = T),
      deceased  = sum(deceased, na.rm = T),
      countries = n_distinct(`Country/Region`)
    )
    return(data)
  }
  return(NULL)
}

key_figures <- reactive({
  data           <- sumData(input$timeSlider)
  data_yesterday <- sumData(input$timeSlider - 1)

  data_new <- list(
    new_confirmed = (data$confirmed - data_yesterday$confirmed) / data_yesterday$confirmed * 100,
    new_active = (data$active - data_yesterday$active) / data_yesterday$active * 100,    
    new_recovered = (data$recovered - data_yesterday$recovered) / data_yesterday$recovered * 100,
    new_deceased  = (data$deceased - data_yesterday$deceased) / data_yesterday$deceased * 100,
    new_countries = data$countries - data_yesterday$countries
  )
  
  data_percentage <- list(
    active_perct = round(data$active / data$confirmed * 100, 1),    
    recovered_perct = round(data$recovered / data$confirmed * 100, 1),
    deceased_perct  = round(data$deceased / data$confirmed * 100, 1),
    countries_perct = round(data$countries / 195 * 100, 1)
  )

  statsPanel <- list(
    "confirmed" = HTML(paste(format(data$confirmed, big.mark = ","), sprintf("<h4>(%+.1f %%)</h4>", data_new$new_confirmed))),
    "active" = HTML(paste(format(data$active, big.mark = ","), sprintf("<h4>Total: %.1f %% (%+.1f %%)</h4>", data_percentage$active_perct, data_new$new_active))),    
    "recovered" = HTML(paste(format(data$recovered, big.mark = ","), sprintf("<h4>Total: %.1f %% (%+.1f %%)</h4>", data_percentage$recovered_perct, data_new$new_recovered))),
    "deceased"  = HTML(paste(format(data$deceased, big.mark = ","), sprintf("<h4>Total: %.1f %% (%+.1f %%)</h4>", data_percentage$deceased_perct, data_new$new_deceased))),
    "countries" = HTML(paste(format(data$countries, big.mark = ","), "/ 195*", sprintf("<h4>Total: %.1f %% (%+.1f %%)</h4>", data_percentage$countries_perct, data_new$new_countries)))
  )
  return(statsPanel)
})

output$valueBox_confirmed <- renderValueBox({
  valueBox(
    key_figures()$confirmed,
    subtitle = "Confirmed",
    icon     = icon("file-medical"),
    color    = "orange",
    width    = NULL
  )
})

output$valueBox_active <- renderValueBox({
  valueBox(
    key_figures()$active,
    subtitle = "Active",
    icon     = icon("diagnoses"),
    color    = "yellow"
  )
})

output$valueBox_recovered <- renderValueBox({
  valueBox(
    key_figures()$recovered,
    subtitle = "Recovered",
    icon     = icon("shield-alt"),
    color    = "green"
  )
})

output$valueBox_deceased <- renderValueBox({
  valueBox(
    key_figures()$deceased,
    subtitle = "Deaths",
    icon     = icon("ambulance"),
    color    = "red"
  )
})

output$valueBox_countries <- renderValueBox({
  valueBox(
    key_figures()$countries,
    subtitle = "Countries Affected",
    icon     = icon("globe-americas"),
    color    = "blue"
  )
})

output$box_statsPanel <- renderUI(box(
  title = paste0("Stats Date :", strftime(input$timeSlider, format = "%d.%b.%Y")),
  fluidRow(
    column(
      fluidRow(valueBoxOutput("valueBox_confirmed", width = "100%")),
      fluidRow(valueBoxOutput("valueBox_active", width = "100%")),
      fluidRow(valueBoxOutput("valueBox_recovered", width = "100%")),
      fluidRow(valueBoxOutput("valueBox_deceased", width = "100%")),
      fluidRow(valueBoxOutput("valueBox_countries", width = "100%")),
      width = 12
    )
  ),
  div("Last updated: ", strftime(changed_date, format = "%d.%b.%Y - %R %Z")),
  width = 12
))