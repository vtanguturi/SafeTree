library(csvread)
library(randomForest)
library(party)
library(xgboost)
set.seed(400)


industries <- read.csv('~/CX4242/project_files/database/industries.csv', stringsAsFactors = FALSE)
predictors <- read.csv('~/CX4242/project_files/database/predictors.csv', stringsAsFactors = FALSE)
df <- read.csv('~/CX4242/project_files/database/data.csv')
for (j in 2:(nrow(industries))) {
  INDUSTRY <- as.character(industries[j,1])
  for (i in 2:(nrow(predictors)-1)) {
    name <- predictors[i,1]
    df_toy <- subset(df,industry==INDUSTRY & predictor == name,select= industry:value)
    df_toy_cleaned <- subset(df_toy, attribute != "not reported")
    df_toy_cleaned$indicator <- 1
    groups <- unique(df_toy_cleaned["attribute"])
    
    industry <- unique(df$industry)
    predictors <- unique(df$group_name)
    
    colnames.1 <-  as.vector(groups[["attribute"]])
    colnames.2 <- c("value")
    colnames.3 <- c(colnames.1,colnames.2)
    
    df.new = data.frame(matrix(ncol = length(colnames.3),nrow=nrow(df_toy_cleaned)))
    colnames(df.new) <- colnames.3
    
    for (row in 1:nrow(df_toy_cleaned)) {
      temp <- df_toy_cleaned[row,"attribute"]
      dafw <- df_toy_cleaned[row,"value"]
      ind <- df_toy_cleaned[row,'indicator']
      row.vals <- vector(mode='numeric',length = length(df.new))
      names(row.vals) <- colnames.3
      for (i in 1:length(colnames.3)) {
        if (temp == colnames.3[i]) {
          row.vals[i] <- 1
        } else {row.vals[i] <- 0}
      }
      
      row.vals[length(colnames.3)] <- dafw
      df.new[row,] <- row.vals
    } 
    write.csv(df.new, file = paste(c('~/CX4242/project_files/Indsutry', INDUSTRY, '/', predictors[i,1], '_toy.csv'), collapse = ''))
  }
}