# Base image
FROM rocker/shiny:4.1.2

# Install required linux librairies
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends libpq-dev \ 
                                               libssl-dev \
                                               libxml2-dev \
                                               gdal-bin \
                                               libgdal-dev

# Install R package and its dependencies
RUN install2.r remotes
COPY myshinyapp/ ./myshinyapp
RUN Rscript -e 'remotes::install_deps("./myshinyapp")'
RUN Rscript -e 'install.packages("./myshinyapp", repos = NULL, type="source")'

# Expose port where shiny app will broadcast
ARG SHINY_PORT=3838
EXPOSE $SHINY_PORT
RUN echo "local({options(shiny.port = ${SHINY_PORT}, shiny.host = '0.0.0.0')})" >> /usr/local/lib/R/etc/Rprofile.site

# Endpoint
CMD ["Rscript", "-e", "myshinyapp::runApp()"]
