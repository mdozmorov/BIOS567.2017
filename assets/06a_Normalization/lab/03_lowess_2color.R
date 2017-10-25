#	 Fitting LOWESS to Gene Expression Data: a 2 channel microarray
setwd("/Users/mdozmorov/Documents/Work/Teaching/BIOS567.2017/assets/05b_Quality/lab/data_spotted")
dir(pattern = "txt")
file <- dir(pattern = "txt")[1:2]
file

library(Biobase)
library(marray)

layout <- read.marrayLayout(fname = file[1], ngr = 12, ngc = 4, nsr = 21, nsc = 21, skip = 21211)
info <- read.marrayInfo(fname = file[1], info.id = c(1, 6), labels = 6, skip = 21211)
xlabels <- c("7-7", "7-12")
raw.data <- read.marrayRaw(file, name.Gf = "ch1 Intensity", name.Gb = "ch1 Background", 
                                 name.Rf = "ch2 Intensity", name.Rb = "ch2 Background", 
                                 layout = layout, gnames = info, skip = 21211)

maPlot(raw.data[, 2], x = "maA", y = "maM", legend.func = NULL)
# Entire cloud is shifted will above the M=0 line...for NON-normalized.

?maNorm
# norm = 'median' - global normalization over whole chip Now a 'loess'
# fit for the *entire* chip
loess.norm <- maNorm(raw.data, norm = "loess")  # Note default span of 0.4.
maPlot(loess.norm[, 2], x = "maA", y = "maM", legend.func = NULL)
# Entire cloud has been brought down to the M=0 line...  ... but leaves
# some sub-grid effects going on.

# Now we'll do the default 'printTip loess' normalization:
printTip.norm <- maNorm(raw.data)  ### by default: 'printTip loess'
maPlot(printTip.norm[, 2], x = "maA", y = "maM", legend.func = NULL)
# Sub-grid specific normalization - nicely centered about M=0 line.

# Let's look at box-plots:
maBoxplot(raw.data[, 2], x = "maPrintTip", y = "maM")
maBoxplot(loess.norm[, 2], x = "maPrintTip", y = "maM")
maBoxplot(printTip.norm[, 2], x = "maPrintTip", y = "maM")

