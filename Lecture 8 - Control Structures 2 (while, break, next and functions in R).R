######## Control Structures 2: while, break, next and functions in R ########

## Control structures in R allow you to control the FLOW of execution
## of a series of R expressions. Basically, control structures allow you
## to put some "logic" into your R code. That is, they allow you to 
## respond to inputs and execute different R expressions accordingly.

## We will cover the following control structures in this lecture:
##
## - "while": execute a loop while a condition is true
## - "break": break the execution of a loop
## - "next": skip an interation of a loop
## - functions in R

## Control structures are very important when writing R functions.
## Therefore, we must understand how they work before we delve into function.



######## while ########

## "while" is another looping construct. "while" loops begin by testing a condition.
## If it is true, then they execute the loop body. After the loop body is executed,
## the condition is tested again, and so forth, until the condition is false,
## after which the loop exits.



#### Syntax ####

## ------------------------------------

while (<test_expression>) {
  ## Do something for each iteration
}

## ------------------------------------

## Example: Print out all positive integers less than 10

counter <- 0              ## a "counter" is usually needed in while loops (you can call it anything you like)
                          ## Here, the "counter" is initialized to 0

while(counter < 10) {     ## before each iteration, test the condition
  print(counter)
  counter <- counter + 1  ## IMPORTANT: this step is crucial! Why?
}



######## Exercise ########
findoddnumber <- function(input_n){
## Find all non-negative odd numbers less than 10 with a while loop
counter <- 0              ## a "counter" is usually needed in while loops (you can call it anything you like)
result <- c() 
## Here, the "counter" is initialized to 0

while(counter < input_n) {     ## before each iteration, test the condition
  if (counter%%2!=0){
    result <- c(result, counter)
  } 
  counter <- counter + 1  ## IMPORTANT: this step is crucial! Why?
}
result
}
findoddnumber(100)
######## Exercise ########

## Let's reuse the R built-in dataset "airquality".

str(airquality)

## Suppose, based on the "Ozone" measurements in the airquality data set, and a cutoff of Ozone levels of 60ppb.
## By using a while loop, we want to figure out which days were good air quality days (Ozone < 60ppb).

airquality_na_omit <- na.omit(airquality)  ## Remove all observations with missing values.

## The following is how to do it with a for loop:

goodair <- c()  ## Initialize an empty vector which stores the indicies of good air quality days

for (i in 1:length(airquality_na_omit$Ozone)) {
  if (airquality_na_omit$Ozone[i] < 60) {
    goodair <- c(goodair, i)
  }
}

## Your code, with a while loop, starts from here:
str(airquality_na_omit)

i <- 1
goodair <- c()  ## Initialize an empty vector which stores the indicies of good air quality days

while (i < length(airquality_na_omit$Ozone + 1)) {
  if (airquality_na_omit$Ozone[i] < 60) {
    goodair <- c(goodair, i)
  }
  i <- i + 1  ## IMPORTANT: this step is crucial! Why?
}
goodair  ## goodair is an integer vector containing the indicies of all the good air quality days

airquality_na_omit[goodair,]



while (i < length(airquality_na_omit$Ozone + 1)) {
  if (airquality_na_omit$Ozone[i] < 60) {
    goodair[i] <- 1
  } else {
    goodair[i] <- 0
  }
  i <- i + 1  ## IMPORTANT: this step is crucial! Why?
  
}

goodair  ## goodair is a vector of 0-1, with 1 being good air quality day and 0 being bad air quality day

split(airquality_na_omit, goodair)  ## Split the data frame by good/bad air quality

split(airquality_na_omit, goodair)[[2]]  ## The second sub-data frame contains all the good air quality days


######## next & break ########

## Sometimes we want to TERMINATE a loop (for and while) to stop the iterations,
## and move the program outside of the loop. For this purpose, we use "break" in the loop.
##
## That is, When the "break" statement is encountered inside a loop,
## the loop is immediately terminated and program control resumes
## at the next statement following (i.e., immediately after) the loop.

## Example 1:

for (i in 1:20) {
  print(i)
  if (i >= 10) {
    break   ## Stop the "for" loop after 10 iterations.
  }
}



## A "next" statement is useful when we want to SKIP the current iteration
## of a loop without terminating it.
##
## That is, When the "next" statement is encountered inside a loop,
## the R parser skips further evaluation and starts the next iteration of the loop.

## Example 2:

for (i in 1:20) {
  if(i <= 10) {
    next    ## Skip the first 10 iterations
  }
  print(i)  ## The first number to be printed is "11".
}



######## Functions in R ########

## A function is a set of statements organized together to perform a specific task.
## In other words, functions are used to encapsulate a sequence of expressions that
## can be executed at any time.
##
## There are two types functions in R:
## - Built-in R fucntions, e.g. print(), max(), mean(), sum(), str(), summary()...
## - User-defined functions
##
## In this lecture, we discuss how to write user-defined functions. They are specific to
## what a user wants and once created they can be used like the built-in functions.

