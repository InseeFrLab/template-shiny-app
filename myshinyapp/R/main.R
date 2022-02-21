
load_data <- function() {
  myshinyapp::to_minio(bucket = "etgtk6", object = "shiny-template/quakes.csv")
  myshinyapp::populate_table(bucket = "etgtk6", object = "shiny-template/quakes.csv")
}

runApp <- function(){
    pkgload::load_all("myshinyapp")
    # myshinyapp::load_data()
    myshinyapp::myApp()
}