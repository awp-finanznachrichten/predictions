###Create Data Frame to collect all iterations
season_prognosis <- data.frame(0,0,0,0,0,0,0,0,0,0)
colnames(season_prognosis) <- c("BSC Young Boys","FC Basel 1893","FC Lausanne-Sport","FC Lugano","FC Luzern","FC Sion","FC St. Gallen 1879","FC Vaduz","FC Zürich","Servette FC")

#Remove rankings
X_season <- X[,-c(1:2)]

#Get needed data from upcoming matches
new_games <- upcoming_matches[,c(2:3,12:21)]


###Start learning process
for (a in 1:50) {


  # Train the model 
  regr <- randomForest(x = X_season, y = y , maxnodes = 250, ntree = 1100)
  print(regr)

    
  #Predict next games
  prediction_next_game <- predict(regr, new_games, type="prob")
  

  #Get score for home and away team
  prediction_next_game <- cbind(prediction_next_game,as.character(new_games$team_home),as.character(new_games$team_away))
  prediction_next_game <- as.data.frame(prediction_next_game)

  prediction_next_game$score_home <- as.numeric(as.character(prediction_next_game$`win home`))*3+as.numeric(as.character(prediction_next_game$draw))
  prediction_next_game$score_away <- as.numeric(as.character(prediction_next_game$`win away`))*3+as.numeric(as.character(prediction_next_game$draw))
  


  #Get overall score of all teams
  scores_home <- aggregate(prediction_next_game$score_home,by=list(prediction_next_game$V4),FUN=sum)
  scores_away <- aggregate(prediction_next_game$score_away,by=list(prediction_next_game$V5),FUN=sum)

  scores_new <- merge(scores_home,scores_away,by="Group.1")
  scores_new$score <- scores_new$x.x + scores_new$x.y

  #Get scores so far
  current_season <- data_transfermarkt[data_transfermarkt$season == season,]
  current_season <- current_season[!is.na(current_season$points_home),]


  scores_home <- aggregate(current_season$points_home,by=list(current_season$team_home),FUN=sum)
  scores_away <- aggregate(current_season$points_away,by=list(current_season$team_away),FUN=sum)

  scores_season <- merge(scores_home,scores_away,by="Group.1")
  scores_season$score <- scores_season$x.x + scores_season$x.y

  #Merge to final score
  scores_overall <- merge(scores_new,scores_season,by="Group.1")
  scores_overall$final_score <- scores_overall$score.x + scores_overall$score.y
  
  
  #Write final score in new data frame
  season_prognosis <- rbind(season_prognosis,scores_overall$final_score) #Change to scores_overall$final_score
  print("new entry done")
  print(nrow(season_prognosis))
  print(scores_overall$final_score) #Change to 
}


season_prognosis <- season_prognosis[-1,]


#Create table
table <- as.data.frame(round(colMeans(season_prognosis)*2)) #Mal 2 in Hinrunde
table$quantile_low <- 0
table$quantile_high <- 0

for (i in 1:ncol(season_prognosis)) {
  
  table$quantile_low[i] <- round(quantile(season_prognosis[,i],0.025)*2)
  table$quantile_high[i] <- round(quantile(season_prognosis[,i],0.975)*2)
  
}

colnames(table) <- c("Final Score","CI low","CI high")
table <- table[order(-table$`Final Score`,-table$`CI low`),]

write.csv(table,file="Output/predictions_season.csv",row.names = TRUE, fileEncoding = "UTF-8")

print(table)
