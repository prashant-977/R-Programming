##
## GROUP MEMBERS:-
##
##NAME: NWACHUKWU UCHECHUKWU JUSTIN
##STUDENT NUMBER: 73151 (UNIVERSITY OF TURKU)
##
##NAME: ZAGLAGO BERNICE
##STUDENT NUMBER: 42038 (ABO AKADEMI)

##ASSIGNMENT_THREE:- PART ONE

##Question 1. APPLYING HIERARCHICAL CLUSTERING TO GIVEN DATA USING LINKAGE METHODS-AVERAGE,COMPLETE,AVERAGE and WARD
##Solution:-

##Reading in the data
EUProtein <- read.csv("EUProteinConsumption.csv", header = TRUE)

## checking if there are	observations with	missing	values:
any(is.na(EUProtein))
which(complete.cases(EUProtein) == FALSE)

## observing the structure of the dataset to know if scales are uniform and which variables are numerical
str(EUProtein)
head(EUProtein)

##ensuring R does not perform calculations on the row names
row.names(EUProtein) <- EUProtein[, 1]

## We only use the numerical variables for clustering (i.e., EUProtein[, 2:9]) as its difficult to measure
##dissimilarity between categorical values
EUProtein <- EUProtein[, -1]

## we need to scale/standardize the data. To do this, we use the scale() function:
EUProtein_scaled <- scale(EUProtein)
head(EUProtein_scaled)

## To determine the optimal number of clusters using Hierarchical Clustering 
##we first calculate the distance matrix between observations
d <- dist(EUProtein_scaled, method = "euclidean")  

EUProtein_hcl_complete <- hclust(d, method = "complete")   ## cluster with "single" linkage
EUProtein_hcl_single <- hclust(d, method = "single")     ## cluster with "single" linkage
EUProtein_hcl_average <- hclust(d, method = "average")   ## cluster with "average" linkage
EUProtein_hcl_ward <- hclust(d, method = "ward.D2")      ## cluster with "ward" linkage

##enabling ploting the 4 graphs on one page for comparison
par(mfrow = c(2, 2))

##Drawing a dendrogram for each linkage method
plot(EUProtein_hcl_complete, cex = 0.8, hang = -1, main = "Hierarchical Clustering with Complete Linkage")
plot(EUProtein_hcl_single, cex = 0.8, hang = -1, main = "Hierarchical Clustering with Single Linkage")
plot(EUProtein_hcl_average, cex = 0.8, hang = -1, main = "Hierarchical Clustering with Average Linkage")
plot(EUProtein_hcl_ward, cex = 0.8, hang = -1, main = "Hierarchical Clustering with Ward Linkage")

par(mfrow = c(1, 1))

##Question 2. DETERMINING THE OPTIMAL NUMBER OF CLUSTERS
##Solution:-

## We utilize NbClust() in determining the optimal number of clusters for Hierarchical Clustering
library("NbClust")
NbClust(EUProtein_scaled, distance = "euclidean", min.nc = 2, max.nc = 10, method = "ward.D2")

##In this case, according to the "majority rule", the optimal number of clusters for our chose Ward Linkage method is 5
##though 3 clusters is also close

par(mfrow = c(1, 1))


##Question 3. SEPERATING THE DATASET INTO IDENTIFIED OPTIMAL NUMBER OF CLUSTERS WITH CORRESPONDING DENDROGRAM-RECTANGLES
##Solution:-

## drawing on the dendrogram a rectangle around each of the 5 clusters.

plot(EUProtein_hcl_ward, cex = 0.8, hang = -1, main = "Hierarchical Clustering with Ward.D2 Linkage")

rect.hclust(EUProtein_hcl_ward, k = 5, border = 2:9)


## We split the "EUProtein_hcl_ward" into 5 clustres
EUProtein_hcl_ward_w5 <- cutree(EUProtein_hcl_ward, 5) 


str(EUProtein_hcl_ward_w5)  
table(EUProtein_hcl_ward_w5) ##to get the frequency distribution

## We add new column "w5" to the data which indicatesto which cluster each customer belongs in each clustering solution.
##This will be utilized in analyzing similarities

EUProtein$w5 <- EUProtein_hcl_ward_w5
cbind(aggregate(EUProtein[, -10], list(EUProtein$w5), mean), Freq = as.vector(table(EUProtein_hcl_ward_w5)))


##Question 4. IDENTIFYING NAME OF COUNTRIES IN EACH CLUSTER
##Solution:-

subset(EUProtein, w5 == 1)
##Cluster 1:-
##Albania, Bulgaria, Romania, Yugoslavia

