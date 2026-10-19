# Check that each module's presentation.qmd and handout.qmd haven't drifted apart.
#
# Usage (from the repo root):
#   Rscript --vanilla .githooks/check-sync.R                       # all modules
#   Rscript --vanilla .githooks/check-sync.R workshop-content/04-data-wrangling
#
# Rules:
# - Every executable R chunk has a label (`#| label: ...`).
# - A chunk that is in both files has the same label and the same code in both.
#   Chunk options (`#|` lines) are not compared, so slide-only options such as
#   `code-line-numbers` or `output-location` are free.
# - A chunk that belongs to one file only has a label starting with `slides-`
#   or `handout-`.
# - `setup` chunks are exempt: each format may set its own options.
# Errors make the script exit with status 1. Differences in the `#` section
# headings and in display-only code blocks (```` ``` r ````) are only warnings.
# A section that is deliberately in one file only carries the class
# `.slides-only` or `.handout-only`, e.g. `# Questions? {.slides-only}`.

read_qmd <- function(path) {
  lines <- readLines(path, warn = FALSE, encoding = "UTF-8")
  chunks <- list()
  display <- character()
  headings <- character()
  fence <- NULL
  start <- 0
  in_yaml <- length(lines) > 0 && lines[1] == "---"
  for (i in seq_along(lines)) {
    line <- lines[i]
    if (in_yaml) {
      if (i > 1 && line == "---") in_yaml <- FALSE
      next
    }
    if (is.null(fence)) {
      m <- regmatches(line, regexec("^(`{3,})\\s*(.*)$", line))[[1]]
      if (length(m)) {
        fence <- m[2]
        info <- m[3]
        start <- i
        next
      }
      if (grepl("^# ", line) && !grepl("\\.(slides|handout)-only\\b", line)) {
        h <- sub("\\s*\\{[^}]*\\}\\s*$", "", sub("^# ", "", line))
        headings <- c(headings, trimws(h))
      }
    } else if (grepl(paste0("^", fence, "`*\\s*$"), line)) {
      body <- if (i - start > 1) lines[(start + 1):(i - 1)] else character()
      if (grepl("^\\{r([ ,].*)?\\}$", info)) {
        opts <- sub("^\\{r[ ,]?\\s*(.*)\\}$", "\\1", info)
        first <- trimws(strsplit(opts, ",")[[1]][1])
        label <- if (!is.na(first) && nzchar(first) && !grepl("=", first)) first else NA
        lab_line <- grep("^#\\|\\s*label:", body, value = TRUE)
        if (length(lab_line)) {
          label <- gsub("[\"']", "", trimws(sub("^#\\|\\s*label:", "", lab_line[1])))
        }
        code <- sub("\\s+$", "", body[!grepl("^#\\|", body)])
        while (length(code) && !nzchar(code[1])) code <- code[-1]
        while (length(code) && !nzchar(code[length(code)])) code <- code[-length(code)]
        chunks[[length(chunks) + 1]] <- list(label = label, line = start, code = code)
      } else {
        display <- c(display, paste(trimws(body), collapse = "\n"))
      }
      fence <- NULL
    }
  }
  list(chunks = chunks, display = display, headings = headings)
}

check_module <- function(dir) {
  files <- file.path(dir, c("presentation.qmd", "handout.qmd"))
  if (!all(file.exists(files))) return(c(errors = 0, warnings = 0))
  name <- basename(normalizePath(dir))
  errors <- 0
  warnings <- 0
  say <- function(kind, ...) cat(sprintf("  %s: %s\n", kind, paste0(...)))
  err <- function(...) { errors <<- errors + 1; say("ERROR", ...) }
  warn <- function(...) { warnings <<- warnings + 1; say("warning", ...) }

  p <- read_qmd(files[1])
  h <- read_qmd(files[2])
  cat(name, "\n")

  index <- function(doc, file) {
    out <- list()
    for (ch in doc$chunks) {
      if (is.na(ch$label)) {
        err(file, ":", ch$line, ": chunk without a label (add `#| label: ...`)")
      } else if (!is.null(out[[ch$label]])) {
        err(file, ":", ch$line, ": label `", ch$label, "` is used twice")
      } else {
        out[[ch$label]] <- ch
      }
    }
    out
  }
  pc <- index(p, "presentation.qmd")
  hc <- index(h, "handout.qmd")

  for (lab in setdiff(names(pc), names(hc))) {
    if (!startsWith(lab, "slides-")) {
      err("chunk `", lab, "` (presentation.qmd:", pc[[lab]]$line,
          ") is missing from handout.qmd; if it is slide-only, prefix its label with `slides-`")
    }
  }
  for (lab in setdiff(names(hc), names(pc))) {
    if (!startsWith(lab, "handout-")) {
      err("chunk `", lab, "` (handout.qmd:", hc[[lab]]$line,
          ") is missing from presentation.qmd; if it is handout-only, prefix its label with `handout-`")
    }
  }
  for (lab in intersect(names(pc), names(hc))) {
    if (lab == "setup") next
    a <- pc[[lab]]$code
    b <- hc[[lab]]$code
    if (!identical(a, b)) {
      err("chunk `", lab, "` differs (presentation.qmd:", pc[[lab]]$line,
          ", handout.qmd:", hc[[lab]]$line, ")")
      n <- max(length(a), length(b))
      for (k in seq_len(n)) {
        if (!identical(a[k], b[k])) {
          cat(sprintf("      line %d\n        slides:  %s\n        handout: %s\n",
                      k, ifelse(is.na(a[k]), "<none>", a[k]), ifelse(is.na(b[k]), "<none>", b[k])))
          break
        }
      }
    }
  }

  only <- function(x, y) x[!(x %in% y)]
  for (s in only(p$headings, h$headings)) warn("section `# ", s, "` is only in presentation.qmd")
  for (s in only(h$headings, p$headings)) warn("section `# ", s, "` is only in handout.qmd")
  for (d in unique(only(p$display, h$display))) {
    warn("a display code block is only in presentation.qmd: ", strsplit(d, "\n")[[1]][1], " ...")
  }
  for (d in unique(only(h$display, p$display))) {
    warn("a display code block is only in handout.qmd: ", strsplit(d, "\n")[[1]][1], " ...")
  }
  if (errors + warnings == 0) cat("  ok\n")
  c(errors = errors, warnings = warnings)
}

args <- commandArgs(trailingOnly = TRUE)
if (!length(args)) {
  args <- list.dirs("workshop-content", recursive = FALSE)
}
totals <- rowSums(vapply(args, check_module, c(errors = 0, warnings = 0)))
cat(sprintf("\n%d error(s), %d warning(s)\n", totals[["errors"]], totals[["warnings"]]))
quit(status = if (totals[["errors"]] > 0) 1 else 0)
