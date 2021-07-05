##
##NAME: NWACHUKWU UCHECHUKWU JUSTIN
##STUDENT NUMBER: 73151

##Reading in the data
data <- read.csv("outcome-of-care-measures.csv",
                 header = TRUE, stringsAsFactors = FALSE)

##making columns 11,17,23 to be numeric
data[, 11] <- as.numeric(data[, 11])
data[, 17] <- as.numeric(data[, 17])
data[, 23] <- as.numeric(data[, 23])

##Question 7. NO SOLUTION YET
##Solution:-
attach(data)
##used a split function but in subsequent questions utilised a subset function

find_best_rate = function (state_var, outcome){
    if (outcome == "heart attack"){
      mysplitdata<- split(data[c("Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack")], list(State))
      print ((sapply(mysplitdata, min, na.rm = TRUE))[state_var])
    } else if(outcome == "pneumonia") {
      mysplitdata<- split(data[c("Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia")], list(State))
      print ((sapply(mysplitdata, min, na.rm = TRUE))[state_var])
    } else if(outcome == "heart failure") {
      mysplitdata<- split(data[c("Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure")], list(State))
      print ((sapply(mysplitdata, min, na.rm = TRUE))[state_var])
  }else {
    print ("Invalid State")
    }
  }




##Question 8. 
##Solution:-

find_best_rate = function (state_var, outcome){
  mysubset <- subset(data, State == state_var)
  if (outcome == "heart attack"){
    best_rate<- subset(mysubset, Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack == 
                         min(mysubset$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack, na.rm = TRUE))
    the_rate <- best_rate[, c(2, 7, 11)]
    print (the_rate)
  } else if(outcome == "pneumonia") {
    best_rate<- subset(mysubset, Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia == 
                         min(mysubset$Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia, na.rm = TRUE))
    the_rate <- best_rate[, c(2, 7, 23)]
    print (the_rate)
  } else if(outcome == "heart failure") {
    best_rate<- subset(mysubset, Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure == 
                         min(mysubset$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure, na.rm = TRUE))
    the_rate <- best_rate[, c(2, 7, 17)]
    print (the_rate)
  }else {
    print ("Invalid State")
  }
}


##alternative - rank function?       



find_best_rate(state_var = "MS", outcome = "heart failure")
fix(data)


##Question 9.
##Solution:-
##Included an if condition in the find_best_rate function to check if the outputs of best outcomes are more than one

find_best_rate = function (state_var, outcome){
  mysubset <- subset(data, State == state_var)
  if (outcome == "heart attack"){
    best_rate<- subset(mysubset, Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack == 
                         min(mysubset$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack, na.rm = TRUE))
    the_rate <- best_rate[, c(2, 7, 11)]
      if (nrow(the_rate) >= 2){
        print (the_rate)
      }
  } else if(outcome == "pneumonia") {
    best_rate<- subset(mysubset, Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia == 
                         min(mysubset$Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia, na.rm = TRUE))
    the_rate <- best_rate[, c(2, 7, 23)]
      if (nrow(the_rate) >= 2){
        print (the_rate)
    }
  } else if(outcome == "heart failure") {
    best_rate<- subset(mysubset, Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure == 
                         min(mysubset$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure, na.rm = TRUE))
    the_rate <- best_rate[, c(2, 7, 17)]
      if (nrow(the_rate) >= 2){
        print (the_rate)
    }
  }else {
    print ("Invalid State")
  }
}

##Creating a vector of all states and using a for loop to check all the states for ties (with find_best_rate function).

unique(data$State)

me <- c("AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "DC", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY",
        "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH",
        "OK", "OR", "PA", "PR", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VI", "VA", "WA", "WV", "WI", "WY", "GU")

for (i in me){
  find_best_rate(state_var = i, outcome = "heart failure")
}
## WI and  MS same minimum value
for (i in me){
  find_best_rate(state_var = i, outcome = "heart attack")
}
for (i in me){
  find_best_rate(state_var = i, outcome = "pneumonia")
}


##For Heart Failure, the hospitals that are tied as best are:-
##                       Hospital.Name  State           Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure
##2274       SOUTH CENTRAL REG MED CTR    MS                                                        9.2
##2309 VA GULF COAST HEALTHCARE SYSTEM    MS                                                        9.2
##                      Hospital.Name                 State   Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure
##3738 VA BLACK HILLS HEALTHCARE SYSTEM - FORT MEADE    SD                                                        9.9
##3752      AVERA HEART HOSPITAL OF SOUTH DAKOTA LLC    SD                                                        9.9
##                      Hospital.Name   State           Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure
##4510     WAUKESHA MEMORIAL HOSPITAL    WI                                                        9.3
##4561 AURORA ST LUKES MEDICAL CENTER    WI                                                        9.3

##For Heart Attack, the hospitals that are tied as best are:-
##             Hospital.Name  State                     Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack
##2440 BENEFIS HOSPITALS INC    MT                                                      13.6
##2441   ST PATRICK HOSPITAL    MT                                                      13.6

##For Pneumonia, the hospitals that are tied as best are:-
##         Hospital.Name  State                         Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia
##1967  NORWOOD HOSPITAL    MA                                                    8.2
##1968 FALMOUTH HOSPITAL    MA                                                    8.2
##        Hospital.Name                                   State   Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia
##4224                                       LDS HOSPITAL    UT                                                    9.9
##4226 UNIVERSITY HEALTH CARE/UNIV HOSPITALS AND  CLINICS    UT                                                    9.9


detach(data)