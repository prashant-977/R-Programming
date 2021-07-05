######## Lecture 4: Importing, Exploring and Understanding Data ########

## Today's lecture is covered by Chapter 2: Managing and Understanding Data
## of Machine Learning with R (2nd Edition) by Brett Lantz

## It is very common for public datasets to be stored in text files.
## One of the most common tabular text file formats is the CSV (Comma-Separated
## Values) file, which as the name suggests, uses the comma as a delimiter.

## We will first show how to import data from a CSV file, and continue with
## the discussion of exploring the data.



######## Installing, Loading and Unloading R packages ########

## Many of the algorithms needed for machine learning, data manipulation and data visualization
## with R are not included as part of the base installation. Instead, these algorithms are
## available via a large community of experts who have shared their work freely.
## Therefore, these algorithms must be installed on top of base R manually.

## A collection of R functions/algorithms are usually avaialbe as a "package".
## And there are many many (a bit less than 7000 by far) packages we can use.
## So, to use a specific function/algorithm, we must first install the "package" that has it.

## Step 1: install the package

##   install.packages("name_of_the_pacakge")

## Step 2: load the package

##   library("name_of_the_package")

## Some of the most useful packages are already installed but not loaded yet.
## We can click "Packages" in the block on the right =============================================>>>>>>>>>>
## To load any of the packages, simply cilck the box.



######## Importing data from CSV files ########

## We will explore the "usedcars.csv" dataset, which contains actual data
## about used cars recently advertised for sale on a popular U.S. website.

## It is often a good idea to view a data set using a text editor or
## other software such as Excel before loading it into R.
## IMPORTANT: Note that variable names are part of the data and are included
##            in the first row. We need to tell R that this is the "header".

## The dataset is stored in the CSV form, we can use the read.csv() function
## to load the data into an R data frame.

usedcars <- read.csv("usedcars.csv", header = TRUE)  ## The variable names are in the first line
                                                     ## of the data, so set "header = TRUE".

## To check the definition of a R built-in function, we can use ? followed by the function's name

?read.csv

## We read the CSV file into a data frame titled "usedcars".
## Note that R has by defauly automatically converted all character variables into factors.
## Sometimes, we need to prevent R from doint it by setting "stringsAsFactors = False",
## and this depends on the case.

## Once the data has been loaded, the fix() function can be used to view it in a spreadsheet like window.
## However, the window must be closed before further R commands can be entered.

fix(usedcars)



######## Exploring the structure of data ########

## One of the first questions to ask in an investigation of a new dataset
## should be about how the dataset is organized.

## As was discussed in previous lecture, the str() function provides a method
## to display the structure of R data structures.

str(usedcars)

## The statement "150 obs." informs us that the data includes 150 observations,
## which means the dataset contains 150 rows.
##
## The "6 variables" statement refers to the six features that were recorded
## in the data (i.e., 6 columns).
##
## Three of the 6 features are labelled as "chr", the character type.
## and the other three are noted as "int", which indicates integer type.



######## Exploring numeric variables (with summary statistics) ########

## To investigate the numeric variables in the used car data, we use a common
## set of measurements to describe values known as summary statistics.
## The summary() function displays several common summary statistics.

summary(usedcars$price)                    ## investigate a single feature

## To refer to a variable, we can type the data frame and the variable name
## joined with a $ symbol. Alternatively, we can use the attach() function in
## order to tell R to make the variables in this data frame available by name.
## So no more $ symbol is needed.

attach(usedcars)
summary(price)                             ## returns the same output as above

## IMPORTANT: Remember to detach the data frame when you are done with it!
##
##   detach(usedcars)

summary(usedcars[c("price", "mileage")])  ## investigate several features
summary(usedcars[3:4])                  
summary(usedcars[c(3,4)])

## In the output, there are 6 summary statistics:
## - "Min." is the minimum
## - "1st Qu." refers to the value below which one quarter of the values are found
## - "Median" is the value that occurs halfway through an ordered list of values
## - "Mean" measures the average of all the values of a feature
## - "3rd Qu." refers to the value above which one quarter of the values are found
## - "Max." is the maximum

## On the price variable, we have the following summary statistics:
##
##      summary(usedcars$price)
##       Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##       3800   10995   13592   12962   14904   21992 
##
## The difference between the minimum and Q1 is about $7,000,
## so is the difference between Q3 and the maximum;
## however, the difference between Q1 and Q3 is roughly $4,000.
##
## This suggests that
##  - the lower and upper 25 percent of values are more widely dispersed
##  - the middle 50 percent of values are more tightly grouped around the center.
##
## this pattern of spread can be resembled to a Normal Distribution (will visualize this later).

