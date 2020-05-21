
library(nycflights13)
library(tidyverse)
library(ggplot2)
library(ggstance)
library(lvplot)


# What type of variation occurs within my variables?
# What type of covariation occurs between my variables?


ggplot(data = diamonds) +
        geom_bar(mapping = aes(x = cut))

smaller <- diamonds %>% 
        filter(carat < 3)

ggplot(data = smaller, mapping = aes(x = carat, color=cut)) +
        geom_histogram(binwidth = 0.1)

ggplot(data = smaller, mapping = aes(x = carat, colour = cut)) +
        geom_freqpoly(binwidth = 0.1)

ggplot(diamonds) + 
        geom_histogram(mapping = aes(x = y), binwidth = 0.5) +
        coord_cartesian(xlim = c(0, 10)) 



# Exercise 7.3.4

diamonds
?diamonds

# 10 different variables.

# 1. Explore the distribution of each of the x, y, and z 
# variables in diamonds. What do you learn? 
# Think about a diamond and how you might decide which 
# dimension is the length, width, and depth.

ggplot(diamonds) +
        geom_histogram(mapping = aes(x=carat), bins=50)

ggplot(diamonds) +
        geom_histogram(mapping = aes(x=price), bins = 100)

ggplot(diamonds) +
        geom_histogram(mapping = aes(x=x), bins = 100)

ggplot(diamonds) +
        geom_histogram(mapping = aes(x=y), bins = 100)

ggplot(diamonds) +
        geom_histogram(mapping = aes(x=z), bins = 100)

# All of them are in mm
# Guessing that X is length, since it's the most variable.
# Logically, width should be bigger than depth, hence width is y
# since mean is about 5-15, while depth at 0-5 is z


# 2. Explore the distribution of price. 
# Do you discover anything unusual or surprising? 
# (Hint: Carefully think about the binwidth and make 
# sure you try a wide range of values.)

ggplot(diamonds) +
        geom_histogram(mapping = aes(x=price), bins = 100) + 
        coord_cartesian(xlim = c(0, 5000)) 


# I would expect a smooth curve, but there appears to be an outlier
# gap at price $1800


# 3. How many diamonds are 0.99 carat? 
# How many are 1 carat? 
# What do you think is the cause of the difference?

diamonds %>%
        filter(carat == 0.99) %>%
        count()


diamonds %>%
        filter(carat == 1) %>%
        count()

# likely due to rounding issues, we all prefer a nicer number



        
# 4. Compare and contrast coord_cartesian() vs xlim() or 
# ylim() when zooming in on a histogram. 
# What happens if you leave binwidth unset? 
# What happens if you try and zoom so only half a bar shows?

ggplot(diamonds) +
        geom_histogram(mapping = aes(x=price)) +
        coord_cartesian(xlim = c(300, 550)) 

# Just one block can be seen




# 7.4 Missing Values

diamonds2 <- diamonds %>% 
        mutate(y = ifelse(y < 3 | y > 20, NA, y))

min(diamonds2$y)

?mutate


# Exercises 7.4.1

# 1. What happens to missing values in a histogram? 
# What happens to missing values in a bar chart? 
# Why is there a difference?

# U get a warning

ggplot(data=diamonds) + 
        geom_bar(mapping=aes(x=cut))

# Both say that they have been removed
# However, barplot will create a new category signifying missing data





# 2. What does na.rm = TRUE do in mean() and sum()?

diamonds %>%
        group_by(cut) %>%
        summarise(is.na(cut))

table(is.na(test$y))

mean(test$y, na.rm=TRUE)
mean(test$x)


# Basically, without na.rm, the summary value will be NA
# as long as one NA value exists in the column




# 7.5 Covariation

# 7.5.1 A categorical and continuous variable


ggplot(data = diamonds, mapping = aes(x = price)) + 
        geom_freqpoly(mapping = aes(colour = cut), binwidth = 500)

ggplot(data = diamonds, mapping = aes(x = price, y = ..density..)) + 
        geom_freqpoly(mapping = aes(colour = cut), binwidth = 500)

ggplot(data = diamonds, mapping = aes(x = cut, y = price)) +
        geom_boxplot()


# generally important to reorder the boxplot based on the
# heirarchy of your categorical variables
# for ease of comparison.




# Exercises 7.5.1.1

# 1. Use what you’ve learned to improve the visualisation of the 
# departure times of cancelled vs. non-cancelled flights.

ggplot(flights) +
        geom_bar(mapping=aes(x=))

flights_2 = flights %>%
        mutate(cancelled = if_else(is.na(dep_time), "Cancelled", "Not Cancelled")) %>%
        mutate(hour = sched_dep_time %/% 100)


ggplot(data = flights_2, aes(hour, ..count..)) + 
        geom_bar(mapping = aes(fill = cancelled))


ggplot(data = flights_2, mapping = aes(x = cancelled, y = hour)) +
        geom_boxplot()


# 2. What variable in the diamonds dataset is most important for 
# predicting the price of a diamond? How is that variable correlated with cut? 
# Why does the combination of those two relationships 
# lead to lower quality diamonds being more expensive?

ggplot(data = diamonds, mapping = aes(x = price)) + 
        geom_freqpoly(mapping = aes(colour = cut), binwidth = 500)

ggplot(data = diamonds, mapping = aes(x = price, y = ..density..)) + 
        geom_freqpoly(mapping = aes(colour = cut), binwidth = 500)

ggplot(data=diamonds, mapping=aes(x=color, y=price)) + 
        geom_boxplot()

ggplot(data=diamonds, mapping=aes(x=clarity, y=price)) + 
        geom_boxplot()


ggplot(data=diamonds, mapping=aes(x=depth, y=price)) + 
        geom_point()
ggplot(data=diamonds, mapping=aes(x=table, y=price)) + 
        geom_point()
ggplot(data=diamonds, mapping=aes(x=x, y=price)) + 
        geom_point()
ggplot(data=diamonds, mapping=aes(x=y, y=price)) + 
        geom_point()
ggplot(data=diamonds, mapping=aes(x=z, y=price)) + 
        geom_point()

ggplot(data=diamonds, mapping=aes(x=price, y=))
# carat, cut, color, clarity, depth, table, price, x,y, z

# Carat is the best



 # 3. Install the ggstance package, and create a horizontal boxplot. 
# How does this compare to using coord_flip()?

ggplot(data = mpg) +
        geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median), y = hwy)) +
        coord_flip()

??ggstance

        
# 4. One problem with boxplots is that they were developed in an 
# era of much smaller datasets and tend to display a prohibitively 
# large number of “outlying values”. One approach to remedy this 
# problem is the letter value plot. Install the lvplot package, 
# and try using geom_lv() to display the distribution of price vs cut. 
# What do you learn? How do you interpret the plots?

ggplot(diamonds, aes(x=price,y=cut)) + 
        geom_lv()

        
# 5. Compare and contrast geom_violin() with a facetted geom_histogram(), 
# or a coloured geom_freqpoly(). What are the pros and cons of each method?
        
# 6. If you have a small dataset, it’s sometimes useful to use geom_jitter() 
# to see the relationship between a continuous and categorical variable. 
# The ggbeeswarm package provides a number of methods similar to geom_jitter().
# List them and briefly describe what each one does.



