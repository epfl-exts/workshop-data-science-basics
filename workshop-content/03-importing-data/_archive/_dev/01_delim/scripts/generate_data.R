library(tidyverse)
library(readxl)

set.seed(1)

names <- read_xlsx(
  "workshop content/03_import/_dev/01_delim/data/names.xlsx",
  col_names = FALSE
)

names <- names %>% slice(1:10)

n <- nrow(names)

gender <- rep("Female", n)
# gender[c(3, 9, 12, 19)] <- "Male"
gender[c(3, 9)] <- "Male"

team <- tibble(
  name = names %>% pull() %>% str_trim(),
  gender = gender,
  weight = rnorm(n, mean = 70, sd = 5) %>% round(),
  height = rnorm(n, mean = 175, sd = 10) %>% round(),
  bmi = round(weight / (height / 100) ^ 2, 2)
)

team_missing <- team %>%
  mutate(
    weight = as.character(weight),
    weight = if_else(weight %in% c("67", "78"), "null", weight),
    height = as.character(height),
    height = if_else(height %in% c("186", "184"), "null", height)
  )

team_bad_names <- team %>%
  rename(
    `First Name` = name,
    `Passport gender` = gender,
    `Weight (in kg)` = weight,
    `Height (in cm)` = height,
    `Body Mass Index` = bmi
  )


write_csv(team, "workshop content/03_import/_dev/01_delim/data/team.csv")

write_csv(
  team,
  "workshop content/03_import/_dev/01_delim/data/team_wo_header.csv",
  col_names = FALSE
)

write_csv(
  team_missing,
  "workshop content/03_import/_dev/01_delim/data/team_missing.csv"
)

write_tsv(
  team,
  "workshop content/03_import/_dev/01_delim/data/team.tsv"
)

write_csv2(team, "workshop content/03_import/_dev/01_delim/data/team2.csv")

write_delim(
  team,
  "workshop content/03_import/_dev/01_delim/data/team_delim.dstr",
  delim = "*"
)

write_csv(
  team_bad_names,
  "workshop content/03_import/_dev/01_delim/data/team_bad_names.csv"
)

writeLines(
  text = "The physiological data of team members\nOnly for internal use!\n",
  con = "workshop content/03_import/_dev/01_delim/data/team_meta.txt"
)
write_csv(
  team,
  "workshop content/03_import/_dev/01_delim/data/team_meta.txt",
  append = TRUE,
  col_names = TRUE
)

#-------------------------------------------------------------------------------

city_names <- c("Neuch\xe2tel", "Z\xfcrich")
Encoding(city_names) <- "latin1"

cities <- tibble(
  name = city_names,
  population = c(32819, 402762)
)

write.csv(
  cities,
  "workshop content/03_import/_dev/01_delim/data/cities.csv",
  fileEncoding = "latin1",
  row.names = FALSE,
  quote = FALSE
)

#-------------------------------------------------------------------------------
paste0(
  "Motor Trend Car Road Tests\n",
  "The data was extracted from the 1974 Motor Trend US magazine, and comprises",
  " fuel consumption and 10 aspects of automobile design and performance for",
  " 32 automobiles (1973–74 models).\n"
) %>%
  writeLines("_dev/01_delim/data/mtcars.txt")

write_csv(
  mtcars,
  file = "_dev/01_delim/data/mtcars.txt",
  append = TRUE,
  col_names = TRUE
)
