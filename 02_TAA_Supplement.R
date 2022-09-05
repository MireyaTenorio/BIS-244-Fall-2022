# This script is designed to provide a refresher/introduction
# of the topic of IF..ELSE statements and FOR loops

# The following assume you already have the covid-19-data repo
# set up as a submodule of the BIS-244-Fall-2020 repo, and that
# you have that data set up as a subfolder of this project's
# folder.

# Clear out Console and Environment
#this clears out environment
rm(list=ls(all=TRUE))
#this clears out console 
cat("\014")

# Let's read in the us-counties file from covid-19-data

# We'll use package readr, which is part of the tidyverse
library(tidyverse)

# Storing the path of the current working directory
Temp <- getwd()

# Switching the working directory to the covid-19-data subfolder
setwd("./covid-19-data/")

# Reading the us.counties.csv in as a data frame
COUNTIES <- read_csv("us-counties.csv")

# Switching the working directory back to the project folder
setwd(Temp)


### Ignore above way and do below option 
# Alternative way to access subfolders
library(here) #this tells you where the working directory is 
COUNTIES <- read_csv(here("covid-19-data","us-counties.csv")) #now start there, and get the following subfolder, each quote is a sublevel

# Examining the data
View(COUNTIES)

# Using filter()to get just Snohomish county in Washington
SNOHOMISH <- filter(COUNTIES, state=="Washington" &
                      county=="Snohomish")
View(SNOHOMISH)

## steps to how many incremental cases have there been? 
# -- 1 figure out how many rows there are via length 
# Set n to length of data set --- n is basically each record 
# variable$date
n <- length(SNOHOMISH$date)

# -- 2 add new varible to data frame 
#the new column is incr_cases (what's after the variable)
# Initialize new variable in data frame
#full of ones bc you know each time it increased by 1 at first, but will adjust in step 3 
SNOHOMISH$incr_cases <- 1

View(SNOHOMISH)

# -- 3 use for loop to calculate the rest of the increments 
# first parenthesis (argument) is the looping varible (what will be in the other part & when it will stop 
#must start with row 2 bc if start with row 1 there's no data -- also already did row 1 
#for the changes in the first day (row 2), calculate the changes of what it is today - yesterday 
# Calculate values for other than first row using FOR loop

for (i in 2:n) {
  SNOHOMISH$incr_cases[i] <- (SNOHOMISH$cases[i]-SNOHOMISH$cases[i-1]) 
}

View(SNOHOMISH)

# Plot what we've got

p <- ggplot(data = SNOHOMISH,
            mapping = aes(x = date,
                          y = incr_cases))
           
p + geom_point() +
  labs(x = "Dates", y = "Incremental Cases",
       title = "COVID-19 Cases in Snohomish County, WA",
       subtitle = "Data points are incremental new confirmed cases",
       caption = "Source: NY Times")

#the p+ is what makes everything be displayed 
#have to graph the whole code to add everything to the console 

#get upgly line in the bottom bc there are too many 0's 
# Let's replace 0 values with NA using IF..ELSE statement
#if i is equal to 0, then replace to NA, if not(else),leave it 
for (i in 1:n) {
  if (SNOHOMISH$incr_cases[i]==0) {
    SNOHOMISH$incr_cases[i] <- NA
  } else {}
}

View(SNOHOMISH)

# Replot

p <- ggplot(data = SNOHOMISH,
            mapping = aes(x = date,
                          y = incr_cases))

p + geom_point() +
  labs(x = "Dates", y = "Incremental Cases",
       title = "COVID-19 Cases in Snohomish County, WA",
       subtitle = "Data points are incremental new confirmed cases",
       caption = "Source: NY Times")

# Remember, we have replaced some value of incr_cases with NA, so...

mean(SNOHOMISH$incr_cases)
#can't do the mean bc there are N/A added 

# There IS a workaround for some commands, such as mean()
#basically saying remove the NA's below to check the mean 
mean(SNOHOMISH$incr_cases, na.rm=TRUE)
meancases <- mean(SNOHOMISH$incr_cases, na.rm=TRUE)

# Initialize seperate vectors for cases above and below average
SNOHOMISH$above_cases <- 0
SNOHOMISH$below_cases <- 0

# But there is no easy workaround for logical tests, such below where
# we have "NA" in a variable in a logical test inside an IF() statement

