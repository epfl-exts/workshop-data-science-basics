Excel files
================
Iegor Rudnytskyi

The chances that you have never been asked to work with Excel sheets
tend to zero. Perhaps, it could be the most popular format for storing
small datasets. In this unit, we will learn how to import data from
Excel files, both legacy `.xls` and current `.xlsx` formats.

------------------------------------------------------------------------

### `{readxl}`

There are plenty of packages in R that can read the data from Excel
(`{xlsx}`, `{openxlsx}`, `XLConnect` to name a few). We will focus on
`{readxl}` package which is a part of `{tidyverse}`. Using a package
from `{tidyverse}` would allow us to stay within this ecosystem ensuring
that functions are compatible with each other. Other benefits of using
`{readxl}` include nice syntax, and absence of dependencies (other
packages might require installing Java on your computer). Even though
`{readxl}` is a part of `{tidyverse}`, it is not included into its core
part. Therefore, we will need to install it separately:

``` r
install.packages("readxl")
```

Once it is installed, we can load it:

``` r
library(readxl)
```

To read the data from Excel into R, we use several function, namely
`read_xls()` and `read_xlsx()` for `.xls` and `.xlsx` file formats,
respectively. There is also `read_excel()` that can guess the file
format automatically. Naturally, the first argument of the function is
the file path, just like in `read_csv()`. That is why consistency is so
important in `{tidyverse}` – it is enough to be a little familiar with
the function to be able to predict its behavior.

The `team` dataset is also saved as an Excel file, and to read it, we
will use `read_xlsx`. Before jumping to the next line, please open the
file and have a look at how it is structured.

``` r
team <- read_xlsx("data/team.xlsx")
team
```

    ## # A tibble: 20 x 5
    ##    name      gender weight height   bmi
    ##    <chr>     <chr>   <dbl>  <dbl> <dbl>
    ##  1 Hilma     Female     62    184  18.3
    ##  2 Olga      Female     66    183  19.7
    ##  3 Freddy    Male       61    176  19.7
    ##  4 Louise    Female     73    155  30.4
    ##  5 Cherly    Female     67    181  20.4
    ##  6 Ranee     Female     61    174  20.2
    ##  7 Laronda   Female     67    173  22.4
    ##  8 Alvina    Female     69    160  27.0
    ##  9 Mack      Male       68    170  23.5
    ## 10 Faye      Female     63    179  19.7
    ## 11 Alline    Female     73    189  20.4
    ## 12 Jerry     Male       67    174  22.1
    ## 13 Tommie    Female     62    179  19.4
    ## 14 Caroyln   Female     54    174  17.8
    ## 15 Sybil     Female     71    161  27.4
    ## 16 Tabitha   Female     65    171  22.2
    ## 17 Gabriella Female     65    171  22.2
    ## 18 Daine     Female     70    174  23.1
    ## 19 Ed        Male       69    186  19.9
    ## 20 Darci     Female     68    183  20.3

Works like a charm! But let’s ask ourselves: are Excel files always that
clean and tidy? If you hesitate to answer, then we show you the file
`je-e-06.02.00.01.02.xlsx` in the folder `data`. At the end of this
unit, you should be able to get any data that you need from this Excel
file. But first, let’s scroll over the useful arguments:

#### `sheet`

The Excel file can have multiple sheets and the argument `sheet`
controls which sheet should be read into tibble. It can be passed as a
character representation of the sheet (e.g.,
`"Seasonally adjusted total"`) or as the numerical index (e.g., `2`). By
default, `read_xlsx()` uses the first sheet, and we can easily alternate
that:

``` r
women_jobs <- read_xlsx(
  "../../../data/fso_data/je-e-06.02.00.01.02.xlsx",
  sheet = "Women"
)
```

    ## New names:
    ## * `` -> ...2
    ## * `` -> ...3
    ## * `` -> ...4
    ## * `` -> ...5
    ## * `` -> ...6
    ## * ...

