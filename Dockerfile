# Base image
FROM harbor.developpement.insee.fr/docker.io/rocker/shiny:4.0.5

# Install required linux librairies
RUN echo 'Acquire::http::Proxy "http://proxy-rie.http.insee.fr:8080";' >> /etc/apt/apt.conf && \
    apt-get update -y && \
    apt-get install -y --no-install-recommends libpq-dev \ 
                                               libssl-dev \
                                               libxml2-dev \
                                               gdal-bin \
                                               libgdal-dev

# Install R package and its dependencies
RUN Rscript -e "install.packages(c('remotes'), repos='https://nexus.insee.fr/repository/r-cran/', method = 'wget', extra = '--no-check-certificate')"
COPY myshinyapp/ ./myshinyapp
RUN Rscript -e "remotes::install_deps('./myshinyapp', repos='https://nexus.insee.fr/repository/r-cran/', method = 'wget', extra = '--no-check-certificate')"
RUN Rscript -e "install.packages('./myshinyapp', repos = NULL, type='source')"

# Expose port where shiny app will broadcast
ARG SHINY_PORT=3838
EXPOSE $SHINY_PORT
RUN echo "local({options(shiny.port = ${SHINY_PORT}, shiny.host = '0.0.0.0')})" >> /usr/local/lib/R/etc/Rprofile.site

# Endpoint
CMD ["Rscript", "-e", "myshinyapp::runApp()"]
