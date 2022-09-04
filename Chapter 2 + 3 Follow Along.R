#Chapter 2 + 3 Follow Along 

###Chapter2 
getwd()

#This will create a scatterplot 
#Overall representation of the work that will be able to do 
install.packages("ggplot2")
install.packages("gapminder")
library(ggplot2)
library(gapminder)

p <- ggplot(data=gapminder,
              mapping = aes(x=gdpPercap, y =lifeExp))

p+ geom_point()

#Features of ggplot 
# -- all should have ggplot() in the beginning and add the following with "+"


# -- geom_point() makes scatterplots 

# -- geom_bar() makes bar plots 

# -- geom_boxplot() makes boxplots

#####Chapter 2 Videos 
##Video 2B
# -- Troy disagrees that it's best to put notes in RMarkdown file
# says this bc we will mostly use code NOT the notes
# double pound signs mean the whole next thing is a note on RMarkdown
#Use BIS244 class directory to see all data 
# the dataviz_course_notes has all notes to do things

## all that happened on Chapter 2 was that he installed a lot of packages
my_packages <- c("tidyverse", "broom", "coefplot", "cowplot", "drat",
                 "gapminder", "GGally", "ggrepel", "ggridges", "gridExtra",
                 "here", "interplot", "margins", "maps", "mapproj",
                 "mapdata", "MASS", "quantreg", "rlang", "scales", "socviz",
                 "survey", "srvyr", "viridis", "viridisLite", "devtools")
install.packages(my_packages, repos = "http://cran.rstudio.com")
#if get pop up, normally just say yes and update the source - DO NOT NOW 

##Video 2C
#Check a few packages: 
library(gapminder)
library(here)
library(socviz)
library(tidyverse)
library(ggplot2)
library(tibble)
library(readr)

# vectors 
c(1,2,3,4,5)
#In order to save it you have to assign it to a variable 
my_numbers <- c(1,2,3,4,5)
#to print the numbers 
my_numbers

#can do arthmitic functions w/ that vector
#the class function tells you what class it is 
# if you have numbers and characters it will autom. be a character vector 
class(my_numbers)

#str will give you as much data about the variable 
str(my_numbers)

#can convert a data frame into a table somehow 

#you can save a url vcs doc as a variable here 
#use read.csv or read_csv 


##Video 2D




#### Chapter 3 
##GGPLOT Uses 
# -- 1 tell it what data to use 
# -- them tell it what to map eg) mapping = aes(x=gdpPercap , y=lifeExp)
# -- the aes links variables 

Tidy Data (tidyverse) -- data in long form? 








