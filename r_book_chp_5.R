
library(nycflights13)
library(tidyverse)

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

1:3 + 1:10








