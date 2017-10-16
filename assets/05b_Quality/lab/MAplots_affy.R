# Constructing ExpressionSet
# Visualizing MA plots, smoothScatter MA plots, Volcano plots

rm(list = ls())
options(stringsAsFactors = FALSE)

# Set plotting parameters
mypar <- function(a = 1, b = 1) {
  par(mar = c(2.5, 2.5, 1.6, 1.1), mgp = c(1.5, 0.5, 0))
  par(mfrow = c(a, b))
}

library(Biobase)
library(geneplotter)
library(genefilter)

## Bioconductor: Constructing ExpressionSet, subset of SpikeIn95
path <- "data_eset"
setwd(path)

assayData <- as.matrix(read.table("exprs.txt", sep = "\t", header = TRUE, row.names = 1, check.names = FALSE))
phenoData <- read.table("phenoData.txt")
phenoData <- phenoData[match(colnames(assayData), phenoData$filename), ]
rownames(phenoData) <- phenoData$filename
annotationData <- readLines("annotation.txt")
miameData <- read.MIAME("miame.txt")

eset <- ExpressionSet(assayData = assayData, phenoData = AnnotatedDataFrame(phenoData), 
                      annotation = annotationData, description = miameData)
eset
exprs(eset) <- log2(exprs(eset) + 1)

## Figure: RAW vs RAW expression, regular axes
# bitmap("Figures/02_array_vs_array_raw.png", res = 300, pointsize = 20)
mypar(1, 1)
plot(2^exprs(eset)[, 1], 2^exprs(eset)[, 2], xlab = "Expression on array1", 
     ylab = "Expression on array 2", cex = 0.25, pch = 16)
# dev.off()

## Figure: RAW vs RAW expression, log2 axes
# bitmap("Figures/02_array_vs_array_log2.png", res = 300, pointsize = 20)
mypar(1, 1)
plot(2^exprs(eset)[, 1], 2^exprs(eset)[, 2], log = "xy", xlab = "Expression on array1", 
     ylab = "Expression on array 2", cex = 0.25, pch = 16, yaxt = "n")
axis(2, at = 10^c(1, 3, 5), label = c("1", "100", "10000"))

smoothScatter(exprs(eset)[, 1], exprs(eset)[, 2], xlab="Expression 1", ylab="Expression 2")
# dev.off()

## Figure: MAplot
x <- exprs(eset)[, 1]
y <- exprs(eset)[, 2]

M <- y - x
A <- (x + y)/2

# bitmap("Figures/02_MA_plot.png", res = 300, pointsize = 20)
mypar(1, 1)
plot(A, M, cex = 0.25, pch = 16)
abline(h = -1, col = "red")
abline(h = 1, col = "red")
# dev.off()

## Figure: MA smooth scatterplot, difference between groups
tt <- genefilter::rowttests(exprs(eset), factor(eset$population))
M <- tt$dm # Difference in group means
A <- rowMeans(exprs(eset))

YLIM <- c(-4, 4)

# bitmap("Figures/02_MA_scatterplot.png", res = 300, pointsize = 20)
mypar(1, 1)
smoothScatter(A, M, ylim = YLIM)
abline(h = -1, col = "red")
abline(h = 1, col = "red")
# dev.off()

## Figure: MA and Volcano plots, with labeling genes of interest
Index <- c(4977, 10771, 3238)
featureNames(eset)[Index] # Three manually selected genes

# bitmap("Figures/02_MA_vs_volcano.png", res = 300, pointsize = 20, width = 12)
mypar(1, 2)
plot(A[-Index], M[-Index], ylim = YLIM, cex = 0.25, pch = 16, xlab = "A", ylab = "M")
text(A[Index], M[Index], 1:3, col = "red", cex = 1.1)
abline(h = c(-1, 1), col = "red")

plot(M[-Index], -log10(tt$p.value)[-Index], xlim = YLIM, ylab = "-Log (base 10) p-value", cex = 0.25, pch = 16, xlab = "M")
text(M[Index], -log10(tt$p.value)[Index], 1:3, col = "red", cex = 1.1)
abline(v = c(-1, 1), col = "red")
abline(h = c(-2, 2), col = "red")
# dev.off()


