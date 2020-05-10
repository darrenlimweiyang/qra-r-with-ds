library(tidyverse)


mpg

# Let’s use our first graph to answer a question: Do cars with big engines use
# more fuel than cars with small engines? You probably already have an answer, 
# but try to make your answer precise. 
# What does the relationship between engine size and fuel efficiency look like? 
# Is it positive? Negative? Linear? Nonlinear?



# Plot Number One
# GGplot will create a empty plot, knowing that the data you want is mpg
# It proceeds to use geom_point to map the x and y axis
ggplot(data=mpg) + geom_point(mapping = aes(x=displ, y=hwy))


# We will be using this format

#ggplot(data = <DATA>) + 
#  <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))


# Exercise 3.2.4
# Run ggplot(data = mpg). What do you see? - Just an empty space.
ggplot(data=mpg)


# How many rows are in mpg? How many columns?
# 234 rows, 11 columns
length(mpg)
mpg

# What does the drv variable describe? Read the help for ?mpg to find out.
?mpg
# DRV refers to f = front-wheel drive, r = rear wheel drive, 4 = 4wd

# Make a scatterplot of hwy vs cyl.
ggplot(data=mpg) + geom_point(mapping = aes(x=hwy, y=cyl))
# We see that as hwy increase, cyl generally decreases
# cyl - number of cylinders, hwl - miles per gallon. More cylinders, less miles/gallon

# What happens if you make a scatterplot of class vs drv? Why is the plot not useful?
ggplot(data=mpg) + geom_point(mapping = aes(x=class, y=drv))
# Not useful because there's not enough types of vehicles to determine anything
# Also, the class of the vehicle generally dictates what sort of drive it has alreqdy


################ 3.3

# Right now, we can one more dimension to the 2-d scatterplot
ggplot(data=mpg) + geom_point(mapping=aes(x=displ, y=hwy, color=class))
ggplot(data=mpg) + geom_point(mapping=aes(x=displ, y=hwy, alpha=class))
ggplot(data=mpg) + geom_point(mapping=aes(x=displ, y=hwy, shape=class))

# Basically, we learnt that it's pretty easy to us geom_point to extend to 3d.
# it's important to note that some methods are more effectiv than others

# We learnt the purpos of ggplot, geom_point and aes.
# Basically, ggplot to input the data, aes to decide the variables and shape if we need more

ggplot(data=mpg) + geom_point(mapping=aes(x=displ, y=hwy), color="pink")

################ Exercise 3.3.1

# What’s gone wrong with this code? Why are the points not blue?
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = "blue"))
# the color needs to be outside of aes()

# Which variables in mpg are categorical? 
# Which variables are continuous? 
# (Hint: type ?mpg to read the documentation for the dataset). 
# How can you see this information when you run mpg?

?mpg


# Map a continuous variable to color, size, and shape. 
# How do these aesthetics behave differently for categorical vs. continuous variables?
ggplot(data=mpg) + geom_point(mapping=aes(x=displ, y=hwy, color=hwy))
ggplot(data=mpg) + geom_point(mapping=aes(x=displ, y=hwy, size=hwy))

ggplot(data=mpg) + geom_point(mapping=aes(x=displ, y=hwy, shape=hwy))
# Cont variable can't be mapped to shape

# What happens if you map the same variable to multiple aesthetics?
ggplot(data=mpg) + geom_point(mapping=aes(x=displ, y=hwy, size=hwy, color=hwy))


# What does the stroke aesthetic do? What shapes does it work with? (Hint: use ?geom_point)

ggplot(data=mpg) + geom_point(mapping=aes(x=displ, y=hwy, stroke=displ))
#Stroke basically is something likee size


# What happens if you map an aesthetic to something other than a variable name, 
# like aes(colour = displ < 5)? Note, you’ll also need to specify x and y.
ggplot(data=mpg) + geom_point(mapping=aes(x=displ, y=hwy, color=displ<5))
# Gives me a true false, based on the mapped logic





################ 3.4 - Common Problems

################ 3.5 - Facets: Splitting up your plot

ggplot(data=mpg) + geom_point(mapping=aes(x=displ, y=hwy)) +
  facet_wrap(~class, nrow=2)
# Basically, the scatter plot, divided by class.


ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ cyl)
# Scatter plot again, but now segmented by two categorical variables


################ Exercise 3.5.1

# 1. What happens if you facet on a continuous variable?
ggplot(data=mpg) + geom_point(mapping=aes(x=displ, y=cty)) +
  facet_wrap(~hwy, nrow=2)

# technically still can, just alot

# 2. What do the empty cells in plot with facet_grid(drv ~ cyl) mean? 
# How do they relate to this plot?
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = drv, y = cyl))
# I think cause  this plot don't hav data point in very box. So if you facet it, become wors

