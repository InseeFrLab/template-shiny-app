
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
    quakes <- data.frame(quakes)
    
    # Disconnect from the DB
    DBI::dbDisconnect(conn)
    
    return(quakes)
  })
  
  # Base map
  output$map <- leaflet::renderLeaflet({
    mymap <- leaflet::leaflet()
    mymap <- leaflet::addTiles(mymap)
    mymap <- leaflet::setView(mymap, lng=178,lat=-23,zoom=4)
    mymap <- leaflet::addProviderTiles(mymap, leaflet::providers$Esri.WorldStreetMap)
  })
  
  # Update markers
  observe({
    proxy <- leaflet::leafletProxy("map")
    proxy <- leaflet::clearMarkers(proxy)
    if (nrow(data()) > 0) {
    proxy <- leaflet::addMarkers(proxy, data=data(), ~long, ~lat, label = ~mag)  
    }
    })
}
