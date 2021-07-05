######## Lecture 13 - Unsupervised Learning - K-Means Clustering with R ########

## To perform a cluster analysis in R, generally, the data should be first prepared as follows:
##
##  - Rows are observations and columns are variables (or in ML language, features)
##  - Any missing value in the data must be removed or estimated (in this course, we remove all missing values)
##  - Check if the data should be standardized (i.e., scaled) to make variables comparable.
##    Recall that, standardization (if using the z-score) consists of transforming the variables such that
##    they have mean zero and standard deviation one.
##
## Common steps in K-means clustering analysis:
##
##  - Indicate the number of clusters (K) that will be generated
##  - Compute k-means clustering
##
## Determining optimal number of clusters:
##
## Since we must specify the number of clusters before we started the algorithm,
## it is necessary to use several different values of K and examine their results.
## Two of the most popular methods for determining the optimal clusters are:
##
##  - Elbow method
##  - Silhouette method



######## Example 1 ########

## Here, we'll re-use the built-in R data set "USArrests", which contains statistics in arrests
## per 100,000 residents for assault, murder, and rape in each of the 50 US states in 1973.
## It includes also the percent of the population living in urban areas.



## Data Preparation

## Let's check the structure of "USArrests" first, the following are the functions we can use:

class(USArrests)
str(USArrests)
dim(USArrests)
fix(USArrests)

## To check if there's any missing value, we can use this:

is.na(USArrests)                 ## The is.na() function indicates which elements are missing.
                                 ## It will return a data frame of the same size as "USArrests" where every entry
                                 ## is TRUE for a missing value or FALSE otherwise.

any(is.na(USArrests))            ## To quickly check if any of the results are TRUE we use the any() function.

apply(is.na(USArrests), 1, sum)  ## Here's another way, if there's any "1" in the output,
                                 ## the corresponding state has missing value.

## To remove any missing value that might be present in the data, type this:

na.omit(USArrests)  ## na.omit() returns the object with incomplete cases (observations/rows) removed

## Since "USArrests" does not contain missing value, the above operation is not needed.

## Since the "UrbanPop" variable is a percantage, while the other variables are frequencies per 100,000 people,
## we need to scale/standardize the data. To do this, we use the scale() function:

USArrests_scaled <- scale(USArrests)  ## For each column, we subtract the mean of all data points from each individual data point,
                                      ## then divide those points by the standard deviation of all points
                                      ## (i.e., we create z-scores from each variable).

head(USArrests_scaled)  ## Now all the columns have the same scale



## K-Means Clustering with R

## We can compute k-means in R with the kmeans() function.
##
## The basic format of kmeans() function is as follow:
##
##  kmeans(x, centers, iter.max = 10, nstart = 1)
##
##   - "x" is a numeric matrix of data (e.g., the scaled distance matrix)
##   - "centers" is the number of clusters (i.e., K)
##   - "iter.max" is the maximum number of iterations allowed, 10 is the default value
##   - "nstart" is the number of randomly selected sets of K observations chosen as the initial centroids.
##     The default value of "nstart" is 1, but it makes sense to select more initial configurations.
##     For example, it is often recommended to set "nstart = 25".

## To start with, we will group the data into two clusters (K = 2):

## As k-means clustering algorithm starts with k randomly selected centroids,
## it's always recommended to use the set.seed() function in order to set a seed for R's random number generator.
## The aim is to make the results reproducible, so that we will obtain exactly the same results as those shown below.

set.seed(123)  ## The set.seed()function in R takes an (arbitrary) integer argument.
               ## So we can take any argument, say, 1 or 123 or 12345 to get the reproducible random numbers.
               ## You have to set seed every time you want to get a reproducible random result.

## As the final result of k-means clustering result is sensitive to the random initial centroids assignments,
## we specify nstart = 25. This means that R will try 25 different random starting centroids assignments
## and then select the best results corresponding to the one with the lowest "total within-cluster sum of square".

k2 <- kmeans(USArrests_scaled, centers = 2, nstart = 25)

k2  ## If we print the results we'll see that our groupings resulted in 2 cluster sizes of 30 and 20.
    ## We also see the centroids (cluster means) for the two clusters.
    ## We also get the cluster assignment for each observation.

## The output of kmeans() is a list with several components. The most important being:

str(k2)

k2$cluster  ## "cluster" is a vector of integers indicating the cluster to which each observation is allocated

k2$centers  ## "centers" indicates the centroids of each cluster

k2$withinss  ## "withinss" is a vector of "within-cluster sum of squares", one component per cluster

k2$tot.withinss  ## "tot.withinss" stands for "total within-cluster sum of square" (a.k.a "total within-cluster variation").
                 ## That is, "tot.withinss" = sum("withinss")
                 ## This is a very useful index, we will talk more about it in our following work.



