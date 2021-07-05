######## Operations on R Objects - Part 1 ########

## In this lecture and the following lecture, we will discuss some useful operations
## on vectors, matrices, lists, data frames and factors.



######## Operations on Vectors - Vectorized Operations ########

## Many operations in R are VECTORIZED, meaning that operations occur in parallel.
## That is, an operation/function applied to a vector is actually applied individually to each element.
## This allows you to write code that is more efficient and easier to read than in non-vectorized languages.

## The simplest example is when adding two vectors together:

x <- c(1,2,4,25,22)
y <- c(6,0,9,20,22) 
x + y

## Without vectorization, we would have to apply the above operation to
## each pair of elements manually.

## Of course, subtraction, multiplication and division are also vectorized:

x - y
x * y
x / y

## Another operation you can do in a vectorized manner is logical comparisons:

x > y
x < y
x == y  ## IMPORTANT: the logical comparison for equality is "==" NOT "="!

## Many R functions are also vectorized, meaning that a function applied to a vector
## is actually applied individually to each element:

sqrt(1:9)
log(1:9)
round(c(1.2,3.9,0.4))

## The vectorization is a very useful feature in R. We will see more applications
## in our future studies.



######## Operations on Vectors - Recycling ########

## When applying an operation to two vectors that requires them to be the
## same length, R automatically recycles, or repeats, the shorter one, until it is
## long enough to match the longer one.

x <- c(1,2,4)
y <- c(6,0,9,20,22)
x + y

## The shorter vector was recycled, so the actual operation was as follows:

c(1,2,4,1,2) + c(6,0,9,20,22)

## Of course, subtraction, multiplication and division also use recycling:

x - y  ## c(1,2,4,1,2) - c(6,0,9,20,22)
x * y  ## c(1,2,4,1,2) * c(6,0,9,20,22)
x / y  ## c(1,2,4,1,2) / c(6,0,9,20,22)

## Guess what the outputs would be for following commands?

y + 5
y > 10
x*y < 25



######## Operations on Vectors - Common Vector Operations ########

## To find and set the length of a vector, we can use length() function

x
length(x)  ## get the length of "x"

## Generating vectors with ":", seq() and rep():

## ":" produces a vector consisting of a range of numbers

1:5  ## c(1,2,3,4,5)
5:1  ## c(5,4,3,2,1)

1:2 - 1  ## this means "(1:2) - 1", not "1:(2-1)"
1:(2-1)  ## this is equivalent to "1:1", which returns only one value

## A generalization of : is the seq() (sequence) function, which generates
## a sequence in arithmetic progression.

seq(from = 1, to = 5, by = 1)  ## this is equivalent to "1:5"

seq(from = 1.1, to = 2, length = 10)   ## the spacing can be noninteger value and
                                       ## you can specify the length of the sequence

## The rep() (repeat) function allows us to conveniently put the same constant(s)
## into long vectors.
##
## The form is rep(x, times), which creates a vector of times*length(x) elements,
## that is, times copies of x.

rep(8, times = 4)
rep(c(5,12,13), times = 3)  ## a vector with 3 copies of vector c(5,12,13)
rep(1:3, 3)

rep(c(5,12,13), each = 3)  ## the output is different to "rep(c(5,12,13), 3)"



######## Operations on Vectors - Filtering ########

## Another feature reflecting the functional language nature of R is filtering.
## This allows us to extract a vector's elements that satisfy certain conditions.
##
## Filtering is one of the most common operations in R, as statistical analyses
## often focus on data that satisfies conditions of interest.

## Generating Filtering Indices:

z <- c(5,2,-3,8)

z >= 5    ## Identify the elements (of z) >= 5
z*z >= 5  

z[z*z > 8]  ## We asked R to extract from "z" all its elements
            ## whose squares were greater than 8:
            ## - Since z is a vector, z*z will also be a vector c(25,4,9,64).
            ## - With recycling, the number 8 becomes the vector c(8,8,8,8).
            ## - With vectorization, "z*z > 8" returns c(TRUE, FALSE, TRUE, TRUE).
            ## - z[c(TRUE, FALSE, TRUE, TRUE)] returns c(5, -3, 8).

## Guess the output of the following commands without running them in R.

z <- c(5,2,-3,8)
y <- c(1,2,30,5)
y[z*z > 8]

## Guess the output before coding in the following commands.

z[c(TRUE, TRUE, FALSE, TRUE)] == 2

z[z > 3] <- 0
z

## Filtering with the subset() Function:

## Filtering can also be done with the subset() function, which returns
## subsets of vectors, matrices or data frames that meet user-specified conditions.

z <- c(5,2,-3,8)

subset(z, z*z > 8)

z[z*z > 8]          ## Compare the output with the one given by "z[z*z > 8]"

## Filtering with the Selection Function which():

## As you've seen, filtering consists of extracting elements of a vector that
## satisfy a certain condition. In some cases, though, we may just want to find
## the POSITIONS within a vector at which the condition occurs.
## We can do this using the which() function.

which(z*z > 8)  ## IMPORTANT: this returns the indices, not the actual values!
                
z[z*z > 8]      ## compare the output with the one given by "which(z*z > 8)".



######## Operations on Vectors - A Vectorized if-then-else: The ifelse() Function ########

## if-then-else construct could be found in almost all programming languages (even in Excel).
## R also includes a vectorized version, the ifelse() function, and it's very handy.
## 
## The general form is as follows:
## 
##   ifelse(test, yes, no)
##
##   - "test" is logical vector (TRUE/FALSE vector)
##   - "yes" is the return value for "TRUE" elements of "test"
##   - "no" is the return value for "FALSE" elements of "test"

