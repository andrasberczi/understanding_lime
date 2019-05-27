# Tabular data

## Create explainer
* use `bin_continuous = FALSE` to have better explainer
* feature weights: coefficient of a (weighted) LASSO regression (standardized, but coeffs are returned on original scale)
    * what does negative coefficients mean for categorical features??
* continuous features:
    * when using bins, bootstraps from bins and then ??
    * when bin_continuous = FALSE, creates permutations with normal distribution for continuous features - no way to change this currently

## Plot features
* Prediction: Black-box model prediction
* Explanation fit: R2 of Locally trained linear model
* (weights = feature weights)


## How it works
1. Permute the observation
2. Complex model prediction of all obs
3. Calculate the distance of permuted data to original data and convert it to a similarity score.
4. Select m features best describing the complex model from permuted data.
5. Fit a simple model, weight results by similarity to the original observation.
6. Extract the feature weights from the simple model and use these as explanations for the complex models local behavior.

