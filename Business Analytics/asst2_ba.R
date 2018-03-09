#Prashant Mahato(73098) and Bhuwan Chhetri(74411)

#1Reading the downloaded file 

flags <- read.csv("C:/Users/Prashant Mahato/Downloads/FlagData.txt", header = TRUE)
fix(flags)
##attaching the headers to variable names
attach(flags)


## 2. see how many flags fall into each religion and landmass
landmass_table <- table(landmass)
landmass_table

## the no. of countries for each landmass: 
##1  2  3  4  5  6 
##31 17 35 52 39 20

religion_table <- table(religion)
religion_table

## no. of countries for each religion subfroup: 
##0  1   2  3  4  5  6  7 
##40 60 36  8  4 27 15  4 


##Question 3. use split() function to partition var. name into subgroups broken down by landmass and religion.
landmass_religion_subgroups <- split(name, list(landmass, religion), drop = TRUE)
landmass_religion_subgroups

##Solution:- There are 48 subgroups of which 24 are empty.

## 3b)Since Landmass 2 indicates continent south american and Religion 1 is called other christians
SA_1 <- subset(flags, landmass == 2 & religion == 1)
SA_1 <- SA_1[,c(1,2,7)]
SA_1
##Thus the 3 countries in S.A. called other christians are Falklands-Malvinas, Surinam and Trinidad-Tobago

summary(landmass_religion_subgroups)
## 3c)The subgroup $`4.5 means landmass 4 (Africa), and religion 5 (Ethnic) has the highest no. ofcountries (26)



##Question 4. Finding the minimum, 50% cut point and maximum population values for each landmass
##Solution:-

population_subgroups <- split(flags[c("population")], list(landmass))
population_subgroups

sapply(population_subgroups, min)
##the minimum population values (of countries) for each landmass are as below:-
## 1 2 3 4 5 6 
## 0 0 0 0 0 0 

sapply(population_subgroups, max)
##the maximum population values (of countries) for each landmass are as follows:-
## 1    2    3    4    5    6 
## 231  119   61   56 1008  157

sapply(population_subgroups, FUN = quantile, probs = c(0.5), na.rm = TRUE)
##the 50% cut point for population values (of countries) in each landmass are as follows:-
## 1.50% 2.50% 3.50% 4.50% 5.50% 6.50% 
##   0     6     8     5    10     0


##Question 5.find out landmass having countries in one zone, and landmass havin country in every zone
## Solution:- splitting the data by zones and landmass, and checking for unique zone values
##
landmass_zone_subgroups <- split(flags[c("zone", "name")], list(landmass))
landmass_zone_subgroups

#We have splitted landmass according to zone and name with above command.
##Now we have to use the unique function in each landmass to find out which 
##landmass have only one zone and which have all

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
##landmass 1 and 5 have all the countries in zone 4 and zone 1 respectively, while landmass 4 has all the countries in all of the zones.

##Question 6. A function, findcountry(), which takes the folowing five arguments:
## number of bars, stripes, circles, crosses, and quarters;
## then returns the names of countries whose flags meet the given criteria, otherwise displays error message

##Solution:-
count <- 0
findcountry <- function(bar, stripe, circle, cross, quarter){
  for (i in 1:length(name)){
    if ((circles[i] == circle) & (crosses[i] == cross) & (quarters[i] == quarter) & (stripes[i] == stripe) & (bars[i] == bar)){
      print(name[i])
      count <- count + 1
    }
  }
  if (count == 0){
    print("Select appropriate numbers and try again")
  }
}

##Test sample data
findcountry(1,2,0,0,0) ## The countries output are Cape-Verde-Islands, Guinea-Bissau, and Malagasy
findcountry(0,0,1,1,1) ## The countries output are Bermuda, Cayman-Islands, Cook-Islands, Falklands-Malvinas, Hong-Kong and Niue
findcountry(1,1,1,1,1) ##Outputs [1] "Select appropriate numbers and try again"

detach(flags)

data<-read.csv('C:/Users/Prashant Mahato/Downloads/outcome-of-care-measures.csv',header = TRUE, stringsAsFactors = FALSE)

##making columns 11,17,23 to be numeric
data[, 11] <- as.numeric(data[, 11])
data[, 17] <- as.numeric(data[, 17])
data[, 23] <- as.numeric(data[, 23])

attach(data)

mysplitdata<- split(data[c("Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack")], list(State))
mysplitdata<- split(data[c("Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia")], list(State))
mysplitdata<- split(data[c("Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure")], list(State))

sapply(mysplitdata, min, na.rm = TRUE)
outcome <- factor (c("heart attack" = 1, "heart failure" = 2, "pneumonia" = 3))

find_best_rate = function (state_var, outcome){
  if (outcome == 1){
    mysplitdata<- split(data[c("Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack")], list(State))
    print ((sapply(mysplitdata, min, na.rm = TRUE))[state_var])
  } else if(outcome == 3) {
    mysplitdata<- split(data[c("Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia")], list(State))
    print ((sapply(mysplitdata, min, na.rm = TRUE))[state_var])
  } else if(outcome == 2) {
    mysplitdata<- split(data[c("Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure")], list(State))
    print ((sapply(mysplitdata, min, na.rm = TRUE))[state_var])
  }else {
    print ("Invalid State")
  }
}


find_best_rate(state_var = "AL", outcome = 2)
fix(data)

##Question 8. 
##Solution:-
find_best_rate = function (state_var, outcome){
  if (outcome == 1){
    mysplitdata<- split(data[c("Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack", "Hospital.Name")], list(State))
    print ((sapply(mysplitdata, min, na.rm = TRUE))[state_var])
  } else if(outcome == 3) {
    mysplitdata<- split(data[c("Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia", "Hospital.Name")], list(State))
    print ((sapply(mysplitdata, min, na.rm = TRUE))[state_var])
  } else if(outcome == 2) {
    mysplitdata<- split(data[c("Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure","Hospital.Name")], list(State))
    print ((sapply(mysplitdata, min, na.rm = TRUE))[state_var])
  }else {
    print ("Invalid State")
  }
}