``` r
women_jobs
```

    ## # A tibble: 75 x 120
    ##    `06.02.00.01.02d… ...2  ...3  ...4  ...5  ...6  ...7  ...8  ...9  ...10 ...11
    ##    <chr>             <chr> <chr> <chr> <chr> <chr> <chr> <chr> <chr> <chr> <chr>
    ##  1 "Full time and p… <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA> 
    ##  2 "Women"           <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA> 
    ##  3 "Quarterly value… <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA> 
    ##  4  <NA>             <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA> 
    ##  5 "Economic branch… <NA>  <NA>  1991  <NA>  1992  <NA>  <NA>  <NA>  1993  <NA> 
    ##  6  <NA>             <NA>  <NA>  III   IV    I     II    III   IV    I     II   
    ##  7  <NA>             <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA> 
    ##  8 "B-S"             5-96  Total 1710… 1704… 1699… 1696… 1672… 1638… 1632… 1644…
    ##  9  <NA>             <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA> 
    ## 10 "B-F"             5-43  SECT… 2982… 2941… 2904… 2883… 2765… 2700… 2679… 2697…
    ## # … with 65 more rows, and 109 more variables: ...12 <chr>, ...13 <chr>,
    ## #   ...14 <chr>, ...15 <chr>, ...16 <chr>, ...17 <chr>, ...18 <chr>,
    ## #   ...19 <chr>, ...20 <chr>, ...21 <chr>, ...22 <chr>, ...23 <chr>,
    ## #   ...24 <chr>, ...25 <chr>, ...26 <chr>, ...27 <chr>, ...28 <chr>,
    ## #   ...29 <chr>, ...30 <chr>, ...31 <chr>, ...32 <chr>, ...33 <chr>,
    ## #   ...34 <chr>, ...35 <chr>, ...36 <chr>, ...37 <chr>, ...38 <chr>,
    ## #   ...39 <chr>, ...40 <chr>, ...41 <chr>, ...42 <chr>, ...43 <chr>,
    ## #   ...44 <chr>, ...45 <chr>, ...46 <chr>, ...47 <chr>, ...48 <chr>,
    ## #   ...49 <chr>, ...50 <chr>, ...51 <chr>, ...52 <chr>, ...53 <chr>,
    ## #   ...54 <chr>, ...55 <chr>, ...56 <chr>, ...57 <chr>, ...58 <chr>,
    ## #   ...59 <chr>, ...60 <chr>, ...61 <chr>, ...62 <chr>, ...63 <chr>,
    ## #   ...64 <chr>, ...65 <chr>, ...66 <chr>, ...67 <chr>, ...68 <chr>,
    ## #   ...69 <chr>, ...70 <chr>, ...71 <chr>, ...72 <chr>, ...73 <chr>,
    ## #   ...74 <chr>, ...75 <chr>, ...76 <chr>, ...77 <chr>, ...78 <chr>,
    ## #   ...79 <chr>, ...80 <chr>, ...81 <chr>, ...82 <chr>, ...83 <chr>,
    ## #   ...84 <chr>, ...85 <chr>, ...86 <chr>, ...87 <chr>, ...88 <chr>,
    ## #   ...89 <chr>, ...90 <chr>, ...91 <chr>, ...92 <chr>, ...93 <chr>,
    ## #   ...94 <chr>, ...95 <chr>, ...96 <chr>, ...97 <chr>, ...98 <chr>,
    ## #   ...99 <chr>, ...100 <chr>, ...101 <chr>, ...102 <chr>, ...103 <chr>,
    ## #   ...104 <chr>, ...105 <chr>, ...106 <chr>, ...107 <chr>, ...108 <chr>,
    ## #   ...109 <chr>, ...110 <chr>, ...111 <chr>, …

There is definitely something that went wrong, so it is not enough to
provide only the sheet.

By the way, to get the names of the Excel file, you can use the function
`excel_sheets`:

``` r
excel_sheets("../../../data/fso_data/je-e-06.02.00.01.02.xlsx")
```

    ## [1] "Total"                     "Seasonally adjusted total"
    ## [3] "Men"                       "Women"

It can be useful if you want to specify the sheet not by its position
but by its name.

#### `range`

The reason why specifying the `sheet` is not enough is that we have data
all over the place, and it is not easy where the data is located. We
need a tool to let R know where to look for data. In Excel, each cell
has its row number and its column letter(s). That is the way how you can
refer to a particular column. For example, a cell D14 is the cell
located on the fourteenth row and in the fourth column. We can also
refer to a rectangular cell range by specifying its upper left and lower
right cell separated by `:`, for example, `B2:K14`. This notion is
implemented as the `range` argument of `read_xlsx()` and friends – we
can specify a particular range that will be treated as data.

