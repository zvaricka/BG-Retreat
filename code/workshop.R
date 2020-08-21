# Objectives: Discover the very basics of plotting in R using base plot and ggplot2
# Types of plot we will troubleshoot with:
# - scatter plot
# - histograms
# - stacked bar charts
# - heatmap
# ----------------------------------------------------------------------------------

# R uses objects to store the results of any manipulation
# The main objects are
# - vector
# - matrix
# - data frame
# - list
# - arrays

# Every manipulation is done using function. A function is ALWAYS followed by ()

# Here are some examples of vectors, matrices, and data frames.
# Lists and arrays are more complex to use and we will not cover them here.
a <- 1 # a vector of size 1 with only 1 in it
a

a <- c("a", 2, "b") # the vector a is replaced by a new one
a

b <- seq(1, 5, by=2)

m <- matrix(1:9, ncol=3) # here is a matrix with 3 columns
m
m[,1] # here is the first column using indices
m[1,] # here is the first line using indices

d <- data.frame(a=a, b=b) # here is a data frame with 2 columns: a and b
# the 2 columns have the same values as the vectors a and b

d[,1] # you can access the columns and lines using indices as you did with matrices
d$a # data.frame also allow you to use directly the name of the variable with the sign '$'


# Now let's use some data!
# Loading the iris data set (already included in R)
data(iris)

# Checking the structure of the iris data set
str(iris)

# Having a quick look at the data
head(iris)

# Scatter plot ---------------------------------------------------------
# Let's look at the potential relationship between sepal Length and width
# A scatter plot is a good first step to look at a univariate relation
# between two quantitative variables

# Let's use basic R plot to begin with
# Check the options of the plot function with '?plot'
plot(iris$Sepal.Length, iris$Sepal.Width)

# Another way to have the exact same plot:
plot(iris$Sepal.Width~iris$Sepal.Length)

# You might want to have clearer names for the axes and a title
plot(iris$Sepal.Width~iris$Sepal.Length,
	xlab="Sepal length",
	ylab="Sepal Width",
	main="Relation between Sepal length and width")

# We can try to look for a pattern based on the species.
# A simple first step would be to color code the dots!

# Let's check the different species
table(iris$Species)

# First create a vector with the colors
# Curious about the ifelse function ==> '?ifelse'
color <- ifelse(iris$Species=="setosa", "red",  # In R when providing a condition an equality HAS to be written with '=='
			ifelse(iris$Species=="versicolor", "blue",
				"green"))

plot(iris$Sepal.Width~iris$Sepal.Length,
	xlab="Sepal length",
	ylab="Sepal Width",
	main="Relation between Sepal length and width",
	col=color)
# Want to know more about colors i R: https://www.nceas.ucsb.edu/sites/default/files/2020-04/colorPaletteCheatsheet.pdf

# Not found of empty dots...
plot(iris$Sepal.Width~iris$Sepal.Length,
	xlab="Sepal length",
	ylab="Sepal Width",
	main="Relation between Sepal length and width",
	col=color,
	pch=20)

# A legend would be useful!
legend("topright", # legend will apply to the figure currently plotted
	c("Setosa", "Versicolor", "Verginica"),
	col=c("red", "blue", "green"),
	pch=20)

# Bonus if you have time ---------------------------------------------
# Here is some code to do it with ggplot2
# We will explain more about ggplot2 below but feel free to experiment
# a little later or if you have some time

library(ggplot2)
# We now can use all the functionailites of ggplot2 !

ggplot(data=iris, aes(x=Sepal.Length, y=Sepal.Width, color=Species)) +
	geom_point() +
	xlab("Sepal length") +
	ylab("Sepal Width") +
	ggtitle("Relation between Sepal length and width") +
	theme_bw()

# Let's also adjust the shape!
ggplot(data=iris, aes(x=Sepal.Length, y=Sepal.Width, color=Species, shape=Species)) +
	geom_point() +
	xlab("Sepal length") +
	ylab("Sepal Width") +
	ggtitle("Relation between Sepal length and width") +
	theme_bw()

# Bar plot -----------------------------------------------------------
# What about the number of individuals of each species?
# It is a qualitative variable. One way to look at it would be a bar chart.

# First let's use base plot using the table to count for us
table(iris$Species)
count <- as.integer(table(iris$Species))
names <- names(table(iris$Species))
barplot(count, names.arg=names)
# Not really exciting...
# But how many have a petal width>0.5?
# Let's keep using table to do the heavy lifting

iris$petal_1.2 <- cut(iris$Petal.Width,
					breaks=c(0, 1.2, 3),
					include.lowest=TRUE)

table(iris$petal_1.2, iris$Species)
values <- matrix(table(iris$petal_1.2, iris$Species), ncol=3)
labels <- c("Petal width<1.2", "Petal width>1.2")
color <- c("violet", "orange")
barplot(values,
	names.arg=names,
	col=color,
	ylim=c(0, 60))
