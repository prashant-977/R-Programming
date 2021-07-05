######## Control Structures 1: if-else and for ########

## Control structures in R allow you to control the FLOW of execution
## of a series of R expressions. Basically, control structures allow you
## to put some "logic" into your R code. That is, they allow you to 
## respond to inputs and execute different R expressions accordingly.

## We will cover the following control structures in this lecture:
##
## - "if-else": testing a condition and acting on it
## - "for": execute a loop for a fixed number of times

## Control structures are very important when writing R functions.
## Therefore, we must understand how they work before we delve into function.



######## if-else ########

## The "if-else" structure allows you to test a condition and act on it
## depending on whether it's true or false.



#### Syntax 1 ####

##--------------------------------------------

if (<condition>) {
  ## Do something if <condition> is true
}

##--------------------------------------------

## Example 1:

x <- sample(-10:10, 1)  ## take a random number from -10:10
x

if (x >= 0) {
  print("x is non-negative.")
}



#### Syntax 2 ####

## The above code does nothing if "x" is negative.
## If you have an action you want to execute when the condition is false,
## then you need an "else" clause.

##--------------------------------------------------

if (<condition>) {
  ## Do something if <condition> is true
} else {
  ## Do something else if <condition> is false
}

##--------------------------------------------------

## Example 2:

x <- sample(-10:10, 1)
x

if (x >= 0) {
  print("x is non-negtive.")
} else {
  print("x is negtive.")
}



#### Syntax 3 ####

## You can also have several tests by following the initial "if" with
## any number of "else if".

##---------------------------------------------------

if (<condition_1>) {
  ## Do something if the <condition 1> is true
} else if (<condition_2>) {
  ## Do something else if the <condition 2> is true
} else {
  ## Do something else if neither condition is true
}

##---------------------------------------------------

## example 3:

x <- sample(-10:10, 1)
x

if (x > 0) {
  print("x is positive.")
} else if (x < 0) {
  print("x is negtive.")
} else {
  print("x is zero.")
}



######## for ########

## "for" is the most useful looping construct in R. By "looping", it means
## it is a repetition structure that allows you to do something
## which needs to be executed a specific number of time.



#### Syntax ####

## -------------------------------------

for(i in x) {
  ## Do something for each iteration
}

##using the ifels function is more efficient than this if structure

## -------------------------------------

## It means that there will be one iteration of the loop for each component
## of the vector "x", with iterator "i" taking on the values of those components:
## 
##  - in the first iteration, i = x[1]
##  - in the second iteration, i = x[2]
##  - in the third iteration, i = x[3]
##  - and so on



## Example 1: Print 1 to 10

for (i in 1:10) {  ## "i" is the iterator, 
  print(i)         ## in each iteration, "i" is given the values 1,2,...,10
}                  ## and in each iteration, the value of "i" is printed.

## Example 2:

x <- c(5, 12, 13)

for (i in x) {
  print(i^2)    ## return the square of every element in vector "x"
}

## Example 3:

x <- c("a", "b", "c", "d")

## The following three loops do the same thing - print in the console each letter in "x":

for(i in x) {   ## "i" takes each element of the vector x in each iteration
  print(i)      ## that is, i <- x[1] for the first iteration, then x[2], x[3], x[4]
}

for(i in 1:length(x)) {  ## length(x) = 4
  print(x[i])    
}

for(i in seq_along(x)) {  ## "seq_along(x)" generates a integer sequence based on the length of "x"
  print(x[i])             ## that is, seq_along(x) = c(1,2,3,4) = 1:4
}



######## Exercise ########

## Please count the number of even numbers in the given vector "y":
a <- 0
for(i in y){
  if (i%%2==0){
    a <- a+1
    print(i)
  }
}
print(a)

######## Exercise ########

z <- c(2,-5,3,9,0,-8,-11,6)

## What is the equivalent for/if...else statements to the following command:

ifelse(z > 0, "positive", ifelse(z < 0, "negative", "zero"))

for(i in z){
  if(i > 0){
    ##print("positive")
    cat(i, " is positive", "\n")
  }
  else if(i < 0){
    ##print("negative")
    cat(i, " is negative", "\n")
  }
  else {
    ##print ("zero")
    cat(i, " is zero", "\n")
  }
}

?cat
######## Exercise ########

## Let's use the R built-in dataset "airquality".

str(airquality)

## Suppose, based on the "Ozone" measurements in the airquality data set, and a cutoff of Ozone level of 60ppb.
## By using a for loop, we want to figure out which days were good air quality days (Ozone < 60ppb).

## First, we want to check if there are any missing values.

is.na(airquality)  ## is.na() indicates which elements are missing (returning TRUE for a missing value)

is.na(airquality[1:2,])  ## is.na() indicates which elements are missing (returning TRUE for a missing value)

## Note that there are many missing values (i.e., NA) in the first two variables (columns).
## As we discussed last week, when there are missing values, many operations in R fail.
## One way to get around this is to create a new data frame that deletes all the rows
## corresponding to observations with missing rows.
##
## This can be done with the na.omit() function.
## It returns the object with incomplete cases (observations/rows) removed.

airquality_na_omit <- na.omit(airquality)
dim(airquality_na_omit)
dim(airquality)          ## How many observations were deleted because of missing data?

goodair <- c()  ## Initialize an empty vector which stores the indicies of good air quality days

for (i in 1: length(airquality_na_omit)) {
  if (airquality_na_omit$Ozone[i]<60){
    goodair[i] <- 1
  } else   {
    goodair[i]<-0
  }
}

airquality_na_omit[!is.na(goodair), ]  ## "!" is the negation (i.e., not) operator
