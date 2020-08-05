#Auf Datenbank zugreifen
mydb <- dbConnect(MySQL(), user='Administrator', password='tqYYDcqx43', dbname='football_data', host='33796.hostserv.eu', encoding="utf8")
dbGetQuery(mydb, "SET NAMES 'utf8'")

rs <- dbSendQuery(mydb, "SELECT * FROM matches_database")
data_transfermarkt <- fetch(rs,n=-1, encoding="utf8")
Encoding(data_transfermarkt$team_home) <- "UTF-8"
Encoding(data_transfermarkt$team_away) <- "UTF-8"
Encoding(data_transfermarkt$referee) <- "UTF-8"


dbDisconnectAll()

data_transfermarkt$date <- as.Date(data_transfermarkt$date)

#999 als NA
data_transfermarkt[data_transfermarkt == 999] <- NA

#Target variable
data_transfermarkt$target <- data_transfermarkt$points_home
data_transfermarkt$target <- gsub(3,"win",data_transfermarkt$target)
data_transfermarkt$target <- gsub(1,"draw",data_transfermarkt$target)
data_transfermarkt$target <- gsub(0,"loss",data_transfermarkt$target)
data_transfermarkt$target <- as.factor(data_transfermarkt$target)

#Select data
data_rf <- data_transfermarkt[,c(6:7,37:38,41:42,45:46,49:52,55)]

data_rf <- na.omit(data_rf)

X <- data_rf[,1:ncol(data_rf)-1]
y <- data_rf$target

predictions_next_game <- data.frame("bla",999,999,999)
colnames(predictions_next_game) <- c("match","win home team","draw","win away team")


#New games
matches <- paste0(upcoming_matches$team_home,"-",upcoming_matches$team_away)
new_games <- upcoming_matches[,c(4:5,12:21)]


for (i in 1:50) {
# Train the model 
regr <- randomForest(x = X, y = y, maxnodes = 250, ntree = 1100, type="prob")
print(regr)

#Predict next games
prediction_next_game <- predict(regr, new_games, type="prob")

#Predict next games
prediction_next_game <- predict(regr, new_games, type="prob")


prediction_next_game <- cbind(prediction_next_game,matches)
prediction_next_game <- prediction_next_game[,c(4,3,1,2)]
colnames(prediction_next_game) <- c("match","win home team","draw","win away team")

predictions_next_game <- rbind(predictions_next_game,prediction_next_game)

print(i)

}

predictions_next_game <- predictions_next_game[-1,]
predictions_next_game$`win home team` <- as.numeric(predictions_next_game$`win home team`)
predictions_next_game$draw <- as.numeric(predictions_next_game$draw)
predictions_next_game$`win away team` <- as.numeric(predictions_next_game$`win away team`)


predictions_next_game <- predictions_next_game  %>%
  group_by(match) %>% 
  summarise_each(funs(mean))

write.csv(predictions_next_game,file="Output/prediction_next_game.csv",row.names = FALSE, fileEncoding = "UTF-8")

print(predictions_next_game)
