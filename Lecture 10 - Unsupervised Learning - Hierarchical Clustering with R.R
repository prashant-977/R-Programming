######## Lecture 10 - Unsupervised Learning - Hierarchical Clustering with R ########

## To perform a cluster analysis in R, generally, the data should be first prepared as follows:
##
##  - Rows are observations and columns are variables (or in ML language, features)
##  - Any missing value in the data must be removed or estimated (in this course, we remove all missing values)
##  - Check if the data should be standardized (i.e., scaled) to make variables comparable.
##    Recall that, standardization (if using the z-score) consists of transforming the variables such that
##    they have mean zero and standard deviation one.
##
## Common steps in hierarchical cluster analysis:
##
##  - Calculate the distance matrix
##  - Decide what type of linkage should be used
##  - Compute hierarchical clustering and generate dendrograms
##
## Next, we look into the dendrograms:
##
##  - Determine the number of clusters (i.e., where to cut the dendrogram)
##  - Interpret the clusters



######## Example 1 ########

## Here, we'll use the built-in R data set "USArrests", which contains statistics in arrests
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
                                      ## then divide those points by the standard deviation of all points (i.e., we create z-scores from each variable).

head(USArrests_scaled)  ## Now all the columns have the same scale

head(USArrests) ##we dont use this as the scales is not standardized-it varies too much

## Hierarchical Clustering with R

## 1. Compute the dissimilarity matrix (i.e., distance between each two observations) with dist() function:

d <- dist(USArrests_scaled, method = "euclidean")  ## Euclidean Distance is used by default

## 2. There are different functions available in R for performing hierarchical clustering,
##    the commonly used function is hclust(), whose format is hclust(d, method = ), where
##     - d is a distance matrix produced by the dist() function
##     - methods include "complete", "single", "average" and "ward.D2".

hcl_complete <- hclust(d, method = "complete") ## hclust() function uses Complete Linkage by default

str(hcl_complete)  ## The result is a list with several components.

?hclust  ## Let's check what the components stand for. The value in the definition shows the outputs meaning

row.names(USArrests)

as.data.frame(hcl_complete[1:2])  ## Let's check how the merging is performed and the corresponding height of each merge.

hcl_single <- hclust(d, method = "single")     ## cluster with "single" linkage
hcl_average <- hclust(d, method = "average")   ## cluster with "average" linkage
hcl_ward <- hclust(d, method = "ward.D2")      ## cluster with "Ward" linkage

## 3. Plot the corresponding dendrogram

plot(hcl_complete)  ## The plot is a bit difficult to read, so let's customize it.

plot(hcl_complete, cex = 0.8, hang = -1)  ## "cex" is a numerical value giving the amount by which plotting text and symbols
                                          ## should be magnified relative to the default
                                          ## "hang" is the fraction of the plot height by which labels should hang below
                                          ## the rest of the plot. A negative value will cause the labels to hang down from 0.

par(mfrow = c(2, 2))  ## par() function places multiple plots in one single figure.
                      ## The "mfrow" parameter to the par() function sets up drawing of multiple plots by rows.
                      ## A vector with two values must be provided to "mfrow" that sets the number of rows and columns.

plot(hcl_complete, cex = 0.8, hang = -1, main = "Hierarchical Clustering with Complete Linkage")
plot(hcl_single, cex = 0.8, hang = -1, main = "Hierarchical Clustering with Single Linkage")
plot(hcl_average, cex = 0.8, hang = -1, main = "Hierarchical Clustering with Average Linkage")
plot(hcl_ward, cex = 0.8, hang = -1, main = "Hierarchical Clustering with Ward Linkage")

par(mfrow = c(1, 1))  ## Stop placing multiple plots in one figure.



## Working with dendrograms:

