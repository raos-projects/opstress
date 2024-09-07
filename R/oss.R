#' Operative Stress Score
#'
#' Calculate the OSS for CPT Codes contained in a table.
#'
#' Table can be a base R data.frame, a data.table, or a tidyverse tibble. The
#' table contains CPT codes grouped by either patient or encounter (henceforth
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
#' @param .data the dataset containing CPT Code data
#' @param .column_prefix prefix in names of columns which contain CPT codes to
#' be assigned OSS values (e.g. 'procd' for `procd1`, `procd2`, etc.)
#' @param .id name of column containing patient or encounter IDs. Default
#' value `NA` assumes no ID column and that each row refers to a unique unit
#'
#' @return the same dataset passed to the function with new columns for OSS
#' corresponding to each column specified by `.column_prefix`
#' @export
#'
#' @examples
oss <- function(.data, .column_prefix, .id = NA){

  warning('`oss` is an incomplete function')

  return(.data)
}
