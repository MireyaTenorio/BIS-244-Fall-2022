## Intended to accompany BIS 244 Video Set 07

library(gapminder)
library(here)
library(tidyverse)
library(socviz)


## 5.1 Use Pipes to Summarize Data

rel_by_region <- gss_sm %>%
    group_by(bigregion, religion) %>%
    summarize(N = n()) %>%
    mutate(freq = N / sum(N),
           pct = round((freq*100), 0))

# Let's see what we did

gss_sm <- gss_sm #assign it to itself so it shows up in environment
View(gss_sm) 
View(rel_by_region) #groups by the same religion and big region 


# The code above is the same as 

temp1 <- group_by(gss_sm, bigregion, religion) #grouping by big region and religion
temp2 <- summarize(temp1, N = n())
rel_by_region2 <- mutate(temp2, freq = N / sum(N), pct = round((freq*100), 0))


# Look at gss_sm vs. temp1 to see what group_by does 
temp1
gss_sm
#they look almost the same, but temp1 specifically shows the groups 


# Look at temp2

temp2
#this one just summarizes the results of the big region and religions 

# Look at rel_by_reion vs. rel_by_region2

View(rel_by_region)
View(rel_by_region2)

#rel_by_region2 is the same stuff rel_by_region, but we created it differently 

# Yet a 3rd way to do the same thing:

rel_by_region3 <- mutate(summarize(group_by(gss_sm, bigregion, religion),N = n()),
                         freq = N / sum(N), pct = round((freq*100), 0))



# Back to our data

rel_by_region


# Do the pct values sum to 100?

rel_by_region %>% group_by(bigregion) %>%
    summarize(total = sum(pct))      
#summarize tells us the total for the summary of the percent by big region
#some are not exactly 100 because of rounding 

#below you see you actually don't need the group by 
#it was already grouped 

rel_by_region %>% summarize(total = sum(pct)) 
# Plotting our summarisation 

p <- ggplot(rel_by_region, aes(x = bigregion, y = pct, fill = religion))
p + geom_col(position = "dodge2") +
    labs(x = "Region",y = "Percent", fill = "Religion") +
    theme(legend.position = "top")      

# BTW, "dodge2" is a newer way with thinner columns of doing
#dodge2 is a part of tidyverse and ggplot2 
#dodge2 gives you better column spaces over dodge

p + geom_col(position = "dodge") +
  labs(x = "Region",y = "Percent", fill = "Religion") +
  theme(legend.position = "top")      

# Using facet_grid() to put graphs for each region side-by-side

p <- ggplot(rel_by_region, aes(x = religion, y = pct, fill = religion))
p + geom_col(position = "dodge") +
  labs(x = NULL, y = "Percent", fill = "Religion") +
  guides(fill = FALSE) + 
  facet_grid(~ bigregion)      

# ... and flippling the x- and y- axes....
#flipping with coord_flip()

p + geom_col(position = "dodge") +
    labs(x = NULL, y = "Percent", fill = "Religion") +
    guides(fill = FALSE) + 
    coord_flip() + 
    facet_grid(~ bigregion)   


## 5.2 Continuous Variables by Group or Category

# Let's look at organdata

View(organdata)

# Another way of getting a quick view of the first 6 columns

organdata %>% select(1:6) %>% sample_n(size = 10)      


# A Bad graph
p <- ggplot(data = organdata,
            mapping = aes(x = year, y = donors))
p + geom_point()      

# Very similar to the problem we saw in section 4.2, which we fixed by grouping by country...

p <- ggplot(data = gapminder,
            mapping = aes(x = year,
                          y = gdpPercap))
p + geom_line()       

# We take a similar approach here
p <- ggplot(data = organdata,
            mapping = aes(x = year, y = donors))
p + geom_line(aes(group = country)) + 
  facet_wrap(~ country)      

# Let's summarize this one one graph using geom_boxplot()
#this really shows the distribution of the data 
#doesn't show data chronologically 
p <- ggplot(data = organdata,
            mapping = aes(x = country, y = donors))
p + geom_boxplot()      

# What is being summarized in each "box"?

# Flipping the axes to make the names more readable...
p + geom_boxplot() + coord_flip()      


# ... and reordering the country listings by "donors" mean values
p <- ggplot(data = organdata,
            mapping = aes(x = reorder(country, donors, na.rm=TRUE),
                          y = donors))
p + geom_boxplot() +
    labs(x=NULL) +
    coord_flip()      

# Could also do reorder() by median values...

p <- ggplot(data = organdata,
            mapping = aes(x = reorder(country, donors, median,na.rm=TRUE),
                          y = donors))
p + geom_boxplot() +
  labs(x=NULL) +
  coord_flip()      

# Easy to add colors using "fill" parameter

p <- ggplot(data = organdata,
            mapping = aes(x = reorder(country, donors, na.rm=TRUE),
                          y = donors, fill = world))
p + geom_boxplot() + labs(x=NULL) +
    coord_flip() + theme(legend.position = "top")      


# Same thing, but with geom_point() or geom_jitter() instead of goem_boxplot()
p <- ggplot(data = organdata,
            mapping = aes(x = reorder(country, donors, na.rm=TRUE),
                          y = donors, color = world))
p + geom_point() + labs(x=NULL) +
    coord_flip() + theme(legend.position = "top")

p + geom_jitter() + labs(x=NULL) +
    coord_flip() + theme(legend.position = "top")      

# And can control the amount of jitter

p + geom_jitter(position = position_jitter(width=0.15)) +
  labs(x=NULL) + coord_flip() + theme(legend.position = "top")      

# When would using individual points like this be infeasible?


## ----summarize------------------------------------------------------
by_country <- organdata %>% group_by(consent_law, country) %>%
    summarize(donors_mean= mean(donors, na.rm = TRUE),
              donors_sd = sd(donors, na.rm = TRUE),
              gdp_mean = mean(gdp, na.rm = TRUE),
              health_mean = mean(health, na.rm = TRUE),
              roads_mean = mean(roads, na.rm = TRUE),
              cerebvas_mean = mean(cerebvas, na.rm = TRUE))

by_country


## ----better_summarize-----------------------------------------------
#same thing as above, but summarized
# better if do it like above bc it's easier 
by_country <- organdata %>% 
  group_by(consent_law, country) %>%
    summarize_if(is.numeric, 
                 list(~ mean(., na.rm = TRUE), 
                      ~ sd(., na.rm = TRUE))) %>%
    ungroup()

by_country


# Regardless of how we get there, can use mean and sd with geom_point()
p <- ggplot(data = by_country,
            mapping = aes(x = donors_mean, 
                          y = reorder(country, donors_mean),
                          color = consent_law))
p + geom_point(size=3) +
    labs(x = "Donor Procurement Rate",
         y = "", color = "Consent Law") +
    theme(legend.position="top")      


# ... or can use facet_wrap to get separate graphs for informed and presumed
p <- ggplot(data = by_country,
            mapping = aes(x = donors_mean,
                          y = reorder(country, donors_mean)))

p + geom_point(size=3) +
    facet_wrap(~ consent_law, scales = "free_y", ncol = 1) +
    labs(x= "Donor Procurement Rate",
         y= "")       


# And can explicitly use mean and SD with geom_pointrange()
p <- ggplot(data = by_country, mapping = aes(x = reorder(country,
              donors_mean), y = donors_mean))

p + geom_pointrange(mapping = aes(ymin = donors_mean - donors_sd,
       ymax = donors_mean + donors_sd)) +
     labs(x= "", y= "Donor Procurement Rate") + coord_flip()      


