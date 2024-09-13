#' OSS Data for CPT Codes
#'
#' A data frame containing CPT codes, descriptions of each procedure, and each
#' procedure's associated operative stress score (OSS). This table is used for
#' matching CPT codes to OSS in the [opstress::oss()] function.
#'
#' @format three columns: `cpt_code<integer>`, `cpt_description<character>`, and `oss<integer>`
#' @source From George EL, Hall DE, Youk A, Chen R, Kashikar A, Trickey AW, Varley PR, Shireman PK, Shinall MC, Massarweh NN, Johanning J. Association between patient frailty and postoperative mortality across multiple noncardiac surgical specialties. JAMA surgery. 2021 Jan 1;156(1):e205152-. List obtained from `sarya1 AT stanford DOT edu` and dated 2019-11-14
"cpt"
