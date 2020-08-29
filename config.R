library(rvest)
library(stringr)
library(XML)
library(readr)
#library(tidyverse)
library(caret)
library(randomForest)
library(Metrics)
library(mgcv)
library(readxl)
library(DBI) 
library(RMySQL)
library(dplyr)
library(RCurl)
library(httr)
library(tibble)

###Funktion Datenbankverbindungen schliessen
dbDisconnectAll <- function(){
  ile <- length(dbListConnections(MySQL())  )
  lapply( dbListConnections(MySQL()), function(x) dbDisconnect(x) )
  cat(sprintf("%s connection(s) closed.\n", ile))
}

#Set working directory
setwd("C:/Users/simon/OneDrive/Fussballdaten/predictions")
