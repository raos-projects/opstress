usethis::use_package("dplyr")
usethis::use_package('magrittr')
usethis::use_package('future')
usethis::use_package('future.apply')

#' Operative Stress Score
#'
#' Calculate the OSS for CPT Codes contained in a table. OSS for each individual CPT
#' code are stored in the [opstress::cpt] data frame.
#'
#' `.data` can be a base R `data.frame`, a `data.table`, or a tidyverse `tibble`. The
#' table should contain CPT codes grouped by either patient or encounter (henceforth
#' referred to as the 'unit').
#'
#' `oss` works both for tables structured in either of two ways. The first structure is
#' that in which there are multiple columns for CPT codes and a single row for
#' each unit. This is the same data format assumed for the input data in the
#' `icdpicr` package and is the default structure in data sets distributed from
#' sources such as HCUP. The second structure is that in which each
#' CPT code is stored in a single column, and multiple rows may contain CPT code
#' data pertaining to a single unit. This is the same data format assumed in the
#' `comorbidity` package.
#'
#' @param .data the dataset containing units' CPT Code data for which the OSS scores
#' are to be calculated. N.B. This parameter is NOT the table [opstress::cpt] which
#' contains the key:value mapping of CPT codes to OSS. Example values for `.data`
#' include [opstress::example_cpts_long] and [opstress::example_cpts_wide]
#' @param .column_prefix prefix in names of columns which contain CPT codes to
#' be assigned OSS values (e.g. 'procd' for `procd1`, `procd2`, etc.)
#' @param .ncores the number of cores to use in parallel processing when generating
#' OSS columns for each column of CPT codes
#'
#' @return the same dataset passed to the function with new columns for OSS
#' corresponding to each column specified by `.column_prefix`
#' @export
#'
#' @examples oss(example_cpts_wide, 'procd') #no need to specify .id given each row is assumed to represent a unique unit
#' @examples oss(example_cpts_long, 'procd') #multiple rows with same value of `mrn` all specify the same unit
#' @examples oss(example_cpts_long, 'procd', .ncores = 4) #compute OSS in parallel across 4 cores
#'

oss <- function(.data, .column_prefix = NA, .ncores = 1) {

  if(is.matrix(.data)){
    .data = as.data.frame(.data)
  }

  if(is.vector(.data)){
    if(is.null(names(.data)) && is.na(.column_prefix)){
      .data = list('dx' = .data)
      .column_prefix = 'dx'
    } else if(length(names(.data)) == 1 && !(.column_prefix %in% names(.data))) {
      warning(paste('argument `.data` is a vector, but `names(.data)` is not equivalent to argument `.column_prefix` (',.column_prefix,'). Will ignore `.column_prefix`'))
      .column_prefix = names(.data)
    }
  } else if (is.list(.data) && !(.column_prefix %in% names(.data))) {
    if(length(names(.data)) == 1){
      warning(paste('argument `.data` is a list or data.frame, but `names(.data)` is not equivalent to argument `.column_prefix` (',.column_prefix,'). Will ignore `.column_prefix`'))
      .column_prefix = names(.data)
    } else if(length(names(.data)) > 1 && !(.column_prefix %in% names(.data))) {
      stop(paste('argument `.column_prefix` (',.column_prefix,') is not found in `names(.data)`'))
    }
  }

  cpt_map <- opstress::cpt %>%
    dplyr::select(cpt_code, oss)

  cpt_cols <- grep(paste0("^", .column_prefix), names(.data), value = TRUE)

  get_oss_col <- function(col) {
    cpt_vec <- .data[[col]]
    oss_vec <- cpt_map$oss[match(cpt_vec, cpt_map$cpt_code)]
    oss_vec
  }

  if (.ncores > 1) {
    future::plan(future::multisession, workers = .ncores)
    oss_matrix <- future.apply::future_lapply(cpt_cols, get_oss_col) %>% as.data.frame()
    future::plan(future::sequential)  # Reset to sequential to avoid surprises later
  } else {
    oss_matrix <- lapply(cpt_cols, get_oss_col) %>% as.data.frame()
  }

  names(oss_matrix) <- paste0(cpt_cols, "_oss")
  return(bind_cols(.data, oss_matrix))
}
