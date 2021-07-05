######## Lecture 14 ########

## So far, we have discussed two clustering methods:
##
##  - K-Means Clustering
##  - Hierarchical Clustering
##
## Whichever method we choose to use, there is always one fundamental question:
##
##   How to choose the right number of expected clusters (i.e., K)?
##
## Unfortunately, there is NO definitive answer to this question.
## The optimal clustering is somehow subjective and depends on the clustering method chosen,
## and the method used for measuring similarities (e.g., the linkages available in hierarchical clustering).

## Last week, we discussed the following two methods for determining the optimal number of clusters:
##
##  - Elbow Method (comparing the Total Within-Cluster Sum of Squares for each K)
##  - Average Silhouette Method (comparing the average silhouette coefficient of all observations for each K)
##
## In addition to the above methods, there are more than 20 other indices and methods that have been published
## for identifying the optimal number of clusters.
##
## Today, we will provide the R codes for computing all these indices and select the optimal number of clusters
## using the "majority rule". In addition, we will apply both clustering methods (i.e., K-Means and Hierarchical)
## to the same datasets and compare their results.



######## Example 1: Wholesale	customer data ########

## Wholesale Customer	dataset	contains data	about	clients	of a wholesale distributor.
## It includes the annual	spending in	monetary units on	diverse	product	categories.
## The information of each product category could be found here:
##
##   https://archive.ics.uci.edu/ml/datasets/Wholesale+customers
##
## Our task is to cluster the customers.

customers <- read.csv("customers data.csv", header = TRUE)  ## I've removed outliers from "customers data.csv"



## Preparing the Data

## We	will first check if there are	observations with	missing	values:

any(is.na(customers))

which(complete.cases(customers) == FALSE)  ## There are no missing values.

## Before we can perform the clustering analysis, please consider the following issue first:
##
## Whichever clustering method we are going to use, it will calculate the Euclidean distance
## between observations. This means:
##
##   All variables must be continuous/numeric, and NOT categorical.
##
## Why? Think about this: is "fish" Euclideanly closer to "bird" than "dog"?
## The answer is "No", because we can't measure the Euclidean distances between animals.
## In other words, it is conceptually difficult to measure the dissimilarity between categorical values.
##
## Therefore,We will only use the numerical variables for clustering (i.e., customers[, 3:8])

str(customers)  ## The first two variables "Channel" and "Region" are categorical
                ## For example, if Channel = 1, the corresponding customer is Horeca (Hotel/Restaurant/Cafe);
                ## if Channel = 2, the corresponding customer is Retail.

customers_use <- customers[, 3:8]  ## We only cluster the numeric variables.

## Next question: Is scaling necessary?

summary(customers_use)  ## We don't want to give variables which have larger magnitudes more importance,
                        ## so scaling is necessary.

customers_use_scaled <- scale(customers_use)



## Determine the optimal number of clusters using K-Means

## Method 1: Elbow Method

wss <- function(k, data) {  ## wss() calculates the "Total Within-Cluster Sum of Squares" for each K
  kmeans(data, k, iter.max = 20, nstart = 100)$tot.withinss  ## We have a rather big dataset, so I set iter.max = 20
}                                                            ## and set nstart = 100

set.seed(123)  ## You have to set seed every time you want to get a reproducible random result.
customers_wss <- sapply(2:10, wss, data = customers_use_scaled)  ## We check the Total WSS for K = 2,...,10

plot(2:10, customers_wss,  ## We plot the "Total WSS" for each K
     type = "b",  ## Points with line connection
     pch = 19,    ## solid circle
     frame = FALSE,
     xlab = "Number of clusters K",
     ylab = "Total within-clusters sum of squares")

## Method 2: Average Silhouette Method

library("cluster")

avg.sil <- function(k, data) {                   ## I usually use "." in naming a function
  kmeans_result <- kmeans(data, k, iter.max = 20, nstart = 100)  ## and in naming a varialbe, I always use "_"
  silhouette_coefficient <- silhouette(kmeans_result$cluster, dist(data))
  mean(silhouette_coefficient[, 3])
}

set.seed(123)
customers_average_silhouette <- sapply(2:10, avg.sil, data = customers_use_scaled)

plot(2:10, customers_average_silhouette,
     type = "b",  ## Points with line connection
     pch = 19,    ## solid circle
     frame = FALSE,
     xlab = "Number of clusters K",
     ylab = "Average Silhouette")

## More methods: NbClust()
##
## The NbClust package in R uses more than 20 different indices (mostly distance measures)
## to indicate the number of clusters required.

install.packages("NbClust")
library("NbClust")

set.seed(123)
NbClust(customers_use_scaled, distance = "euclidean", min.nc = 2, max.nc = 10, method = "kmeans")

par(mfrow = c(1, 1))

## According to the "majority rule", the best number of clusters is 3.

## Interpret the Clusters (K = 3):

set.seed(123)
customers_k3 <- kmeans(customers_use_scaled, 3, iter.max = 20, nstart = 100)

customers_use$k3 <- customers_k3$cluster  ## We add a new column "k3" to the data which indicates
                                          ## to which cluster each customer belong.

aggregate(customers_use, list(customers_use$k3), mean)  ## Let's check the mean value of each variable in each cluster




## Determine the optimal number of clusters using Hierarchical Clustering

d <- dist(customers_use_scaled, method = "euclidean")  ## Calculate the distance matrix between observations

customers_hcl_complete <- hclust(d, method = "complete")   ## cluster with "single" linkage
customers_hcl_single <- hclust(d, method = "single")     ## cluster with "single" linkage
customers_hcl_average <- hclust(d, method = "average")   ## cluster with "average" linkage
customers_hcl_ward <- hclust(d, method = "ward.D2")      ## cluster with "ward" linkage

