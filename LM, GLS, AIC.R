#Generalized least squares model#

#Use the built-in iris data and make a plot to show: 

####How `Petal.Length` varies between species####

iris <- as_tibble(iris)
iris

#Select columns
iris %>% select(Petal.Length,Species)

#Plotting the data
iris %>% 
  ggplot(aes(x = Species, y = Petal.Length)) + geom_boxplot()


####Find the variance of `Petal.Length` for each species####

iris %>% group_by(Species) %>% 
  summarise(mean_petal_length = mean(Petal.Length), sd_petal_length = sd (Petal.Length), variance = var(Petal.Length)) 

####Anova using lm between petal length and species####
mod <- lm(Petal.Length~Species, data = iris)
anova (mod)
summary(mod)

#Examine the diagnostic plots
par(mfrow = c(2,2))
plot(mod)

####Fitting a GLS for the same model####
library(nlme) 

fit_gls1 <- gls(Petal.Length ~ Species, data = iris)
anova(fit_gls1)
summary(fit_gls1)

#Have the coefficients changed? 
#No, because gls does the same as lm unless you add other parameters. Both models assume the same variance

####Fitting a GLS to the same model but allow different variance for each species####
fit_gls2 <- gls(Petal.Length ~ Species, data = iris, weights = varIdent (form = ~ +1 |Species))
anova(fit_gls2)
summary(fit_gls2)

#Use AIC to test if this is a better model

#the coefficients stay the same in this case, but the AIC decreases from 189 (with same variance)
#to 137 including different variance. AIC = estimate of fit - the lower AIC the better 



