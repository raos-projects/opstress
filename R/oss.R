usethis::use_package("dplyr")
usethis::use_package('magrittr')
usethis::use_package('future')
usethis::use_package('furrr')

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
#' @param .id name of column containing patient or encounter IDs. Default
#' value `NA` assumes no ID column and that each row refers to a unique unit. If
#' value is a vector of column names, then all unique combinations of values from
#' the columns will be used as the grouping criterion (similar to [dplyr::group_by])
#' @param .ncores the number of cores to use in parallel processing when generating
#' OSS columns for each column of CPT codes
#'
#' @return the same dataset passed to the function with new columns for OSS
#' corresponding to each column specified by `.column_prefix`
#' @export
#'
#' @examples oss(example_cpts_wide, 'procd') #no need to specify .id given each row is assumed to represent a unique unit
#' @examples oss(example_cpts_long, 'procd', .id = 'mrn') #multiple rows with same value of `mrn` all specify the same unit
#' @examples oss(example_cpts_long, 'procd', .id = 'mrn', .ncores = 4) #compute OSS in parallel across 4 cores
#'
oss <- function(.data, .column_prefix, .id = NA, .ncores = 1){

  warning('`oss` is an incomplete function')

  #determine whether data is wide (multiple cpt columns) or long (one cpt column)
  columns = select(.data, dplyr::starts_with(.column_prefix))
  column_names = names(columns)
  column_types = lapply(columns, typeof)

  secret_match_oss <- function(column_) {
    column_name_ = names(column_)
    names(column_) <- 'Input_CPT'
    column_with_oss_ <- dplyr::left_join(data.frame(column_),
                                         dplyr::select(cpt_table,
                                                       c(CPTcode,Consensus.OSS)),
                                         by=join_by('Input_CPT' == 'CPTcode'))
    # column_with_oss_ = dplyr::rename_with(column_with_oss_,
    #                                       ~ paste0(column_name_,'_oss'),
    #                                       dplyr::starts_with('Consensus.OSS'))
    names(column_with_oss_) <- c(column_name_, paste0(column_name_, '_oss'))
    return(column_with_oss_)
  }

  plan(multicore, workers = .ncores)
  ossified_columns <- furrr::future_pmap(.l = list(column_ = as.list(columns)),
                                         .f = secret_match_oss)
  ossified_columns <- cbind(ossified_columns)
  select


  return(.data)
}
