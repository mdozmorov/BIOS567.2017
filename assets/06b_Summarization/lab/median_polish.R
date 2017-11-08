median.polish <- function(x) {
  ### 1st iteration Initialize effects to zero
  a.0 <- rep(0, nrow(x))
  b.0 <- rep(0, ncol(x))
  m.0 <- 0
  ### Calculate row medians
  delta.a.1 <- apply(x, 1, median)
  ### Row polish by subtracting row medians
  x <- x - delta.a.1
  ### Calculate column medians
  delta.b.1 <- apply(x, 2, median)
  ### Column polish by subtracting column medians
  x <- t(t(x) - delta.b.1)
  ### Estimate effects after 1 iteration
  delta.mb.1 <- median(b.0)
  delta.ma.1 <- median(a.0 + delta.a.1)
  m.1 <- m.0 + delta.ma.1 + delta.mb.1
  a.1 <- a.0 + delta.a.1 - delta.ma.1
  b.1 <- b.0 + delta.b.1 - delta.mb.1
  ### Repeat row and column polish using 2nd iteration Calculate row
  ### medians
  delta.a.2 <- apply(x, 1, median)
  ### Row polish
  x <- x - delta.a.2
  ### Calculate column medians and delta ma
  delta.b.2 <- apply(x, 2, median)
  ### Column polish by subtracting column medians
  x <- t(t(x) - delta.b.2)
  ### Estimate effects after 2nd iteration
  delta.mb.2 <- median(b.1)
  delta.ma.2 <- median(a.1 + delta.a.2)
  a.eff <- a.1 + delta.a.2 - delta.ma.2
  b.eff <- b.1 + delta.b.2 - delta.mb.2
  m.eff <- m.1 + delta.ma.2 + delta.mb.2
  output <- list(a.eff, b.eff, m.eff, round(x, 3))
  names(output) <- c("row.effect", "column.effect", "main.effect", "residuals")
  output
}

### Read data into R ###
example <- c(14, 11, 14, 7, 4, 7, 8, 5, 8, 12, 9, 12, 0, -3, 0)
example <- matrix(example, nrow = 5, byrow = TRUE)
example

median.polish(example)

# Artificial example with one outlier
test<-c(9,rep(0,8))
test
test<-matrix(test,ncol=3)
test

median.polish(test)

# Median polish on real data
setwd("/Users/mdozmorov/Documents/Work/Teaching/BIOS567.2017/assets/05b_Quality/lab/data_affy")
library(affy)
Lung <- read.affybatch(filenames=list.celfiles(pattern = "REP"))
Lung

pm <- pm(Lung,"205586_x_at")
pm
median.polish(pm) 
# gene expression = main effect + column effect

# Median polish in 'rma' function
pm.rma <- rma(Lung, normalize=FALSE, background=FALSE) # All it does is applying median polish
exprs(pm.rma)[grep("205586_x_at",featureNames(pm.rma)),]	# for specific probe
2^exprs(pm.rma)[grep("205586_x_at",featureNames(pm.rma)),]

# Typical usage of 'rma' function: leave defaults intact
Lung.final <- rma(Lung)
# So final expression summaries truly:
exprs(Lung.final)[grep("205586_x_at",featureNames(Lung.final)),]
# ... output: actual RMA Probe Set Expression Summaries
