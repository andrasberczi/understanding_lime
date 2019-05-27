source("global.R")
seed <- 132

data(Sacramento)
apartments_dt <- copy(as.data.table(Sacramento))

# tabular data ------------------------------------------------------------

formula <- formula("price ~ .")
method <- "rf"

train <- createTrainSet(apartments_dt)
model <- train(formula, data = train, method = method)
test <- createTestSet(apartments_dt)

head(test)

explainer <- lime(train[, -c("price")], model = model, bin_continuous = FALSE)

test[123]
set.seed(seed)
explanation <- explain(
	test[123, -c("price")], explainer = explainer, n_features = 3
)

plot_features(explanation)
plot_explanations(explanation)