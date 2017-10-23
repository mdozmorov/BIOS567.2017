# Color normalization (correct dye bias)
# Using parametric curve fitting

# Simulate MA plot with dye bias
# First, simulate A (average expression)
# Log base 2 gene intensities typically range from 3 to 16.
x <- runif(50, 0, 16)	# 50 obs random uniform dist: ranging from 0 to 16
# Second, simulate M (minus ratio), that relates to x in some in some non-linear fasion y = a + b * exp(-c * x)
y <- 1 + 0.5*exp(-0.5 * x) + rnorm(50, 0, 0.1)	# rnorm for random error (noise).

data <- data.frame(x, y)
rm(x,y)			# keep 'data', get rid of extraneous clutter

ls()
data
data <- data[order(data$x), ]	## ordering the data - just for clarity of illustration
data
attach(data)
plot(x, y)

curve(1 + .5*exp( -0.5*x ),add=T)	### overlay the curve that was used to generate our data
# If we don't know the curve, we need to estimate the parameters for the curve

# Try to 'recover' the curve using just the data, as in real life.
?nls
formula1 <- y ~ a + b * exp(-c * x) # ~ = modeled by

# In this example, there seems no advantage to profide the gradient.
# In other cases, there might be
# attr(formula1, "gradient") <- deriv(formula1, c("a", "b", "c") )
formula1

fit <- nls(formula1, data = data, start = list(a = 1, b = 1, c = 1) )	# arbitrary starting values
summary(fit)
# https://socserv.socsci.mcmaster.ca/jfox/Books/Companion/appendix/Appendix-Nonlinear-Regression.pdf
?SSasymp
fit1 <- nls(y ~ SSasymp(x, a, b, c), data = data) # Alternatively, we use self-starting function. Mind the model!
summary(fit1)

lines(x, predict(fit), col="red")
lines(x, predict(fit1), col = "blue")

# Eliminating bias in one of the channel
y.norm <- (y - predict(fit) )		# shift y's by fitted values
# Only normalizing one channel: usuallly the 'm' values for gene data.
plot(x, y.norm) # Now, nicely centered around zero
abline(lm(y.norm ~ x), col = "red")

# PROBLEM: With parametric, we usually do NOT know the underlying model!
# Usually use LOWESS: A locally weighted regression technique.
