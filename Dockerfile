FROM jupyter/scipy-notebook:latest AS builder

LABEL maintainer="Paul Dziemiela <Paul.Dziemiela@erg.com>"

ARG DEBIAN_FRONTEND=noninteractive

USER root

RUN apt-get update                              &&\
    apt-get install -y --no-install-recommends    \
       python3.6                                  \
       python3.6-dev                              \
       python3-numpy                              \
       python3-gdal                               \
       python3-pip                                \
       python3-libxml2                            \
       python3-setuptools                         \
       binutils                                   \
       libgdal-dev                                \
       libxml2-dev                                \
       libgeos-dev                                \
       libopenjp2-7-dev                           \
       libpq-dev                                  \
       libjson-c-dev                              \
       libxerces-c-dev                            \
       libtiff-dev                                \
       libgeotiff-dev                             \
       libjpeg-dev                                \
       libkml-dev                                 \
       libsqlite3-dev                             \
       libopenjp2-7-dev                           \
       libcurl4-gnutls-dev                        \
       libproj-dev                                \
       libgdal20                                  \
       gettext                                  &&\
    apt-get clean                               &&\
    rm -rf /var/lib/apt/lists/*                 &&\
    rm -rf /var/cache/apt/*

USER $NB_USER

RUN pip3 install wheel                          &&\
    pip3 wheel                                    \
      gdal==$(gdal-config --version)              \
         --global-option=build_ext                \
         --global-option="-I/usr/include/gdal"    \
         --wheel-dir /home/$NB_USER/wheels      &&\
    pip3 wheel --wheel-dir /home/$NB_USER/wheels  \
      bonobo[jupyter]                             \
      fiona                                       \
      folium                                      \
      geocoder                                    \
      geopandas                                   \
      geopy                                       \
      googlemaps                                  \
      psycopg2-binary                             \
      pyproj                                      \
      pysal                                       \
      rtree                                       \
      shapely                                     \
      wget                                        \
      XlsxWriter

FROM jupyter/scipy-notebook:latest

USER root

RUN apt-get update                              &&\
    apt-get install -y --no-install-recommends    \
       python3-pip                                \
       gdal-bin                                   \
       libgdal20                                  \
       sqlite3                                    \
       postgresql-client                          \
       apt-utils                                  \
       vim                                      &&\
    apt-get clean                               &&\
    rm -rf /var/lib/apt/lists/*                 &&\
    rm -rf /var/cache/apt/*
    
COPY --from=builder /home/$NB_USER/wheels /home/$NB_USER/wheels

USER $NB_USER

RUN pip3 install --no-index --find-links=/home/$NB_USER/wheels \
      gdal                                        \
      bonobo[jupyter]                             \
      fiona                                       \
      folium                                      \
      geocoder                                    \
      geopandas                                   \
      geopy                                       \
      googlemaps                                  \
      psycopg2-binary                             \
      pyproj                                      \
      pysal                                       \
      rtree                                       \
      shapely                                     \
      wget                                        \
      XlsxWriter

      