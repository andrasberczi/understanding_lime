createTrainSet <- function(data, ratio_of_train = 0.3, seed = 123) {
	set.seed(seed)
	train_index <- sample(1:nrow(data), nrow(data) * ratio_of_train)
	data[train_index]
}

createTestSet <- function(data, ratio_of_train = 0.3, seed = 123) {
	set.seed(seed)
	train_index <- sample(1:nrow(data), nrow(data) * ratio_of_train)
	data[-train_index]
}

getMatrix <- function(text) {
  it <- itoken(text, progressbar = FALSE)
  create_dtm(it, vectorizer = hash_vectorizer())
}