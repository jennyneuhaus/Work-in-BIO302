#Bergen bysykkeldata#

####Importing data####

sykkel <- read.csv("C:/Users/jenny/Desktop/BIO302/04.csv")
library(tidyverse)

####Which is the most popular starting station?####

#Making a tibble and selecting a column 
sykkel <- as_tibble(sykkel)
sykkel

sykkel %>%  select(start_station_name)


#Telling R that the same station name belongs in the same group 
#I name the subset start
#rename the column names: rename(New name = Old name)

start <- sykkel %>% group_by(start_station_name) %>% 
         count() %>% 
         arrange(desc(n))

end <- sykkel %>% group_by(end_station_name) %>% 
       count() %>% 
       arrange(desc(n))

####Plot the number of hires and returns from each station####

library(ggplot2)

#we want the data to be in one table below each other in one column as use gather
#key is the first column, end and start station below each other
#value is the second column and shows the stations
#we use count to get a third column with values (n)

sykkel %>% gather (key = variable, value = Stations, start_station_name, end_station_name) %>% 
  count(variable, Stations) %>% 
  ggplot(aes(y=n, x= Stations, fill=variable))+geom_col (position=position_dodge())



####Which is the most popular pair of start and end stations?####

sykkel %>% count(start_station_name, end_station_name) %>% 
  arrange(desc(n)) %>% 
  slice (1:2)

####What was the longest/shortest duration of hire?####

#Longest duration of hire
sykkel %>% arrange(desc(duration)) %>% slice(1:1)

#Shortest duration of hire
sykkel %>% arrange(duration) %>% slice(1:1)


####Plot the distribution of hire duration####
sykkel %>%  ggplot(aes(x= duration))+ geom_histogram() + xlim(10, 7200)


####What is the median duration of hire from each station?####
map <- sykkel %>% group_by(start_station_name, start_station_latitude, start_station_longitude) %>% 
  summarise(median_duration=median(duration))



####Map this information####
map %>% 
ggplot(aes(x=start_station_longitude, y=start_station_latitude)) + geom_point(aes(size = median_duration))
x11()

####Are there any significant differences in duration between stations####

mod <- lm(duration~start_station_name, data = sykkel)
anova(mod)

#we have significant differences in duration between stations


####How far does a typical cyclist travel?####



