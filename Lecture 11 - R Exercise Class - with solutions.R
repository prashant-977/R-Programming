######## Lecture 11 - R Exercise Class ########

## In this lecture, we will sharpen our R programming skills by solving several exercises.



######## London Tube Performance ########

## "tubeData.csv" is a data frame with 1050 observations on the following 9 variables concerning
## 10 tube lines in London:
##
##  - Line: A factor with 10 levels, one for each London tube line
##  - Month: A numeric vector indicating the month of the observation
##  - Scheduled: A numeric vector giving the scheduled journey time 
##  - Excess: A numeric vector giving the excess journey time
##  - TOTAL: A numeric vector giving the total journey time
##  - Opened: A numeric vector giving the year the line opened
##  - Length: A numeric vector giving the line length
##  - Type: A factor indicating the type of tube line (DT = Deep Tube, SS = Sub-surface)
##  - Stations: A numeric vector giving the number of stations on the line

tubedata <- read.csv("tubeData.csv", header = TRUE)



## Question 1: Please find the average distance between two stations for each tube line.
##             Which tube line has the largest average inter-station distance?

## First, please check if the length and number of stations of each tube line stayed unchanged
## for the time period under consideration.

aggregate(tubedata[c("Length", "Stations")], list(tubedata$Line), unique)

## If they stayed unchanged during the period, we could compute the average distance between stations by
## taking the ratio of "Length" to "Stations" for each tube line.

## There are several ways available. For example, we can use functions from apply() family or for() loop.

## Your code starts from here:

splitdata1 <- split(tubedata[c("Length", "Stations")], tubedata$Line)

ratio <- function(df) {
  df$Length[1] / df$Stations[1]
}

sapply(splitdata1, ratio)



## Question 2: Please find the most and least punctual tube lines in London
##
## Hint: calculate the ratio of sum_of_Excess to sum_of_Scheduled for each tube line

## Your code starts from here:

splitdata2 <- split(tubedata[c("Excess", "Scheduled")], tubedata$Line)

ratio2 <- function(df) {
  sum(df[, 1]) / sum(df[, 2])
}

sapply(splitdata2, ratio2)



######## World Data ########

## In this example, we'll use the "world" data. The data is stored in "world.txt".
##
## Among the 8 variables:
##
##  - literacy = Literacy rate
##  - phys = physicians/1000 population
##  - un.date = date joined the UN 

world <- read.csv("world.txt", header = TRUE)

## Please write a function which takes the following arguments
## and returns the countries that satisfy the given criteria:
##
##  - Continent
##  - Minimum gdp
##  - Minimum military expenditure
##  - Minimum literacy rate
##
## Hint: Logical AND is & and &&
##       Logical OR is | and ||

## The shorter forms (& and |) performs element-wise comparisons between two vectors. 
## The longer forms (&& and ||) compares just the first elements of each vector.

x <- c(TRUE, FALSE, TRUE)
y <- c(TRUE, TRUE, FALSE)

x & y   ## & performs element-wise comparison
x && y  ## && looks at just the FIRST element of each vector

## Also note that logical AND (& and &&) has higher precedence than OR (| and ||).

TRUE | TRUE & FALSE    # is different from the code below
(TRUE | TRUE) & FALSE

## Your code starts from here:

findcountry1 <- function(continent, min_gdp, min_military, min_literacy) {
  subset(world, cont == continent & gdp >= min_gdp & military >= min_military & literacy >= min_literacy)
}

## For example, the code below will list all countries:
##  - which are in Europe
##  - whose gdp is at least 30,000
##  - whose military expenditure is at least 1,000,000,000
##  - whose literacy rate is at least 95%

findcountry1("EU", 30000, 1000000000, 95)  



## Please write another function which takes the following arguments
## and returns the non-European countries that satisfy the given criteria:
##
##  - Minimum gdp
##  - Minimum military expenditure
##  - Minimum literacy rate
##
## If the "cont" is missing but the above criteria are satisfied for some countries,
## the function should also return them.

## Your code starts from here:

findcountry2 <- function(min_gdp, min_military, min_literacy) {
  subset(world, (cont != "EU" | is.na(cont)) & gdp >= min_gdp & military >= min_military & literacy >= min_literacy)
}

## For example, the code below will list all non-European countries (including the countries whose "cont" value is missing):
##  - whose gdp is at least 18,000
##  - whose military expenditure is at least 1,000,000,000
##  - whose literacy rate is at least 99%

findcountry2(18000, 1,000,000,000, 99)



######## Matrix Manipulation ########

## Please write a function which takes any matrix as its argument,
## and returns another matrix of the same dimensions, each of whose elements is assigned the value
## based on its position: product of its row and column indicies.
##
## Hint: nested for() loops

matrix_manipulation <- function(mat) {
  new_mat <- matrix(, ncol = ncol(mat), nrow = nrow(mat))  ## We create an empty matrix "new_mat" which has the same dimension as the input matrix "mat"
  for (i in 1:nrow(mat)) {
    for (j in 1:ncol(mat)) {
      new_mat[i, j] <- i * j
    }
  }
  return(new_mat)
}

x <- matrix(rep(100, 16), ncol = 4)  ## "x" is a 4x4 matrix, and all its elements are 100.
x

matrix_manipulation(x)  ## The output matrix is a 4x4 matrix, the same dimensions as "x". But observe its elements.
