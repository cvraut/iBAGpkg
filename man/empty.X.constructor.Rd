% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mechmodel.R
\name{empty.X.constructor}
\alias{empty.X.constructor}
\title{empty.X.constructor}
\usage{
empty.X.constructor(
  patients,
  genes,
  k,
  data.names,
  other.name = "other",
  sep = "_",
  DEBUG = FALSE
)
}
\arguments{
\item{k}{this is the number of datasets (not including the other/residual, gets added automatically)}
}
\description{
This is a helper function to create & name the rows & columns of X appropriately
}
