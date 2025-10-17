################################################################################
# EVR628 Hawaii Ocean Time Series Data
################################################################################
#
# Jason Freisen
# jaf3457@miami.edu
# 10/13/2025
#
# Tidying and visualization of Hawaii time series data for EVR628 class project
#
################################################################################
# SET UP #######################################################################

## Load packages --------------------------------------------------------------
library(tidyverse)
library(janitor)
library(readxl)
usethis::git_vaccinate()
install.packages(c("usethis", "gitcreds"))
library(dplyr)

## Load data -------------------------------------------------------------------
h_bacteria_data <- read_excel("data/raw/hot_raw_data.xlsx")

chl_a_data <- read_excel("data/raw/hot_raw_data_Chl.xlsx")


# PROCESSING ###################################################################

new_bac_data <- h_bacteria_data |>
  select(`date (yymmdd)`, `depth (m)`, `hbact (#/ml)`) |>
  clean_names() |>
  mutate(date_num = as.integer(date_yymmdd),
         date_char = formatC(date_num, width = 6,
                             format = "d", flag = "0"),
         date = as.Date(date_char, format = "%y%m%d")) |>
  mutate(year = year(date)) |>
  group_by(year, depth_m) |>
  summarize(avg_bacteria = mean(hbact_number_ml, na.rm = TRUE))

saveRDS(new_bac_data, file = "new_bac_data.rds")

new_chl_data <- chl_a_data |>
  select(`date (yymmdd)`, `depth (m)`, `chl (mg/m3)`) |>
  clean_names() |>
  mutate(date_num = as.integer(date_yymmdd),
         date_char = formatC(date_num, width = 6,
                             format = "d", flag = "0"),
         date = as.Date(date_char, format = "%y%m%d")) |>
  mutate(year = year(date)) |>
  group_by(year, depth_m) |>
  summarize(avg_chlorophyll = mean(chl_mg_m3, na.rm = TRUE))

saveRDS(new_chl_data, file = "new_chl_data.rds")

# VISUALIZE ####################################################################

ggplot(data = new_bac_data,
       aes(x = year, y = avg_bacteria)) +
  geom_point() +
  facet_wrap(~depth_m, ncol = 1)

# ANALYSIS #####################################################################

## Almost last step ------------------------------------------------------------


# EXPORT #######################################################################

## The final step --------------------------------------------------------------
