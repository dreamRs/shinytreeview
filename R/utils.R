dropNulls <- function(x) {
  x[!vapply(x, is.null, FUN.VALUE = logical(1))]
}

list1 <- function(x) {
  if (length(x) == 1) {
    list(x)
  } else {
    x
  }
}
