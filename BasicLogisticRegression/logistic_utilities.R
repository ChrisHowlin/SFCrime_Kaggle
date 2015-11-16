# Utilities for logistic regressions

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