par(mfrow = c(2, 2))

plot(customers_hcl_complete, cex = 0.8, hang = -1, main = "Hierarchical Clustering with Complete Linkage")
plot(customers_hcl_single, cex = 0.8, hang = -1, main = "Hierarchical Clustering with Single Linkage")
plot(customers_hcl_average, cex = 0.8, hang = -1, main = "Hierarchical Clustering with Average Linkage")
plot(customers_hcl_ward, cex = 0.8, hang = -1, main = "Hierarchical Clustering with Ward Linkage")

par(mfrow = c(1, 1))

## We can use NbClust() to determine the optimal number of clusters for Hierarchical Clustering
## Note that in calling the function, we need to set "method" to be one of the linkage methods.

NbClust(customers_use_scaled, distance = "euclidean", min.nc = 2, max.nc = 10, method = "ward.D2")

par(mfrow = c(1, 1))

## According to the "majority rule", the best number of clusters is 2 or 6 using "ward.D2" linkage.

## We can draw on the dendrogram a rectangle around each of the 2 or 6 clusters.

plot(customers_hcl_ward, cex = 0.8, hang = -1, main = "Hierarchical Clustering with Ward.D2 Linkage")

rect.hclust(customers_hcl_ward, k = 2, border = 2:7)
rect.hclust(customers_hcl_ward, k = 6, border = 2:7)

## Interpret the Clusters (K = 2 & K = 6):

customers_hcl_ward_w2 <- cutree(customers_hcl_ward, 2)  ## We first split the "customers_hcl_ward" into 2 clustres
customers_hcl_ward_w6 <- cutree(customers_hcl_ward, 6)  ## and then 6 clustres

str(customers_hcl_ward_w2)  ## Recall that the output of cutree() is simply the cluster number for each observation
str(customers_hcl_ward_w6)  

table(customers_hcl_ward_w2)  ## Number of observations in each cluster
table(customers_hcl_ward_w6)

customers_use$w2 <- customers_hcl_ward_w2  ## We add new columns "w2" and "w6" to the data which indicates
customers_use$w6 <- customers_hcl_ward_w6  ## to which cluster each customer belongs in each clustering solution.

## Again, let's check the mean value of each variable in each cluster

aggregate(customers_use[, -7], list(customers_use$w2), mean)
aggregate(customers_use[, -7], list(customers_use$w6), mean)

## It may also be useful to add the numbers of observations in each cluster to the above display.

cbind(aggregate(customers_use[, -7], list(customers_use$w2), mean), Freq = as.vector(table(customers_hcl_ward_w2)))
cbind(aggregate(customers_use[, -7], list(customers_use$w6), mean), Freq = as.vector(table(customers_hcl_ward_w6)))

 

######## Example 2: iris ########

## Here, we will use the famous "iris" data which comes with RStudio.
## This is perhaps the best known database to be found in the pattern recognition literature.
##
## The dataset consists of 150 observations with 4 variables: Sepal Length, Sepal Width, Petal Length and Petal Width.
## The entire dataset has three different species of Setosa, Versicolor and Virginica with 50 samples each.
## 
## The "iris" data was introduced by the British statistician and biologist Ronald Fisher in his 1936 paper.
## The dataset was used to distinguish the species from each other.

str(iris)

## Note that in the "iris" data, the correct species for each observation has already been given
## in the fifth variable "Species".
## 
## But, let's first pretend that we didn't know the correct "Species" or the correct number of clusters.
## That is, we will drop the varable "Species", perform the cluster analysis,
## and then see if we can recover the known "Species" and number of clusters.

iris_use <- iris[, -5]  ## drop the varable "Species"

## Your code starts from here:






## Now, set K = 3 which is equal to the number of clusters in the original data.
## Then compare your clustering solution with the original data which has 3 classes.
## Can you find three clusters which are very similar to the original 3 classes:
## 
##  - "setosa"
##  - "versicolor"
##  - "virginica"



######## Example 3: Users knowledge modeling data ########

## Here, we use the "users knowledge modeling data.csv".
## It is the real dataset about the students' knowledge status about the subject of Electrical DC Machines.
## The dataset had been obtained from a Ph.D. Thesis.

## The variable information is given as follows:
##
##  - STG: The degree of study time for goal object materials
##  - SCG: The degree of repetition number of user for goal object materials
##  - STR: The degree of study time of user for related objects with goal object
##  - LPR: The exam performance of user for related objects with goal object
##  - PEG: The exam performance of user for goal objects
##  - UNS: The knowledge level of user (output)

## Before we perform clustering analysis on the dataset. I want to talk a bit more about importing data into R.
## If we are given a complex dataset, it's very often that we fail to get the number of columns we expect.
## For example, let's reuse the read.csv() function to read in the "users knowledge modeling data.csv"

students <- read.csv("users knowledge modeling data.csv", header = TRUE)

## We got a error message, even though the data was stored in a rather rigid format.

## IMPORTANT: This is a "separator" problem!
## 
## In many countries this is not an issue, but the Swedish (Finnish also?) standard is using a comma as decimal separator,
## while R uses a decimal point (i.e., a fullstop). This means if you export a comma separated value file on a Swedish computer,
## you are very likely to get numbers with commas as decimal separators and semicolons as field separators.
## To verify this, try opening the file with a Notepad.
##
## What we need is read.csv2( ), which is made for semicolon separated files with decimal commas.

students <- read.csv2("users knowledge modeling data.csv", header = TRUE)

str(students)  ## check the format of the numeric variables
