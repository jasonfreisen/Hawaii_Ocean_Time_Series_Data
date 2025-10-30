################################################################################
# Visualization Hawaii time series data
################################################################################
#
# Jason Freisen
# jaf3457@miami.edu
# 10/30/2025
#
# Script used for creation of visualizations of previously cleaned time-series data
#
################################################################################
# SET UP #######################################################################

## Load packages ---------------------------------------------------------------
library(tidyverse)
library(janitor)
library(readxl)
usethis::git_vaccinate()
install.packages(c("usethis", "gitcreds"))
library(dplyr)
library(ggridges)
library(cowplot)

## Load data -------------------------------------------------------------------
new_bac_data <- readRDS("data/processed/new_bac_data.rds")
new_chl_data <- readRDS("data/processed/new_chl_data.rds")

# VISUALIZE ####################################################################

#Bacteria data

bacteria_time_series <- ggplot(data = new_bac_data,
       aes(x = year, y = avg_bacteria)) +
  geom_point() +
  geom_smooth() +
  facet_wrap(~depth_m) +
  theme_minimal() +
  labs(x = "Year", y = "Bacteria (#/mL)",
       title = "Time-series data of heterotrophic bacteria at varying depths (m)",
       caption = "Source: Hawaii Ocean Time-series Data Organization & Graphical System")

p1 <- ggplot(data = new_bac_data,
       aes(x = avg_bacteria, y = depth_m, color = year)) +
  geom_point() +
  scale_y_reverse() +
  labs(x = "Bacteria (#/mL)", y = "Depth (m)",
       title = "Vertical depth profile of heterotrophic bacteria and chlorophyll-a") +
  theme_minimal() +
  theme(legend.position = "none")

#Chlorophyll data

p2 <- ggplot(data = new_chl_data,
       aes(x = avg_chlorophyll, y = depth_m, color = year)) +
  geom_point() +
  scale_y_reverse() +
  labs(x = "Chlorophyll-a (mg/cubic meter)", y = "Depth (m)", legend = "Year",
       caption = "Source: Hawaii Ocean Time-series Data Organization & Graphical System") +
  theme_minimal() +
  theme(legend.position = "bottom")

#Cowplot with p1 and p2

final_vertical_profile <- plot_grid(p1, p2, ncol = 1, rel_heights = c(0.8,1))

# EXPORT #######################################################################

ggsave(plot = bacteria_time_series,
       filename = "results/images/bacteria_time_series.png")

ggsave(plot = final_vertical_profile,
       filename = "results/images/final_vertical_profile.png")
