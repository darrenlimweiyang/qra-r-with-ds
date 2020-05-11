library(tidyverse)


seq(1,10)

x <- "hello world"

(y <- seq(1, 10, length.out = 5))


# 4.4 Exercises

# 1. Why does this code not work?
my_variable <- 10
my_varıable

# The i value is different

# 2. Tweak each of the following R commands so that they run correctly:

library(tidyverse)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))


filter(mpg, cyl = 8)

filter(diamonds, carat > 3)

