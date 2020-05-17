
library(nycflights13)
library(tidyverse)
library(ggplot2)
?flights

# What is flights?
# Contains date, departure and arrival time
# delays, carrier name, flight number, tail number, origin and destination

flights

# The difference is that it's a tibble, which is a dataframe, but slightly tweaked to work
# better with tidyverse

# What are the workhorses of dplyr
# Fliter - select specific rows on conditions
# arrange - for ordering
# select() - subsetting variables
# Mutate() - creating new variables
# Summarise() 

# All of them can be used with groupby()


# 5.2 FILTER ############################################

filter(flights, month==1, day==1)

# 5.2.1 Comparisons

sqrt(2) ^ 2 == 2
#> [1] FALSE
1 / 49 * 49 == 1
#> [1] FALSE

near(sqrt(2) ^ 2,  2)
#> [1] TRUE
near(1 / 49 * 49, 1)
#> [1] TRUE

# Use near

# 5.2.2 Logical Operators


filter(flights, month == 11 | month == 12)

nov_dec <- filter(flights, month %in% c(11, 12))

# both are the same because we can use month in the list provided


# note that filter will ignore na values, we need to explicitly ask for them

df <- tibble(x = c(1, NA, 3))
df
filter(df, x > 1)

(filter(df, is.na(x) | x > 1))



# 5.2.4 Exercises

#  Find all flights that

# 1. Had an arrival delay of two or more hours
filter(flights, dep_delay >= 120)

# 2. Flew to Houston (IAH or HOU)
(filter(flights, dest == "IAH" | dest == "HOU"))

# 3. Were operated by United, American, or Delta
(filter(flights, carrier %in% c("UA", "AA", "DL")))

# 4. Departed in summer (July, August, and September)
(filter(flights, month %in% c(7,8,9)))

# 5. Arrived more than two hours late, but didn’t leave late
(filter(flights, arr_delay > 120, dep_delay <= 0))


# 6. Were delayed by at least an hour, but made up over 30 minutes in flight
(filter(flights, dep_delay >= 60  & (arr_delay - dep_delay) >= 30))


# 7. Departed between midnight and 6am (inclusive)
(filter(flights, dep_time <= 0600 | dep_time == 2400))


# 2. Another useful dplyr filtering helper is between(). What does it do? 
# Can you use it to simplify the code needed to answer the previous challenges?
?between()
# What between does is to allow you to check for integers between two specific values, or a range


# 3. Hw many flights have a missing dep_time? What other variables are missing? 
# What might these rows represent?
(filter(flights, is.na(dep_time)))
# 8,255 rows have a missing departure time
# These rows are likely flights that got cancelled


# 4. Why is NA ^ 0 not missing? 
# Why is NA | TRUE not missing? Why is FALSE & NA not missing? 
# Can you figure out the general rule? (NA * 0 is a tricky counterexample!)

NA ^ 0
# anything to the power of 0 is 1, even nothing

# NA | TRUE takes into account the "better" of the union, as long as one is true, it returns true. 

# False overpowers NA

# In general, the tiering is that NA is the lowest. 


# 5.3 Arrange rows with arrange()


# Basiscally, as many columsn as you want, descending or ascending
# missing values are always last

# Exercise 5.3.1


# 1. How could you use arrange() to sort all missing values to the start? (Hint: use is.na()).
arrange(flights, is.na())
arrange(flights, desc(is.na(dep_time)))


?arrange()

# 2. Sort flights to find the most delayed flights. Find the flights that left earliest.

arrange(flights, desc(arr_delay, dep_delay))

arrange(flights, dep_delay)

# 3. Sort flights to find the fastest (highest speed) flights.

View(arrange(flights, air_time))


# 4. Which flights travelled the farthest? Which travelled the shortest?
arrange(flights, distance)
arrange(flights, desc(distance))





# 5.4 Select Columns with select()


# Select purpose
# Various string functions to combine with select
# rename is a subset of select

# 5.4.1 Exercises

