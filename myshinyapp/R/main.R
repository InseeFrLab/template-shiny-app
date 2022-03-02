
load_data <- function() {
  myshinyapp::to_minio(bucket = "etgtk6", object = "diffusion/shiny-template/quakes.csv")
  myshinyapp::populate_table(bucket = "etgtk6", object = "diffusion/shiny-template/quakes.csv")
}

runApp <- function(){
  myshinyapp::load_data()
  appDir <- system.file("app", package = "myshinyapp")
  shiny::runApp(appDir, display.mode = "normal")
}
