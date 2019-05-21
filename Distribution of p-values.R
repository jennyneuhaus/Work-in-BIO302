####Distribution of p-values####

#Random data can help explore the properties of the methods we use. In this practical we use 
#independent values from a normal distribution as the response (y). All the assumptions 
#of the linear model are met. In subsequent practicals we will test what happens 
#when these assumptions are violated.

#In this practical you will meet some new R syntax and functions, 
#specifically the pipe %>% and functions from the purrr package (in tidyverse).

#Generate the explanatory variable (x) as a sequence of values between 1 to 20, 
#and some corresponding response variable (y) from a normal distribution 
#with mean = 0 and sd = 1(use rnorm).

#Fit an ordinary least squares model between x and y
#Use anova and summary to find the effect size and the p-value.
#Now use glance and tidy from the package broom

library("tidyverse", quietly = TRUE)
library("broom")

set.seed(42)
x <- 1:20 #random nr. between 1 and 20 
y <- rnorm(20) 

mod <- lm(y ~ x)

#anova
anova(mod)

#summary
summary(mod)

#with broom: reformatting the data into a tibble 
glance(mod)
tidy(mod)


####Lots of random data####
#We want to repeat this many times to find the distribution of the p-value under 
#the null hypothesis. Use rerun from the package purrr to generate random data-sets, 
#and then pipe the data to use map to fit a model to each data-set followed by 
#map with glance

#Find the p-value of many (1000) models with random data with n = 20 
#and plot them with ggplot

rerun(.n = 1000, tibble(x = 1:20, y = rnorm(20))) %>% 
  map(~ lm(y ~ x, data = .)) %>% 
  map_df(glance) %>% 
  ggplot(aes(x = p.value)) + geom_histogram()

#not really much effect of the predictor on the response 


####How does the effect size varies with the p-value?####

#effect size: how much x is affecting y; with increasing effect you get more power 
#power: number of times you reject the null hypothesis 

#Extend the above analysis to find the distribution of p-values when there is 
#a relationship between x and y. Use rnorm(20, x * effect) where  effect is 
#the effect of x on y. Use different values of effect and plot the distribution of p-values.

rerun(.n = 1000, tibble(x = 1:20, y = rnorm(20, x * 0.0001))) %>% 
  map(~ lm(y ~ x, data = .)) %>% 
  map_df(glance) %>% 
  ggplot(aes(x = p.value)) + geom_histogram()

#predictor has a very low effect on the response (0.0001): p-values quite linear,
#less likely that there is a relationship between x and y 


####Different sample size####

#See the effect of different sample sizes on the effect sizes and p-value distributions

set.seed(42)
x <- 1:5 #random nr. between 1 and 5
y <- rnorm(5) 

mod <- lm(y ~ x)

#anova
anova(mod)

#summary
summary(mod)

#with broom: reformatting the data into a tibble 
glance(mod)
tidy(mod)

#small sample size 

rerun(.n = 1000, tibble(x = 1:5, y = rnorm(5, x * 0.2))) %>% 
  map(~ lm(y ~ x, data = .)) %>% 
  map_df(glance) %>% 
  ggplot(aes(x = p.value)) + geom_histogram()

#even with a high effect size, the p-value distribution remains linear due to small sample size
#even if there is an effect, it could still be random 

#large sample size
set.seed(42)
x <- 1:40 #random nr. between 1 and 40 
y <- rnorm(40) 

mod <- lm(y ~ x)

#anova
anova(mod)

#summary
summary(mod)

#with broom: reformatting the data into a tibble 
glance(mod)
tidy(mod)


rerun(.n = 1000, tibble(x = 1:40, y = rnorm(40, x * 0.2))) %>% 
  map(~ lm(y ~ x, data = .)) %>% 
  map_df(glance) %>% 
  ggplot(aes(x = p.value)) + geom_histogram()

#the larger the sample size, the more certain it is that there is an effect (is there is an effect at all)

