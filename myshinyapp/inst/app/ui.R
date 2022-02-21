
ui <- shiny::fluidPage(
shiny::tags$h1("Earthquakes"),
# Slider to control the minimum magnitude
shiny::sliderInput(inputId = "magSlider", label = "Minimum magnitude:", min = 0, max = 10, value = 0, step = 0.1),
# Map output
leaflet::leafletOutput(outputId = "map")
)