## Determining optimal number of clusters:

## Recall that the number of clusters (i.e., K) must be set before we start the algorithm,
## It is often advantageous to use several different values of k and examine the differences in the results.
## We can execute the same process for 3, 4, and 5 clusters:

k3 <- kmeans(USArrests_scaled, centers = 3, nstart = 25)
k4 <- kmeans(USArrests_scaled, centers = 4, nstart = 25)
k5 <- kmeans(USArrests_scaled, centers = 5, nstart = 25)



## Method 1: Elbow Method

## Recall that "total within-cluster sum of square (Total WSS)" (or "total within-cluster variation")
## measures the compactness of the clustering and we want it to be as small as possible.
## 
## In order to determine the optimal number of clusters (i.e., K), we can compare
## the total within-cluster sum of square given by different K.

k2$tot.withinss
k3$tot.withinss
k4$tot.withinss
k5$tot.withinss

## As can be seen, the larger the K, the smaller the total within-cluster sum of square (Total WSS).
## However, we don't want to have a very large number of clusters (i.e., a very big K).
## Thus, we can use the following algorithm to define the optimal clusters:
##
##  - Compute K-means clustering for different values of K. For instance, by varying K from 2 to 10.
##  - For each K, calculate the total within-cluster sum of square (Total WSS).
##  - Plot the curve of Total WSS according to the number of clusters K.
##  - The location of a bend (like an elbow) in the plot is considered as
##    an indicator of the appropriate number of clusters K.

wss <- function(k, data) {
  kmeans(data, k, nstart = 25)$tot.withinss
}

set.seed(123)  ## You have to set seed every time you want to get a reproducible random result.
wss_USArrest <- sapply(2:10, wss, data = USArrests_scaled)  ## We check the Total WSS for K = 2,...,10
wss_USArrest

plot(2:10, wss_USArrest,
     type = "b",  ## Points with line connection
     pch = 19,    ## solid circle
     frame = FALSE,
     xlab = "Number of clusters K",
     ylab = "Total within-clusters sum of squares")

## The elbow method suggests the 4-cluster solution (i.e., the elbow is at K = 4).



## Method 2: Average Silhouette Method

## In short, the average silhouette approach measures the quality of a clustering.
## A high average silhouette width indicates a good clustering.
##
## First, we apply kmeans() function to "USArrests_scaled" using different K (e.g., 2 to 10).
## For each K, we need to calculate the silhouette coefficient (or silhouette width) for each observation.
##
## Here, we can use the silouette() function in the "cluster" package.
## Let's first install and load the "cluster" package.

install.packages("cluster")
library("cluster")

## The basic format of silhouette() function is as follow:
##
##  silhouette(x, dist)
##
##   - "x" is the "cluster" value given by the kmeans() function, which is a vector of integers (1 to K)
##     indicating the cluster to which each observation belongs.
##   - "dist" is the distance matrix.

## For example, to calculate the sulhouette() coefficient of each observation when K = 2, we write

k2 <- kmeans(USArrests_scaled, centers = 2, nstart = 25)
d <- dist(USArrests_scaled, method = "euclidean")

silhouette(k2$cluster, d)  ## Note that the first argument is given "k2$cluster", the "cluster" value of kmeans()

## The average silhouette method computes the average silhouette of all observations
## for different values of K. The optimal number of clusters K is the one that maximizes
## the average silhouette over a range of possible values for K.

avg.sil <- function(k, data) {                   ## I usually use "." in naming a function
  kmeans_result <- kmeans(data, k, nstart = 25)  ## and in naming a varialbe, I always use "_"
  silhouette_coefficient <- silhouette(kmeans_result$cluster, dist(data))
  mean(silhouette_coefficient[, 3])
}

set.seed(123)
average_silhouette <- sapply(2:10, avg.sil, data = USArrests_scaled)
average_silhouette

plot(2:10, average_silhouette,
     type = "b",  ## Points with line connection
     pch = 19,    ## solid circle
     frame = FALSE,
     xlab = "Number of clusters K",
     ylab = "Average Silhouette")

## The average silhouette method suggests the 2-cluster solution,
## while 4-cluster solution comes in as the second optimal one.



######## Example 3 ########

## In this example, we'll apply the K-means clustering to the "cars" data.
## The data is stored in "cars.tab", which is a tab-delimited values file. 
## A tab-delimited values file is a simple text format for storing data in a tabular structure, e.g. spreadsheet data.
## Here, we use read.delim() to read it into R:

cars <- read.delim("cars.tab", header = TRUE, stringsAsFactors = FALSE)

str(cars)
head(cars)

## You might have noticed that the first column is just the country where each car is from.
## Instead, We would want to give each row a name corresponding to the car name,
## which would make our following analysis way easier.
## 
## For example, let's compare the first column of "cars" with "USArrests"