We can modify our initial expression to accommodate a particular range,
say between A9 and DP72:

``` r
women_jobs <- read_xlsx(
  "../../../data/fso_data/je-e-06.02.00.01.02.xlsx",
  sheet = "Women",
  range = "A9:DP72"
)

women_jobs
```

    ## # A tibble: 63 x 120
    ##    `B-S` `5-96` Total             `1710064.5499` `1704262.475400… `1699109.2015`
    ##    <chr> <chr>  <chr>                      <dbl>            <dbl>          <dbl>
    ##  1 <NA>  <NA>   <NA>                         NA               NA             NA 
    ##  2 B-F   5-43   SECTOR II                298283.          294159.        290407.
    ##  3 <NA>  <NA>   <NA>                         NA               NA             NA 
    ##  4 B     5-9    Mining and quarr…           353.             350.           345.
    ##  5 C     10-33  Manufactury              259643.          254771.        251217.
    ##  6 <NA>  10-12  Manufacture of f…         39272.           38052.         37138.
    ##  7 <NA>  13-15  Manufacture of t…         37266.           36377.         35894.
    ##  8 <NA>  16-18  Manufacture of w…         29553.           29280.         28934.
    ##  9 <NA>  19-20  Manufacture of c…         15547.           15173.         15049.
    ## 10 <NA>  21     Manufacture of p…          9953.            9719.          9630.
    ## # … with 53 more rows, and 114 more variables: 1696893.0288 <dbl>,
    ## #   1672964.4538 <dbl>, 1638676.3631 <dbl>, 1632557.2704 <dbl>,
    ## #   1644530.6231 <dbl>, 1638546.6857 <dbl>, 1628677.7028000001 <dbl>,
    ## #   1614918.9143000001 <dbl>, 1609477.7178 <dbl>, 1638743.5467000001 <dbl>,
    ## #   1630486.8839 <dbl>, 1639813.3154 <dbl>, 1636397.9375 <dbl>,
    ## #   1641207.1146 <dbl>, 1632228.8348000001 <dbl>, 1621344.7398000001 <dbl>,
    ## #   1630193.0596 <dbl>, 1618614.4722 <dbl>, 1623271.0473 <dbl>,
    ## #   1621275.5107 <dbl>, 1629347.9480000001 <dbl>, 1639733.9203999999 <dbl>,
    ## #   1630273.5474 <dbl>, 1637161.3728 <dbl>, 1641970.5199 <dbl>,
    ## #   1652154.6396999999 <dbl>, 1657090.3328 <dbl>, 1667352.699 <dbl>,
    ## #   1685081.574 <dbl>, 1710015.69 <dbl>, 1723944.2842999999 <dbl>,
    ## #   1739346.3711000001 <dbl>, 1761597.0652999999 <dbl>, 1774681.4885 <dbl>,
    ## #   1783498.5430000001 <dbl>, 1788744.4976999999 <dbl>,
    ## #   1784958.4828999999 <dbl>, 1798737.0669 <dbl>, 1791042.1916 <dbl>,
    ## #   1794442.2472999999 <dbl>, 1792206.4502000001 <dbl>, 1812263.8628 <dbl>,
    ## #   1787374.4188000001 <dbl>, 1781517.3759999999 <dbl>, 1791738.8166 <dbl>,
    ## #   1810930.689 <dbl>, 1811735.6954000001 <dbl>, 1816317.2472000001 <dbl>,
    ## #   1825131.3713 <dbl>, 1829903.2135999999 <dbl>, 1826492.4828000001 <dbl>,
    ## #   1821634.9029000001 <dbl>, 1826803.8796999999 <dbl>,
    ## #   1849642.3322999999 <dbl>, 1846725.1782 <dbl>, 1859696.9750999999 <dbl>,
    ## #   1872030.2164 <dbl>, 1907315.7050999999 <dbl>, 1914386.0109000001 <dbl>,
    ## #   1924172.0730000001 <dbl>, 1949478.9234 <dbl>, 1981284.7611 <dbl>,
    ## #   1995077.7457000001 <dbl>, 2012206.7951 <dbl>, 2033841.081 <dbl>,
    ## #   2049006.4076 <dbl>, 2037916.6865000001 <dbl>, 2037337.8067999999 <dbl>,
    ## #   2032626.2280999999 <dbl>, 2047547.9261 <dbl>, 2044370.2853000001 <dbl>,
    ## #   2049128.5536 <dbl>, 2052854.2013999999 <dbl>, 2071849.827 <dbl>,
    ## #   2075597.6187 <dbl>, 2068476.2668000001 <dbl>, 2084648.5438000001 <dbl>,
    ## #   2100413.3454 <dbl>, 2099037.0419999999 <dbl>, 2108425.6773000001 <dbl>,
    ## #   2124193.5216000001 <dbl>, 2154072.7211000002 <dbl>, 2159015.5055 <dbl>,
    ## #   2159961.4963000002 <dbl>, 2169799.068 <dbl>, 2186916.35 <dbl>,
    ## #   2181245.3229999999 <dbl>, 2185471.2799999998 <dbl>,
    ## #   2190144.5726000001 <dbl>, 2208903.7815 <dbl>, 2215398.3366999999 <dbl>,
    ## #   2208587.1076000002 <dbl>, 2227838.4279999998 <dbl>,
    ## #   2249572.7650000001 <dbl>, 2255127.9114000001 <dbl>, 2250365.2736 <dbl>,
    ## #   2259122.4558000001 <dbl>, 2276130.4542 <dbl>, 2290862.2080999999 <dbl>,
    ## #   2271846.6334000002 <dbl>, …

