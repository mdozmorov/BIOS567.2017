install.packages("HDclassif")
library(HDclassif)
# demo_hddc()
data(wine)
?wine
colnames(wine)[colnames(wine) == "V1"] <- "Alcohol"
colnames(wine)[colnames(wine) == "V10"] <- "Color"


# PROBLEM: With parametric, we usually do NOT know the underlying model!
# Usually use LOWESS: A locally weighted regression technique - becomes non-parametric

attach(wine)
names(wine)

plot(Color, Alcohol)
points(Color[50], Alcohol[50], pch=16)	# Arbitrarily choose obs 50 for illustration

Color[50]		# x value
Alcohol[50]		# y value

distance <- abs(Color - Color[50])	# Only dist along x axis to all otherpoints

# Consider neighborhood span 50% of the data, then k = 50
neighbor <- ifelse(rank(distance) <= 50, 1, 0) # Ranks of the distances within 50%

points( Color[neighbor == 1], Alcohol[neighbor == 1], pch = 19)
points( Color[50], Alcohol[50], pch=16, col = "red")

distance
distance[50] # Distance to our target point is 0
rank(distance)
rank(distance)[50] # Rank to out target point is 1

delta.50 <- max( distance[neighbor == 1] ) # Largest distance between X0 and the points in the neighborhood
delta.50

u <- ifelse( neighbor==1, distance/delta.50, NA ) # Calculate u

weight <- ifelse( u >= 0 & u < 1, (1 - u^3)^3, 0 ) # Calculate W depending on u

cbind( distance, neighbor, u, weight ) # Show it all side-by-side

local.50 <- lm( Alcohol ~ Color, x = TRUE, weights = weight )	# weighted linear regression
abline(local.50)

predict(local.50)

# Now repeat for *another* observation in the dataset, 30
Color[30]
Alcohol[30]
points(Color[30], Alcohol[30], pch=16, col = "green")	# Another point

distance.30 <- abs(Color - Color[30])
neighbor.30 <- ifelse( rank(distance.30) <= 50, 1, 0 )
points(Color[neighbor.30 == 1], Alcohol[neighbor.30 == 1], pch = 19, col = "blue")
points(Color[30], Alcohol[30], pch = 16, col = "green")

delta.30 <- max(distance.30[neighbor.30 == 1])
delta.30

u.30 <- ifelse(neighbor.30 == 1, distance.30 / delta.30, NA)

weight.30 <- ifelse( u.30 >= 0 & u.30 < 1, (1 - u.30^3)^3, 0)
local.30 <- lm( Alcohol ~ Color, x = TRUE, weights = weight.30)
abline( local.30, lty=2)
predict( local.30 )

#	Built in LOWESS (So you don't have to go through the above pain!)
?loess	# (No 'w'): by default fit's a 2 degree polynomial.
out <- loess( Alcohol ~ Color, data = wine, span = 0.4, degree = 1 )
out
names(out)

# NOTE: You must sort the data, 
# Sort the x's, then take the fitted values and sort THEM by the x's.
lines( sort(out$x), out$fitted[order(out$x)], col = "red")


out <- loess( Alcohol ~ Color, data = wine, span = 0.7, degree = 1 )
lines( sort(out$x), out$fitted[order(out$x)], col = "blue")

