Getting ready with the opstress package
================

The `opstress` R package provides a fast and flexible way to assign
Operative Stress Scores (OSS) to CPT codes, using the `oss` function.

Operative Stress Scores are ordinal numeric values assigned to surgical
CPT codes based on physiologic burden. The OSS was developed and
validated by a multi-institutional expert panel and is commonly used in
geriatric surgery research.

The `oss` function works on both wide and long data formats and can
handle input as base `data.frame`, `data.table`, or `tibble` objects.
The function robustly handles common input structures and supports
optional parallelization for faster processing of large datasets.

## Installation

The `opstress` package is still in development and has not yet been
uploaded to CRAN. Until then, the package may be installed from github
using the `devtools` package with the following code:

``` r
# Install from GitHub
# install.packages("devtools")
devtools::install_github("raos-projects/opstress")
```

## `oss`

The `oss` function maps CPT codes to their operative stress scores,
which are drawn from the `opstress::cpt` dataset. It supports vector
input, wide format (one row per unit with multiple CPT columns, e.g.,
procd1, procd2, …), and long format (multiple rows per unit, one CPT
code per row). Parallelization of CPT code assignment is also supported
by supplying a value greater than 1 to the optional argument `.ncores`.

| Argument         | Description                                  |
|------------------|----------------------------------------------|
| `.data`          | Dataset containing CPT codes                 |
| `.column_prefix` | Prefix shared by columns storing CPT codes   |
| `.ncores`        | Number of parallel workers to use (optional) |

If there is only one column storing CPT codes (e.g., long format), then
the `.column_prefix` argument can be the full column name.

## Data Dependency

The `oss` function uses the internal data frame `opstress::cpt`, which
contains the following columns:

| Column            | Description                                  |
|-------------------|----------------------------------------------|
| `cpt_code`        | <numeric> 5-digit CPT code                   |
| `oss`             | <numeric> operative stress score (range 1-5) |
| `cpt_description` | <char> plain language description of surgery |

## Vignette

``` r
library(opstress)
library(dplyr)
library(magrittr)
```

``` r
# Example with vector input
oss(c("19301", "19303", "00000")) %>% as_tibble()  # Includes an invalid CPT
```

    ## # A tibble: 3 × 3
    ##   dx    dx_oss dx_descr                                                         
    ##   <chr>  <int> <chr>                                                            
    ## 1 19301      2 Mastectomy, partial (eg, lumpectomy, tylectomy, quadrantectomy, …
    ## 2 19303      2 Mastectomy, simple, complete                                     
    ## 3 00000     NA <NA>

``` r
# Example with long-format data
head(example_cpts, 10)
```

    ##    id procd
    ## 1   1 36218
    ## 2   2 17311
    ## 3   3 64708
    ## 4   4 11005
    ## 5   5 26410
    ## 6   6 52310
    ## 7   7 26587
    ## 8   8 44660
    ## 9   9 32507
    ## 10 10 35606

``` r
oss(example_cpts[1:10,], .column_prefix = "procd") %>% as_tibble()
```

    ## # A tibble: 10 × 4
    ##       id procd procd_oss procd_descr                                            
    ##    <int> <dbl>     <int> <chr>                                                  
    ##  1     1 36218         1 Selective catheter placement, arterial system; additio…
    ##  2     2 17311         2 Mohs micrographic technique, including removal of all …
    ##  3     3 64708         2 Neuroplasty, major peripheral nerve, arm or leg, open;…
    ##  4     4 11005         3 Debridement of skin, subcutaneous tissue, muscle and f…
    ##  5     5 26410         1 Repair, extensor tendon, hand, primary or secondary; w…
    ##  6     6 52310         1 Cystourethroscopy, with removal of foreign body, calcu…
    ##  7     7 26587         1 Reconstruction of polydactylous digit, soft tissue and…
    ##  8     8 44660         4 Closure of enterovesical fistula; without intestinal o…
    ##  9     9 32507         4 Thoracotomy; with diagnostic wedge resection followed …
    ## 10    10 35606         3 Bypass graft, with other than vein; carotid-subclavian

``` r
# Example with parallel processing
oss(example_cpts[1:10,], .column_prefix = "procd", .ncores = 2) %>% as_tibble()
```

    ## Warning: package 'future' was built under R version 4.4.3

    ## # A tibble: 10 × 4
    ##       id procd procd_oss procd_descr                                            
    ##    <int> <dbl>     <int> <chr>                                                  
    ##  1     1 36218         1 Selective catheter placement, arterial system; additio…
    ##  2     2 17311         2 Mohs micrographic technique, including removal of all …
    ##  3     3 64708         2 Neuroplasty, major peripheral nerve, arm or leg, open;…
    ##  4     4 11005         3 Debridement of skin, subcutaneous tissue, muscle and f…
    ##  5     5 26410         1 Repair, extensor tendon, hand, primary or secondary; w…
    ##  6     6 52310         1 Cystourethroscopy, with removal of foreign body, calcu…
    ##  7     7 26587         1 Reconstruction of polydactylous digit, soft tissue and…
    ##  8     8 44660         4 Closure of enterovesical fistula; without intestinal o…
    ##  9     9 32507         4 Thoracotomy; with diagnostic wedge resection followed …
    ## 10    10 35606         3 Bypass graft, with other than vein; carotid-subclavian

<!-- ## Performance Benchmarking -->

<!-- ```{r} -->

<!-- library(microbenchmark) -->

<!-- microbenchmark( -->

<!--   single_core = oss(example_cpts, .column_prefix = "procd", .ncores = 1), -->

<!--   multi_core  = oss(example_cpts, .column_prefix = "procd", .ncores = 2), -->

<!--   times = 10 -->

<!-- ) -->

<!-- ``` -->

## Contact

Questions about the `opstress` package can be directed to saieesh DOT
rao AT northwestern DOT edu