We are one step closer, but still not there. The column names contain
values, so we need somehow to let R know that we need to treat them as
values instead. But that’s something that we’ve learned already, no?

#### `col_names`

Well, yes. The function `read_xlsx()` has an identical argument
`col_names` as the function `read_csv()`. The behavior is absolutely the
same, and you know what to expect – set it to `FALSE`, and the first
line won’t be considered as column names. This consistency is what we
love the most about `{tidyverse}` – everything works as expected.

``` r
women_jobs <- read_xlsx(
  "../../../data/fso_data/je-e-06.02.00.01.02.xlsx",
  sheet = "Women",
  range = "A9:DP72", 
  col_names = FALSE, 
)
```

    ## New names:
    ## * `` -> ...1
    ## * `` -> ...2
    ## * `` -> ...3
    ## * `` -> ...4
    ## * `` -> ...5
    ## * ...

``` r
women_jobs
```

    ## # A tibble: 64 x 120
    ##    ...1  ...2  ...3         ...4    ...5    ...6    ...7    ...8    ...9   ...10
    ##    <chr> <chr> <chr>       <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>
    ##  1 B-S   5-96  Total      1.71e6  1.70e6  1.70e6  1.70e6  1.67e6  1.64e6  1.63e6
    ##  2 <NA>  <NA>  <NA>      NA      NA      NA      NA      NA      NA      NA     
    ##  3 B-F   5-43  SECTOR II  2.98e5  2.94e5  2.90e5  2.88e5  2.77e5  2.70e5  2.68e5
    ##  4 <NA>  <NA>  <NA>      NA      NA      NA      NA      NA      NA      NA     
    ##  5 B     5-9   Mining a…  3.53e2  3.50e2  3.45e2  3.50e2  3.45e2  3.40e2  3.34e2
    ##  6 C     10-33 Manufact…  2.60e5  2.55e5  2.51e5  2.49e5  2.40e5  2.33e5  2.31e5
    ##  7 <NA>  10-12 Manufact…  3.93e4  3.81e4  3.71e4  3.72e4  3.65e4  3.58e4  3.45e4
    ##  8 <NA>  13-15 Manufact…  3.73e4  3.64e4  3.59e4  3.53e4  3.30e4  3.23e4  3.13e4
    ##  9 <NA>  16-18 Manufact…  2.96e4  2.93e4  2.89e4  2.88e4  2.72e4  2.62e4  2.67e4
    ## 10 <NA>  19-20 Manufact…  1.55e4  1.52e4  1.50e4  1.48e4  1.45e4  1.43e4  1.40e4
    ## # … with 54 more rows, and 110 more variables: ...11 <dbl>, ...12 <dbl>,
    ## #   ...13 <dbl>, ...14 <dbl>, ...15 <dbl>, ...16 <dbl>, ...17 <dbl>,
    ## #   ...18 <dbl>, ...19 <dbl>, ...20 <dbl>, ...21 <dbl>, ...22 <dbl>,
    ## #   ...23 <dbl>, ...24 <dbl>, ...25 <dbl>, ...26 <dbl>, ...27 <dbl>,
    ## #   ...28 <dbl>, ...29 <dbl>, ...30 <dbl>, ...31 <dbl>, ...32 <dbl>,
    ## #   ...33 <dbl>, ...34 <dbl>, ...35 <dbl>, ...36 <dbl>, ...37 <dbl>,
    ## #   ...38 <dbl>, ...39 <dbl>, ...40 <dbl>, ...41 <dbl>, ...42 <dbl>,
    ## #   ...43 <dbl>, ...44 <dbl>, ...45 <dbl>, ...46 <dbl>, ...47 <dbl>,
    ## #   ...48 <dbl>, ...49 <dbl>, ...50 <dbl>, ...51 <dbl>, ...52 <dbl>,
    ## #   ...53 <dbl>, ...54 <dbl>, ...55 <dbl>, ...56 <dbl>, ...57 <dbl>,
    ## #   ...58 <dbl>, ...59 <dbl>, ...60 <dbl>, ...61 <dbl>, ...62 <dbl>,
    ## #   ...63 <dbl>, ...64 <dbl>, ...65 <dbl>, ...66 <dbl>, ...67 <dbl>,
    ## #   ...68 <dbl>, ...69 <dbl>, ...70 <dbl>, ...71 <dbl>, ...72 <dbl>,
    ## #   ...73 <dbl>, ...74 <dbl>, ...75 <dbl>, ...76 <dbl>, ...77 <dbl>,
    ## #   ...78 <dbl>, ...79 <dbl>, ...80 <dbl>, ...81 <dbl>, ...82 <dbl>,
    ## #   ...83 <dbl>, ...84 <dbl>, ...85 <dbl>, ...86 <dbl>, ...87 <dbl>,
    ## #   ...88 <dbl>, ...89 <dbl>, ...90 <dbl>, ...91 <dbl>, ...92 <dbl>,
    ## #   ...93 <dbl>, ...94 <dbl>, ...95 <dbl>, ...96 <dbl>, ...97 <dbl>,
    ## #   ...98 <dbl>, ...99 <dbl>, ...100 <dbl>, ...101 <dbl>, ...102 <dbl>,
    ## #   ...103 <dbl>, ...104 <dbl>, ...105 <dbl>, ...106 <dbl>, ...107 <dbl>,
    ## #   ...108 <dbl>, ...109 <dbl>, ...110 <dbl>, …