subset(EUProtein, w5 == 2)
##Cluster 2:-
##Austria, Belgium, France, Ireland, Netherlands, Switzerland, UK, W Germany

subset(EUProtein, w5 == 3)
##Cluster 3:-
##Czechoslovakia, E Germany, Hungary, Poland, USSR  

subset(EUProtein, w5 == 4)
##Cluster 4:-
##Denmark, Finland, Norway, Sweden

subset(EUProtein, w5 == 5)
##Cluster 5:-
##Greece, Italy, Portugal, Spain


##Question 5. IDENTIFYING SIMILARITIES BETWEEN COUNTRIES IN EACH CLUSTER
##Solution:-

##           RedMeat WhiteMeat Eggs Milk Fish Cereals Starch Nuts Fr.Veg w5
##Albania       10.1       1.4  0.5  8.9  0.2    42.3    0.6  5.5    1.7  1
##Bulgaria       7.8       6.0  1.6  8.3  1.2    56.7    1.1  3.7    4.2  1
##Romania        6.2       6.3  1.5 11.1  1.0    49.6    3.1  5.3    2.8  1
##Yugoslavia     4.4       5.0  1.2  9.5  0.6    55.9    3.0  5.7    3.2  1
##            RedMeat WhiteMeat Eggs Milk Fish Cereals Starch Nuts Fr.Veg w5
##Austria         8.9      14.0  4.3 19.9  2.1    28.0    3.6  1.3    4.3  2
##Belgium        13.5       9.3  4.1 17.5  4.5    26.6    5.7  2.1    4.0  2
##France         18.0       9.9  3.3 19.5  5.7    28.1    4.8  2.4    6.5  2
##Ireland        13.9      10.0  4.7 25.8  2.2    24.0    6.2  1.6    2.9  2
##Netherlands     9.5      13.6  3.6 23.4  2.5    22.4    4.2  1.8    3.7  2
##Switzerland    13.1      10.1  3.1 23.8  2.3    25.6    2.8  2.4    4.9  2
##UK             17.4       5.7  4.7 20.6  4.3    24.3    4.7  3.4    3.3  2
##W Germany      11.4      12.5  4.1 18.8  3.4    18.6    5.2  1.5    3.8  2
##                RedMeat WhiteMeat Eggs Milk Fish Cereals Starch Nuts Fr.Veg w5
##Czechoslovakia     9.7      11.4  2.8 12.5  2.0    34.3    5.0  1.1    4.0  3
##E Germany          8.4      11.6  3.7 11.1  5.4    24.6    6.5  0.8    3.6  3
##Hungary            5.3      12.4  2.9  9.7  0.3    40.1    4.0  5.4    4.2  3
##Poland             6.9      10.2  2.7 19.3  3.0    36.1    5.9  2.0    6.6  3
##USSR               9.3       4.6  2.1 16.6  3.0    43.6    6.4  3.4    2.9  3
##        RedMeat WhiteMeat Eggs Milk Fish Cereals Starch Nuts Fr.Veg w5
##Denmark    10.6      10.8  3.7 25.0  9.9    21.9    4.8  0.7    2.4  4
##Finland     9.5       4.9  2.7 33.7  5.8    26.3    5.1  1.0    1.4  4
##Norway      9.4       4.7  2.7 23.3  9.7    23.0    4.6  1.6    2.7  4
##Sweden      9.9       7.8  3.5 24.7  7.5    19.5    3.7  1.4    2.0  4
##          RedMeat WhiteMeat Eggs Milk Fish Cereals Starch Nuts Fr.Veg w5
##Greece      10.2       3.0  2.8 17.6  5.9    41.7    2.2  7.8    6.5  5
##Italy        9.0       5.1  2.9 13.7  3.4    36.8    2.1  4.3    6.7  5
##Portugal     6.2       3.7  1.1  4.9 14.2    27.0    5.9  4.7    7.9  5
##Spain        7.1       3.4  3.1  8.6  7.0    29.2    5.7  5.9    7.2  5

##The countries in each cluster are geographically close to each other,
##and from the data, there is a cluster similarity in their annual spending on milk products in comparison to others
##as well as similarity in spending on cereals, starch and red meat


##ASSIGNMENT PART TWO

##Reading in the data
ItalianWineType <- read.csv("ItalianWineSamples.csv", header = TRUE)

## We	will first check if there are	observations with	missing	values:
any(is.na(ItalianWineType))
which(complete.cases(ItalianWineType) == FALSE)

##observing the overall structure of the dataset
str(ItalianWineType)
fix(ItalianWineType)
head(ItalianWineType)


