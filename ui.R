source("modules/uiMain.R", local = TRUE)
source("modules/uiPlots.R", local = TRUE)
#source("modules/uiAbout.R", local = TRUE)
source("modules/uiDataTable.R", local = TRUE)

ui <- fluidPage(
  theme = "styles.css",
  title = "COVID-19 Dashboard",
  tags$head(
    tags$link(rel = "shortcut icon", type = "image/png", href = "logo.png")
  ),
  tags$style(type = "text/css", ".container-fluid {padding-left: 0px; padding-right: 0px !important;}"),
  tags$style(type = "text/css", ".navbar {margin-bottom: 0px;}"),
  tags$style(type = "text/css", ".content {padding: 0px;}"),
  tags$style(type = "text/css", ".row {margin-left: 0px; margin-right: 0px;}"),
  tags$style(HTML(".col-sm-12 { padding: 5px; margin-bottom: -15px; }")),
  tags$style(HTML(".col-sm-6 { padding: 5px; margin-bottom: -15px; }")),
  navbarPage(
    title       = div("COVID-19 Dashboard", style = "padding-left: 10px"),
    collapsible = TRUE,
    fluid       = TRUE,
    tabPanel("World Map", page_overview, value = "page-overview"),
    tabPanel("Plots", page_plots, value = "page-plots"),
    tabPanel("Data", page_fullTable, value = "page-fullTable"),
    #tabPanel("About", page_about, value = "page-about"),
    tags$script(HTML("var header = $('.navbar > .container-fluid');
    header.append('<div style=\"float:right\"><a target=\"_blank\" href=\"https://github.com\"><img src=\"logo.png\" alt=\"alt\" style=\"float:right;width:33px;padding-top:10px;margin-top:-50px;margin-right:10px\"> </a></div>');
    console.log(header)")
    )
  )
)