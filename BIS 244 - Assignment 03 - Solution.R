# Solution file for BIS 244 Assignment 03 Spring 2022
# Grading Rubric:
# Note: overall grade is 100 points. Things to look for include:
#   Failure to successfully import files from COVID-19 subfolder: 20 points
#   Date inappropriately imported and left as character vector: 10 points
#   Failure to set incr_cases on row 1 to cases on row 1: 10 points

# First, clear memory and the Console 

rm(list=ls(all=TRUE))
cat("\014")

library(here)
library(tidyverse)

# Import data into dataframe
LIVE <- read_csv(here("covid-19-data","live","us-counties.csv"))
RECENT <- read_csv(here("covid-19-data","us-counties-recent.csv"))
COUNTIES2020 <- read_csv(here("covid-19-data","us-counties-2020.csv"))
COUNTIES2021 <- read_csv(here("covid-19-data","us-counties-2021.csv"))
COUNTIES2022 <- read_csv(here("covid-19-data","us-counties-2022.csv"))

COUNTIES <- rbind(COUNTIES2020, COUNTIES2021,COUNTIES2022,RECENT,LIVE)


# Filter down to PA and Lehigh only
LEHIGH <- COUNTIES %>% filter(state=="Pennsylvania" & county == "Lehigh")

LEHIGH <- distinct(LEHIGH,date,.keep_all=TRUE)


# Set n to length of data set
n <- length(LEHIGH$date)

# Initialize new variables in data frame
LEHIGH$incr_deaths <- LEHIGH$deaths[1]
LEHIGH$incr_cases <- LEHIGH$cases[1]

# Calculate values for incremental cases and deatchs
for (i in 2:n) {
  LEHIGH$incr_cases[i] <- LEHIGH$cases[i] - LEHIGH$cases[i-1]
  LEHIGH$incr_deaths[i] <- LEHIGH$deaths[i] - LEHIGH$deaths[i-1]
}

p <- ggplot(data = LEHIGH)
p + geom_line(color="blue", mapping = aes(x = date, y = incr_cases)) +
  labs(x = "Date", 
       y = "New Cases Reported",
       title = "COVID-19 Cases Reported in Lehigh, PA")
