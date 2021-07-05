##
##NAME: NWACHUKWU UCHECHUKWU JUSTIN
##STUDENT NUMBER: 73151

##Question 1. Reading in FlagData.txt and storing it as flags.
##Solution:-
flags <- read.csv("FlagData.txt", header = TRUE)

##instructing R to make the variables in data frame flags available by name without the $ symbol
attach(flags)


##Question 2. Using the table() function to see how many flags/countries fall into each group (landmass and religion)
landmass_table <- table(landmass)
landmass_table

religion_table <- table(religion)
religion_table

##Solution:- Landmass has the following distribution: 
##1  2  3  4  5  6 
##31 17 35 52 39 20

##While Religion has the following distribution: 
##0  1   2  3  4  5  6  7 
##40 60 36  8  4 27 15  4 


##Question 3. Using the split() function to partition the variable "name" into subgroups (with landmass and religion)
landmass_religion_subgroups <- split(name, list(landmass, religion), drop = TRUE)
landmass_religion_subgroups

##Solution:- There are 48 subgroups of which 24 are empty.
length(landmass_religion_subgroups)
##Since Landmass 2 is south american and Religion 1 is called other christians, the grouping we need is $2.1:-
mysubset <- subset(flags, landmass == 2 & religion == 1)
SA_Others_set <- mysubset[,c(1,2,7)]
##Thus the 3 countries in S.A. called other christians are Falklands-Malvinas, Surinam and Trinidad-Tobago

summary(landmass_religion_subgroups)
##The subgroup $`4.5 (Africa with Ethnic Religion) has most countries with 26 countries
##Subgroup $`5.2 (Muslim Asians) and $`1.1`(North American other christians)
##are the next large subgroups with 20 and 21 countries respectively


##Question 4. Finding the minimum, 50% cut point and maximum population values for each landmass
##Solution:-

population_subgroups <- split(flags[c("population")], list(landmass))
population_subgroups

sapply(population_subgroups, min)
##the minimum values for each landmass are as follows:-
## 1 2 3 4 5 6 
## 0 0 0 0 0 0 

sapply(population_subgroups, max)
##the maximum values for each landmass are as follows:-
## 1    2    3    4    5    6 
## 231  119   61   56 1008  157

sapply(population_subgroups, FUN = quantile, probs = c(0.5), na.rm = TRUE)
##the 50% cut point for each landmass are as follows:-
## 1.50% 2.50% 3.50% 4.50% 5.50% 6.50% 
##   0     6     8     5    10     0

##IQR not working! but maybe???? IQR(population_subgroups, na.rm = TRUE)



##Question 5. Using split function to identify landmass in certain zones
## Solution:- splitting the data by zones and landmass, and checking for unique zone values
##
landmass_zone_subgroups <- split(flags[c("zone", "name")], list(landmass))
landmass_zone_subgroups

##landmass 1 and 5 has its countries all in zone 4 and zone 1 respectively, while landmass 4 has countries in eevry zone
landmass_zone_subgroupss <- split(flags[c("zone")], list(landmass))
landmass_zone_subgroupss
unique(landmass_zone_subgroupss$`1`)
##   zone
## 7    4
unique(landmass_zone_subgroupss$`2`)
##    zone
## 9     3
## 39    4
unique(landmass_zone_subgroupss$`3`)
##    zone
## 2     1
## 56    4
unique(landmass_zone_subgroupss$`4`)
##      zone
## 3      1
## 6      2
## 28     4
## 159    3
unique(landmass_zone_subgroupss$`5`)
##   zone
## 1    1
unique(landmass_zone_subgroupss$`6`)
##     zone
## 4     3
## 11    2
## 72    1


##Question 6. A function, findcountry(), which takes the folowing five arguments:
## number of bars, stripes, circles, crosses, and quarters;
## then returns the names of countries whose flags meet the given criteria, otherwise displays error message

##Solution:-
a <- 0
findcountry <- function(brs, strp, circl, crss, quartr){
  for (i in 1:length(name)){
    if ((circles[i] == circl) & (crosses[i] == crss) & (quarters[i] == quartr) & (stripes[i] == strp) & (bars[i] == brs)){
      print(name[i])
      a <- a + 1
    }
  }
  if (a == 0){
      print("Select appropriate numbers and try again")
  }
}

##Test sample data
findcountry(1,2,0,0,0) ## Outputs Cape-Verde-Islands, Guinea-Bissau, and Malagasy
findcountry(0,0,1,1,1) ## Outputs Bermuda, Cayman-Islands, Cook-Islands, Falklands-Malvinas, Hong-Kong and Niue
findcountry(1,1,1,1,1) ##Outputs [1] "Select appropriate numbers and try again"

detach(flags)
