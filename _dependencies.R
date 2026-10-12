# Complete list of R packages available to workshop participants on Renku.
#
# This file is never run. renv scans it so that renv::snapshot() records
# every package below in renv.lock, including those no workshop document
# attaches yet (e.g. {here}). Renku builds the session image from renv.lock.
#
# Adding a library() call to any workshop document REQUIRES adding the
# package here and running renv::snapshot() under R 4.3.1 (the Renku
# version), or the document breaks for every participant.

# The tidyverse supplies dplyr, ggplot2, readr, tidyr, stringr, forcats
# and lubridate, so none of those need listing separately.
library(tidyverse)

library(janitor)
library(knitr)
library(rmarkdown)
library(visdat)
library(here)
library(readxl)
library(haven)
library(DT)
library(kableExtra)

# Deliberately NOT listed:
#
#   xaringan / icons - needed only to re-render the legacy module 01 deck.
#     {icons} is not on CRAN, and module 01 now uses the Quarto content.qmd.
