library(pxR)


library(tidyverse)




pop <- pxR::read.px("preparation/data_population/px-x-0102020000_401.px")


pop_data <- pop %>%
  pluck("DATA", "value") %>%
  janitor::clean_names() %>%
  dplyr::rename(year = jahr,
         household_size= haushaltsgrosse,
         canton_district_commune = kanton_bezirk_gemeinde) %>%
  mutate(admin_level = case_when(
    str_detect(canton_district_commune, "^-") ~ 1,
    str_detect(canton_district_commune, ">>") ~ 2,
    str_detect(canton_district_commune, "\\.\\d{4}") ~ 3,
    TRUE ~ 0
  ))%>%
  mutate(household_size = as.character(household_size),
         year = as.character(year),
         canton_district_commune = as.character(canton_district_commune))


cantons <- pop_data %>%
  filter(admin_level == 1) %>%
  mutate(canton_district_commune = str_remove(canton_district_commune, "- ")) %>%
  filter(!str_detect(household_size, "Total")) %>%
  dplyr::rename(canton = canton_district_commune) %>%
  mutate(household_size = as.character(household_size),
         year = as.character(year))


districts <- pop_data %>%
  filter(admin_level == 2) %>%
  mutate(canton_district_commune = str_remove(canton_district_commune, ">> ")) %>%
  filter(!str_detect(household_size, "Total")) %>%
  dplyr::rename(district = canton_district_commune) %>%
  mutate(household_size = as.character(household_size),
         year = as.character(year))


communes <- pop_data %>%
  filter(admin_level == 3) %>%
  mutate(canton_district_commune = str_remove_all(canton_district_commune, "\\.")) %>%
  filter(!str_detect(household_size, "Total")) %>%
  dplyr::rename(commune = canton_district_commune) %>%
  mutate(household_size = as.character(household_size),
         year = as.character(year))


# now I create a table with just commune and districts


tot <- pop_data %>%
  distinct(canton_district_commune, admin_level) %>%
  slice(-1) %>%
  mutate(canton = ifelse(admin_level == 1, canton_district_commune, NA)) %>%
  mutate(canton = str_remove(canton, "- ")) %>%
  fill(canton, .direction = "down") %>%
  mutate(district = ifelse(admin_level == 2, canton_district_commune, NA)) %>%
  mutate(district = str_remove(district, ">> ")) %>%
  fill(district, .direction = "down") %>%
  mutate(district = ifelse(admin_level == 1, NA, district)) %>%
  mutate(commune = ifelse(admin_level == 3, canton_district_commune, NA)) %>%
  mutate(commune = str_remove_all(commune, "\\.")) %>%
  fill(commune, .direction = "down") %>%
  mutate(commune = ifelse(admin_level %in% c(1:2), NA, commune))


communes_ids <- tot %>%
  distinct(commune, district) %>%
  drop_na(commune)


district_ids <- tot %>%
  distinct(canton, district) %>%
  drop_na(district)


## make communes population data wide

communes_wide <- communes %>%
  pivot_wider(names_from = year, values_from = value)



# export relevant data

write_excel_csv(communes_wide, "preparation/data_population/communes_population.csv")

write_excel_csv(communes_ids, "preparation/data_population/communes_ids.csv")

write_excel_csv(district_ids, "preparation/data_population/district_ids.csv")