# 3. What plots does the following code make? What does . do?

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)
# Basically just a period to the function, the drv ~ . or ~ drv will determine whether is 
# horizontal or vertical

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)
# Same


# 4. Take the first faceted plot in this section:
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class)) 

# What are the advantages to using faceting instead of the colour aesthetic? 
# What are the disadvantages? 
# How might the balance change if you had a larger dataset?
# Basically, if you do a comparison, with faceting, it's clearl divided across the variable you select
# It might be better for large datasets becaus the color can get crowded.
# More difficult to determine outliers though


# 5. Read ?facet_wrap. What does nrow do? 
# What does ncol do?
# What other options control the layout of the individual panels? 
# Why doesn’t facet_grid() have nrow and ncol arguments?

?facet_wrap
# Basically, instead of facetgrid, facet wrap try to squeeze, based on how many nrow and ncol u input




# 6. When using facet_grid() you should usually put the variable with 
# more unique levels in the columns. Why?

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(~ class)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, ncol = 2)  




## 3.6 GEOMETRIC OBJECTS

# left
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

# right
ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))

# We can use the group aesthetic to display multiple rows of data.
# Group aesthetic for a categorical object to draw many
# 


ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, group = drv))

ggplot(data = mpg) +
  geom_smooth(
    mapping = aes(x = displ, y = hwy, color = drv),
    show.legend = FALSE
  )

# To add many geoms to the same plot, we just add many geom functions to the same ggplot
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  geom_smooth(mapping = aes(x = displ, y = hwy, group=drv))


ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth()

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth()

# Basically, there's a difference between global and local layers for each specific ggplot function


ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth(data = filter(mpg, class == "subcompact"), se = FALSE)


# Exercise 3.6.1
# What geom would you use to draw a line chart? A boxplot? A histogram? An area chart?

ggplot(data=mpg, mapping = aes(x=displ, y=hwy)) + 
  geom_smooth()

ggplot(data=mpg, mapping = aes(x=displ)) + 
  geom_histogram()


# 2. Run this code in your head and predict what the output will look like. 
# Then, run the code in R and check your predictions.

ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
  geom_point() + 
  geom_smooth(se = FALSE)

# 3. What does show.legend = FALSE do? What happens if you remove it?
#  Why do you think I used it earlier in the chapter?

# Removes the legend from the plot. Make it less confusing. 

# 4. What does the se argument to geom_smooth() do?

ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
  geom_point() + 
  geom_smooth()

# se is the standard error of the lines


# 5. Will these two graphs look different? Why/why not?

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth()

ggplot() + 
  geom_point(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_smooth(data = mpg, mapping = aes(x = displ, y = hwy))

# Same, is just local vs global mapping for the function


# 6. Recreate the R code necessary to generate the following graphs.

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth(se = FALSE)

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth(mapping = aes(line=drv), se=FALSE)



ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color=drv)) + 
  geom_point() + 
  geom_smooth(se=FALSE)

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping=aes(color=drv)) + 
  geom_smooth(se=FALSE)

ggplot(data = mpg, mapping = aes(x = displ, y = hwy, linetype=drv, color=drv)) + 
  geom_point() + 
  geom_smooth(se=FALSE)

ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color=drv)) + 
  geom_point()



##################### 3.7 Statistical Transformations

# 3.7.1 Exercises

# 1. What is the default geom associated with stat_summary()? 
# How could you rewrite the previous plot to use that geom 
# function instead of the stat function?
ggplot(data = diamonds) + 
  stat_summary(
    mapping = aes(x = cut, y = depth),
    fun.ymin = min,
    fun.ymax = max,
    fun.y = median
  )

?stat_summary

ggplot(data = diamonds) +
  geom_pointrange(
    mapping = aes(x = cut, y = depth),
    stat = "summary",
    fun.ymin = min,
    fun.ymax = max,
    fun.y = median
  )


# The default is geom_pointrage


# 2. What does geom_col() do? How is it different to geom_bar()?
?geom_col

ggplot(data=diamonds) + 
  geom_col(mapping=aes(x=cut, y=depth))

ggplot(data=diamonds) + 
  geom_bar(mapping=aes(x=cut))

# geom_col sums up the y-valus you input, while geom_bar gives u essentially a histogram
  

# 3. Most geoms and stats come in pairs that are almost always used in concert.
# Read through the documentation and make a 
# list of all the pairs. What do they have in common?
?geom_bar
?geom_line

  
# 4. What variables does stat_smooth() compute? 
# What parameters control its behaviour?
?stat_smooth
# Very similar to geom_smooth
# mainly the position
  
# 5. In our proportion bar chart, we need to set group = 1. 
# Why? In other words what is the problem with these two graphs?
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = ..prop..))
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = color, y = ..prop..))

# never specify the proportion

# Correct Code
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = stat(prop), group = 1))

?geom_bar



#####################  3.8 Position Adjustments


















  
  


