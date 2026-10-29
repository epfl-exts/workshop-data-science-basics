# Check that the DE and FR translations still match their EN masters.
#
# Usage (from the repo root):
#   Rscript --vanilla .githooks/check-translations.R                # every translation
#   Rscript --vanilla .githooks/check-translations.R workshop-content/03-importing-data
#   Rscript --vanilla .githooks/check-translations.R --stamp workshop-content/03-importing-data/handout-fr.qmd
#
# A translation sits next to its master and is named after it:
# `presentation.qmd` -> `presentation-de.qmd`, `presentation-fr.qmd`, and the same
# for `handout.qmd` and the exercise notebooks. The master is always the file
# without a language suffix.
#
# Two checks per translation:
# - Staleness. Each translation records in its YAML header the version of its
#   master it was translated from (`translated-from:`, a git blob hash). If the
#   master has changed since, the translation is stale and the script prints
#   the master's diff to port. After porting it, run `--stamp` on the file.
# - Structure. The sequence of headings (level and attributes, not text),
#   fenced divs, `. . .` pauses, `\newpage`s and R chunks must be the same as in
#   the master. Chunks must have the same `#| label:` and the same code,
#   ignoring `#|` options, comments that contain words, and the content of
#   string literals and of backtick-quoted names (e.g. `tribble()` headers),
#   since those are translated.
# Errors make the script exit with status 1. A stale translation is an error.

langs <- c("de", "fr")

read_skeleton <- function(path) {
  lines <- readLines(path, warn = FALSE, encoding = "UTF-8")
  out <- list()
  add <- function(i, what) out[[length(out) + 1]] <<- list(line = i, what = what)
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
      if (grepl("^#+(\\s|$)", line)) {
        level <- nchar(sub("\\s.*", "", line))
        attrs <- regmatches(line, regexpr("\\{[^}]*\\}\\s*$", line))
        add(i, paste0("heading level ", level, if (length(attrs)) paste0(" ", trimws(attrs))))
      } else if (grepl("^:::+\\s*\\S", line)) {
        add(i, paste0("div ", sub("^:::+\\s*", "", trimws(line))))
      } else if (grepl("^:::+\\s*$", line)) {
        add(i, "end of div")
      } else if (grepl("^\\. \\. \\.\\s*$", line)) {
        add(i, "pause . . .")
      } else if (grepl("^\\\\newpage", line)) {
        add(i, "\\newpage")
      }
    } else if (grepl(paste0("^", fence, "`*\\s*$"), line)) {
      body <- if (i - start > 1) lines[(start + 1):(i - 1)] else character()
      if (grepl("^\\{r([ ,].*)?\\}$", info)) {
        lab_line <- grep("^#\\|\\s*label:", body, value = TRUE)
        # a label can also be the first argument of the chunk header: ```{r cars}
        header_label <- sub("^\\{r[ ]+([^ ,}=]+).*$", "\\1", info)
        label <- if (length(lab_line)) {
          gsub("[\"']", "", trimws(sub("^#\\|\\s*label:", "", lab_line[1])))
        } else if (header_label != info) {
          header_label
        } else {
          "<no label>"
        }
        code <- body[!grepl("^#\\|", body)]
        code <- code[!grepl("^\\s*#.*[[:alpha:]]", code)]
        code <- gsub("\"[^\"]*\"", "\"\"", code)
        code <- gsub("'[^']*'", "''", code)
        code <- gsub("`[^`]*`", "``", code)
        code <- trimws(code)
        code <- code[nzchar(code)]
        add(start, paste0("chunk `", label, "`: ", paste(code, collapse = " | ")))
      } else {
        add(start, "display code block")
      }
      fence <- NULL
    }
  }
  out
}

yaml_field <- function(path, field) {
  lines <- readLines(path, warn = FALSE, encoding = "UTF-8")
  hit <- grep(paste0("^", field, ":"), lines, value = TRUE)
  if (!length(hit)) return(NA_character_)
  gsub("[\"']", "", trimws(sub(paste0("^", field, ":"), "", hit[1])))
}

git <- function(...) suppressWarnings(system2("git", c(...), stdout = TRUE, stderr = TRUE))

master_of <- function(path) sub(paste0("-(", paste(langs, collapse = "|"), ")\\.qmd$"), ".qmd", path)

# Hash of the current master; `-w` stores the blob so it can be diffed later
master_blob <- function(master) git("hash-object", "-w", shQuote(master))

stamp <- function(path) {
  master <- master_of(path)
  lines <- readLines(path, warn = FALSE, encoding = "UTF-8")
  i <- grep("^translated-from:", lines)[1]
  if (is.na(i)) stop(path, " has no `translated-from:` line in its YAML header")
  lines[i] <- paste0("translated-from: \"", master_blob(master), "\"")
  writeLines(lines, path, useBytes = TRUE)
  cat(path, "now marked as translated from the current", basename(master), "\n")
}

check_translation <- function(path) {
  master <- master_of(path)
  cat(sprintf("%s <-> %s\n", master, basename(path)))
  errors <- 0

  from <- yaml_field(path, "translated-from")
  current <- master_blob(master)
  if (is.na(from) || !nzchar(from)) {
    errors <- errors + 1
    cat("  ERROR: no `translated-from:` in the YAML header\n")
  } else if (from != current) {
    errors <- errors + 1
    cat("  ERROR: stale, ", basename(master), " changed since this translation. Changes to port:\n", sep = "")
    d <- git("diff", "--no-color", "-U1", from, current)
    if (!is.null(attr(d, "status"))) {
      cat("    (the old master version is not in this git repo, so the diff is unavailable)\n")
    } else {
      cat(paste0("    ", d[-(1:2)]), sep = "\n")
    }
    cat("  After porting, run: Rscript --vanilla .githooks/check-translations.R --stamp ", path, "\n", sep = "")
  }

  en <- read_skeleton(master)
  tr <- read_skeleton(path)
  n <- max(length(en), length(tr))
  for (k in seq_len(n)) {
    a <- if (k <= length(en)) en[[k]] else list(line = NA, what = "<end of file>")
    b <- if (k <= length(tr)) tr[[k]] else list(line = NA, what = "<end of file>")
    if (!identical(a$what, b$what)) {
      errors <- errors + 1
      cat(sprintf("  ERROR: structure differs (element %d)\n    %s:%s  %s\n    %s:%s  %s\n",
                  k, basename(master), a$line, a$what, basename(path), b$line, b$what))
      cat("    (only the first difference is shown)\n")
      break
    }
  }
  if (errors == 0) cat("  ok\n")
  errors
}

args <- commandArgs(trailingOnly = TRUE)
if (length(args) && args[1] == "--stamp") {
  for (path in args[-1]) stamp(path)
  quit(status = 0)
}
dirs <- if (length(args)) args else c(list.dirs("workshop-content", recursive = FALSE))
pattern <- paste0("-(", paste(langs, collapse = "|"), ")\\.qmd$")
files <- unlist(lapply(dirs, function(d) {
  if (file_test("-f", d)) d else list.files(d, pattern = pattern, full.names = TRUE)
}))
files <- files[file.exists(master_of(files))]
if (!length(files)) {
  cat("No translations found.\n")
  quit(status = 0)
}

errors <- sum(vapply(files, check_translation, numeric(1)))
cat(sprintf("\n%d error(s)\n", errors))
quit(status = if (errors > 0) 1 else 0)
