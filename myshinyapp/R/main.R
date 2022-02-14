load_data <- function() {
  to_minio(bucket = "etgtk6", object = "shiny-template/quakes.csv")
  populate_table(bucket = "etgtk6", object = "shiny-template/quakes.csv")
}

run_app <- function() {
  appDir <- system.file("app", package = "myshinyapp")
  shiny::runApp(appDir, display.mode = "normal")
}
