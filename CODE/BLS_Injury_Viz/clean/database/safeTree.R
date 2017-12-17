library(csvread)
library(randomForest)
library(party)
set.seed(400)


industries <- read.csv('~/CX4242/project_files/database/industries.csv', stringsAsFactors = FALSE)
#windows()

predictors <- read.csv('~/CX4242/project_files/database/predictors.csv', stringsAsFactors = FALSE)
main_oob.err = double(nrow(predictors)-2)
main_test.err = double(nrow(predictors)-2)

for (j in 1:(nrow(industries))) {
  industry <- as.character(industries[j,1])
  oob.err = double(nrow(predictors)-2)
  test.err = double(nrow(predictors)-2)
  predictors <- read.csv('~/CX4242/project_files/database/predictors.csv', stringsAsFactors = FALSE)
  for (i in 2:(nrow(predictors)-1)) {
    name <- predictors[i,1]
    dataset <- read.csv(paste(c('~/CX4242/project_files/database/Industry/', industry, '/', tolower(name), '_toy.csv'), collapse = ''))
    dataset <- dataset[1:nrow(dataset),2:ncol(dataset)]
    train <- sample(1:nrow(dataset),(floor(2*nrow(dataset)/3)))
    rf <- randomForest(value ~ ., data = dataset, subset= train, importance = TRUE, mtry= ncol(dataset), ntree = 1000)
    oob.err[i-1] = rf$mse/14 # to account for number of predictors
    prediction <- predict(rf, dataset[-train,])
    test.err[i-1] = with(dataset[-train,], mean( (value - prediction)^2)/14) # to account for number of predictors
    # print(prediction)
    # plot(varImpPlot(rf))
    # print(rf$oob.times)
    # print(getTree(rf))
    # print(importance(rf))
    main_oob.err[i-1] <- main_oob.err[i-1] + oob.err[i-1]
    main_test.err[i-1] <- main_test.err[i-1] + test.err[i-1]
  }
   print(oob.err)
   print(test.err)
}
elements <- nrow(industries) * 14
main_test.err <- main_test.err/elements
main_oob.err <- main_oob.err/elements
# print(main_test.err)
# print(main_oob.err)