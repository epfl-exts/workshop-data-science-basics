# Complete list of R packages available to workshop participants on Renku.
#
# Adding a library() call to any workshop document REQUIRES adding the
# package here, or the document breaks for every participant.

# The tidyverse supplies dplyr, ggplot2, readr, tidyr, stringr, forcats
# and lubridate, so none of those need listing separately.
install.packages("tidyverse")

install.packages("janitor")
install.packages("knitr")
install.packages("visdat")
install.packages("here")
install.packages("readxl")
install.packages("haven")
install.packages("DT")
install.packages("kableExtra")

# Deliberately NOT installed:
#
#   xaringan / icons - needed only to re-render the legacy slide deck
#     01-what-is-data-science-r-basics/presentation.Rmd. Participants never
#     render it, they read the committed .html. {icons} is not on CRAN
#     (github.com/mitchelloharawild/icons) and needs a post-install asset
#     download, so that deck is instructor-renderable only. The Quarto
#     deck presentation_slides.qmd beside it has no such dependency.
