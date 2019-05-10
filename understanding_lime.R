source("global.R")
seed <- 132

data(Sacramento)
apartments_dt <- copy(as.data.table(Sacramento))

# tabular data ------------------------------------------------------------

# formula <- formula("price ~ beds + baths + sqft")
formula <- formula("price ~ .")
method <- "lm"

train <- createTrainSet(apartments_dt)
model <- train(formula, data = train, method = method)
summary(model)

test_with_predictions <- createTestSet(apartments_dt) %>% 
	.[, prediction := predict(model, newdata = .)]

ggplot(test_with_predictions, aes(price, prediction)) + geom_point()
RMSE(test_with_predictions$price, test_with_predictions$prediction)

explainer <- lime(train[, -c("price")], model = model, bin_continuous = FALSE)
set.seed(seed)
explanation <- lime::explain(
	test_with_predictions[123:125, -c("prediction", "price")], 
	explainer = explainer, n_features = 6
)

test_with_predictions[123:125]
plot_features(explanation)
plot_explanations(explanation)

# image example -----------------------------------------------------------

explanation_image <- .load_image_example()
plot_image_explanation(explanation_image)