head(USArrests)  ## The first column is the name of each state

fix(USArrests)  ## In fact, this first column is a "row.names" column,
                ## and R will NOT try to perform calculations on the row names.

## Let's give a name for each row of the "cars" data.
## Let's name each row after the corresponding car's name.

row.names(cars) <- cars[, 2]

fix(cars)

## Note that another column now appears before the "Country" variable.
## However, this is not a data column but rather the name that R is giving to each row.

## However, we still need to eliminate the second column in the data where the car names are stored.

cars <- cars[, -2]

head(cars)  ## Let's see what the data frame "cars" looks like now.

## Check if there's any missing value:

any(is.na(cars))
apply(is.na(cars), 1, sum)

## We don't need the "Country" variable, since it is not numeric.

cars_use <- cars[, -1]

head(cars_use)

## Your own code starts from here:

cars_scaled <- scale(cars_use)
head(cars_scaled)
set.seed(123)
c2 <- kmeans(cars_scaled, centers = 2, nstart = 25)
c2
str(c2)

c2$cluster
c2$centers
c2$withinss
c2$tot.withinss
c3 <- kmeans(cars_scaled, centers = 3, nstart = 25)
c4 <- kmeans(cars_scaled, centers = 4, nstart = 25)
c5 <- kmeans(cars_scaled, centers = 5, nstart = 25)
c2$tot.withinss
c3$tot.withinss
c4$tot.withinss
c5$tot.withinss
cars.wss <- function(c, data) {
  kmeans(data, c, nstart = 25)$tot.withinss
}
set.seed(123)
wss_cars <- sapply(2:10, cars.wss, data = cars_scaled)  ## We check the Total WSS for K = 2,...,10
wss_cars
plot(2:10, wss_cars,
     type = "b",  ## Points with line connection
     pch = 19,    ## solid circle
     frame = FALSE,
     xlab = "Number of clusters K",
     ylab = "Total within-clusters sum of squares")



c2 <- kmeans(cars_scaled, centers = 2, nstart = 25)
dis <- dist(cars_scaled, method = "euclidean")
silhouette(c2$cluster, dis)
avg_cars.sil <- function(c, data) {
  kmeans_result <- kmeans(data, c, nstart = 25)
  silhouette_coefficient <- silhouette(kmeans_result$cluster, dist(data))
  mean(silhouette_coefficient[, 3])
}
set.seed(123)
average_cars_silhouette <- sapply(2:10, avg_cars.sil, data = cars_scaled)
average_cars_silhouette
plot(2:10, average_cars_silhouette,
     type = "b",  ## Points with line connection
     pch = 19,    ## solid circle
     frame = FALSE,
     xlab = "Number of clusters K",
     ylab = "Average Silhouette")

######## Example 2 ########

## Here, please apply K-means analysis to the example discussed in yesterday's lecture.
## The dataset we used yesterday is as follows:

x <- c(1, 1.5, 3, 5.5, 3.5, 4.5, 3.5)
y <- c(1, 2, 4, 7, 5, 5, 4.5)
data <- cbind(x, y)
row.names(data) <- 1:7
data

## You own code starts from here:
dat_scaled <- scale(data)
head(dat_scaled)
set.seed(123)
d2 <- kmeans(dat_scaled, centers = 2, nstart = 25)
d3 <- kmeans(dat_scaled, centers = 3, nstart = 25)
d4 <- kmeans(dat_scaled, centers = 4, nstart = 25)
d5 <- kmeans(dat_scaled, centers = 5, nstart = 25)
dat.wss <- function(c, data) {
  kmeans(data, c, nstart = 25)$tot.withinss
}
set.seed(123)
wss_dat <- sapply(2:5, dat.wss, data = dat_scaled)
wss_dat
plot(2:5, wss_dat,
     type = "b",  
     pch = 19,    
     frame = FALSE,
     xlab = "Number of clusters K",
     ylab = "Total within-clusters sum of squares")



d2 <- kmeans(dat_scaled, centers = 2, nstart = 25)
dis <- dist(dat_scaled, method = "euclidean")
silhouette(d2$cluster, dis)
avg_data.sil <- function(c, data) {
  kmeans_result <- kmeans(data, c, nstart = 25)
  silhouette_coefficient <- silhouette(kmeans_result$cluster, dist(data))
  mean(silhouette_coefficient[, 3])
}
set.seed(123)
average_dat_silhouette <- sapply(2:6, avg_data.sil, data = dat_scaled)
average_dat_silhouette
plot(2:6, average_dat_silhouette,
     type = "b",  ## Points with line connection
     pch = 19,    ## solid circle
     frame = FALSE,
     xlab = "Number of clusters K",
     ylab = "Average Silhouette")

