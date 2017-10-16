# Reading custom spotted array data into R - Quality Control Data
# Stratagene Universal Human RNA, same samples on multiple arrays,
# each sample labeled with both Cy3 and Cy5
setwd("data_spotted/")
dir(pattern = "txt")
file <- dir(pattern = "txt")[1:2]
file
library(Biobase)
library(marray)
openVignette()
# 12 x 4 subgrids
# 21 x 21 grid in each subgrid
# data obs actually START on row 21212.

# layout
?read.marrayLayout
layout<-read.marrayLayout(fname=file[1], ngr=12, ngc=4, nsr=21, 
                          nsc=21, skip=21211)	

# info.id: columns 1 and 6(gene name).  labels: Tell R where the unique gene labels are
info<-read.marrayInfo(fname=file[1], info.id=c(1,6), labels=6, 
                      skip=21211)
str(info)

# 'chip labels'
# xlabels<-c("7-7","7-12")	   

# gene expression data
?read.marrayRaw	
# tell R which column is the green foreground
raw.data <- read.marrayRaw(file, 
                           name.Gf="ch1 Intensity", name.Gb="ch1 Background", 
                           name.Rf="ch2 Intensity", name.Rb="ch2 Background", 
                           layout=layout, gnames=info, skip=21211)

class(raw.data)	# "marrayRaw"

slotNames(raw.data)

# for the 1st array: [,1]
plot(raw.data@maRf[,1],raw.data@maGf[,1])	# Red Foreground against Green Foreground
# note noise at the low expression level

### Most common is to visualize log base 2 data
plot( log(raw.data@maRf[,1],2) , log(raw.data@maGf[,1],2) )		### Log base 2
plot( log(raw.data@maRf[,1],2) , log(raw.data@maGf[,1],2), ylab="Green", xlab="Red")

# Great, BUT... Bland & Altman says there's a better way:
# Plotting the log-difference by the log-average: Average on x axis, and diff on y.
head(maA(raw.data))	# Bland & Altman have written a lot about this...
head(maM(raw.data))	# Just the first few rows...

plot(maA(raw.data)[,1],maM(raw.data)[,1])

# Operating on Red and Green channels without background subtraction
raw.nobkg<-raw.data  # Creating an object to zero out background - this avoids automatic background subtraction
raw.nobkg@maGb <- raw.nobkg@maRb <- 0 # Won't work, need a vector of zeros, on a single one
raw.nobkg@maGb <- raw.nobkg@maRb <- 0*raw.nobkg@maRb

summary(raw.nobkg@maGb)
summary(raw.data@maGb)

# MA plots, should be around 0. If not - dye bias
par(mfrow=c(2,2))
maPlot(raw.data[,1],x="maA",y="maM",z=NULL,lines.func=NULL,main="7-7")
maPlot(raw.data[,2],x="maA",y="maM",z=NULL,lines.func=NULL,main="7-12") # above zero line, dye bias
maPlot(raw.nobkg[,1],x="maA",y="maM",z=NULL,lines.func=NULL,main="7-7 no back")
maPlot(raw.nobkg[,2],x="maA",y="maM",z=NULL,lines.func=NULL,main="7-12 no back")

# QC
library(arrayQuality)

?maPalette
Colors<-maPalette(low="green",high="red",k=50)
# x11()
image(raw.data[,1],xvar="maM",subset=TRUE,col=Colors)
# x11()
image(raw.data[,2],xvar="maM",subset=TRUE,col=Colors) # Artefact

Colors<-maPalette(low="blue",high="yellow",k=50)
image(raw.data[,2],xvar="maM",subset=TRUE,col=Colors) # Look in different color
image(raw.data[,2],xvar="maGb",subset=TRUE,col=Colors) # Look at background only
image(raw.nobkg[,2],xvar="maM",subset=TRUE,col=Colors) # Look at data 

# x11()
# 12 x 4 subgrids
maBoxplot(raw.data[,2],x="maPrintTip",y="maM",main="Chip 2 PreNorm") # , ylim = c(-5, 5)
# To determine from MA plot and Lowess plot, whether normalization is needed
maPlot(raw.data[,2],x="maA",y="maM",z="maPrintTip",legend.func=NULL,main="Chip 2 MA") # What lowess is, briefly

