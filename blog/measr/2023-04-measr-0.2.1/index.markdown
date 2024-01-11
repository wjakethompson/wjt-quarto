---
title: "measr 0.2.1"
date: 2023-04-10
subtitle: ""
description: "Initial release of measr package for estimating and evaluating diagnostic classification models."
image: "sidebar-hex.png"
twitter-card:
  image: "sidebar-hex.png"
open-graph:
  image: "sidebar-hex.png"
categories:
  - R
  - package
  - measr
  - dcm
  - Stan
---



I'm excited to announce the release of [measr](https://measr.info) 0.2.1.
The goal of measr is to provide applied researchers and psychometricians with a user friendly interface for estimating and evaluating diagnostic classification models (DCMs).
DCMs are a class of psychometric models that provide classification of students into profiles of proficiency on a predefined set of knowledge, skills, or understandings.
This offers many advantages over traditional assessment models.
Because results are reported as proficiency on individual skills, teachers, students, and parents get actionable feedback about which areas could use additional attention.
However, these models have not been widely used in applied or operational settings, in part due to a lack of user friendly software for estimating and evaluating these models.
measr aims to bridge this gap between psychometric theory and applied practice.

You can install it from CRAN with:


```r
install.packages("measr")
```

This blog post will highlight the main features of the package.


```r
library(measr)
```

## Estimating DCMs

To illustrate DCMs and their application with measr, we'll use a simulated data set.
In this data set, we have 1,000 respondents who each answered 15 questions about addition, multiplication, and fractions.
For each item, a 1 represents a correct response to the item, and a 0 represents an incorrect response.


```r
library(tidyverse)

dat <- read_csv("data/example-data.csv")
dat
#> # A tibble: 1,000 × 16
#>    resp_id item_01 item_02 item_03 item_04 item_05 item_06 item_07 item_08
#>      <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>
#>  1       1       1       1       1       0       1       1       0       1
#>  2       2       1       1       0       0       0       1       0       1
#>  3       3       1       1       0       0       0       1       0       1
#>  4       4       1       0       1       0       1       0       1       1
#>  5       5       1       1       0       0       0       1       1       0
#>  6       6       1       1       0       0       0       1       0       1
#>  7       7       1       1       1       0       0       1       1       1
#>  8       8       0       0       0       0       0       0       0       1
#>  9       9       0       1       0       0       0       1       0       0
#> 10      10       1       1       0       1       1       1       0       1
#> # ℹ 990 more rows
#> # ℹ 7 more variables: item_09 <dbl>, item_10 <dbl>, item_11 <dbl>,
#> #   item_12 <dbl>, item_13 <dbl>, item_14 <dbl>, item_15 <dbl>
```

When using DCMs, a Q-matrix defines which items measure each attribute, or skill.
In the Q-matrix, a 1 indicates that the item measures the attributes, and a 0 indicates the item does not measure the attribute.


```r
qmatrix <- read_csv("data/example-qmatrix.csv")
qmatrix
#> # A tibble: 15 × 4
#>    item_id addition multiplication fractions
#>    <chr>      <dbl>          <dbl>     <dbl>
#>  1 item_01        1              1         0
#>  2 item_02        1              0         0
#>  3 item_03        0              1         0
#>  4 item_04        0              0         1
#>  5 item_05        0              1         0
#>  6 item_06        1              0         0
#>  7 item_07        0              1         0
#>  8 item_08        0              1         1
#>  9 item_09        0              1         1
#> 10 item_10        0              0         1
#> 11 item_11        1              1         0
#> 12 item_12        1              0         1
#> 13 item_13        0              0         1
#> 14 item_14        0              1         1
#> 15 item_15        1              0         0
```

Our goal is to estimate whether each respondent is proficient in each of the skills measured by the assessment, and DCMs are our tool.
There are many different types of DCMs, each with different constraints or assumptions about how the attributes relate to each other.
For example, if an item measures multiple attributes, does a respondent need to be proficient on all attributes to answer the item correctly?
Or can proficiency in one attribute compensate for the lack of proficiency on another?