<img src="slides/slides.001.png" width="1920" />

For now, we leave the tibble as is, that is without proper column names
and some information not properly represented. It is time to practice
now!

### Exercises

#### Exercise \#1

1.  What are the names of the sheets in `data/je-f-17.02.06.01.xlsx`?
    Try not to open the file and use exclusively R to complete this
    exercise.

**Answer:**

``` r
library(readxl)

excel_sheets("../../../data/fso_data/je-f-17.02.06.01.xlsx")
```

    ##  [1] "2020" "2019" "2018" "2017" "2016" "2015" "2014" "2013" "2012" "2011"
    ## [11] "2010" "2009" "2008" "2007" "2006" "2005" "2004" "2003" "2002" "2001"
    ## [21] "2000" "1999" "1995" "1991" "1987" "1983"

2.  Open `data/je-f-17.02.06.01.xlsx` and inspect all sheets. Do the
    sheet names match the ones that you printed in the exercise above?

**Answer:** Yes, they do.

3.  Do all sheets have the same range of data? Can you name ranges for
    each sheet?

**Answer:** No, they don’t. The range of sheets `2020` and `2019` is
`A2:AF29`, and for the rest of the sheets, the range is `A4:AF34`.

4.  Now, we will try to read the sheet `2020` from it. Before jumping
    into the actual code writing, take a moment to look at the
    `read_xlsx()` documentation (`?read_xlsx`). It is useful to keep an
    eye on the data in Excel. The following questions can help to read
    the data:

-   Do the data have explicit column names? Do we need to use the
    `col_names` argument? Do you remember the default value of this
    argument?

**Answer:** Yes, there are explicit names. The default of the
`col_names` argument is `TRUE`, so that the first row will be treated as
column names. Therefore, we do not need to specify anything and can rely
on the default value.

-   Do we have a specific character(s) that signify(ies) the missing
    value? Which argument is responsible for specifying missing values?

    **Answer:** Yes, we do. The specific symbol is `"*"`. We need to set
    `na = "*"` inside the function call.