## Other useful functions for data exploration include:

## The span between the min. and max. value is known as the range
range(price)

## The difference between Q1 and Q3 is known as the Interquartile Range (IQR)
IQR(price)

## The quantile() function provides a robust tool to identify
## quantiles for a set of values
quantile(price)

## If we specify an additional "probs" parameter using a vector of probabilities denoting cut points,
## we can obtain arbitrary quantiles, such as the 1st and 99th percentiles
quantile(price, probs = c(0.01, 0.99))



######## Exploring numeric variables (with visualization) ########


## Method 1:

## Visualizing numeric variables can be very helpful in exploring numeric varialbes.
## A common visualization tool for the five-number summary (min, Q1, median, Q3, Max)
## is the boxplot() function.

boxplot(price,
        main = "Boxplot of Used Car Prices",  ## use "main" to add a title to the figure
        ylab = "Price ($)")                   ## use "ylab" to label the vertical axis

## The boxplot displays the center as well as the spread of a numeric variable:
## - If reading the plot from the bottom to the top, the horizontal lines
##   forming the box in the middle of each figure represent Q1, median and Q3.
## - The whiskers extend to a minimum or maximum of 1.5 times of the IQR
##   below Q1 or above Q3.
## - Any values that fall beyond this threshold are considered outliers
##   and are denoted as circles or dots.

## Also note that the width of the box-and-whiskers plot is arbitrary and
## does NOT illustrate any characteristic of the data.


## Method 2:

## Another method to graphically depict the spread of a numeric variable is to
## use the histgram.

hist(price,
     main = "Histogram of Used Car Prices",
     xlab = "Price ($)")

## Histgram divides the variable's values into a number of bins
## that act as containers for values. Note that:
## - the bins have an identical width;
## - the heights of bins indicate the count or frequency of values
##   falling within each of the equal width bins.

hist(mileage,
     main = "Histogram of Used Car Mileage",
     xlab = "Odometer (mi.)")

hist(mileage,
     main = "Histogram of Used Car Mileage",
     xlab = "Odometer (mi.)", breaks = 12) #we use break to specify numbers of bin


## Note that the preceding histograms have a different number of bins.
## This is because the hist() function attempts to identify a reasonable
## number of bins for the variable's range.

## Finally, variance and standard deviation of the used car data:

var(price)    ## In R, SAMPLE variance is calculated with the var() function
sd(price)     ##In R, SAMPLE standard deviation is calculated with the sd() function
var(mileage)
sd(mileage)



######## Exploring categorical variables ########

## The used car dataset had three categorical variables: model, color, and transmission.
## Recall that while loading the data R has automatically converted them into factor type.

model
color
transmission

levels(model)  #gives only the variables
## In contrast to numeric data, categorical data is typically examined
## using tables rather than summary statistics (the summary() function still works sometimes).
## The table() function can be used to generate one-way tables for a single categorical variable.

table(model)

## The table() function lists the categories of the nominal variables
## and a count of the number of values falling into each category.

## R can also perform the calculation of table proportions directly, by using
## the prop.table() command on a table produced by the table() function.

model_table <- table(model)
model_table
prop.table(model_table)



######## Exercise ########

## First, find how many categories there are for "color" and "transmission", respectively,
## and how many observations there are in each category.
##
## Second, Determine the percentage for each category in "color" and "transmission", respectively.

table(color)
prop.table(table(color))

table(transmission)
prop.table(table(transmission))

######## Exploring relationships between numeric variables ########

## So far, we have examined variables one at a time, calculating only UNIVARIATE
## statistics. During our investigation above, we might have raised questions that
## we were unable to answer at that time:
##
## - Does the price data imply that we are examining only economy-class cars or
##   are there also luxury cars with high mileage?
##
## - Do relationships between the year and price data provide insight into the
##   types of cars we are examining?
##
## These type of questions can be addressed by looking at BIVARIATE relationships,
## which consider the relationship between two variables.
## Relationships of more than two variables are called MULTIVARIATE relationships.

## A scatterplot is a diagram that visualizes a bivariate relationship.
## The plot() function is the primary way to plot bivariate relationship in R.
## For instance, plot(x, y) produces a scatterplot of the numbers in x versus
## the numbers in y.

