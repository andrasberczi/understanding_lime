source("global.R")
seed <- 132

data(Sacramento)
apartments_dt <- copy(as.data.table(Sacramento))

# tabular data ------------------------------------------------------------

# formula <- formula("price ~ .")
formula <- formula("price ~ beds + baths + sqft")
method <- "lm"

train <- createTrainSet(apartments_dt)
model <- train(formula, data = train, method = method)
summary(model)
RMSE(test_with_predictions$price, test_with_predictions$prediction)

test_with_predictions <- createTestSet(apartments_dt) %>% 
	.[, prediction := predict(model, newdata = .)]

explainer <- lime(train[, -c("price")], model = model, bin_continuous = FALSE)
set.seed(seed)
explanation <- lime::explain(
	test_with_predictions[123:125, -c("prediction", "price")], 
	explainer = explainer, n_features = 3
)

test_with_predictions[123:125]
plot_features(explanation)
plot_explanations(explanation)

# text example ------------------------------------------------------------

library(text2vec)
library(xgboost)

data(train_sentences)
data(test_sentences)

dtm_train <- getMatrix(train_sentences$text)

xgb_model <- xgb.train(list(max_depth = 7, eta = 0.1, objective = "binary:logistic",
                            eval_metric = "error", nthread = 1),
                       xgb.DMatrix(dtm_train, label = train_sentences$class.text == "OWNX"),
                       nrounds = 50)

sentences <- head(test_sentences[test_sentences$class.text == "OWNX", "text"], 1)
explainer <- lime(train_sentences$text, xgb_model, get_matrix)
explanations <- explain(sentences, explainer, n_labels = 1, n_features = 4)

plot_features(explanations)
plot_explanations(explanations)
plot_text_explanations(explanations)

# image example -----------------------------------------------------------

library(keras)
library(abind)
library(magick)

img <- image_read('https://media.sweetwater.com/api/i/q-82__ha-ba57a5bd70abd52b__hmac-fbb7b2a4da6df6eb33d6668ff7037bcbd32b23a2/images/items/750/SBP2F57-RB-large.jpg')
img_path <- file.path(tempdir(), 'kitten.jpg')
image_write(img, img_path)
plot(as.raster(img))

plot_superpixels(img_path, n_superpixels = 100)

model <- application_vgg16(include_top = TRUE, weights = "imagenet")

img_preprocess <- function(x) {
  arrays <- lapply(x, function(path) {
    img <- image_load(path, target_size = c(224,224))
    x <- image_to_array(img)
    x <- array_reshape(x, c(1, dim(x)))
    x <- imagenet_preprocess_input(x)
  })
  do.call(abind, c(arrays, list(along = 1)))
}

res <- predict(model, img_preprocess(c(img_path)))
imagenet_decode_predictions(res)

model_labels <- readRDS(system.file('extdata', 'imagenet_labels.rds', package = 'lime'))

explainer <- lime(img_path, as_classifier(model, model_labels), img_preprocess)

img_explanation <- explain(
	img_path, explainer, n_labels = 2, n_features = 10
)

plot_image_explanation(img_explanation)

plot_image_explanation(img_explanation, display = 'block')
