######## Operations on R Objects - Part 2 ########

## In this lecture we will discuss some useful operations
## on lists, data frames and factors



######## Operations on Lists - lapply() Function ########

## The function lapply() (for (l)ist apply) works like the matrix apply() function,
## it applies the user-specified function on each component of a list or vector
## and returns another LIST.

## This is the general form of lapply():
##
##   lapply(X, FUN, ...)
##
## - "X" is a list or a vector
## - "FUN" is the user-specified function you want to use
## - "..." is optional arguments to "FUN"

## Example:

apply(X = list(1:3,25:29), MARGIN = 2, FUN = mean)   ## We want to find the mean for each vector of a list
                                                     ## This won't work.

lapply(X = list(1:3,25:29), FUN = mean)  ## note that it also returns a list of length 2
                                         ## also note that it is capital "X"

lapply(list(1:3,25:29), mean)            ## you don't need tp specify "X" or "FUN"

## Example:

cities <- c("New York", "London", "Cape Town")

apply(cities, 1, nchar)  ## nchar() takes a character vector as an argument
                         ## and returns a vector whose elements contain the
                         ## sizes of the corresponding elements of the input vector.
                         ## However, this won't work.

lapply(cities, nchar)    ## Since we use "lapply", the output is a list.



######## Operations on Lists - sapply() Function ########

## The list returned by lapply() could be simplified to a vector or matrix.
## This is exactly what sapply() (for (s)implified [l]apply) does.
## That is, sapply() is a user-friendly version of lapply().

## This is the general form of sapply():
##
##   sapply(X, FUN, ..., simplify = TRUE, USE.NAMES = TRUE)
##
## - "X" is a list or a vector
## - "FUN" is the user-specified function you want to use
## - "..." is optional arguments to "FUN"
## - "simplify", if set to be "TRUE" (default value), returns a vector or matrix if appropriate
## - "USE.NAMES", if set to be "TRUE" (default value) and if X is character,
##   use X as names for the result.

## Example:

sapply(list(1:3,25:29), mean)  ## note that it returns a vector of length 2

cities
sapply(cities, nchar)  ## since "cities" is a character vector, the elements of "cities"
                       ## are used as the names for the result.
                       ## Also note that the output is a vector instead of a list as with "lapply".



######## Exercise ########

## The following is a list of temperature measurements for 5 days.
## Please find the minimum temperature for each day and return the result as a list.
## Please also return the result as a vector.

temp <- list(
  Day1 = c(3, 7, 9, 6, -1),  ## temperatures for day 1
  Day2 = c(6, 9, 12, 13, 5), ## temperatures for day 2
  Day3 = c(4, 8, 3, -1, -3), ## temperatures for day 3
  Day4 = c(1, 4, 7, 2, -2),  ## temperatures for day 4
  Day5 = c(5, 7, 9, 4, 2)    ## temperatures for day 5
)

lapply(temp, min)
sapply(temp, min)

######## Exercise ######## 

## Throughout this exercise, we'll use the Flags dataset from the UCI Machine Learning Repository.
## This dataset ("FlagData.txt") contains details of various nations and their flags.
## More information may be found here: http://archive.ics.uci.edu/ml/datasets/Flags

## 1. Please read in "FlagData.txt" and check its structure and its dimensions.

flags <- read.csv("FlagData.txt", header = TRUE)
str(flags)
dim(flags)

## 2. As with any dataset, we'd like to know in what format the variables have been stored.
##    We can check their format with the class() function.

class(flags)
class(flags[,1])

## 3. The previous step only tells us that the entire dataset is stored as a "data.frame",
##    which doesn't answer our question. What we really need is to call the class() function
##    on each individual variable. Since a data frame is really just a list of vectors,
##    we can use lapply() to do so. Please save the result in "class_list".

class_list <- lapply(flags, class)
class_list
str(class_list)

## 4. Recall that lists are most helpful for storing multiple classes of data structure.
##    In this case, since every element of the list returned by lapply() is a character vector of
##    length one (i.e. "factor" or "numeric"), "class_list" can be simplified to a character vector
##    and sapply() is created for this purpose. Try it yourself.

class_vector <- sapply(flags, class)
class_vector
str(class_vector)

## 5. Note that variables 11 through 17 of our dataset are indicator variables, each representing a
##    different color. The value of the indicator variable is 1 if the color is present in
##    a country's flag and 0 otherwise. Please find for each color the total number of countries
##    in our dataset that has it on their flags. Can the result also be simplified to a vector?

head(flags[,11:17])
lapply(flags[,11:17], sum)
sapply(flags[,11:17], sum)

## 6. In the examples we've looked at so far, sapply() has been able to simplify the result
##    to vector. That's because each element of the list returned by lapply() was a vector
##    of length one. Recall that sapply() instead returns a matrix when each element of the
##    list returned by lapply() is a vector of the same length (> 1).
##    
##    To illustrate this, let's extract columns 19 through 23 from the flags dataset.
##    Each of these columns (i.e., variables) represents the number of times a particular
##    shape or design appears on a country's flag. We are interested in the minimum and
##    maximum number of times each shape or design appears. How can we find them?
##
##    Hint: range()

