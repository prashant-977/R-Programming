#Student name: Prashant Mahato (73098) and Bhuwan Chhetri (74411)
#1.Read file into dataframe
colleges<-read.csv('C:/Users/Prashant Mahato/Downloads/Colleges.csv',header=TRUE)
attach(colleges)
#2. Basic scatter plot of the following variables
pairs(~Private+Top10perc+Top25perc+Expend+Grad.Rate,data=colleges,main="Scatterplot example")
#3. Scatter plot of Private vs Expend
plot(x = Private, y = Expend, main = "Scatterplot of Expend vs. Private", xlab = "Private Colleges", ylab = "Expenditure") 
summary(colleges[c("Private","Expend")])
#4. Difference between the instructional expenditure per student made by private and public unis:
##In the private, there are a lot of outliers whereas in public there are a few.
##So we can conclude that many of private institutes do lots of expenses.
#5.Identifying the college expending the most, we use the identify function and locate them in the graph
identify(x=Private,y=Expend,Name)
##We get 285 as maximum for private and 695 for the public if we dont type the parameter 'Name'
colleges[285,]##John Hopkins Uni.
colleges[695,]##University of Wasington
#6. If we 
summary(colleges[c("Top10perc","Top25perc")])
#For both, the top10perc and top25 perc is less than their corresponding max values
# for both the no. of part time graduates seems less.
