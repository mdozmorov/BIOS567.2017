# Product factorial implementation
my.fact <- function(n) {		
  prod(1:n)
}
my.fact(6)

# Loop factorial implementation
my.fact <- function(n) {
  result <- 1
  for (i in 1:n) {
    result <- i * result
  }
  result
}
my.fact(6)

