# Tabular data

## Create explainer
* use `bin_continuous = FALSE` to have better explainer
* feature weights: coefficient of a (weighted) LASSO regression (standardized, but coeffs are returned on original scale) 

## Plot features
* Prediction: Black-box model prediction
* Explanation fit: R2 of Locally trained linear model