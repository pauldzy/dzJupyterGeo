FROM jupyter/scipy-notebook:latest

LABEL maintainer="Paul Dziemiela <Paul.Dziemiela@erg.com>"

ARG DEBIAN_FRONTEND=noninteractive

USER root

RUN apt-get update                           &&\
    apt-get install -y --no-install-recommends \
       python3.6                               \
       python3.6-dev                           \
       python3-numpy                           \
       python3-gdal                            \
       python3-pip                             \
       python3-libxml2                         \
       python3-setuptools                      \
       gdal-bin                                \
       binutils                                \
       libgdal-dev                             \
       libxml2-dev                             \
       libgeos-dev                             \
       libopenjp2-7-dev                        \
       libpq-dev                               \
       libjson-c-dev                           \
       libxerces-c-dev                         \
       libtiff-dev                             \
       libjpeg-dev                             \
       libkml-dev                              \
       libsqlite3-dev                          \
       libopenjp2-7-dev                        \
       sqlite3                                 \
       libcurl4-gnutls-dev                     \
       libproj-dev                             \
       libgdal20                               \
       postgresql-client                       \
       vim                                     \
       apt-utils                               \
       gettext                               &&\
    apt-get clean                            &&\
    rm -rf /var/lib/apt/lists/*              &&\
    rm -rf /var/cache/apt/*

USER $NB_USER

RUN pip3 install wheel         &&\
    pip3 install gdal==$(gdal-config --version) --global-option=build_ext --global-option="-I/usr/include/gdal" &&\
    pip3 install                 \
      bonobo[jupyter]            \
      fiona                      \
      folium                     \
      geocoder                   \
      geopandas                  \
      geopy                      \
      googlemaps                 \
      psycopg2-binary            \
      pyproj                     \
      pysal                      \
      rtree                      \
      shapely                    \
      wget                       \
      XlsxWriter