x <- 1:10

ifelse(x %% 2 == 0, "even", "odd") ## "%%" is the "modular division", i.e., x/2 and return the remainder

x <- c(5,2,9,12)

ifelse(x > 6,2*x,3*x)  ## "yes" and "no" can also be expressions 

## Question: In the given vector called "gender", gender is coded as "M", "F", or "I" (for infant).
##           Please recode those characters in "gender" as 1, 2 or 3.
##
##           g <- c("M", "F", "F", "I", "M", "M", "F")

g <- c("M", "F", "F", "I", "M", "M", "F")
ifelse(g == "M",1,ifelse(g == "F", 2, 3))

######## NA Values ########

## In statistical data sets, we often encounter missing data, which we represent
## in R with the value "NA". Generally speaking, "NA" = Problems!

x <- c(88,NA,12,168,13)
x

mean(x)  ## mean() refused to calculate, as one value in x was NA

## Fortunately, in many of R's statistical functions, we can instruct the function
## to skip over any missing values.

mean(x, na.rm = TRUE)  ## By setting the optional argument "na.rm" (NA remove) to TRUE,
                       ## we calculated the mean of the remaining elements.

##we can use ?mean or ?subset to check the definition of functions
## Diffrent filtering methods treat "NA" differently:

x[x > 50]  ## "NA" is kept in the output

subset(x, x > 50)  ## "NA" is removed by subset()



######## Operations on Matrices - Linear Algebra Operations ########

## Matrix operations are also vectorized, making for nicly compact notation.
## This way, we can do element-by-element operations on matrices.

x <- matrix(1:4, nrow = 2, ncol = 2)
x

y <- matrix(rep(10, 4), nrow = 2, ncol = 2)
y

x + y  ## mathematical matrix addition

y * 3  ## mathematical multiplication of matrix by scalar

x * y  ## element-wise multiplication

x / y  ## element-wise division

x %*% y  ## true matrix multiplication



######## Operations on Matrices - Filtering ########

## Filtering can be done with matrices, just as with vectors.
## You must be careful with the syntax though.

## Generating Filtering Indices:

x <- matrix(1:6, ncol = 2)
x

x >= 5  ## Identify the elements >= 5

x[x[,2] >= 5, ]  ## We asked R to extract from matrix "x" all its rows
                 ## whose value on the second column is at least 5.
                 ##  - x[,2] is the second column of x, and also a vector c(4,5 6)
                 ##  - Due to recycling, the number 5 becomes the vector c(5,5,5)
                 ##  - With vectorization, "x[,2] >= 5" returns c(FALSE, TRUE, TRUE)
                 ##  - x[c(FALSE, TRUE, TRUE), ] returns the rows of x specified
                 ##    by the "TRUE" element of c(FALSE, TRUE, TRUE).
                 ## IMPORTANT: Don't forget the last "," in the commands!

## Filtering with the Selection Function which():

## Recall that which() function finds the POSITIONS within a vector
## at which a given condition occurs.
##
## Also recall that a matrix is essentially a vector!
##
## Therefore, we can also apply which() to matrics.

x <- matrix(c(3,4,9,-1,10,11), ncol = 2)
x
which(x %% 2 == 0)  

## R informed us here that, from a vector-indexing point of view,
## the 2nd and 5th elements of matrix x dividable by 2.



######## Operations on Matrices - Applying Functions to Matrix Rows and Columns with apply() ########

## We can instruct R to call a user-specified function on each of the rows or
## each of the columns of a matrix. We can do this using the apply() function.
## Note that apply() and other functions within the same family are very very ... very useful.

## This is the general form of apply for matrices:
##
##   apply(X, MARGIN, FUN, ...)
##
## - "X" is the matrix
## - "MARGIN" is the dimension, equal to 1 if the user-specified function applies to rows
##   or 2 for columns
## - "FUN" is the user-specified function you want to use
## - "..." is for any other arguments to be passed to "FUN"

m <- matrix(1:6, ncol = 2)
m

apply(X = m, MARGIN = 1, FUN = mean)  ## we want to determine the average of each ROW of m
                                      ## note that it is capital "X"

apply(m, 1, mean)  ## it is ok if you don't specificy "X", "MARGIN" or "FUN"

apply(m, 2, mean)  ## we want to determine the average of each COLUMN of m

apply(m, 1:2, sqrt)  ## How about this one?

## Finally, we discuss when to use "...", the argument passed to "FUN".
## And we will use the quantile() function as an example. 
## Recall that quantile() identifies quantiles for a set of values.
## With an additional "probs" parameter using a vector of probabilities denoting cut points,
## we can obtain arbitrary quantiles, such as the 1st and 99th percentiles.

m <- matrix(1:120, ncol = 3)  
m ## m has 3 columns and 40 rows

## How can we find the half (50%) cut point for each column with quantile() function?

?quantile

apply(m, 2, quantile, probs = 0.5)
apply(m, 2, quantile, probs = c(0.25, 0.5, 0.75))

######## Exercise ########

## There's a built-in data frame in R, called "mtcars". Let's do the following:
##
##  - First, check its definition.
##  - Next, find the average value for the first 7 variables.
##  - Find the 25%, 50% and 75% cut points for each of the first 7 variables.
apply(mtcars[,1:7], 2, mean)
apply(mtcars[,1:7], 2, mean) ##can also be treated as a list

apply(mtcars[,1:7], 2, quantile, probs = c(0.25, 0.5, 0.75))
