##
##NAME: NWACHUKWU UCHECHUKWU JUSTIN
##STUDENT NUMBER: 73151

##Question 1. using the read.csv() function to load the data into an R data frame named colleges.
colleges <- read.csv("Colleges.csv", header = TRUE)


##Question 2. Creating a scatterplot matrix for variables subsets: (Private, Top10perc, Top25perc, Expend, Grad.Rate)

##instructing R to make the variables in data frame colleges available by name without the $ symbol
attach(colleges)

## creating a scatterplot matrix for the above mentioned  variable subsets.
pairs(~ Private + Top10perc + Top25perc + Expend + Grad.Rate)

##Question 3. creating a scatterplot for 2 variables: Private and Expend in order to study their relationship
plot(x = Private, y = Expend,                     
     main = "Scatterplot of Expend vs. Private",  
     xlab = "Private Colleges",           
     ylab = "Expenditure")    

##viewing the statiscal summary of the 2 variables
summary(colleges[c("Expend", "Private")]) 

##Question 4. Hence from the scatterplot generated, it shows that there is a clear relationship between the colleges expenditure
##and if the are private. There is a similarity in the distribution of their expenses.
##but there are quite many private universities/colleges who spend way above the non-private ones.

##Question 5. using the identify() method to indicate which university has the highest instructional expenditure
identify(x = Private, y = Expend, Name)

## the result obtained is Johns Hopkins University with an index of 285 in colleges
##and all information on it can be obtained as follows:

colleges[285, ]
##Categories: Name Private Apps Accept Enroll Top10perc Top25perc F.Undergrad P.Undergrad Outstate Room.Board
##285 Johns Hopkins University     Yes 8474   3446    911        75        94        3566        1569    18800       6740
##Books Personal PhD Terminal S.F.Ratio perc.alumni Expend Grad.Rate
##285   500     1040  96       97       3.3          38  56233        90




##Question 6. No, from the summary, it can be seen that the Top25perc and Top10perc variable values in 
##John Hopkins University is less than their respective maximum value 

summary(colleges[c("Top10perc", "Top25perc")])
##OR
which.max(Top10perc)

##instructing R to detach the data frame
detach(colleges)
