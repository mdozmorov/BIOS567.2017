# Quantile normalization, motivated by quantile-quantile plots
data(USArrests)
attach(USArrests)
names(USArrests)
?qnorm
dim(USArrests)
qpoints <- qnorm((1:length(Murder) - 1/2)/length(Murder))  # Define quantile points
qpoints
plot(qpoints, sort(Murder))
qqnorm(Murder)

# QUANTILE normalization using the Affy data
library(affy)
list.celfiles()
Lung <- read.affybatch(filenames = list.celfiles(pattern = "REP*"))  # Lung cancer samples from the same individual

Lung.quantile <- normalize(Lung)  # Quantile is default, but check and specify
Lung.quantile2 <- normalize(Lung, method = "quantiles")
all.equal(pm(Lung.quantile)[, 1], pm(Lung.quantile2)[, 1])

# Before
boxplot(log(pm(Lung)[, 1], 2), log(pm(Lung)[, 2], 2), 
        log(pm(Lung)[, 3], 2))

# After
boxplot(log(pm(Lung.quantile)[, 1], 2), log(pm(Lung.quantile)[, 2], 2), 
        log(pm(Lung.quantile)[, 3], 2))

# Before
plot( density(log(pm(Lung)[, 1], 2)), col = "black")
lines(density(log(pm(Lung)[, 2], 2)), col = "blue")
lines(density(log(pm(Lung)[, 3], 2)), col = "red")

# After
plot( density(log(pm(Lung.quantile)[, 1], 2)), col = "black")
lines(density(log(pm(Lung.quantile)[, 2], 2)), col = "blue")
lines(density(log(pm(Lung.quantile)[, 3], 2)), col = "red")

# A function to quickly plot MA plots for single-channel arrays
ma.plot <- function(x, y) {
  M <- log(x, 2) - log(y, 2)
  A <- (log(x, 2) + log(y, 2))/2
  plot(A, M)  ### A is on the x axis, M on the y axis.
}

ma.plot(pm(Lung.quantile)[, 1], pm(Lung.quantile)[, 2])

# NOTE! Normalization does not eliminate confounding variables (batch effect)