Also several DCM subtypes are supported by measr, we are primarily focused on the [loglinear cognitive diagnostic model](https://link.springer.com/article/10.1007/s11336-008-9089-5) (LCDM), which is a general DCM.
This means that it subsumes many of the other DCM subtypes and allows for the data to determine how much (if at all) one attribute might compensate for another.

measr works by wrapping the [*Stan*](https://mc-stan.org) language to estimate DCMs.
We can estimate the LCDM using `measr_dcm()`.
This function use the inputs to write a Stan script defining the model and then estimates the model using either the [rstan](https://mc-stan.org/rstan/) or [cmdstanr](https://mc-stan.org/cmdstanr/) packages.
To estimate the model, we just supply our data set and the Q-matrix.
Because our data set and Q-matrix contain respondent and item identifiers, respectively, we need to specify the names of the identifier columns.
We can also specify prior distributions for each of the model parameters.
Finally, we specify a file for saving the model once it is estimated.
For more information on model estimation, including details on specifying prior distributions, see the [model estimation vignette](https://measr.info/articles/model-estimation.html).


```r
lcdm <- measr_dcm(data = dat, qmatrix = qmatrix,
                  resp_id = "resp_id", item_id = "item_id", 
                  prior = c(prior(normal(0, 2), class = "intercept"),
                            prior(lognormal(0, 1), class = "maineffect"),
                            prior(normal(0, 2), class = "interaction")),
                  file = "fits/example-lcdm")
```

Once the model has estimated, we can use `measr_extract()` to examine different aspects of the model, such as proportion of respondents with each pattern of proficiency across the attributes.


```r
measr_extract(lcdm, "strc_param")
#> # A tibble: 8 × 2
#>   class          estimate
#>   <chr>        <rvar[1d]>
#> 1 [0,0,0]  0.165 ± 0.0127
#> 2 [1,0,0]  0.211 ± 0.0153
#> 3 [0,1,0]  0.048 ± 0.0089
#> 4 [0,0,1]  0.072 ± 0.0090
#> 5 [1,1,0]  0.166 ± 0.0164
#> 6 [1,0,1]  0.065 ± 0.0115
#> 7 [0,1,1]  0.084 ± 0.0116
#> 8 [1,1,1]  0.187 ± 0.0164
```

## Evaluating DCMs

There are several functions included for evaluating the model.
For example we can examine the probability that each respondent is proficient in each attribute.
Here, respondent 1 is likely proficient in all skills, whereas respondent 2 is likely only proficient in addition.


```r
lcdm <- add_respondent_estimates(lcdm)
measr_extract(lcdm, "attribute_prob")
#> # A tibble: 1,000 × 4
#>    resp_id addition multiplication fractions
#>    <fct>      <dbl>          <dbl>     <dbl>
#>  1 1       0.997          0.977      0.920  
#>  2 2       1.00           0.00297    0.0102 
#>  3 3       1.00           0.133      0.0370 
#>  4 4       0.0228         1.00       0.0556 
#>  5 5       0.999          0.0253     0.0223 
#>  6 6       1.00           0.00297    0.00224
#>  7 7       0.998          0.469      0.938  
#>  8 8       0.000520       0.0233     0.0194 
#>  9 9       0.984          0.000116   0.00641
#> 10 10      0.997          0.920      0.957  
#> # ℹ 990 more rows
```

Often, we would dichotomize these probabilities into a 0/1 decision (e.g., proficient/not proficient).
We can also look at the reliability of those classifications.
The `add_reliability()` function will calculate the classification consistency and accuracy metrics described by [Johnson & Sinharay (2018)](https://doi.org/10.1111/jedm.12196).
Here we see that all of the attributes have fairly high accuracy and consistency for classifications.


```r
lcdm <- add_reliability(lcdm)
measr_extract(lcdm, "classification_reliability")
#> # A tibble: 3 × 3
#>   attribute      accuracy consistency
#>   <chr>             <dbl>       <dbl>
#> 1 addition          0.960       0.927
#> 2 multiplication    0.956       0.917
#> 3 fractions         0.936       0.882
```

As you can see, for each type of model evaluation, we follow the same process of `add_{metric}` and then we can use `measr_extract()` to view the results.
For a complete list of model evaluation options, see `?model_evaluation`.

## Future Development

We're already in the process of adding features and making improvements for the next version of measr.
Some highlights include:

* Adding support for more DCM subtypes
* More refined prior specifications
* Additional vignettes including a complete description of model evaluation and example case studies

If you have a specific feature request, suggestion for improvement, or run into any problems, please [open an issue](https://github.com/wjakethompson/measr/issues) on the project repository!