##Question 6. DROPPING THE "TYPE" VARIABLE
##Solution:-

## We only use numerical variables for clustering as its difficult to measure dissimilarity between categorical values
ItalianWine <- ItalianWineType[, -1]

## we need to scale/standardize the data. To do this, we use the scale() function:
ItalianWine_scaled <- scale(ItalianWine)
head(ItalianWine_scaled)


##Question 7. APPLYING K-MEANS CLUSTERING TO REMAINING 13 VARIABLES AND IDENTIFYING OPTIMAL K
##Solution:-

## To determine the optimal number of clusters using K-Means Method 1: Elbow Method

wss <- function(k, data) {  ## wss() calculates the "Total Within-Cluster Sum of Squares" for each K
  kmeans(data, k, iter.max = 20, nstart = 100)$tot.withinss  ## We have a rather big dataset, so we set iter.max = 20
}                                                            ## and set nstart = 100

set.seed(123) ## To get a reproducible random result.
ItalianWine_wss <- sapply(2:10, wss, data = ItalianWine_scaled)  ## We check the Total WSS for K = 2,...,10

plot(2:10, ItalianWine_wss,  ## We plot the "Total WSS" for each K
     type = "b",  ## Points with line connection
     pch = 19,    ## solid circle
     frame = FALSE,
     xlab = "Number of clusters K",
     ylab = "Total within-clusters sum of squares")
##Optimal number of clusters is 3


## To determine the optimal number of clusters using K-Means Method 2: Average Silhouette Method

library("cluster")

avg.sil <- function(k, data) {                   
  kmeans_result <- kmeans(data, k, iter.max = 20, nstart = 100)  
  silhouette_coefficient <- silhouette(kmeans_result$cluster, dist(data))
  mean(silhouette_coefficient[, 3])
}

set.seed(123)
ItalianWine_silhouette <- sapply(2:10, avg.sil, data = ItalianWine_scaled)

plot(2:10, ItalianWine_silhouette,
     type = "b",  ## Points with line connection
     pch = 19,    ## solid circle
     frame = FALSE,
     xlab = "Number of clusters K",
     ylab = "Average Silhouette")
##Optimal number of clusters is also 3


## To determine the optimal number of clusters using K-Means Method 3: Average NbClust Method
library("NbClust")

set.seed(123)
NbClust(ItalianWine_scaled, distance = "euclidean", min.nc = 2, max.nc = 10, method = "kmeans")

par(mfrow = c(1, 1))

## According to the "majority rule", the best number of clusters is also 3.


##Question 8. IDENTIFYING HOW MANY OBSERVATIONS ARE IN EACH CLUSTER
##Solution:-



set.seed(123)
ItalianWine_k3 <- kmeans(ItalianWine_scaled, 3, iter.max = 20, nstart = 100)

ItalianWineType$k3 <- ItalianWine_k3$cluster  ## We add a new column "k3" to the data which indicates
## to which cluster each customer belong.

str(subset(ItalianWineType, k3 == 1))
## Cluster 1 has 62 observations

str(subset(ItalianWineType, k3 == 2))
## Cluster 2 has 51 observations

str(subset(ItalianWineType, k3 == 3))
## Cluster 3 has 65 observations



##Question 9. COMPARING OUR CLUSTER SOLUTIONS WITH THE TYPE VARIABLE
##Solution:-

aggregate(ItalianWineType, list(ItalianWineType$k3), mean)  ## Let's check the mean value of each variable in each cluster

cbind(aggregate(ItalianWineType[, -14], list(ItalianWineType$k3), mean), Freq = as.vector(table(ItalianWine_k3$cluster)))

subset(ItalianWineType, Type == 1)
##All observations in Type 1 belong to the Cluster 1 subgroup
subset(ItalianWineType, Type == 2)
##There are a few observations in Type 2 which are in Cluster 2 and 1 but most belong to Cluster 3 subgroup 
subset(ItalianWineType, Type == 3)
##All observations in Type 3 belongs to the Cluster 2 subgroup


str(subset(ItalianWineType, Type == 2))
##Out of the 71 observations in Type 2:-
subset(ItalianWineType, (Type == 2 & k3 == 3))
str(subset(ItalianWineType, (Type == 2 & k3 == 3))) ##65 are in cluster 3
subset(ItalianWineType, (Type == 2 & k3 == 2))
str(subset(ItalianWineType, (Type == 2 & k3 == 2))) ##3 are in cluster 2
subset(ItalianWineType, (Type == 2 & k3 == 1))
str(subset(ItalianWineType, (Type == 2 & k3 == 1))) ##3 are in cluster 1
