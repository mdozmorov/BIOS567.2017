rm(list = ls())
gapdh.3 <- c(5146.3, 5076.9, 4916, 5245.7, 4944.7, 4767.2, 4469.4, 5012.5, 5391, 4690.9, 4621.1, 4752.5, 4729.9, 4602.2, 4272.5) #, 4990.3)
gapdh.3 <- sort(gapdh.3)            # Sort the vector
n <- length(gapdh.3)                # 15 observations

# How to use the trimmed mean method in order to calculate the actual 50%-ile MEDIAN
alpha <- 1 / 2 - 1 / (2 * n)        # equals 0.4666 which will be trimmed from _BOTH ends_.
R <- n * (1 - 2 * alpha)            # Denominator
start_index <- floor(alpha * n) + 1 # From index
end_index <- n - floor(alpha * n)   # To index
(1 / R) * sum(gapdh.3[start_index:end_index])

# Check our result using the built-in R 'median' operation/function:
median(gapdh.3)

?mean
mean(gapdh.3, trim=0.5) # R has a built-in function to calculate the trimmed mean


# EXACT TRIMMED MEAN
alpha <- 0.19
g <- floor(alpha * n)
r <- alpha * n - g
start_index <- g + 2
end_index <- n - g - 1
(1 / (n * (1 - 2 * alpha))) * ((1 - r) * sum(gapdh.3[g + 1], gapdh.3[n - g]) + sum(gapdh.3[start_index:end_index]))

mean(gapdh.3, trim=.19)    # trims 20% total: 10% from _each_ end.  PAY ATTENTION!!!: alpha = 10% (therefore: 20% total trimmed).


# Internal R mean
# https://stats.stackexchange.com/questions/16528/is-rs-trimmed-means-function-biased
mean <- function (x, trim = 0, na.rm = FALSE, ...) {
  
  if (!is.numeric(x) && !is.complex(x) && !is.logical(x)) {
    warning("argument is not numeric or logical: returning NA")
    return(NA_real_)
  }
  
  if (na.rm) 
    x <- x[!is.na(x)]
  if (!is.numeric(trim) || length(trim) != 1L) 
    stop("'trim' must be numeric of length one")
  n <- length(x)
  if (trim > 0 && n) {
    if (is.complex(x)) 
      stop("trimmed means are not defined for complex data")
    if (any(is.na(x))) 
      return(NA_real_)
    if (trim >= 0.5) 
      return(stats::median(x, na.rm = FALSE))
    lo <- floor(n * trim) + 1
    hi <- n + 1 - lo
    x <- sort.int(x, partial = unique(c(lo, hi)))[lo:hi]
  }
  .Internal(mean(x))
}

#' Exact trimmed mean
#' @param vec a numeric vector to be trimmed
#' @param alpha proportion to be trimmed from both ends
#' @return exact trimmed mean
mean2 <- function(vec, alpha) {  
  x <- sort(vec)    # Sort the vector
  n <- length(x)    # Get its length
  g <- n * alpha    # How much to remove
  R <- n - 2 * g    # Denominator
  # Is g an integer?:
  if( g %% 1 > 0 ){ # g *not* an integer
    frac <- g %% 1  # Fraction part of g
    g <- floor(g)   # Integer part of g
    tr <- (1/R) * sum(frac * x[g+1], x[(g+2):(n-g-1)], frac * x[n-g])
  } else {          # g *is* an integer:
    tr <- (1/R) * sum(x[(g+1):(n-g)])
  }
  return(tr)
}

a <- c(2, 4, 6, 7, 11, 21, 81, 90, 105, 121)
mean(a, .10)
mean2(a, .10)
mean(a, .15)
mean2(a, .15)
mean(a, .27)
mean(a, .20)
mean2(a, .27)



