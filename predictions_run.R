source("config.R")

#Recently played matches
games <- 3197414:3197418

#Upcoming matches
new_matches <- 3197414:3197418

#Season
season <- "19/20"

#Scrape recently played matches
source("get_new_data.R", encoding = "UTF-8")

#Scrape upcoming matches
source("get_upcoming_matches.R", encoding = "UTF-8")


#Predict next round
str(upcoming_matches)

#Predict season