# 1. Brainstorm as many ways as possible to select dep_time, dep_delay, arr_time, 
# and arr_delay from flights.
flights

select(flights, dep_time, dep_delay, arr_time,arr_delay)
select(flights, dep_time:arr_delay)
select(flights, starts_with("dep"), starts_with("arr"))



# 2. What happens if you include the name of a variable multiple times in a select() call?
select(flights, dep_time, dep_time, dep_time)
# Nothing


# 3. What does the one_of() function do? Why might it be helpful in conjunction with this vector?
vars <- c("year", "month", "day", "dep_delay", "arr_delay")


# 4. Does the result of running the following code surprise you? 
#  How do the select helpers deal with case by default? How can you change that default?

select(flights, contains("TIME", ignore.case=FALSE))

# Surprised cause i thought casing matters

?contains()


# 5.5 Add new variables with mutate()

flights_sml <- select(flights, 
                      year:day, 
                      ends_with("delay"), 
                      distance, 
                      air_time
)
mutate(flights_sml,
       gain = dep_delay - arr_delay,
       speed = distance / air_time * 60
)

mutate(flights_sml,
       gain = dep_delay - arr_delay,
       hours = air_time / 60,
       gain_per_hour = gain / hours
)


# 5.5.1 Useful creation functions!

# Basic Math
# Lead lag
# Cumsum/cummean
# Ranking

# 5.5.2 Exercises


# 1. Currently dep_time and sched_dep_time are convenient to look at, 
# but hard to compute with because they’re not really continuous numbers. 
# Convert them to a more convenient representation of number of minutes since midnight.

# NOTE
# There are no flights at midnight, hence we can dep_time NA with 0
# There is no missing data in sched_dep_time, but missing data exists in dep_time
# Likely due to cancelled or postponed flights

difftime(as.POSIXct('0334', format = '%H%M'), as.POSIXct('0000', format = '%H%M'), units = 'min') 


diff_in_time <- function(input){
        input = formatC(sprintf("%04d", input), width=4, flag="0")
        as.double(difftime(as.POSIXct(input, format = '%H%M'), as.POSIXct('0000', format = '%H%M'), units = 'min')) 
}

flights$sched_dep_time_min <- lapply(flights$sched_dep_time, diff_in_time)

flights$dep_time[is.na(flights$dep_time)] <- 0

flights$dep_time_min <- lapply(flights$dep_time, diff_in_time)



# 2. Compare air_time with arr_time - dep_time. 
# What do you expect to see? What do you see? What do you need to do to fix it?

# Naturally, I would expect arr_time - dep_time = air_time
# However,upon a cursory inspection, that's not the case.
# Hypothesis that 
# a. Due to the change in timezones
# b. Due to data entry problems
# c. Due to time needed for taxing. 

# However, in this case, I can only test for one specific scenario - A.

# In order to test for this, i would subset flights from a particular timezone. 


flights %>% count(dest, origin)

# Using ABQ - JFK
# ABQ is gmt-6, JFK is gmt-4
# Hence time difference should be two hours

filtered_jfk_abq <- filter(flights, dest == "ABQ", origin=="JFK")
a <- select(filtered_jfk_abq, origin, dest, arr_time, dep_time, air_time)

a$diff = a$arr_time - a$dep_time

a$diff_air_time_diff <- a$air_time - a$diff

# Since the differences are very volatile, it's clear that it's not related to the timezone differences




# 3. Compare dep_time, sched_dep_time, and dep_delay. 
# How would you expect those three numbers to be related?

select(flights, dep_time, sched_dep_time, dep_delay)

# By right, sched_dep_time + dep_delay = dep_time
flights$test <- flights$dep_time - flights$sched_dep_time
flights$test_diff <- flights$test - flights$dep_delay

flights$test_diff
select(flights, sched_dep_time, dep_delay, dep_time, test, test_diff)
        

# 4. Find the 10 most delayed flights using a ranking function. 
# How do you want to handle ties? Carefully read the documentation for min_rank().
?min_rank

# to find the most delayed flights, we only use arr_delay, cause anytime at the scheduled
# delay is made up for