## First, let's revisit one of the last exercises:

## Find all non-negative odd numbers less than 10 with a while loop



## We can put the above commands together and turn it into a user-defined function
## that can be executed in the same way as we use any built-in function.

## Let's write our first function - findoddnumber()
##
## We want findoddnumber() to be able to print out all the non-negative odd numbers
## which are smaller than the number we've specified: 



######## Function Components ########

## An R function is created by using the keyword "function".
## The basic syntax of an R function definition is as follows:

## ------------------------------------

Function_Name <- function(Argument_1, Argument_2, ...) {
  Function_Body 
}

## ------------------------------------

## The different parts of a function are:
##
##  - Function_Name: This is the actual name of the function. It is stored in R environment (check the upper-right window).
##  - Argument: An argument is a placeholder. When a function is invoked, you pass a value to the argument.
##               Arguments are optional, that is, a function may contain no arguments.
##               Also arguments can have default values.
##  - Function_Body: The function body contains a collection of statements that defines what the function does.
##  - Return_Value: The return value of a function is the last expression in the function body to be evaluated.



######## Function with Argument Values ########

## The function findoddnumber() we just created is a function with one argument (input_number)

findoddnumber <- function(input_number) {
  counter <- 0
  result <- c()
  while (counter < input_number) {
    if (counter %% 2 != 0) {  ## "!" is the negation operator ("!=" means "not equal to")
      result <- c(result, counter)
    }
    counter <- counter + 1
  }
  result
}

findoddnumber(10)  ## Call the function with a number in the place of "input_number"



## Sometimes we might need to define a function with several arguments. For example:

new_function <- function(a, b, c) {  ## Three arguments: a, b, c
  result <- a * b + c
  print(result)
}

## The arguments to a function call can be supplied in the same sequence as defined in the function
## or they can be supplied in a different sequence but assigned to the names of the arguments:

## 1. Call the function by position of arguments

new_function(1, 2, 3)

## 2. Call the function by names of the arguments

new_function(a = 1, b = 2, c = 3)
new_function(c = 3, b = 2, a = 1)  ## the order of the arguments doesn't matter if their names are specified


######## Function with Default Argument ########

## We can pre-define the value of the arguments in the function definition (i.e., assigning default values),
## and call the function without supplying any argument to get the default result.
## 
## But we can also call such functions by supplying new values of the argument and get non-default result.

new_function <- function(a = 3, b = 6) {
  result <- a * b
  print(result)
}

# Call the function without giving any argument (using the default values)

new_function()

# Call the function using new values for the arguments

new_function(5, 9)



######## Lazy Evaluation of Function ########

## Arguments to functions are evaluated lazily, which means
## they are evaluated only when needed by the function body.

new_function <- function(a, b) {
  result <- a^2
  print(result)
}

new_function(6)  ## We can call the function without supplying one of the arguments (i.e., b)



## If we modify the above function slightly:

new_function <- function(a, b) {
  result <- a^2
  print(result)
  print(b)       ## We also want to print the value of "b"
}

new_function(6)  ## This shows lazy evaluation at work, but does eventually result in an error
                 ## Therefore, make sure that you have given values to all the necessary arguments when calling a function.



######## Function without an Argument ########

## We can also create a function which takes NO arguments

new_function <- function() {  ## Create a function without an argument
    print("Hello world!")
}

new_function()  ## Call the function without supplying an argument.



######## Function with Return Values ########

## The value of the last executed statement will be returned as the "return value" of the function.
## We can also return a value back to the caller by explicitly calling return().
##
## Our findoddnumber() function returns all the odd positive numbers which are less than the "input_number".
## The "result" at the bottom of the function is the "last executed statement", so it is the return value.

findoddnumber <- function(input_number) {
  counter <- 0
  result <- c()
  while (counter < input_number) {
    if (counter %% 2 != 0) {  ## "!" is the negation operator ("!=" means "not equal to")
      result <- c(result, counter)
    }
    counter <- counter + 1
  }
  result  ## This is the last executed statement, so "result" is the return value of this function.
}

findoddnumber(10)

## We can also explicitly call "return()" to return the result:

findoddnumber <- function(input_number) {
  counter <- 0
  result <- c()
  while (counter < input_number) {
    if (counter %% 2 != 0) {  ## "!" is the negation operator ("!=" means "not equal to")
      result <- c(result, counter)
    }
    counter <- counter + 1
  }
  return(result)  ## we return a value back to the caller by explicitly calling return()
}

findoddnumber(10)



######## Exercise ########

## Please write a function which plots the scatter points for two vectors.
##
## Test your function with airquality_na_omit$Ozone and airquality_na_omit$Wind.
## What does your plot tell you about their relationship?

myplot <- function(x, y, ...){
  plot(x,y,...)
}

myplot(airquality_na_omit$Ozone, airquality_na_omit$Wind, col = "red", xlab = "Ozone", ylab = "Wind")