## In the dendrograms displayed above, each leaf corresponds to one observation.
## As we move up the tree, observations that are similar to each other are combined into branches,
## which are themselves fused at a higher height.
##
## The height of the fusion, provided on the vertical axis, indicates the dissimilarity between two observations.
## The higher the height of the fusion, the less similar the observations are. 
##
## IMPORTANT: Conclusions about the proximity of two observations can be drawn ONLY based on the height
##            where branches containing those two observations first are fused. In other words,
##            We cannot use the proximity of two observations along the horizontal axis as a criterion of their similarity.
##
## Next, we would like to discuss how to "cut" the dendrogram. Recall that The height of the cut to the dendrogram
## controls the number of clusters obtained.
##
## Let's look at the dendrogram where the "complete" linkage has been used.

## Method 1:
##
## We can cut the dendrogram with the cutree() function:

cluster_complete_2 <- cutree(hcl_complete, 2)  ## We first split the "hcl_complete" into 2 clustres

str(cluster_complete_2)  ## The output of cutree() is simply the cluster number for each observation

table(cluster_complete_2)  ## Number of observations in each cluster

cut.table <- function(hcluster, ncluster) {  ## cut.table() automatically cuts a dendrogram into required number of clusters 
  table(cutree(hcluster, ncluster))          ## and shows the number of observations in each cluster
}

cut.table(hcl_complete, 3)  
cut.table(hcl_complete, 4)
cut.table(hcl_complete, 5)
cut.table(hcl_complete, 6)
cut.table(hcl_complete, 7)

## If there are 5 or more clusters, one of the cluster will have only one observation, which is not a very good idea.
## So we only consider 2, 3 and 4 clusters solutions.

cluster_complete_3 <- cutree(hcl_complete, 3)  
cluster_complete_4 <- cutree(hcl_complete, 4)

USArrests_complete <- USArrests  ## We create a copy of the original data frame, which will be used to store
                                 ## the clustering solutions generated with the "complete" linkage.

USArrests_complete$Cluster_2 <- cluster_complete_2  ## Add a new variable "Cluster_2" to the original data frame
USArrests_complete$Cluster_3 <- cluster_complete_3  ## Add a new variable "Cluster_3" to the original data frame
USArrests_complete$Cluster_4 <- cluster_complete_4  ## Add a new variable "Cluster_4" to the original data frame

head(USArrests_complete)

## Method 2:
##
## It's also possible to draw on the dendrogram a rectangle around each cluster. To do this, we use rect.hclust():

plot(hcl_complete, cex = 0.8, hang = -1, main = "Hierarchical Clustering with Complete Linkage")

rect.hclust(hcl_complete, k = 2, border = 2:3) ## "border" is used to specify the border colors for the rectangles.

rect.hclust(hcl_complete, k = 3, border = 2:4)  

rect.hclust(hcl_complete, k = 4, border = 2:5)  

rect.hclust(hcl_complete, k = 5, border = 2:6)  

rect.hclust(hcl_complete, k = 6, border = 2:7)



## Interpret the Clusters 

## Let's look into each of the 4 clusters in "cluster_complete_4".
## Since "USArrests_complete" has a new column "Cluster_4" which indicates which one of the 4 clusters each states belongs to,
## we can easily extract them.

subset(USArrests_complete, Cluster_4 == 1)
subset(USArrests_complete, Cluster_4 == 2)
subset(USArrests_complete, Cluster_4 == 3)
subset(USArrests_complete, Cluster_4 == 4)

## If we had a very large data set, we wouldn't be able to generate any meaningful conclustion by just looking at each cluster.
## A very useful method for characterizing clusters is to look at some sort of summary statistic,
## such as the median and mean, of the variables that were used to perform the cluster analysis,
## broken down by the groups that the cluster analysis identified.
##
## To do so, we can use the aggregate() function which is well suited for this task,
## since it will perform summaries on many variables of a data frame simultaneously.

cluster_complete_4_median <- aggregate(USArrests_complete[, 1:4], list(USArrests_complete$Cluster_4), median)

cluster_complete_3_median <- aggregate(USArrests_complete[, 1:4], list(USArrests_complete$Cluster_3), median)

