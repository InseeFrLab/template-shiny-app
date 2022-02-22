
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
  
  # Get data from MinIO
  df <- aws.s3::s3read_using(
    FUN = readr::read_csv,
    object = object,
    bucket = bucket,
    opts = list("region" = "")
  )

  # Connect to the postgresql db
  conn <- DBI::dbConnect(
    RPostgres::Postgres(),
    dbname = Sys.getenv("POSTGRESQL_DB_NAME"),
    host = Sys.getenv("POSTGRESQL_DB_HOST"),
    port = Sys.getenv("POSTGRESQL_DB_PORT"),
    user = Sys.getenv("POSTGRESQL_DB_USER"),
    password = Sys.getenv("POSTGRESQL_DB_PASSWORD")
  )

  # Populate table
  DBI::dbWriteTable(conn, "quakes", df, overwrite = TRUE)

  # Close DB connection
  DBI::dbDisconnect(conn)
}
