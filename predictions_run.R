#Load library and set wd
source("config.R")

#Season, played Round and tips from players
season <- "20/21"
round <- "03"
tips <- read_csv("BeatTheRobot/Beat the robot - Round 3 (Antworten) - Formularantworten 1.csv")


#Get old predictions of robot
predictions_robot_old <- read_csv("Output/predictions_SwissFootyBot.csv")

#Get Recently played matches and upcoming matches
source("getting_ids.R", encoding = "UTF-8")

#Get Elo-Daten
source("get_elodata.R", encoding = "UTF-8")

#Marktwerte laden
source("get_market_values.R", encoding = "UTF-8")


#Scrape recently played matches
source("get_new_data.R", encoding = "UTF-8")

#Scrape upcoming matches
source("get_upcoming_matches.R", encoding = "UTF-8")


#Predict next round
source("predict_next_round.R", encoding= "UTF-8")

#Predict season
source("predict_season.R", encoding= "UTF-8")

###Beat the robot

#Predictions fans
source("predictions_fans.R", encoding = "UTF-8")

#Evaluate current round
source("beat_the_robot_run.R", encoding = "UTF-8")
