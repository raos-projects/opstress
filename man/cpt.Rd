% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cpt.R
\docType{data}
\name{cpt}
\alias{cpt}
\title{OSS Data for CPT Codes}
\format{
three columns: \code{cpt_code} \if{html}{\out{<integer>}}, \code{cpt_description} \if{html}{\out{<character>}}, and \code{oss} \if{html}{\out{<integer>}}
}
\source{
From George EL, Hall DE, Youk A, Chen R, Kashikar A, Trickey AW, Varley PR, Shireman PK, Shinall MC, Massarweh NN, Johanning J. Association between patient frailty and postoperative mortality across multiple noncardiac surgical specialties. JAMA surgery. 2021 Jan 1;156(1):e205152-. List obtained from \code{sarya1@stanford.edu} and dated 2019-11-14
}
\usage{
cpt
}
\description{
A table containing CPT codes, descriptions of each procedure, and each
procedure's associated operative stress score (OSS). This table is used for
matching CPT codes to OSS in the \code{\link[=oss]{oss()}} function.
}
\keyword{datasets}