flights$rank <- min_rank(desc(flights$arr_delay))

select(filter(flights, flights$rank < 10),rank, arr_delay)

flights

# Take note of the difference between min_rank and dense rank and how they deal with
# ties

# 5. What does 1:3 + 1:10 return? Why?
1:3 + 1:10
1:3
# you are trying to add the vector [1,2,3] and [1,2,3...,9,10]
# Hence, a length error is thrown

        
# 6. What trigonometric functions does R provide?
# http://www.endmemo.com/program/R/trig.php



# 5.6 Grouped summaries with summarise()



# 5.6.7 Exercises

# 1. Brainstorm at least 5 different ways to assess the typical delay 
# characteristics of a group of flights. Consider the following scenarios:

# a. A flight is 15 minutes early 50% of the time, 
# and 15 minutes late 50% of the time.


# b. A flight is always 10 minutes late.

# c. A flight is 30 minutes early 50% of the time, and 30 minutes late 50% of the time.

# d. 99% of the time a flight is on time. 1% of the time it’s 2 hours late.


# Question: Which is more important: arrival delay or departure delay?
# arrival delay. 
# Departure delay is fine as long as time is made up, no issue. 
        

# 2. Come up with another approach that will give you the same output 
# as not_cancelled %>% count(dest) and not_cancelled %>% count(tailnum, wt = distance) 
# (without using count()).

not_cancelled <- flights %>% 
        filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled %>% count(dest)

table(not_cancelled$dest) # alternative that works


not_cancelled %>% count(tailnum, wt = distance)


aggregate(not_cancelled$distance, by=list(not_cancelled$tailnum), FUN=sum)

# Alternative



# 3. Our definition of cancelled flights (is.na(dep_delay) | is.na(arr_delay) ) 
# is slightly suboptimal. Why? Which is the most important column?

# All flights that are is.na(dep_delay) will be is.na(arr_delay)
# The most important column is dep_time


        

# 4. Look at the number of cancelled flights per day.
# Is there a pattern? 
# Is the proportion of cancelled flights related to the average delay?

cancelled_flights <- filter(flights, is.na(dep_time))
cancelled <- cancelled_flights %>% 
        count(month,day)

all_flights <- flights %>%
        count(month,day)

combined_df <- all_flights %>% left_join(cancelled, by=c("month", "day"))

combined_df$proportion <- (combined_df$n.y / combined_df$n.x)*100        

by_day <- group_by(flights, month, day)
avg_delay <- summarise(by_day, delay = mean(dep_delay, na.rm = TRUE))

final_df <- combined_df %>% left_join(avg_delay, by=c("month", "day"))

ggplot(data=final_df) + geom_point(mapping = aes(y=proportion, x=delay))
# Somewhat linear relationship

filter(final_df, proportion > 50)

# https://en.wikipedia.org/wiki/Early_February_2013_North_American_blizzard
# 1/2 of all flights cancelled due to Blizzard in NA




# 5. Which carrier has the worst delays? Challenge: 
# can you disentangle the effects of bad airports vs. bad carriers? 
# Why/why not? (Hint: think about flights %>% group_by(carrier, dest)
# %>% summarise(n()))

# To find out which carriers has the worst delays, we can
# group by carriers and obtain average delay per carrier

by_car <- group_by(flights, carrier)
avg_delay <- summarise(by_car, delay = mean(dep_delay, na.rm = TRUE))
arrange(avg_delay, delay)

# Can I disentagle effects of bad airports vs bad carriers
df_flights_delay_by_carrier_airport <- flights %>%
        group_by(carrier, dest) %>%
        summarise(delay=mean(arr_delay, na.rm=TRUE)) %>%
        left_join(flights %>% 
                          group_by(carrier, dest) %>% 
                          summarise(n()), by=c("carrier", "dest"))

arrange(df_flights_delay_by_carrier_airport, dest)




# 6. What does the sort argument to count() do. When might you use it?
?count()
# Whether you wanna sort the output dataframe




