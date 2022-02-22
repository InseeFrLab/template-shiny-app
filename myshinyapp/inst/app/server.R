
server <- function(input, output) {

  output$map <- leaflet::renderLeaflet({
    leaflet::leaflet()
  })

  observeEvent(input$magSlider, {
    # Connect to the DB
    conn <- DBI::dbConnect(
    RPostgres::Postgres(),
    dbname = Sys.getenv("POSTGRESQL_DB_NAME"),
    host = Sys.getenv("POSTGRESQL_DB_HOST"),
    port = Sys.getenv("POSTGRESQL_DB_PORT"),
    user = Sys.getenv("POSTGRESQL_DB_USER"),
    password = Sys.getenv("POSTGRESQL_DB_PASSWORD")
    )

    # Get the data
    quakes <- DBI::dbGetQuery(conn, glue::glue("SELECT * FROM quakes WHERE mag >= {input$magSlider}"))
    quakes <- data.frame(quakes)

    # Update map
    if (nrow(quakes) > 0) {
      new_map <- leaflet::leafletProxy("map")
      new_map <- leaflet::addTiles(new_map)
      new_map <- leaflet::addMarkers(new_map, ~long, ~lat, label = ~mag)
      new_map <- leaflet::addProviderTiles(new_map, leaflet::providers$Esri.WorldStreetMap)
    }
    
    # Disconnect from the DB
    DBI::dbDisconnect(conn)
  })

}
