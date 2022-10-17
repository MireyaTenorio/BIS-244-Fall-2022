# BIS 244 Fall 2022 Sample Midterm Applied Solutions

# Load packages I'm going to use
library(tidyverse)
if (!require("here")) install.packages("here")
library(here)

# Read in us-counties.csv
AAPL <- read_csv("AAPL.csv")

# Create changes in Adjusted Closing Prices

n <- length(AAPL$Date)

AAPL$Change <- NA
AAPL$UpDown <- NA

# Calculate values for changes in Adjusted Closing Prices
for (i in 2:n) {
  AAPL$Change[i] <- AAPL$"Adj Close"[i]-AAPL$"Adj Close"[i-1]
  if (AAPL$Change[i]<0) {
    AAPL$UpDown[i] <- "Down"
  } else{
    AAPL$UpDown[i] <- "Up"
  }
}


# Make graph

p <- ggplot(data = AAPL,
            mapping = aes(x = Date, y = Change, color = UpDown))
p + geom_point() +
  labs(x = "Date", y = "Change in Adjusted Closing Price",
       title = "Changes in AAPL Prices Over 5-Year Span",
       subtitle = "Graph Produced by Troy Adair, October 2, 2022")
