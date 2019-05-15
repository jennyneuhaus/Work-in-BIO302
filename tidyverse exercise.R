##15.05.19; Exercise##

library(tidyverse)

install.packages("vegan")
data(BCI, package = "vegan") #BCI is the dataframe 

x11() #opens plot in a new window
plot(sort(colSums(BCI), decreasing = TRUE))

####PIPES; control-shift-M: %>% ####

BCI %>% 
  colSums() %>% 
  sort(decreasing = TRUE) %>% 
  plot()


#TIBBLE: shows a table with only a few rows except the whole dataset 
iris <- as_tibble(iris)
iris

#Select columns
iris %>% select(Sepal.Length,Species)

#Getting rid of a column
iris %>% select(-Sepal.Width)


#Every column between start and end
iris %>% select(Sepal.Length:Petal.Length)


#Every column between start and end plus another one
iris %>% select(Sepal.Length:Petal.Length, Species)

#Renaming a column: new name = old name
#If you want to have a space between two words you use ``
iris %>% rename(sepal.length = Sepal.Length, spp = Species)


#filter function: it filters rows with certain values 
iris %>% filter(Sepal.Length > 5, Petal.Length < 2) %>% 
  select(Sepal.Length, Petal.Length, Species)

#mutate: we can make a new column or change the existing one
iris %>% mutate(petal.area = Petal.Length * Petal.Width)
iris %>% mutate(Species = toupper(Species)) #changed lower case to upper case 


#group by categorical variables 
iris %>% group_by(Species) %>% 
  summarise(mean_petal_length = mean(Petal.Length), sd_petal_length = sd (Petal.Length)) 




####Reshaping data####


