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

### Rendering

The rendered `.html` files are committed next to their sources: after editing a `.qmd`, re-render it and commit both.

Render with **R 4.3.1**, the version on Renku, so that your output matches what participants get. With [rig](https://github.com/r-lib/rig), point Quarto at it:

```bash
export QUARTO_R=/Library/Frameworks/R.framework/Versions/4.3-x86_64/Resources/bin/Rscript   # macOS
```

**Single-format documents** (modules 03–05, `_exercises/`) render as usual:

```bash
quarto render workshop-content/04-data-wrangling/presentation.qmd
```

**Two-format documents** (`content.qmd` in modules 00–02, which give both `presentation.html` and `handout.html`) must be rendered **one format at a time**:

```bash
quarto render workshop-content/01-what-is-data-science-r-basics/content.qmd --to revealjs   # → presentation.html
quarto render workshop-content/01-what-is-data-science-r-basics/content.qmd --to html       # → handout.html
```

A plain `quarto render content.qmd` (both formats at once) produces broken slides with Quarto 1.10: they still point to a `content_files/libs/` folder that no longer exists, and display unstyled. Quarto warns `Could not fetch resource content_files/libs/...`. **Check every two-format render before committing:**

```bash
grep -c content_files workshop-content/0[0-2]-*/presentation.html workshop-content/0[0-2]-*/handout.html
```

Every count must be `0`. A broken deck is also easy to spot by its size: around 100 KB instead of several MB.

Other things to watch:

- **Never use `--output-dir`** for a test render: Quarto then deletes the committed `.html` next to the source and writes a `.gitignore` into the module folder.
- **`_exercises/exercise-solution.html` isn't self-contained.** A re-render also changes `exercise-solution_files/`, sometimes with new file names: stage the whole folder with it.
- **Example code chunks:** to *show* a chunk header in the material rather than run it, write `` ```{{r}} ``. A literal `` ```{r} `` is run by knitr, even inside a block fenced with four backticks, and garbles the rest of the document (Quarto then warns about stray `:::`).
- **Tabsets in slides:** tab titles inside a `panel-tabset` must be `###`. With `slide-level: 2`, a `##` starts a new slide and breaks the tabset.
- **Data paths:** documents read data relative to their own folder. Shared data lives in `workshop-content/data/` and is read as `../data/...`.

### R environment

Renku builds the session image from `renv.lock`, which pins **R 4.3.1**. `.Rprofile` activates renv, so locally the project library is `renv/library/` (not committed).

- **Adding a package:** `_dependencies.R` lists every package participants need (it is never run; it only makes `renv::snapshot()` record them). Adding a `library()` call to the material means adding the package there and snapshotting **under R 4.3.1**, or the lockfile records your local R version:

  ```bash
  rig run --r-version 4.3-x86_64 -e 'renv::install("pkg"); renv::snapshot()'
  ```

- **After every snapshot, check three records in `renv.lock`.** `stringi`, `ragg` and `readxl` must keep `"Repository": "https://cloud.r-project.org"`; a snapshot resets them to `"CRAN"` or `"RSPM"`. Renku installs R through conda, whose system libraries differ from Ubuntu's. The CRAN URL makes these packages compile from source against conda's libraries instead of downloading an Ubuntu binary that fails to load (for stringi: `libicui18n.so.74: cannot open shared object file`).
- **Minimum versions for Renku's compiler** (conda's GCC 16 in October 2026). Locked versions that aren't current on CRAN are compiled on Renku, and old sources can fail with a newer compiler:
  - `ragg` ≥ 1.3.3: older versions don't compile against FreeType ≥ 2.13.3.
  - `readxl` ≥ 1.4.5: 1.4.3 doesn't compile with GCC 16.
- **Keep the `PKG_CONFIG_PATH` block at the top of `.Rprofile`.** It lets packages that compile from source (textshaping, ragg) find conda's graphics libraries (harfbuzz, freetype, fribidi, libpng, ...). It does nothing outside Renku. During a Renku build, the log shows `.Rprofile: PKG_CONFIG_PATH = ...`; if a build fails and that line is missing, `.Rprofile` was not read.
- **When a Renku build fails**, search its log for the first `FAILED` package and read the compiler error below it. It is usually either a missing library (`pkg-config`, `.h: No such file`) or an old package version that the new compiler rejects; in the second case, upgrade that package to a version that fixes it.

### Saving work on Renku

Renku sessions can't push to git, and RStudio's *Export* fails for folders and multiple files (`error in running command`), most likely because the session has no `zip` program. Module 01 ("💾 Saving today's work") teaches participants to download their files one at a time, or to pack their own `.qmd`/`.Rmd`/`.R` files with `tar(..., tar = "internal")` first. The archive leaves out Quarto's `*_files/` folders on purpose: their long file names make `tar()` warn that paths over 100 bytes are not portable.
