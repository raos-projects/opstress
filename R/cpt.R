#' OSS Data for CPT Codes
#'
#' A data frame containing CPT codes, descriptions of each procedure, and each
#' procedure's associated operative stress score (OSS). This table is used for
#' matching CPT codes to OSS in the [opstress::oss()] function.
#'
#' @format three columns: `cpt_code<integer>`, `cpt_description<character>`, and `oss<integer>`
#' @source From Shinall MC, Arya S, Youk A, et al. Association of Preoperative Patient Frailty and Operative Stress With Postoperative Mortality. JAMA Surg. 2020;155(1):e194620. doi:10.1001/jamasurg.2019.4620. Table obtained from `sarya1 AT stanford DOT edu` and dated 2019-11-14
"cpt"
