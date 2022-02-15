library(DBI)

to_minio <- function(bucket, object){
  # Export built-in R dataframe "quakes" to MinIO
  aws.s3::s3write_using(
  quakes,
  FUN = readr::write_csv,
  object = object,
  bucket = bucket,
  opts = list("region" = "")
  )
}

populate_table <- function(bucket, object){
  # Connect to the postgresql db
  conn <- dbConnect(
    RPostgres::Postgres(),
    dbname = Sys.getenv("POSTGRESQL_DB_NAME"),
    host = Sys.getenv("POSTGRESQL_DB_HOST"),
    port = Sys.getenv("POSTGRESQL_DB_PORT"),
    user = Sys.getenv("POSTGRESQL_DB_USER"),
    password = Sys.getenv("POSTGRESQL_DB_PASSWORD")
  )

  # Create empty table 
  create_query <- "
  CREATE TABLE quakes (
    id INT PRIMARY KEY,
    latitude REAL,
    longitude REAL,
    depth REAL,
    richter REAL,
    stations INT
  );"
  dbSendQuery(conn, create_query)

  # Get data from MinIO
  df <- aws.s3::s3read_using(
    FUN = readr::read_csv,
    object = object,
    bucket = bucket,
    opts = list("region" = "")
  )

  # Populate table
  dbWriteTable(conn, "quakes", df)
}

load_data <- function() {
  to_minio(bucket = "etgtk6", object = "shiny-template/quakes.csv")
  populate_table(bucket = "etgtk6", object = "shiny-template/quakes.csv")
}