cluster_complete_2_median <- aggregate(USArrests_complete[, 1:4], list(USArrests_complete$Cluster_2), median)

## We can also add the number of observations of each cluster to the data.frame

data.frame(cluster_complete_4_median, table(cluster_complete_4))
data.frame(cluster_complete_3_median, table(cluster_complete_3))
data.frame(cluster_complete_2_median, table(cluster_complete_2))



## Comments:
##
## In the case of hierarchical clustering, we need to be concerned about:
##
##  - What type of linkage should be used?
##  - Where should we cut the dendrogram in order to obtain clusters (i.e., how many clusters should we choose)?
##
## Again, each of these decisions can have a strong impact on the results obtained.
## In practice, we try several different choices, and look for the one with the most useful or interpretable solution. 



######## Example 2 ########

## In this example, we'll apply hierarchial clustering to a set of cars from 1978-1979.
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

## It looks like the variables are measured on different scales, so we will likely want to
## standardize the data before proceeding.

cars_use_scaled <- scale(cars_use)

## Your own code starts from here:
head(cars_use_scaled)

d_car <- dist(cars_use_scaled, method = "euclidean") 

##*****
car_complete <- hclust(d_car, method = "complete") ## hclust() function uses Complete Linkage by default

str(car_complete)  ## The result is a list with several components.

?hclust  ## Let's check what the components stand for. The value in the definition shows the outputs meaning

row.names(cars_use)

as.data.frame(car_complete[1:2])  ## Let's check how the merging is performed and the corresponding height of each merge.

car_single <- hclust(d_car, method = "single")     ## cluster with "single" linkage
car_average <- hclust(d_car, method = "average")   ## cluster with "average" linkage
car_ward <- hclust(d_car, method = "ward.D2")      ## cluster with "Ward" linkage

## 3. Plot the corresponding dendrogram

plot(car_complete)  ## The plot is a bit difficult to read, so let's customize it.

plot(car_complete, cex = 0.8, hang = -1)  ## "cex" is a numerical value giving the amount by which plotting text and symbols
## should be magnified relative to the default
## "hang" is the fraction of the plot height by which labels should hang below
## the rest of the plot. A negative value will cause the labels to hang down from 0.

par(mfrow = c(2, 2))  ## par() function places multiple plots in one single figure.
## The "mfrow" parameter to the par() function sets up drawing of multiple plots by rows.
## A vector with two values must be provided to "mfrow" that sets the number of rows and columns.

plot(car_complete, cex = 0.8, hang = -1, main = "Hierarchical Clustering with Complete Linkage")
plot(car_single, cex = 0.8, hang = -1, main = "Hierarchical Clustering with Single Linkage")
plot(car_average, cex = 0.8, hang = -1, main = "Hierarchical Clustering with Average Linkage")
plot(car_ward, cex = 0.8, hang = -1, main = "Hierarchical Clustering with Ward Linkage")

par(mfrow = c(1, 1))  ## Stop placing multiple plots in one figure.

##in this case the Ward method provides a better illustration of the clustering,
##as the inner clusters are more evenly/equally spaced


## Method 1:
##
## We can cut the dendrogram with the cutree() function:

car_cluster_ward_2 <- cutree(car_ward, 2)  ## We first split the "hcl_ward" into 2 clustres

str(car_cluster_ward_2)  ## The output of cutree() is simply the cluster number for each observation

table(car_cluster_ward_2)  ## Number of observations in each cluster

cut.table <- function(hcluster, ncluster) {  ## cut.table() automatically cuts a dendrogram into required number of clusters 
  table(cutree(hcluster, ncluster))          ## and shows the number of observations in each cluster
}

cut.table(car_ward, 2)
cut.table(car_ward, 3)  
cut.table(car_ward, 4)
cut.table(car_ward, 5)
cut.table(car_ward, 6)
cut.table(car_ward, 7)

## Similarly we consider 3 cluster solution, which gives a better representation
##cluster solutions 6, 7 and more have 2 observations in some.

