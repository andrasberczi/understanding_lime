source("global.R")
seed <- 132

data(Sacramento)
apartments_dt <- copy(as.data.table(Sacramento))

# train model for tabular data --------------------------------------------

formula <- formula("price ~ .")
method <- "rf"

train <- createTrainSet(apartments_dt)
model <- train(formula, data = train, method = method)
test <- createTestSet(apartments_dt)

head(test)

# create explanations with LIME -------------------------------------------

explainer <- lime::lime(train[, -c("price")], model = model, bin_continuous = FALSE)
explainer

set.seed(seed)
explanation <- lime::explain(
	test[c(1, 415), -c("price")], explainer = explainer, n_features = 3
)
explanation

lime::plot_features(explanation)
