############################################
## Processing Affymetrix CEL files
############################################
library(affy)
56000*11*2 # Memory requirements for 56K probesets, 11 arrays, PM-MM
memory.limit(size=4000) # Windows onlyl

setwd("data_affy")
list.celfiles() # What are the CEL files in the current directory
# A subset of study at VCU, 36 patients with lung cancer
# Lung cancer samples from the same individual, sampled from tissue blocks
filenames <- list.celfiles(pattern = "REP*") 
filenames
?ReadAffy # Wrapper for read.affybatch
Lung<-read.affybatch(filenames=filenames) # Warning about phenoData, since it wasn't provided
Lung
pData(Lung)
class(Lung) # AffyBatch object allows access to PM/MM data

# Working with probesets - Affy IDs
# Use pm and mm functions to access the perfect match and mismatch data
hist(pm(Lung)[,1])  # First GeneChip histogram of PM values
hist( log(pm(Lung)[,1], 2) )  # log2 PM values
plot(density( log(pm(Lung)[,1], 2) ))  # Density of PM values
lines(density( log(mm(Lung)[,1], 2) ), lty=2)  # Overlay density of MM values

# Working with probes in a probeset
head(featureNames(Lung)) # What probeset names are there
matplot(pm(Lung,"121_at"),type="l",xlab="Probe Number",ylab="PM Probe Intensity") # Not as representative
matplot(pm(Lung,"1007_s_at"),type="l",xlab="Probe Number",ylab="PM Probe Intensity") # Probe effect is visible - GC content, location in the gene's 5'/3' end
# Note all three chips are plotted - very consistent
# x11()
matplot(mm(Lung,"1007_s_at"),type="l",xlab="Probe Number",ylab="MM Probe Intensity") # Some probes in MM probeset are actually good
boxplot(log(pm(Lung)[,1],2), 
        log(pm(Lung)[,2],2), 
        log(pm(Lung)[,3],2), 
        log(mm(Lung)[,1],2), 
        log(mm(Lung)[,2],2), 
        log(mm(Lung)[,3],2)) 



# Quality Control from Affymetrix GeneChips
image(Lung[,1])
library(affyPLM) # Probe level linear models
?fitPLM
Pset1<-fitPLM(Lung)
par(mfrow=c(2,2))
image(Lung[,1])
image(Pset1, type="weights", which=1)
image(Pset1, type="resids", which=1)
image(Pset1, type="pos.resids", which=1)

par(mfrow = c(1, 1))
boxplot(Lung, col=c("red","blue","green"), cex.axis=0.7)

library(simpleaffy)
Lung.qc <- qc(Lung)
?qc
avbg(Lung.qc) # average background for each GeneChip, should be consistent
sfs(Lung.qc) # scaling factor for each GeneChip, should be consistent

percent.present(Lung.qc) # percent of probe sets called present by the Affy Detection Call algorithm


# Affymetrix detection call algorithm
pm <- pm(Lung,"205586_x_at")[,1] # In the first experiment only
pm
mm <- mm(Lung,"205586_x_at")[,1]
mm
cbind(pm, mm)
diff <- pm - mm
cbind(pm,mm, diff)
r <- (pm-mm)/(pm+mm)
wilcox.test(r,alternative="greater",mu=0.015,exact=TRUE)

# Doing P/M/A calls automatically
?mas5calls
Lung.calls <- mas5calls(Lung,alpha1=0.05,alpha2=0.065)

exprs(Lung.calls)[1:5,]

sum(ifelse(exprs(Lung.calls)[,1]=="P",1,0))	# How many are present: count 1's
Lung.calls

# Get the percent present:
sum(ifelse(exprs(Lung.calls)[,1]=="P",1,0))/22283*100
percent.present(Lung.qc)	# they're now equal

sum(ifelse(exprs(Lung.calls)[,2]=="P",1,0))/22283*100
sum(ifelse(exprs(Lung.calls)[,3]=="P",1,0))/22283*100

plot(Lung.qc)
avbg(Lung.qc) # average background for each GeneChip


# 3 Prime / 5 Prime ratios should ideally be 1
Lung.mas5 <- mas5(Lung)

gapdh <- grep("AFFX-HUMGAPDH/M33197",featureNames(Lung.mas5))
gapdh

featureNames(Lung.mas5)[gapdh]

gapdh.3<-grep("AFFX-HUMGAPDH/M33197",featureNames(Lung.mas5))[1]
gapdh.5<-grep("AFFX-HUMGAPDH/M33197",featureNames(Lung.mas5))[2]

featureNames(Lung.mas5)[gapdh.3]
gapdh.3
gapdh.5
featureNames(Lung.mas5)[gapdh.5]
exprs(Lung.mas5)[gapdh.3,]/exprs(Lung.mas5)[gapdh.5,]

ratios(Lung.qc) # Doesn't work, with no explanation

biocLite("arrayQualityMetrics")
library(arrayQualityMetrics)

arrayQualityMetrics(Lung, outdir = "Lung.qc")

