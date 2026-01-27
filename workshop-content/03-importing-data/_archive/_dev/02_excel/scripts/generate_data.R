library(tidyverse)
library(readxl)
library(openxlsx)

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

write.xlsx(team, "workshop content/03_import/_dev/02_excel/data/team.xlsx")
