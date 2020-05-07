## code to prepare `cities` dataset goes here

library(stringi)

cities <- data.frame(
  continent = c("America", "America", "America", "Africa",
                "Africa", "Africa", "Africa", "Africa",
                "Europe", "Europe", "Europe", "Antarctica"),
  country = c("Canada", "Canada", "USA", "Tunisia", "Tunisia",
              "Tunisia", "Algeria", "Algeria", "Italy", "Germany", "Spain", NA),
  city = c("Trois-Rivières", "Québec", "San Francisco", "Tunis",
           "Monastir", "Sousse", "Alger", "Oran", "Rome", "Berlin", "Madrid", NA),
  stringsAsFactors = FALSE
)

cities$city <- stringi::stri_trans_general(str = cities$city, id = "ASCII-Latin")


usethis::use_data(cities, overwrite = TRUE)
