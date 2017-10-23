# /Users/mdozmorov/Documents/Work/Teaching/Microarray_Irizarry_done/03-code.R
# SpikeIn95 Concentration ~ Expression plots. Raw vs. Log2 probe intensity

rm(list = ls())
options(stringsAsFactors = FALSE)
# Set plotting parameters
mypar <- function(a = 1, b = 1) {
  par(mar = c(2.5, 2.5, 1.6, 1.1), mgp = c(1.5, 0.5, 0))
  par(mfrow = c(a, b))
}


###SpikeIn
library(SpikeIn)
data(SpikeIn95)

SpikeIn95 # 59 samples
pData(SpikeIn95)[1:8, 1:8] # Latin square concentrations

Index <- which(probeNames(SpikeIn95) %in% colnames(pData(SpikeIn95))) # Latin square probes
pms <- pm(SpikeIn95)[Index,] # PM for relevant probes
pns <- probeNames(SpikeIn95)[Index] # Probe names
nominal <- sapply(1:ncol(pms), function(i) unlist(pData(SpikeIn95)[i, pns])) # Probe-level concentrations
avg=2^tapply(log2(as.vector(pms)), as.vector(nominal), mean) # Average expression per concentration

## Figure: Concentration ~ Expression, regular and log2 axes
# bitmap("Figures/03_Spikein.png",res=300,pointsize=20, width = 12)
mypar(1,2)
plot(as.numeric(names(avg)),avg,xlab="Nominal Concentration",ylab="Observered Average Intensity",type="b",xlim=c(0,8),ylim=c(0,410))
plot(log2(as.numeric(names(avg))),log2(avg),xlab="Nominal Log Concentration",ylab="Observered Average Log Intensity",type="b",xlim=log2(c(0.25,8)),ylim=log2(c(180,410)))
# dev.off()

##  Figure: raw vs. log2 probe intensity histograms
# bitmap("Figures/03_Histogram_raw_log2.png",res=300,pointsize=20, width = 12)
mypar(1,2)
hist(pm(SpikeIn95)[, 1], main = "Raw PM data", xlab = "Expression")
hist(log2(pm(SpikeIn95)[, 1]), main = "log2 PM data", xlab = "log2 expression")
# dev.off()

## Figure: Loess demo
Data <- SpikeIn95[,9:10] # Select two datasets
x <- log2(pm(Data[,1]))
y <- log2(pm(Data[,2]))
A <- (x+y)/2
M <- y-x
Index <- which(abs(M) < 1.2) # Keep points within reasonable M range
A <- A[Index]
M <- M[Index]

mypar(1,1)
smoothScatter(A,M) # Real data
sIndex <- which(probeNames(Data)[Index] == "40322_at") # Label selected probe
points(A[sIndex], M[sIndex], col="red", pch=16, cex=0.5)
fit1 <- loess(M~A, subset=order(A)[seq(1,length(A), len=2000)], degree=1, span=1/3)
lines(sort(fit1$x), fit1$fitted[order(fit1$x)], col=2)             

## Figure: Loess demo. Sliding window loess figures
# Simulated data
A <- seq(min(fit1$x), max(fit1$x),len=2000)
M <- predict(fit1, A) + rnorm(length(A), 0, 0.15) 

for(i in 1:5){
  mypar(1,1)
  plot(A,M,cex=.25,col=3)
  fit1 <- loess(M~A,degree=1,span=1/3)
  cutoff <- (8:12)[i]
  a <- A[which(A>cutoff-1 & A<cutoff+1)]
  m <- M[which(A>cutoff-1 & A<cutoff+1)]
  points(a,m,cex=.35,col= "black",pch=16)
  lines(sort(fit1$x),fit1$fitted[order(fit1$x)],col=2,lwd=2)
  abline(lm(m~a), col=4,lwd=2,lty=2)
  cat ("Press [enter] to continue")
  line <- readline()
} 
 
