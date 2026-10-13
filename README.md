# Basics of Data Science

Material for the **Basics of Data Science** workshop of the EPFL Extension School: two mornings of hands-on data science with R, RStudio, the `{tidyverse}` and R Markdown.

## Workshop content

Everything you need is in `workshop-content/`. The modules are taught in this order:

| Folder | Module |
|---|---|
| `00-agenda` | Agenda and learning objectives |
| `01-what-is-data-science-r-basics` | A brief introduction to data science and R |
| `02-working-with-r-markdown` | Working with R Markdown |
| `03-importing-data` | Importing data |
| `04-data-wrangling` | Data wrangling |
| `05-data-visualisation` | Data visualisation |

Each module folder contains the slides (`presentation.html`, plus `handout.html` where available) and the source they are made from (`.qmd`).

The other folders are shared by all modules:

- `_exercises/`: the exercise notebook you work in during the workshop, `exercise-notebook.qmd`. The slides tell you which exercise to do and when.
- `_prework/`: the preparation sent before the workshop.
- `_renku-setup/`: how to open the workshop on Renku.
- `data/`: the datasets used by the exercises and by modules 04 and 05.

## Working on Renku

The workshop runs on [Renku](https://renkulab.io), in RStudio. Follow the steps in `workshop-content/_renku-setup/dsb-renku-setup.pdf` to open a session. Everything is already installed in the session: you don't need to install any package.

## For maintainers

- **R environment:** Renku builds the session from `renv.lock` (R 4.3.1). `_dependencies.R` lists every package participants need. Adding a `library()` call to the material means adding the package there and updating the lockfile under R 4.3.1.
- **Rendered material:** the `.html` files are committed next to their sources. Re-render a document after editing it.
