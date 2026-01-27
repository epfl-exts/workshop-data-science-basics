library(tidyverse)
library(readxl)
library(DBI)
library(RSQLite)
library(janitor)

set.seed(1991)

customers <- read_xlsx(
  "workshop content/03_import/03-db/data/customer_names.xlsx"
)

customers <- customers %>%
  mutate(
    name = str_extract(name, "\\w*"),
    age = rpois(n = 50, lambda = 30),
    n_likes = rpois(n = 50, lambda = 70)
  )

team <- read_csv("workshop content/03_import/01_delim/data/team.csv")

connection <- dbConnect(
  SQLite(),
  "workshop content/03_import/03-db/data/company.db"
)

dbWriteTable(connection, "team", team, overwrite = TRUE)
dbWriteTable(connection, "customers", customers, overwrite = TRUE)

dbDisconnect(connection)

#-------------------------------------------------------------------------------

episodes <- read_csv(
  "workshop content/03_import/03-db/data/episode_list.csv"
) %>%
  clean_names()

transcripts <- read_csv(
  "workshop content/03_import/03-db/data/only_spoken_text.csv"
) %>% clean_names()

connection <- dbConnect(
  SQLite(),
  "workshop content/03_import/03-db/data/futurama.db"
)

dbWriteTable(connection, "episodes", episodes, overwrite = TRUE)
dbWriteTable(connection, "transcripts", transcripts, overwrite = TRUE)

dbDisconnect(connection)
