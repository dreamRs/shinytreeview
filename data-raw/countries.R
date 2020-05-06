## code to prepare `countries` dataset goes here

library(rnaturalearth)

countries <- rnaturalearth::countries110@data[, c("continent", "subregion", "name")]


usethis::use_data(countries, overwrite = TRUE)
