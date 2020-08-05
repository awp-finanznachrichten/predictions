#Get Tips
tips <- read_csv("BeatTheRobot/Beat the robot - Round 1 (Antworten) - Formularantworten 1.csv")

#Evaluate score of the robot
compare <- merge(last_results,predictions_robot)
score_robot <- length(intersect(compare$target,compare$Prediction))

#Evaluate scores of the players
tips$score <- 0
tips$won <- 0
tips$lost <- 0
tips$tie <- 0

for (i in 1:nrow(tips)) {
  
 if (as.character(tips[i,2]) == as.character(last_results[1,2])) {
   
  tips$score[i] <- tips$score[i] + 1 
 }

  if (as.character(tips[i,3]) == as.character(last_results[2,2])) {
    
    tips$score[i] <- tips$score[i] + 1 
  }
  
  if (as.character(tips[i,6]) == as.character(last_results[3,2])) {
    
    tips$score[i] <- tips$score[i] + 1 
  }
  
  if (as.character(tips[i,7]) == as.character(last_results[4,2])) {
    
    tips$score[i] <- tips$score[i] + 1 
  }
  
  if (as.character(tips[i,8]) == as.character(last_results[5,2])) {
    
    tips$score[i] <- tips$score[i] + 1 
  }

  
  if (tips$score[i] > score_robot) {
    
    
    tips$won[i] <- tips$won[i] + 1
    
  } else if (tips$score[i] == score_robot) {
    
    
    tips$tie[i] <- tips$tie[i] + 1 
    
  } else {
    
    tips$lost[i] <- tips$lost[i] + 1
    
  }
    
}  

tips$fail <- 5-tips$score
  
#Get current Leaderboard

mydb <- dbConnect(MySQL(), user='Administrator', password='tqYYDcqx43', dbname='football_data', host='33796.hostserv.eu', encoding="utf8")
dbGetQuery(mydb, "SET NAMES 'utf8'")

rs <- dbSendQuery(mydb, "SELECT * FROM leaderboard_btr")
leaderboard <- fetch(rs,n=-1, encoding="utf8")
Encoding(leaderboard$email) <- "UTF-8"
Encoding(leaderboard$name) <- "UTF-8"
Encoding(leaderboard$twitter) <- "UTF-8"

#Save old data (to be sure)
save(leaderboard,file="BeatTheRobot/leaderboard.Rda")

#Merge with new data and adapt
leaderboard_new <- merge(leaderboard,tips,by.x="email",by.y="E-Mail-Adresse",all=TRUE)

leaderboard_new[is.na(leaderboard_new)] <- 0

leaderboard_new$wins <- leaderboard_new$wins + leaderboard_new$won
leaderboard_new$losses <- leaderboard_new$losses + leaderboard_new$lost
leaderboard_new$ties <- leaderboard_new$ties + leaderboard_new$tie
leaderboard_new$correct_guesses <- leaderboard_new$correct_guesses + leaderboard_new$score
leaderboard_new$wrong_guesses <- leaderboard_new$wrong_guesses + leaderboard_new$fail
leaderboard_new$accuracy <- leaderboard_new$correct_guesses/(leaderboard_new$correct_guesses+leaderboard_new$wrong_guesses)
leaderboard_new$rounds_played <- leaderboard_new$rounds_played + 1

#Select Data
leaderboard_new <- leaderboard_new[,c(1,14,18,4:10)]

#Load new data in database
mydb <- dbConnect(MySQL(), user='Administrator', password='tqYYDcqx43', dbname='football_data', host='33796.hostserv.eu', encoding="utf8")



#DE-Datenbank einlesen

sql_qry <- "TRUNCATE TABLE football_data.leaderboard_btr"
rs <- dbSendQuery(mydb, sql_qry)

sql_qry <- "INSERT INTO leaderboard_btr(email,name,twitter,wins,losses,ties,correct_guesses,wrong_guesses,accuracy,rounds_played) VALUES"



sql_qry <- paste0(sql_qry, paste(sprintf("('%s', '%s', '%s', '%s' , '%s', '%s', '%s', '%s' , '%s', '%s')",
                                         leaderboard_new$email,
                                         leaderboard_new$`What is your name?`,
                                         leaderboard_new$`Your Twitter account (voluntary)`,
                                         leaderboard_new$wins,
                                         leaderboard_new$losses,
                                         leaderboard_new$ties,
                                         leaderboard_new$correct_guesses,
                                         leaderboard_new$wrong_guesses,
                                         leaderboard_new$accuracy,
                                         leaderboard_new$rounds_played
                                       
), collapse = ","))

dbGetQuery(mydb, "SET NAMES 'utf8'")
rs <- dbSendQuery(mydb, sql_qry)

dbDisconnectAll()

#Create performance sheet of SwissFootyBot