``` r
parties <- read_xlsx(
  "../../../data/fso_data/je-f-17.02.06.01.xlsx",
  sheet = "2020",
  range = "A2:AF29", 
  na = "*"
)
```

    ## New names:
    ## * `` -> ...1

``` r
parties
```

    ## # A tibble: 27 x 32
    ##    ...1    `Année électorale… `PLR 2)` `PDC 3)`    PS   UDC  Dém. `PLS 2)`   AdI
    ##    <chr>                <dbl>    <dbl>    <dbl> <dbl> <dbl> <dbl>    <dbl> <dbl>
    ##  1 Total                   NA       35       37    32    25     0        2     0
    ##  2 Zurich                2019        1        1     2     2    NA       NA    NA
    ##  3 Berne                 2018        1       NA     2     2    NA       NA    NA
    ##  4 Lucerne               2019        1        2     0     1    NA       NA    NA
    ##  5 Uri                   2020        2        3     1     1    NA       NA    NA
    ##  6 Schwytz               2020        2        2     0     3    NA       NA    NA
    ##  7 Obwald                2018        1        1    NA     1    NA       NA    NA
    ##  8 Nidwald               2018        2        3    NA     2    NA       NA    NA
    ##  9 Glaris                2018        2        1     0     1    NA       NA    NA
    ## 10 Zoug                  2018        2        3     0     2    NA       NA    NA
    ## # … with 17 more rows, and 23 more variables: PEV <dbl>, PCS <dbl>, PSD <dbl>,
    ## #   PVL <dbl>, PBD <dbl>, PST <dbl>, PSA <dbl>, POCH <dbl>, PES <dbl>,
    ## #   ASV <dbl>, Sol. <dbl>, DS <dbl>, Rép. <dbl>, UDF <dbl>, PSL <dbl>,
    ## #   Lega <dbl>, MCR <dbl>, LS <dbl>, JB <dbl>, Front <dbl>, Grut <dbl>,
    ## #   Autres 5) <dbl>, Total <dbl>

5.  In the previous unit, we considered the very useful function
    `clean_names()`. Do we need to use it in our context? If yes, please
    apply this function.

**Answer:** Yes, because column names contain spaces and other special
symbols.

``` r
library(janitor)
```

    ## 
    ## Attaching package: 'janitor'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     chisq.test, fisher.test

``` r
parties <- read_xlsx(
  "../../../data/fso_data/je-f-17.02.06.01.xlsx",
  sheet = "2020",
  range = "A2:AF29", 
  na = "*"
) %>% clean_names()
```

    ## New names:
    ## * `` -> ...1

``` r
parties
```

    ## # A tibble: 27 x 32
    ##    x1     annee_electoral… plr_2 pdc_3    ps   udc   dem pls_2  ad_i   pev   pcs
    ##    <chr>             <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
    ##  1 Total                NA    35    37    32    25     0     2     0     0     1
    ##  2 Zurich             2019     1     1     2     2    NA    NA    NA     0    NA
    ##  3 Berne              2018     1    NA     2     2    NA    NA    NA     0    NA
    ##  4 Lucer…             2019     1     2     0     1    NA    NA    NA    NA    NA
    ##  5 Uri                2020     2     3     1     1    NA    NA    NA    NA    NA
    ##  6 Schwy…             2020     2     2     0     3    NA    NA    NA    NA    NA
    ##  7 Obwald             2018     1     1    NA     1    NA    NA    NA    NA    NA
    ##  8 Nidwa…             2018     2     3    NA     2    NA    NA    NA    NA    NA
    ##  9 Glaris             2018     2     1     0     1    NA    NA    NA    NA    NA
    ## 10 Zoug               2018     2     3     0     2    NA    NA    NA    NA    NA
    ## # … with 17 more rows, and 21 more variables: psd <dbl>, pvl <dbl>, pbd <dbl>,
    ## #   pst <dbl>, psa <dbl>, poch <dbl>, pes <dbl>, asv <dbl>, sol <dbl>,
    ## #   ds <dbl>, rep <dbl>, udf <dbl>, psl <dbl>, lega <dbl>, mcr <dbl>, ls <dbl>,
    ## #   jb <dbl>, front <dbl>, grut <dbl>, autres_5 <dbl>, total <dbl>
