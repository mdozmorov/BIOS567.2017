library(RColorBrewer)

boats <- read.table("lab/boats.txt.gz", sep = "\t", colClasses = "numeric")
boats <- as.matrix(boats) # Convert data frame to matrix for efficiency
boats[1:5, 1:5] # Grayscale intensities

rotate <- function(x) (apply(x, 2, rev)) # Reverse column order

boats <- rotate(boats) # Need to reverse column order
boats <- t(boats) # and transpose the matrix

bits <- 16 # Color depth. Experiment with 1, 2, 4, 16 bits

colors <- colorRampPalette(c("grey0", "grey100"))(2^bits) # Palette with pre-defined color depth
image(boats, col = colors)
