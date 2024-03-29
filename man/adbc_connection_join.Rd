% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/helpers.R
\name{adbc_connection_join}
\alias{adbc_connection_join}
\alias{adbc_statement_join}
\title{Join the lifecycle of a unique parent to its child}
\usage{
adbc_connection_join(connection, database)

adbc_statement_join(statement, connection)
}
\arguments{
\item{connection}{A connection created with \code{\link[=adbc_connection_init]{adbc_connection_init()}}}

\item{database}{A database created with \code{\link[=adbc_database_init]{adbc_database_init()}}}

\item{statement}{A statement created with \code{\link[=adbc_statement_init]{adbc_statement_init()}}}
}
\value{
The input, invisibly.
}
\description{
It is occasionally useful to return a connection, statement, or stream
from a function that was created from a unique parent. These helpers
tie the lifecycle of a unique parent object to its child such that the
parent object is released predictably and immediately after the child.
These functions will invalidate all references to the previous R object.
}
\examples{
# Use local_adbc to ensure prompt cleanup on error;
# use join functions to return a single object that manages
# the lifecycle of all three.
stmt <- local({
  db <- local_adbc(adbc_database_init(adbc_driver_log()))

  con <- local_adbc(adbc_connection_init(db))
  adbc_connection_join(con, db)

  stmt <- local_adbc(adbc_statement_init(con))
  adbc_statement_join(stmt, con)

  adbc_xptr_move(stmt)
})

# Everything is released immediately when the last object is released
adbc_statement_release(stmt)

}
