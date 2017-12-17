safeTree_predict <- function(industryName, predictor, attribute,notrees,mtrys) {
  userChoice <- read.csv(paste(c('~/PATH TO INDUSTRY FOLDER', industryName, '/', tolower(predictor), '_toy.csv'), collapse = ''))
  userChoice <- userChoice[1:nrow(userChoice),2:ncol(userChoice)]
  rf <- randomForest(value ~ ., data = userChoice, importance = TRUE, mtry= mtrys, ntree = notrees)
  userChoice <- userChoice[1,]
  for (i in 1:length(colnames(userChoice))) {
    if (attribute == colnames(userChoice)[i]) {
      userChoice[1,i] <- 1
    }
    else {
      userChoice[1,i] <- 0
    }
  }
  userPrediction <- predict(rf, userChoice)
  errorPlot <- plot(rf) # plots the error rate vs the number of trees
  varImport <- varImpPlot(rf) # plots the importance of the attributes being used in rf model
  returnList <- list("prediction" = userPrediction, "rf" = rf)
  return(returnList) # the predicted value of the regression model
}