car_cluster_ward_2  <- cutree(car_ward, 2)
car_cluster_ward_3  <- cutree(car_ward, 3)
car_cluster_ward_4  <- cutree(car_ward, 4)
car_cluster_ward_5  <- cutree(car_ward, 5)

cars_use_ward <- cars_use  ## We create a copy of the original data frame, which will be used to store
## the clustering solutions generated with the "ward" linkage.

cars_use_ward$Cluster_2 <- car_cluster_ward_2  ## Add a new variable "Cluster_2" to the original data frame
cars_use_ward$Cluster_3 <- car_cluster_ward_3  ## Add a new variable "Cluster_3" to the original data frame
cars_use_ward$Cluster_4 <- car_cluster_ward_4  ## Add a new variable "Cluster_4" to the original data frame
cars_use_ward$Cluster_5 <- car_cluster_ward_5  ## Add a new variable "Cluster_5" to the original data frame
##we wouldnt need to add cluster 4 and 5 in this case
cars_use_ward <- cars_use_ward[,-9]
cars_use_ward <- cars_use_ward[,-9]

head(cars_use_ward)

## Method 2:
##
## It's also possible to draw on the dendrogram a rectangle around each cluster. To do this, we use rect.hclust():

plot(car_ward, cex = 0.8, hang = -1, main = "Hierarchical Clustering with Ward Linkage")

rect.hclust(car_complete, k = 2, border = 2:3) ## "border" is used to specify the border colors for the rectangles.

rect.hclust(car_complete, k = 3, border = 2:4)  

rect.hclust(car_ward, k = 4, border = 2:5)  

rect.hclust(car_ward, k = 5, border = 2:6)  

rect.hclust(car_ward, k = 6, border = 2:7)



## Interpret the Clusters 

## Let's look into each of the 3 clusters in "cluster_ward_3".
## Since "car_ward" has a new column "Cluster_3" which indicates which one of the 3 clusters each states belongs to,
## we can easily extract them.

subset(cars_use_ward , Cluster_1 == 1)
subset(cars_use_ward , Cluster_2 == 2)
subset(cars_use_ward , Cluster_3 == 3)
subset(cars_use_ward , Cluster_4 == 4)
subset(cars_use_ward , Cluster_5 == 5)


## If we had a very large data set, we wouldn't be able to generate any meaningful conclustion by just looking at each cluster.
## A very useful method for characterizing clusters is to look at some sort of summary statistic,
## such as the median and mean, of the variables that were used to perform the cluster analysis,
## broken down by the groups that the cluster analysis identified.
##
## To do so, we can use the aggregate() function which is well suited for this task,
## since it will perform summaries on many variables of a data frame simultaneously.

car_cluster_ward_5_median <- aggregate(cars_use_ward[, 1:4], list(cars_use_ward$Cluster_5), median)

car_cluster_ward_4_median <- aggregate(cars_use_ward[, 1:4], list(cars_use_ward$Cluster_4), median)

car_cluster_ward_3_median <- aggregate(cars_use_ward[, 1:4], list(cars_use_ward$Cluster_3), median)

car_cluster_ward_2_median <- aggregate(cars_use_ward[, 1:4], list(cars_use_ward$Cluster_2), median)

## We can also add the number of observations of each cluster to the data.frame

data.frame(car_cluster_ward_5_median, table(car_cluster_ward_5))
data.frame(car_cluster_ward_4_median, table(car_cluster_ward_4))
data.frame(car_cluster_ward_3_median, table(car_cluster_ward_3))
data.frame(car_cluster_ward_2_median, table(car_cluster_ward_2))

##note we cant access cluster 4 and 5 because they were deleted previously as we did not need them

##*****

######## Example 3 ########

## In this example, we'll apply hierarchial clustering to the "world" data.
## The data is stored in "world.txt".
##
## Among the 8 variables:
##
##  - literacy = Literacy rate
##  - phys = physicians/1000 population
##  - un.date = date joined the UN