head(flags[,19:23])
lapply(flags[,19:23], range)
sapply(flags[,19:23], range)
class(sapply(flags[,19:23], range))

## 7. As we've seen, sapply() always attempts to simplify the result given by lapply().
##    It has been successful in doing so for each of the examples we've looked at so far.
##    Let's look at an example where sapply() can't figure out how to simplify the result
##    and thus returns a list, no different from lapply().
##
##    When given a vector, the unique() function returns a vector with all duplicate elements
##    removed. In other words, unique() returns a vector of only the "unique" elements.
##    To see how it works, try this first:
##
##                       unique(c(3, 4, 5, 5, 5, 6, 6)).
##    
##    We want to know the unique values for each variable in the flags dataset by using unique().
##    Compare the results given by lapply() and sapply(). Are they different or not?
##
##    The fact that the elements of the result are all vectors of different length
##    poses a problem for sapply(), since there's no obvious way of simplifying the result.
unique(c(3, 4, 5, 5, 5, 6, 6))
lapply(flags, unique)
str(lapply(flags, unique))

sapply(flags, unique)
str(sapply(flags, unique))

######## Matrix-Like Operations on Data Frames ########

## Filtering

## Filtering can be done with data frames, just as with matrices.

examsquiz <- read.csv("ExamsQuiz.txt", header = TRUE)
head(examsquiz)

examsquiz$final_exam >= 3              ## Identify which student got at least 3 in "final_exam", return a vector
examsquiz[, 1, drop = FALSE] >= 3      ## Identify which student got at least 3 in "final_exam", return a data frame
examsquiz[examsquiz$final_exam >= 3,]  ## Return the students' records who got at least 3 in "final_exam"

## Filtering a data frame can also be done with the subset() function.

subset(examsquiz, final_exam >= 3)  ## Note that you don't need "examsquiz" before the variable's name


## The rbind() and cbind() functions
                                                         
## The rbind() and cbind() matrix functions introduced for matrics work with
## data frames, too, providing that you have compatible sizes.

## We can use rbind() to add a row (i.e., a new record):

newrecord <- c(3, 3.7, 4)    ## A new record for the "examsquiz"
rbind(examsquiz, newrecord)  ## Add the "newrecord" as a row to the bottom of "examsquiz"
                             ## IMPORTANT: Has "examsquiz" been modified? (original data set doesnt change)

## You can also create new columns of a data frame from old ones and add it to the data frame:

cbind(examsquiz, hwquizdiff = examsquiz$homework - examsquiz$quiz)  ## we want to study the difference
                                                                    ## between "homework" and "quiz"
                                                                    ## IMPORTANT: Has "examsquiz" been modified?
                                                                    ##            Has "hwquizdiff" been created?

examsquiz

examsquiz$hwquizdiff <- examsquiz$homework - examsquiz$quiz  
examsquiz                                                    ## IMPORTANT: Has "examsquiz" been modified now?
                                                             ##            Has "hwquizdiff" been added to the data frame?
examsquiz$hwquizdiff <- examsquiz$homework - examsquiz$quiz  



## The apply(), lapply() and sapply() functions

## You can use apply() on data frames, if the columns are all of the same type (why?)

apply(examsquiz[,1:3], 1, max)  ## What operation does this command perform?

## Now, please do the follow:
##
##  - Find the average of "final_exam", "quiz" and "homework" for each student.
##  - Find the maximum grade for each test.

apply(examsquiz[,1:3], 1, mean)
apply(examsquiz[,1:3], 2, max)

## Keep in mind that data frames are special cases of lists, with the list components
## consisting of the data frame's columns. Thus, if you call lapply() (or sapply()) on a
## data frame with a specified function f(), then f() will be called on each of
## the data frame's columns, with the return values placed in a list (or vector/matrix).

## For example, by using lapply(), we can also solve the above task: find the maximum grade for each test.
lapply(examsquiz[,1:3], max)
lapply(examsquiz[,1:3], min)
sapply(examsquiz[,1:3], min)



######## Common Functions Used with Factors ########

## Recall that factors are used to represent categorical (i.e., nominal or ordinal) data.
## For factors, we have a member of the family of apply() functions, tapply().
## We'll look at that function, as well as other function commonly used with factors: split(), aggregate().



## The tapply() function

## As a data analyst, you'll often wish to split your data into groups based on the
## value of some categorical variable, then apply a function to the members of each group.
## The next function we'll look at, tapply(), does exactly that.
##
## As motivation, suppose we have the following data:
##    
##  - a vector "ages" which has the ages of several voters
##   
              ages <- c(25,26,55,37,21,42)
##
##  - a factor "affils" showing the non-numeric/categorical trait of each corresponding voter,
##    that is their party affiliation (Democrat, Republican, Unaffiliated)
##
              affils <- c("R","D","D","R","U","D")