for (i in 1:n) {
  if(SNOHOMISH$incr_cases[i]>=meancases) {
    SNOHOMISH$above_cases[i] <- SNOHOMISH$incr_cases[i]
  } else {
    SNOHOMISH$below_cases[i] <- SNOHOMISH$incr_cases[i]
  }
}

# Return incr_cases to what it was when we first computed it

SNOHOMISH$incr_cases <- 1
for (i in 2:n) {
  SNOHOMISH$incr_cases[i] <- (SNOHOMISH$cases[i]-SNOHOMISH$cases[i-1]) 
}

View(SNOHOMISH)

# Assign values to above_cases and below_cases based on whether incr_cases
# is greater than or less than average

for (i in 1:n) {
  if(SNOHOMISH$incr_cases[i]>=meancases) {
    SNOHOMISH$above_cases[i] <- SNOHOMISH$incr_cases[i]
  } else {
    SNOHOMISH$below_cases[i] <- SNOHOMISH$incr_cases[i]
  }
}

View(SNOHOMISH)

# Plot what we've got

p = ggplot() + 
  geom_point(data = SNOHOMISH, aes(x = date, y = above_cases), color = "red") +
  geom_point(data = SNOHOMISH, aes(x = date, y = below_cases), color = "green") +
  labs(x = "Dates", y = "Incremental Cases",
       title = "Incremental COVID-19 Cases in Snohomish County, WA",
       subtitle = "Red = Above Average, Green = Below Average",
       caption = "Source: NY Times")
p

# Now, the values on the x-axis are really ugly, so, replace 0 values with "NA"

for (i in 1:n) {
  if(SNOHOMISH$above_cases[i]==0) {
    SNOHOMISH$above_cases[i] <- NA
  } else {}
  if(SNOHOMISH$below_cases[i]==0) {
    SNOHOMISH$below_cases[i] <- NA
  } else {}
}

# Now, our plot will look much better

p = ggplot() + 
  geom_point(data = SNOHOMISH, aes(x = date, y = above_cases), color = "red") +
  geom_point(data = SNOHOMISH, aes(x = date, y = below_cases), color = "green") +
  labs(x = "Dates", y = "Incremental Cases",
       title = "Incremental COVID-19 Cases in Snohomish County, WA",
       subtitle = "Red = Above Average, Green = Below Average",
       caption = "Source: NY Times")
p

###################################################################################
# Recommend you DO NOT run lines below here unless you want to download
# Yellow Trip data file used in BIS-044 and are prepared to wait
###################################################################################

# Clear out Console and Environment
rm(list=ls(all=TRUE))
cat("\014")

# A timed example of readr::read_csv()
### Run as a block of text to time #########
ptm <- proc.time()
DF <- read_csv("yellow_tripdata_2017-06.csv", col_names=TRUE)
READR_READ_TIME <- (proc.time() - ptm)
READR_READ_TIME

# Reminder of what's in the data
str(DF)

# Tired of typing name of data.frame all the time, so...
attach(DF)

# Store the max value for our FOR loops
n <- length(VendorID)
n

# Was going to take WAY too long to process the whole file, so am only going to 
# process .1 percent

n <- n/1000

# Loop to calculate trip_length (i.e., time of trip)
ptm <- proc.time()
pcter <- 0
for (i in 1:n) {
### This if() command is just to provide the "dots" for visual feedback
    if(pcter >= 2*n/100) {
    cat(".")
    pcter <- 0
  } else {
    pcter <- pcter + 1
  }
###

### The single line below is the main point of the loop, calculating trip_length  
  DF$trip_length[i] <- difftime(tpep_dropoff_datetime[i],tpep_pickup_datetime[i],
                                units="mins")
}
LOOP_TIME <- (proc.time() - ptm)
LOOP_TIME

# Let's see what we got
View(DF)

cat("If we had processed the whole file, would have taken",as.numeric(LOOP_TIME[3], units = "hours"),"hours.")

# Now, will use dplyr::mutate() command, which uses the fact that columns in 
# data frame are vectors, allowing it to "vectorize" calculations

ptm <- proc.time()
DF <- mutate(DF,trip_length2=(tpep_dropoff_datetime - tpep_pickup_datetime)/60)
MUTATE_TIME <- (proc.time() - ptm)
MUTATE_TIME

View(DF)

cat("Took",as.numeric(MUTATE_TIME[3]), units = "seconds")

# Moral of the story: use FOR() loops very cautiously on "big" data
