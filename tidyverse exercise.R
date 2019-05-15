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

#sorting by a variable from small to large
iris %>% arrange(Petal.Length)

#sorting by a variable from large to small
iris %>% arrange(desc(Petal.Length))

#sorting by a variable for each species and slice these 
iris %>% group_by(Species) %>% arrange(Petal.Length) %>% slice(1:3)

#nesting: all data for all the species making it into a tibble
iris %>%  group_by(Species) %>% nest()

#linear regression model with the nested data
#map: part of tidyverse, taking each element of each column at its turn
iris %>%  group_by(Species) %>% nest() %>% 
  mutate(mod = map(data, ~lm(Sepal.Length ~ Sepal.Width, data = .))) %>% 
  mutate(coef = map(mod, broom::tidy)) %>% 

#we unnest the tibbles because we want to see what the model shows 
  unnest(coef)


####Reshaping data####
iris %>% 
  rownames_to_column() %>% 
  gather(key = variable, value = measurement, -Species, -rowname) %>% 
  group_by(Species, variable) %>% 
  summarise(mean = mean(measurement)) 

#plotting the data
iris %>% 
  rownames_to_column() %>% 
  gather(key = variable, value = measurement, -Species, -rowname) %>% 
  group_by(Species, variable) %>% 
  ggplot(aes(x = variable, y = measurement, fill = Species)) + geom_violin()





