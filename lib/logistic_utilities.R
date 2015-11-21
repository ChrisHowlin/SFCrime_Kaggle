# Utilities for logistic regressions

source('crime_utilities.R')

# Generate model for category using input_data and use to model generate prediction
# from test_data
get_test_predictions <- function(input_data, test_data, category)
{
  L = input_data$Category == category
  input_data$isCategory <- L

  logit.fit <- glm(isCategory ~ X + Y + Times, family='binomial', data=input_data)
  predictions <- predict(logit.fit, newdata=test_data,type='response')

  return(predictions)
}

cross_validate_logistic_regression <- function(input_data, formula, num_folds)
{
  folds <- cut(seq(1,nrow(input_data)),breaks=num_folds,labels=FALSE)

  print("Starting K-fold cross validation")

  log_loss <- NULL

  #Perform 10 fold cross validation
  for(i in 1:num_folds){
    cat(" - Fold", i, "of", num_folds, "\n")
    cat("Generating glms\n")

    #Segement your data by fold using the which() function
    testIndexes <- which(folds==i,arr.ind=TRUE)
    testData <- input_data[testIndexes, ]
    trainData <- input_data[-testIndexes, ]
    #Use test and train data partitions however you desire...

    predict.df <- testData$Id

    levels(crime_data_working$Category) <- get_category_levels()
    for(category in levels(crime_data_working$Category))
    {
      # print(category)
      L = trainData$Category == category
      trainData$isCategory <- L

      logit.fit <- glm(formula=formula, family='binomial', data=trainData)
      predictions <- predict(logit.fit, newdata=testData,type='response')

      predict.df <- cbind(predict.df, predictions)
    }

    cat("Calculating log-loss\n")
    colnames(predict.df) <- c(levels(get_category_levels()))
    fold_log_loss <- log_loss_by_record(testData$Category, predict.df)
    log_loss <- c(log_loss, fold_log_loss)
    cat("Log loss:",fold_log_loss, '\n')
  }

  cat('Mean log-loss: ', mean(log_loss), '\n')
  return(log_loss)
}
