#' My first script : Solution
#'
#' This script is the soltuion for the exercise in section `01-what-is-r`
#' of the Data Science Basics Workshop

# Basic Arithmetic

5 + 5
30 / 6

# Storing data in variables

## Single values
my_single_value <- 5

my_single_value

## Collections: Vectors

a_collection_of_values <- c(1, 2, 3)
a_collection_of_values

# Working with variables

my_single_value + 5
a_collection_of_values * my_single_value

# Datasets in variables: SPOILER!

library(readr)

rolling_stones_data <- read_csv("data/rolling_stones.csv")
slice_head(rolling_stones_data)

sales_data <- read_tsv("data/sales_data.tsv", skip = 3)
slice_head(sales_data)

# Using packages

slice_head(cars) # expect an error



