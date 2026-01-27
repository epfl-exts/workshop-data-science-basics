R’s native binary format
================
Iegor Rudnytskyi

In the previous units, we considered various file formats for storing
data and how to read them by R. However, this subject won’t be complete
without mentioning R’s native binary format called RDS (stand for R Data
**Single**). There are two major advantages of using this file
extension: it is much faster to read/write files compared to, e.g., CSV,
and the size of such files is much lower when compared to alternatives.
In this unit, we will quickly cover the main functions to import and
export data in RDS format.

### `read_rds()`/`write_rds()`

Imagine, you are through the main steps of the data science pipeline.
The data of interest was imported, cleaned, and wrangled. Next time you
want to work on this project, you do not want to re-run these
time-consuming scripts to get where you are right now. It would be wise
to save an intermediate step(s) (you can think of it as saving
intermediate stages when you work with your Excel sheet), so that you
can read immediately the clean and nice dataset.

CSV files (and other data files) would do the trick. However, we have
much more powerful solution – the pair of `read_rds()`/`write_rds()`
functions. They are extremely easy to use, and in most cases, you do not
have to worry about various arguments. Even though there are other
functions from base R that do a similar job, we will focus on
`read_rds()`/`write_rds()` as they are a part of `{tidyverse}`.

In the following example, we will show you how to export and then import
the data to R. There is a built-in `iris` dataset – it’s available
straight away:

``` r
head(iris)
```

    ##   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
    ## 1          5.1         3.5          1.4         0.2  setosa
    ## 2          4.9         3.0          1.4         0.2  setosa
    ## 3          4.7         3.2          1.3         0.2  setosa
    ## 4          4.6         3.1          1.5         0.2  setosa
    ## 5          5.0         3.6          1.4         0.2  setosa
    ## 6          5.4         3.9          1.7         0.4  setosa

To export this data into `iris.rds`, you can use the following command:

``` r
library(readr)

write_rds(iris, "data/iris.RDS")
```

Equivalently, to import the data from `iris.RDS`, we use `write_rds()`’s
antagonist – `read_rds()`:

``` r
my_iris <- read_rds("data/iris.RDS")
```

``` r
head(my_iris)
```

    ##   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
    ## 1          5.1         3.5          1.4         0.2  setosa
    ## 2          4.9         3.0          1.4         0.2  setosa
    ## 3          4.7         3.2          1.3         0.2  setosa
    ## 4          4.6         3.1          1.5         0.2  setosa
    ## 5          5.0         3.6          1.4         0.2  setosa
    ## 6          5.4         3.9          1.7         0.4  setosa

The nice thing is that the object to save should not necessarily be a
tibble, it can be anything: vector, list, function, you name it.
