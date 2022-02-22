
server <- function(input, output) {

  data <- reactive({
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
    
    # Disconnect from the DB
    DBI::dbDisconnect(conn)
    
    # Convert to data.frame
    data.frame(quakes)
  })

  # Render map
  output$map <- leaflet::renderLeaflet({
    mymap <- leaflet::leaflet(data = data())
    mymap <- leaflet::addTiles(mymap)
    mymap <- leaflet::addProviderTiles(mymap, leaflet::providers$Esri.WorldStreetMap)
  })

  observe({
    proxy <- leaflet::leafletProxy("map", data=data())
    proxy <- leaflet::addMarkers(proxy, ~long, ~lat, label = ~mag)
  })

}
