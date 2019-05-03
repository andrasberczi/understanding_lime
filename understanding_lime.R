library(lime)
library(data.table)
library(magrittr)
library(mlbench)
library(caret)

# linear regression -----------------------------------------------------

data(Sacramento)
apartments_dt <- copy(as.data.table(Sacramento))

set.seed(132)
train_index <- sample(1:nrow(apartments_dt), nrow(apartments_dt) * 0.3)
train <- apartments_dt[train_index]
test <- apartments_dt[-train_index]

# model_lm <- train(price ~ beds + baths + sqft, data = train, method = "lm")
model_lm <- train(price ~ ., data = train, method = "lm")
summary(model_lm)

# model_rf <- train(price ~ beds + baths + sqft, data = train, method = "rf")
model_rf <- train(price ~ ., data = train, method = "rf")
summary(model_rf)

test_with_predictions <- copy(test) %>% 
	.[, prediction_lm := predict(model_lm, newdata = test)] %>% 
	.[, prediction_rf := predict(model_rf, newdata = test)]

ggplot(test_with_predictions, aes(price, prediction_lm)) + geom_point()
ggplot(test_with_predictions, aes(price, prediction_rf)) + geom_point()

RMSE(test_with_predictions$price, test_with_predictions$prediction_lm)
RMSE(test_with_predictions$price, test_with_predictions$prediction_rf)

lime_explainer <- lime(train[, -c("price")], model = model)

lime_explanation <- lime::explain(test[123:133, -c("price")], explainer = lime_explainer, n_features = 3)
plot_features(lime_explanation)
plot_explanations(lime_explanation)

# image example -----------------------------------------------------------

explanation_image <- .load_image_example()
plot_image_explanation(explanation_image)