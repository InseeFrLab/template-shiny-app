
server <- function(input, output) {

  data <- reactive({
    # Connect to the DB
    con <- DBI::dbConnect(
    RPostgres::Postgres(),
    dbname = Sys.getenv("POSTGRESQL_DB_NAME"),
    host = Sys.getenv("POSTGRESQL_DB_HOST"),
    port = Sys.getenv("POSTGRESQL_DB_PORT"),
    user = Sys.getenv("POSTGRESQL_DB_USER"),
    password = Sys.getenv("POSTGRESQL_DB_PASSWORD")
    )

    # Get the data
    quakes <- DBI::dbGetQuery(conn, glue::glue("SELECT * FROM quakes WHERE richter >= {input$magSlider}"))
    # Convert to data.frame
    data.frame(quakes)

    # Disconnect from the DB
    DBI::dbDisconnect(conn)
  })

  # Render map
  output$map <- leaflet::renderLeaflet({
    leaflet::leaflet(data = data()) %>%
      leaflet::addTiles() %>%
      leaflet::addMarkers(~longitude, ~latitude, label = ~richter) %>%
      leaflet::addProviderTiles(providers$Esri.WorldStreetMap)
  })

}
