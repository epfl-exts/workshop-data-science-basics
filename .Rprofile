# Renku builds R through conda, whose system libraries (harfbuzz, freetype,
# fribidi, libpng, ...) sit outside pkg-config's default search path. Packages
# that renv has to compile from source (textshaping, ragg) then fail to
# configure. Point pkg-config at conda's .pc files. No-op on other setups.
local({
  pc <- normalizePath(file.path(R.home(), "..", "pkgconfig"), mustWork = FALSE)
  if (Sys.info()[["sysname"]] == "Linux" && file.exists(file.path(pc, "harfbuzz.pc"))) {
    old <- Sys.getenv("PKG_CONFIG_PATH")
    Sys.setenv(PKG_CONFIG_PATH = paste(c(pc, old[nzchar(old)]), collapse = ":"))
    if (nzchar(Sys.getenv("CNB_LAYERS_DIR")))
      message(".Rprofile: PKG_CONFIG_PATH = ", Sys.getenv("PKG_CONFIG_PATH"))
  }
})

source("renv/activate.R")
