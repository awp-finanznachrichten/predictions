get_elodata <- function() {


teams <- c("YoungBoys","Basel","StGallen","Servette","Luzern","Zuerich","Lugano","Sion","Lausanne","Vaduz","Xamax","Thun")

elo_values <- data.frame("None","bla","SUI",0,0,1901-01-01,1901-01-01)
colnames(elo_values) <- c("Rank","Club","Country","Level","Elo","From","To")


for (i in teams) {


res <- GET(paste0("http://api.clubelo.com/",i))
data <- as.data.frame(content(res,"parsed"))

elo_values <- rbind(elo_values,data)

print(paste0("Elo-Values scraped from ",data$Club[1]))

}

elo_values <- elo_values[-1,]
elo_values <- elo_values[elo_values$From >= 2010-01-01,]


return(elo_values)

}
