################################################################################
# Building a vector for station ALOHA
################################################################################
#
# Jason Freisen
# jaf3457@miami.edu
# 11/16/2025
#
# Using coordinates to build a vector polygon for the sampling location of the
# Hawaii Ocean Time series
################################################################################
# SET UP #######################################################################

## Load packages ---------------------------------------------------------------
library(tidyverse)
library(janitor)
library(sf)
library(rnaturalearth)
library(mapview)
library(terra)
library(tidyterra)
library(ggspatial)

## Load data -------------------------------------------------------------------
depth <- rast("data/raw/depth_raster.tif")
depth_df <- as.data.frame(depth, xy = TRUE, na.rm = TRUE)

aloha_poly_coord <- st_polygon(
  x = list(
    matrix(
      data = c(
        -158.0000, 22.8500,
        -158.0830, 22.8320,
        -158.1250, 22.7710,
        -158.0830, 22.7080,
        -158.0000, 22.6900,
        -157.9170, 22.7080,
        -157.8750, 22.7710,
        -157.9170, 22.8320,
        -158.0000, 22.8500),
      ncol = 2,
      byrow = T)),
  dim = "XY") |>
  st_sfc(crs = 4326)

aloha_polygon <- st_sf(id = "Station ALOHA (polygon)",
                     geometry = aloha_poly_coord)

# VISUALIZE ####################################################################
mapview(aloha_polygon)

hawaii_st_aloha <- ggplot() +
  geom_raster(data = depth_df, aes(x = x, y = y, fill = depth_m)) +
  scale_fill_viridis_c(name = "Depth (m)", na.value = "transparent") +
  geom_sf(data = aloha_polygon, fill = "red", color = "red", size = 1) +
  coord_sf(
    xlim = c(-160, -154),
    ylim = c(20, 23),
    expand = FALSE
  ) +
  labs(
    title = "Hawaii Ocean Depth with Station ALOHA Polygon Overlay (red)",
    x = "Longitude",
    y = "Latitude",
    caption = "Raster depth data from GMED:
    Global Marine Environment Datasets for environment
    visualization and species distribution modelling"
  ) +
  theme_minimal() +
  annotation_north_arrow(location = "tr") +
  annotation_scale(location = "bl") +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0))

# EXPORT #######################################################################

ggsave(plot = hawaii_st_aloha, filename =
         "results/images/hawaii_st_aloha.png")