legend("topright",
	labels,
	fill=color)

# Now try to adjust the axis names and add a title
# As you see, it is not necessarily very complex but it is not straighforward either
# Let's try ggplot2

# ggplot2 has a different logic.
# You could see it as layer cake: you add information and details layer by layer (line by line)
library(ggplot2) # In case you did not load it before

ggplot(data=iris) + # indicate the data frame to use. Notice that '+' is necessary to link the lines
	geom_bar(aes(x=Species, fill=petal_1.2), stat="count") # here we indicate we want a bar plot and indicate whatshould be used
# ggplot2 takes care of a lot of steps on its own, but you need to learn its specific syntax

# Now let's customize a bit
ggplot() + # the ggplot2 syntax is flexible, you can indicate the data.set to use in the function indicating the type of graph too
	geom_bar(data=iris, aes(x=Species, fill=petal_1.2), stat="count") +
	xlab("") + # removing the axis names
	ylab("") +
	scale_fill_manual(
		name="Petal width", # changing the name of the legend
		values=c("violet", "orange"), # changing the colors
		labels=c("<1.2", ">1.2")) + # changing the labels
	theme_bw() # changing the theme (background, grid, etc)

# You do not want to stak? No problem!
ggplot() +
	geom_bar(data=iris, aes(x=Species, fill=petal_1.2),
		position="dodge", stat="count") +
	xlab("") +
	ylab("") +
	scale_fill_manual(
		name="Petal width",
		values=c("violet", "orange"),
		labels=c("<1.2", ">1.2")) +
	theme_bw()

# You would rather flip it?
ggplot() +
	geom_bar(data=iris, aes(x=Species, fill=petal_1.2),
		position="dodge", stat="count") +
	xlab("") +
	ylab("") +
	scale_fill_manual(
		name="Petal width",
		values=c("violet", "orange"),
		labels=c("<1.2", ">1.2")) +
	theme_bw() +
	coord_flip()


# Histogram -----------------------------------------------------------
# Now let's explore the distribution of a quantitative variable
# What about the distribution of petal length? What does it look like?

# Base R does it quite simply
hist(iris$Petal.Length)
# Prefer another color?
hist(iris$Petal.Length, col="darkblue")

# Now try to modify the axes, title, and the color.


# Here we will try to color based on the species with ggplot2
# Color coding a histogram could be complex considering what it is but
# with ggplot2 it is actually pretty easy!

fig <- ggplot() + # Another advantage of ggplot2: the plots can be stored in objects
		geom_histogram(data=iris, aes(x=Petal.Length))

fig # Now it is plotted!

# Let's modify it using the object rather than recreating it all
fig <- fig +
		theme_bw() +# We are just adding layers to what is stored in 'fig'
		xlab("Petal length") +
		ylab("")

# Let's modify it
fig <- ggplot() +
		geom_histogram(data=iris, aes(x=Petal.Length),
			fill="darkblue", color="black")
fig

# Now let's color code the species directly in the histogram
fig <- ggplot() +
		geom_histogram(data=iris, aes(x=Petal.Length, fill=Species),
			color="black")
fig

# You do not like the color code?
fig <- fig +
		scale_fill_brewer(palette = "Set2")
fig
# Various famous color palette are available or can be added in a sinmple
# way to ggplot2 such as Rcolorbrewer, Viridis, or others

# A very powerfulpossibility with ggplot2 is to use facets if you prefer to plot the species separately
fig <- ggplot() +
		geom_histogram(data=iris, aes(x=Petal.Length),
			color="black") +
		facet_wrap(Species~.) +
		theme_bw()
fig

# You can do that and keep the color code!
fig <- ggplot() +
		geom_histogram(data=iris, aes(x=Petal.Length, fill=Species),
			color="black") +
		scale_fill_brewer(palette = "Set2") +
		facet_wrap(Species~.) +
		theme_bw()
fig

# Let's try something more complex: a heatmap ------------------------------
# We will focus on ggplot2 here, but it is possible also with base plot
# however the way the data are formatted differ

# We want to visualize the variation a quantitative variable (color coded)
# across various combinations of 2 qualitatives variables.
# Here we will create random variables because iris only has 1 qualitative variable

set.seed(1) # We define the seed so that everybody has the same data set

data <- expand.grid(
			species=paste0("species", 1:10),
			group=rep(paste0("group", 1:5), each=2))
# Take a look at what we have for now
View(data)

# Now let's add the quantitative variable
data$measure <- rnorm(nrow(data)) # rnorm randomly draws values from a normal distribution

ggplot(data=data) +
	geom_tile(aes(x=group, y=species, fill=measure)) +
	theme_bw()

# Another palette?
library(viridis)
ggplot(data=data) +
	geom_tile(aes(x=group, y=species, fill=measure)) +
	scale_fill_viridis(option="D") + # Check the viridis package to know more!
	theme_bw()
