url <- paste0("https://www.transfermarkt.ch/raiffeisen-super-league/trainervergleich/wettbewerb/C1")
webpage <- read_html(url)

coaches_data <- html_text(html_nodes(webpage,"a"))

coaches_names <- c(coaches_data[50],coaches_data[54],coaches_data[58],coaches_data[62],coaches_data[66],
                   coaches_data[70],coaches_data[74],coaches_data[78],coaches_data[82],coaches_data[86])

coaches_teams <- c(coaches_data[51],coaches_data[55],coaches_data[59],coaches_data[63],coaches_data[67],
                   coaches_data[71],coaches_data[75],coaches_data[79],coaches_data[83],coaches_data[87])


coaches <- data.frame(coaches_names,coaches_teams)

coaches$PPS <- NA
coaches$alert_level <- 0

print(coaches)