# 5.7 Grouped Mutates (and filters)



# 1. Refer back to the lists of useful mutate and filtering functions. 
# Describe how each operation changes when you combine it with grouping.
# <SKIP>


# 2. Which plane (tailnum) has the worst on-time record?
# What's on-time -  proportion of flights delayed or cancelled
# Highest Average Arrival Delay

arrange(flights %>% 
        group_by(tailnum) %>%
        summarise(delay=mean(arr_delay, na.rm=TRUE)), desc(delay))

# Second way is the proportion of flights delayed


        
# 3. What time of day should you fly if you want to avoid delays 
# as much as possible?
cancelled_flights <- filter(flights, is.na(dep_time))
cancelled <- cancelled_flights %>% 
        count(month,day)

flights %>% 
        group_by(hour) %>%
        summarise(delay=mean(arr_delay, na.rm=TRUE)) %>%
        left_join(flights %>% 
                          count(hour), by="hour")
        


# 4. For each destination, compute the total minutes of delay. 
# For each flight, 
# compute the proportion of the total delay for its destination.

filter(flights, arr_delay>0) %>%
        group_by(dest) %>%
        summarise(total_delay=sum(arr_delay, na.rm=TRUE))

delays_sum <- filter(select(flights, arr_delay, flight, dest), arr_delay > 0) %>%
        left_join(filter(flights, arr_delay>0) %>%
        group_by(dest) %>%
        summarise(total_delay=sum(arr_delay, na.rm=TRUE)),by="dest")

delays_sum$prop <- (delays_sum$arr_delay / delays_sum$total_delay)*100
arrange(delays_sum, desc(prop))




# 5. Delays are typically temporally correlated:
# even once the problem that caused the initial delay has been resolved, 
# later flights are delayed to allow earlier flights to leave. 
# Using lag(), 
# explore how the delay of a flight is related to the delay of the 
# immediately preceding flight.

select(arrange(flights, year, month, day, origin, dep_time, sched_dep_time),
       month, day, dep_time, sched_dep_time, dep_delay, origin)

flights

lagged_delays <- flights %>%
        arrange(origin, month, day, dep_time) %>%
        group_by(origin) %>%
        mutate(dep_delay_lag = lag(dep_delay)) %>%
        filter(!is.na(dep_delay), !is.na(dep_delay_lag))

lagged_delays %>%
        group_by(dep_delay_lag) %>%
        summarise(dep_delay_mean = mean(dep_delay)) %>%
        ggplot(aes(y=dep_delay_mean, x= dep_delay_lag)) + 
        geom_point() + 
        scale_x_continuous(breaks = seq(0, 1500, by=120)) + 
        labs(y = "Dearture Delay", x = "Previous Departure Delay")

# 6. Look at each destination. 
# Can you find flights that are suspiciously fast? 
# (i.e. flights that represent a potential data entry error). 
# Compute the air time of a flight relative to the 
# shortest flight to that destination. Which flights were most delayed in the air?


flights %>% 
        group_by(dest) %>%
        summarise(mean(air_time, na.rm=TRUE))


# 7. Find all destinations that are flown by at least two carriers. 
# Use that information to rank the carriers.

flights %>%
        group_by(dest) %>%
        filter(n_distinct(carrier) > 2) %>%
        group_by(carrier, dest) %>%
        summarise(n=n_distinct(dest)) %>%
        count(carrier) %>%
        arrange(desc(nn))

        


# 8. For each plane, 
# count the number of flights before the first delay of greater than 1 hour.

flights %>% 
        select(tailnum, month, day, dep_delay, arr_delay)
        

ranked_df <- select(flights %>%
        group_by(tailnum) %>%
        mutate(my_ranks = order(month,day)), tailnum, month, day, dep_delay, arr_delay, my_ranks)
                

View(filter(ranked_df, dep_delay >= 60) %>%
        group_by(tailnum) %>%
        slice(which.min(my_ranks)))

# Hence this dataframe gives me the number of flights (n-1) before the first delay > 60







