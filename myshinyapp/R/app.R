library(shiny)
library(DBI)
library(glue)
library(leaflet)

myApp <- function(...) {

  ui <- fluidPage(
  tags$h1("Earthquakes"),
  # Slider to control the minimum magnitude
  sliderInput(inputId = "magSlider", label = "Minimum magnitude:", min = 0, max = 10, value = 0, step = 0.1),
  # Map output
  leafletOutput(outputId = "map")
)

server <- function(input, output) {

  data <- reactive({
    # Connect to the DB
    con <- dbConnect(
    RPostgres::Postgres(),
    dbname = Sys.getenv("POSTGRESQL_DB_NAME"),
    host = Sys.getenv("POSTGRESQL_DB_HOST"),
    port = Sys.getenv("POSTGRESQL_DB_PORT"),
    user = Sys.getenv("POSTGRESQL_DB_USER"),
    password = Sys.getenv("POSTGRESQL_DB_PASSWORD")
    )

    # Get the data
    quakes <- dbGetQuery(conn, glue("SELECT * FROM quakes WHERE richter >= {input$magSlider}"))
    # Convert to data.frame
    data.frame(quakes)

    # Disconnect from the DB
    dbDisconnect(conn)
  })

  # Render map
  output$map <- renderLeaflet({
    leaflet(data = data()) %>%
      addTiles() %>%
      addMarkers(~longitude, ~latitude, label = ~richter) %>%
      addProviderTiles(providers$Esri.WorldStreetMap)
  })

  shinyApp(ui, server, ...)

  }
}