## For example, to answer our previous question about the relationship between
## price and mileage, we can draw a scatterplot with plot() function:

#plot(x = mileage, y = price)

plot(x = mileage, y = price,                     ## Conventionally, y variable is the 
     main = "Scatterplot of Price vs. Mileage",  ## one that is presumed to depend on x.
     xlab = "Used Car Mileage (mi.)",            ## x - independent variable (i.e., feature)
     ylab = "Used Car Price ($)")                ## y - dependent variable (i.e., target)

## Using the scatterplot, we notice a clear relationship between the price of a used
## car and the mileage. That is, car prices tend to be lower as the mileage increases.

## In addition, there are very few cars that have both high price and high mileage.
## That is, our data is unlikely to include any high mileage luxury cars.
## However, there is one lone outlier. How can we identifity it?

## In conjunction with the plot() function, identify() provides a useful interactive
## method for identifying the value for a particular variable for points on a plot.
## We pass in three arguments to identify(): the x-axis variable, the y-axis variable,
## and the variable whose values we would like to see printed for each point.
## Then clicking on a given point in the plot will order R to print the value of the
## variable of interest; clicking Esc to exit the identify() function;
## the number printed under the identify() function is the row of the selected point.

identify(x = mileage, y = price, model)

usedcars[90, ]

######## Exercise ######## 

## Do relationships between the price and year data provide insight into the
## types of cars we are examining?

plot(x = year, y = price,                     ## Conventionally, y variable is the 
     main = "Scatterplot of Price vs. Year",  ## one that is presumed to depend on x.
     xlab = "Used Car Year (year.)",            ## x - independent variable (i.e., feature)
     ylab = "Used Car Price ($)")                ## y - dependent variable (i.e., target)


#we dont use scatterplots for 2 categorical variables as the output wont make much sense
#for example

plot(x = model, y = transmission,                     ## Conventionally, y variable is the 
     main = "Scatterplot of Transmission vs. Model",  ## one that is presumed to depend on x.
     xlab = "Used Car Year (model.)",            ## x - independent variable (i.e., feature)
     ylab = "Used Car Price (Transmission)")                ## y - dependent variable (i.e., target)



######## Exploring relationships between categorical variables ########

## Sometimes we also want to examine a relationship between two nominal variables,
## To do so, we will create a "two-way cross-tabulation" (aka. a crosstab or contingency table).
##
## A cross-tabulation is similar to a scatterplot in that it allows you to examine how
## the values of one variable vary by the values of another.
## The format is a table in which the rows are the levels of one variable,
## while the columns are the levels of another.

## Remeber how to upload a package? Now we need the package called "gmodels".
## In particular, we want to used the CrossTable() function to create cross-tabulation.
## Let's check if it's been installed already ===================================================>>>>>>>>>>

## For example, we want to know the the relationship between "model" and "color":


install.packages("gmodels")

library("gmodels")

CrossTable(x = model, y = color)


## We could also defined and add a new variable (column) to the existing data frame.
## 
## For example, variable "color" has 9 levels, but we don't really need this much detail.
## Instead, we could label the car's color as conservative or not-conservative, that is:
## - conservative: Black, Gray, Silver, White
## - non-conservative: Blue, Gold, Green, Red, Yellow
##
## We could create a binary logical variable (often called a dummy variable), indicating
## whether or not the car's color is conservative by the above definition.
## Its value will be 1 if true, or 0 otherwise.

color %in% c("Black", "Gray", "Silver", "White")

## The %in% operator returns TRUE or FALSE for each value in the vector on the LHS
## of the operator depending on whether the value is found in the vector on the RHS.

## We create a new feature called "conservative" (dummy variable) and add it to the data frame "usedcars":

usedcars$conservative <- color %in% c("Black", "Gray", "Silver", "White")
str(usedcars)


summary(usedcars$conservative)  ## Let's check the new variable we've just created.

## Question: Is there substantial differences in the types of colors chosen by the model of the car?

CrossTable(x = model, y = usedcars$conservative)

#we can see from the cross table that there is no much difference in the ratio of each model: all are
#roughly 30-35% to 65-70%

######## Additional Graphical and Numerical Summaries ########

## The pairs() function creates a scatterplot matrix, i.e. a scatterplot for EVERY
## scatterplot pair of variables for any given data set.

pairs(usedcars)

## We can also produce scatterplots matrix for just a subset (model, price, mileage) of the variables.

pairs(~ model + price + mileage)









