library("htmltools")

addLabel <- function(data) {
  data$label <- paste0(
    '<b>', ifelse(is.na(data$`Province/State`), data$`Country/Region`, data$`Province/State`), '</b><br>
    <table style="width:120px;">
    <tr><td>Confirmed:</td><td align="right">', data$confirmed, '</td></tr>
    <tr><td>Deaths:</td><td align="right">', data$deceased, '</td></tr>
    <tr><td>Recovered:</td><td align="right">', data$recovered, '</td></tr>
    <tr><td>Active:</td><td align="right">', data$active, '</td></tr>
    </table>'
  )
  data$label <- lapply(data$label, HTML)

  return(data)
}

map <- leaflet(addLabel(data_latest)) %>%
  setMaxBounds(-180, -90, 180, 90) %>%
  setView(0, 20, zoom = 2) %>%
  addTiles() %>%
  addProviderTiles(providers$CartoDB.Positron, group = "Dark") %>%
  addProviderTiles(providers$HERE.satelliteDay, group = "Satellite") %>%
  addProviderTiles(providers$OpenWeatherMap.Temperature, group = "Temperature", 
                   options = providerTileOptions(apiKey="fb69ce5e06ea57fc3ea236395e3be766")) %>%
  
  addLayersControl(
    baseGroups    = c("Dark", "Satellite", "Temperature"),
    overlayGroups = c("Confirmed", "Recovered", "Deaths", "Active"),
    options = layersControlOptions(collapsed = FALSE),
    position = "bottomright"
  ) %>%
  
  hideGroup("Recovered") %>%
  hideGroup("Deaths") %>%
  hideGroup("Active") %>%
  addEasyButton(easyButton(
    icon    = "glyphicon glyphicon-globe", title = "Reset zoom",
    onClick = JS("function(btn, map){ map.setView([20, 0], 2); }"))) %>%
  addEasyButton(easyButton(
    icon    = "glyphicon glyphicon-map-marker", title = "Locate Me",
    onClick = JS("function(btn, map){ map.locate({setView: true, maxZoom: 6}); }")))

observe({
  req(input$timeSlider, input$overview_map_zoom)
  zoomLevel               <- input$overview_map_zoom
  data                    <- data_atDate(input$timeSlider) %>% addLabel()
  data$confirmedPerCapita <- data$confirmed / data$population * 100000
  data$activePerCapita    <- data$active / data$population * 100000

  leafletProxy("overview_map", data = data) %>%
    clearMarkers() %>%
    addCircleMarkers(
      lng          = ~Long,
      lat          = ~Lat,
      radius       = ~log(confirmed^(zoomLevel / 2)),
      stroke       = FALSE,
      fillOpacity  = 0.5,
      color        = "#E7590B",
      label        = ~label,
      labelOptions = labelOptions(textsize = 15),
      group        = "Confirmed"
    ) %>%
    addCircleMarkers(
      lng          = ~Long,
      lat          = ~Lat,
      radius       = ~log(recovered^(zoomLevel)),
      stroke       = FALSE,
      color        = "green",
      fillOpacity  = 0.5,
      label        = ~label,
      labelOptions = labelOptions(textsize = 15),
      group = "Recovered"
    ) %>%
    addCircleMarkers(
      lng          = ~Long,
      lat          = ~Lat,
      radius       = ~log(deceased^(zoomLevel)),
      stroke       = FALSE,
      color        = "red",
      fillOpacity  = 0.5,
      label        = ~label,
      labelOptions = labelOptions(textsize = 15),
      group        = "Deaths"
    ) %>%
    addCircleMarkers(
      lng          = ~Long,
      lat          = ~Lat,
      radius       = ~log(active^(zoomLevel / 2)),
      stroke       = FALSE,
      color        = "#f49e19",
      fillOpacity  = 0.5,
      label        = ~label,
      labelOptions = labelOptions(textsize = 15),
      group        = "Active"
    )

})

output$overview_map <- renderLeaflet(map)


