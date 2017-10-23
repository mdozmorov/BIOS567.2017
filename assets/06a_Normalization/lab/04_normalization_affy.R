### Affymetrix normalization methods ###
library(affy)
setwd("data_affy")
list.celfiles()
Lung <- read.affybatch(filenames = list.celfiles(pattern = "REP*"))  # Lung cancer samples from the same individual
pData(Lung)
Lung

# Select first chip as the baseline array
sampleNames(Lung)
xbase <- mean(pm(Lung)[, 1], trim = 0.02)
xbase

# Scaling factor for the chip 2
x2 <- mean(pm(Lung)[, 2], trim = 0.02)
SF2 <- xbase / x2
SF2
new.pm.2 <- pm(Lung)[, 2] * SF2  # new.pm values = orig values * scaling factor

# A function to quickly plot MA plots for single-channel arrays
ma.plot <- function(x, y) {
  M <- log(x, 2) - log(y, 2)
  A <- (log(x, 2) + log(y, 2))/2
  plot(A, M)  ### A is on the x axis, M on the y axis.
}

par(mfrow = c(1, 2))
ma.plot(pm(Lung)[, 1], pm(Lung)[, 2])  # Original data
abline(h = 0)
ma.plot(pm(Lung)[, 1], new.pm.2)  # Chip 2 scaled
abline(h = 0)


# Built-in global Normalization - Just a scaling method in Affy: Affy
# the Easy Way:
?normalize
Lung.scale <- normalize(Lung, method = "constant")
Lung.scale

# Cyclic loess.
Lung.loess <- normalize(Lung, method = "loess")
ma.plot(pm(Lung.loess)[, 1], pm(Lung.loess)[, 2])

# Check the difference before/after normalization
all.equal(pm(Lung)[, 1], pm(Lung.loess)[, 1])
all.equal(pm(Lung)[, 2], pm(Lung.loess)[, 2])
all.equal(pm(Lung)[, 3], pm(Lung.loess)[, 3])

# INVARIANT SET normalization in AFFY on actual genome data
Lung.invariant <- normalize(Lung, method = "invariantset")
ma.plot(pm(Lung.invariant)[, 1], pm(Lung.invariant)[, 2])


