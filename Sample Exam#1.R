# Mireya Tenorio 


#load packages into memory 
library(tidyverse)
library(socviz)
library(here)

apple <- read_csv(here("AAPL.csv"))
view(apple)

n <- length(apple$`Adj Close`)
apple$Changes_Adj_CP <- 1

for (i in 2:n) {
  apple$Changes_Adj_CP[i] <- (apple$`Adj Close`[i]-apple$`Adj Close`[i-1]) 
}


p <- ggplot(data = apple,
            mapping = aes(x = Date, y = Changes_Adj_CP)

p + geom_point(color="light blue")+
  labs(x = "Date", y = "Changes in Adjusted Closing Price",
       title = "Changes in AAPL Prices Over 5-Year Span",
       subtitle= "Graph Produced by Mireya Tenorio, Ocotber 21,2022")

#have to change colors 

