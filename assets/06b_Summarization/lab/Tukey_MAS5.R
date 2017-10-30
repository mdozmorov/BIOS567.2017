rm(list=ls())
setwd("/Users/mdozmorov/Documents/Work/Teaching/BIOS567.2017/assets/05b_Quality/lab/data_affy")
library(affy)

list.celfiles()
Lung<-read.affybatch(filenames=list.celfiles(pattern = "REP*"))
pData(Lung)

# Average difference for one probe set example
PM<-pm(Lung[,1],"AFFX-BioB-3_at")
PM # at_20 - < 5' end --- 3' end > - at_1    
MM<-mm(Lung[,1],"AFFX-BioB-3_at")
MM

# What happens if mismatch is subtracted from perfect match
diff<-PM-MM
diff

diff[diff!=min(diff) & diff!=max(diff)] # Excluding minimum and maximum difference
mean(diff[diff!=min(diff) & diff!=max(diff)])
# Negative differences can happen
log(-12) # Error

# Normalizing using expresso function
?expresso
# MAS4.0
Lung.avgdiff<-expresso(Lung, normalize=FALSE, 
                       bg.correct=FALSE, pmcorrect.method="subtractmm",
                       summary.method="avgdiff")
head(exprs(Lung.avgdiff))
exprs(Lung.avgdiff)[grep("AFFX-BioB-3_at",featureNames(Lung.avgdiff)),]

Lung.avgdiff<-expresso(Lung, normalize.method="constant", 
                       bg.correct=FALSE, pmcorrect.method="subtractmm",
                       summary.method="avgdiff")
exprs(Lung.avgdiff)[grep("AFFX-BioB-3_at",featureNames(Lung.avgdiff)),] # Note 2 and 3 arrays are scaled now by constant

# MAS4 background correction
Lung.avgdiff<-expresso(Lung, normalize.method="constant", 
                       bgcorrect.method="mas", pmcorrect.method="subtractmm",
                       summary.method="avgdiff")
exprs(Lung.avgdiff)[grep("AFFX-BioB-3_at",featureNames(Lung.avgdiff)),] # Numbers change again

# MAS 5.0 Algorithm:
?mas5
Lung.mas5 <- mas5(Lung)
index <- grep("AFFX-BioB-3_at",featureNames(Lung.mas5))
index
exprs(Lung.mas5)[index,]

# Tukey's biweight for our example probe set
PM
T0<-median(PM) # Probe median
T0
Sn<-median(abs(PM-T0)) # Scale estimate, MAD
Sn
c<-5 # Tuning constant
u<-(PM-T0)/(c*Sn+0.0001) 
u
w<-ifelse(abs(u)<=1, (1-u^2)^2, 0) # Tukey's 'bi-weight'.
data.frame(PM = PM[, 1], u = u[, 1], w = w[, 1])
Tstar<- sum(w*PM)/sum(w)
Tstar							# Tstar - weighted median of the probeset

# So for our example using the PM and MM we read in:
cbind(PM, MM)
tukey.biweight <- function(x, c=5, epsilon=1e-04) {
  m <- median(x)			# sample mean
  s <- median(abs(x-m))		# Scaling value: median absolute deviation
  u <- (x-m)/(c*s+epsilon)	# 'c' is a 'tuning constant'l.  's' is a scaling factor.
  w <- ifelse(abs(u)<=1, (1-u^2)^2, 0)
  t.bi <- sum(w*x)/sum(w)			# Tukey's bi-weight
  t.bi
}

SB <- tukey.biweight( log(PM, 2) - log(MM, 2) )
SB	# Specific Background

# Idealized Mismatch.
IM <- ifelse( MM < PM, MM, PM /(2^( 0.03 / (1+(0.03 - SB ) / 10 ))))

cbind( PM, MM, IM )

diff <- PM - IM		# NOW we will NOT get any negative values.
log.diff <- log( diff, 2 )

tukey.biweight( log.diff )	# Apply TB a SECOND time !
2^tukey.biweight( log.diff )	# Actualy intensity after taking anti-log.


# Built-in MAS5 with Tukey's biweight
Lung.tb <- expresso(Lung, bg.correct=FALSE, normalize=FALSE, # no background correction and normalization
                    pmcorrect.method="mas", summary.method="mas") # mas5 only, Tukey's biweight
exprs(Lung.tb)[grep("AFFX-BioB-3_at",featureNames(Lung.tb)),]
Lung.mas5<-mas5(Lung) # All the steps in MAS5 algorithm (background correction, normalziation etc.) are summarized in 'mas5' function
exprs(Lung.mas5)[grep("AFFX-BioB-3_at",featureNames(Lung.tb)),]


# LI WONG 
li.wong <- expresso(Lung, normalize.method="invariantset",
                    bg.correct=FALSE, pmcorrect.method="subtractmm",
                    summary.method="liwong")
exprs(li.wong)[grep("AFFX-BioB-3_at",featureNames(Lung.tb)),]
log(exprs(li.wong)[grep("AFFX-BioB-3_at",featureNames(Lung.tb)),],2)