##
## We might wish to find the average age of voters within each of the party groups.
## For this purpose, we need to use tapply().
##
## In typical usage, the call tapply(X, INDEX, FUN) are defined as follows:
## 
##  - X is a vector
##  - INDEX is a factor or a list of factors
##  - FUN is the function to be applied
##
## X will be assigned the ages of all voters (i.e., "ages"),
## INDEX will be assigned the party affiliation for each voter (i.e., "affils"),
## and FUN in our example above would be mean().
##                
## Intuitively, factor "affils" must have the same length as "ages".

ages <- c(25,26,55,37,21,42)          ## This is X
affils <- c("R","D","D","R","U","D")  ## This is INDEX
tapply(ages, affils, mean)            ## mean() is FUN

## Let's look at what happened:
## 
##  - X (ages) is first (temporarily) split into groups, each group corresponding to a level of the factor INDEX (affils),
##    that is, (1,4) for "R", (2,3,6) for "D", and (5) for "U".
##  - then FUN (mean) is applied to the resulting subgroups (subvectors) of X.

## Question: If the gender of each voter is given as follows,
##           what's the mean age for male and female voters, respectively?
##   
    gender <- c("M","M","F","M","F","M")
    tapply(ages, gender, mean)
class(tapply(ages, gender, mean))    
## What if we have two or more factors, that is, INDEX is a list of factors?

tapply(ages,list(affils, gender),mean)  ## Note that INDEX needs to be a list.
class(tapply(ages,list(affils, gender),mean))

## Question: Suppose that we have the follow economic data which includes variables for gender, age, and income.
##           We want to find the mean incomes in each of the four subgroups
##
##            - Male and under 25 years old
##            - Female and under 25 years old
##            - Male and over 25 years old
##            - Female and over 25 years old
## 
   data.frame(list(gender = c("M","M","F","M","F","F"),
                   age = c(47,59,21,32,33,24),
                   income = c(55000,88000,32450,76500,123000,45650)))

tapply(ages,list(affils, gender),mean)  ## Note that INDEX needs to be a list.

##tapply(ages, gender, mean)
##oldmale <- ages >=25 & gender == "M"
##oldfemale <- ages >=25
##youngmale <- ages <=25
##youngfemale <- ages <=25

eco_data  ## Let's reuse the earlier example
eco_data$over25 <- ifelse(eco_data$age >=25, "YES", "NO")
eco_data$over25 <- eco_data$age >=25
eco_data
tapply(eco_data$income, list(eco_data$gender, eco_data$over25), mean)

## The split() function

## In contrast to tapply(), which splits a vector into groups and then applies a specified function to each group,
## split() stops at that first stage, just forming the groups.
##
## Therefore, its basic form is like split(X, INDEX), which is similar to tapply(X, INDEX, FUN) but without the "FUN".
## Another difference is that split() can take in a data frame, while tapply() can only takes a vector. 
## One last thing, split() returns a list.



split(eco_data$income, list(eco_data$gender, eco_data$over25))

## Question: We have a dataset "Abalone.txt" which was used to predict the age of abalone from 9 physical measurements.
##           More information about the dataset may be found here: https://archive.ics.uci.edu/ml/datasets/abalone
##           We simply want to find the following information:
##
##            - Divide the data into three separate data frames based on each abalone's gender.
##            - What are the indicies of all the male, female and infant abalones, respectively? (use split())

aba  <- read.csv("Abalone.txt", header = TRUE)
str(aba)
aba
split(aba, aba$Gender)  ##might not work sometimes if not defined as a list
split(aba[1:5,], aba$Gender)
split(aba, list(aba$Gender))
str(split(aba, list(aba$Gender)))
str(split(aba[1:5,], aba$Gender))

split(1:length(aba[,1]), list(aba$Gender))
str(split(1:length(aba[,1]), list(aba$Gender)))

## The aggregate() function

## With tapply(), we can apply the user-specified function to ONLY ONE vector or ONE column of a data frame,
## broken down by one or several factors.
##
## What if we want to apply a function to SEVERAL columns of a data frame broken down by some factor at the same time?
## That is, we need to find a function that can apply tapply() to each columns of the data frame at the same time.
##
## This is exactly what the aggregate() function does. It splits the data into subsets,
## applies some user-specified function to each, and returns the result in a convenient form.
## That is, the aggregate() function calls tapply() once for each variable in a group.
## 
## In typical usage, the call aggregate(X, by, FUN) are defined as follows:
## 
##  - X is a data frame
##  - by is a list of grouping elements, each as long as the variables in the data frame x
##  - FUN is the function to be applied

## For example, in the abalone data, we could find the mean of each variable, broken down by gender, as follows:

aggregate(aba[, -1], list(aba$Gender), mean)

tapply(aba[, 2], list(aba$Gender), mean)  ## The output is part of the result above
tapply(aba[, 3], list(aba$Gender), mean)  
tapply(aba[, 4], list(aba$Gender), mean)

## Question: How to find the 25%, 50% and 75% cut points for all the variables in each gender group?



######## Exercise ########

## Recall the built-in data frame in R, namely "mtcars". Let's do the following:
##
##  - Split the cars based on their engine shapes and find the average value for
##    each of the first 7 variables in each subset.
##  - Find the 25%, 50% and 75% cut points for each of the first 7 variables in each subset.