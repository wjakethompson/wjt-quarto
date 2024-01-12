---
title: "measr 0.3.1"
date: 2023-06-06
subtitle: ""
description: "measr 0.3.1 is a minor release focusing on expanding the set of models that can be estimated."
image: "featured.jpg"
twitter-card:
  image: "featured.jpg"
open-graph:
  image: "featured.jpg"
categories:
  - R
  - package
  - measr
  - dcm
  - Stan
---



I'm stoked to announce the release of [measr](https://measr.info) 0.3.1.
The goal of measr is to provide applied researchers and psychometricians with a user friendly interface for estimating and evaluating diagnostic classification models (DCMs).
This update is a minor release to introduce a couple of enhancements to model and prior specifications.

You can install the update version of measr from CRAN with:


```r
install.packages("measr")
```

This blog post will highlight the two enhancements included in the update.
For a complete list of changes, check out the [changelog](https://measr.info/news/index.html#measr-031).


```r
library(measr)
```

## Model Specifications

In this version, support for a new DCM subtype was added.
The compensatory reparameterized unified model (C-RUM) model can now be specified in `measr_dcm()` with `type = "crum"`.
The C-RUM is similar to the log-linear cognitive diagnostic model (LCDM), except the C-RUM estimates only item-level intercepts and main effects (i.e., no interactions when multiple attributes are measured by an item).
Because of this, along with the addition of the C-RUM, the LCDM now has additional flexibility through the new `max_interaction` argument.
When using `type = "lcdm"`, `max_interaction` specifies the highest level interaction to be estimated.
For example, setting `max_interaction = 2` would estimate the LCDM with only intercepts, main effects, and two-way interactions.
If an item measures 3 or more attributes, the 3-way interactions and higher will be excluded.
Specifying `type = "lcdm"` with `max_interaction = 1` is equivalent to the C-RUM, as 1 indicates that main effects are the highest-level interaction to be estimated.

This version also introduces new options for the structural component of the DCMs.
Currently two attributes structures are possible, and are defined through the `attribute_structure` argument.
The first is `attribute_structure = "unconstrained"`.
This is the default, which makes no assumptions about the relationships between attributes.
Specifying and unconstrained structural model is equivalent to the saturated structural model described by [Hu & Templin (2020)](https://doi.org/10.1080/00273171.2019.1632165) and in Chapter 8 of [Rupp et al. (2010)](https://www.amazon.com/Diagnostic-Measurement-Applications-Methodology-Sciences/dp/1606235273).
The other option currently supported is `attribute_structure = "independent"`.
When an independent attribute structure is specified, the proficiency or the presence of one attribute is independent of other attributes.
Future development will include additional attribute structure specifications such as a reduced loglinear model (e.g., [Thompson, 2018](https://dissertation.wjakethompson.com)) or a Bayesian Network (e.g., [Hu & Templin, 2020](https://doi.org/10.1080/00273171.2019.1632165); [Martinez & Templin, 2023](https://doi.org/10.31234/osf.io/pjc5f)).

## Prior Specifications

There are two main improvements to prior specifications included in this release.
First, custom prior distributions can be specified for the structural model parameters.
We can view the default parameters for each attribute structure specification with:


```r
default_dcm_priors(type = "lcdm", attribute_structure = "unconstrained")
#> # A tibble: 4 × 3
#>   class       coef  prior_def                  
#>   <chr>       <chr> <chr>                      
#> 1 intercept   <NA>  normal(0, 2)               
#> 2 maineffect  <NA>  lognormal(0, 1)            
#> 3 interaction <NA>  normal(0, 2)               
#> 4 structural  Vc    dirichlet(rep_vector(1, C))

default_dcm_priors(type = "lcdm", attribute_structure = "independent")
#> # A tibble: 4 × 3
#>   class       coef  prior_def      
#>   <chr>       <chr> <chr>          
#> 1 intercept   <NA>  normal(0, 2)   
#> 2 maineffect  <NA>  lognormal(0, 1)
#> 3 interaction <NA>  normal(0, 2)   
#> 4 structural  <NA>  beta(1, 1)
```

We can also view the specific parameters available for a specific model using the [`get_parameters()`](https://measr.info/reference/get_parameters.html) function.
For example, using the 


```r
library(tidyverse)

get_parameters(ecpe_qmatrix, attribute_structure = "unconstrained") |> 
  filter(class == "structural")
#> # A tibble: 1 × 4
#>   item_id class      attributes coef  
#>     <int> <chr>      <chr>      <glue>
#> 1      NA structural <NA>       Vc

get_parameters(ecpe_qmatrix, attribute_structure = "independent") |> 
  filter(class == "structural")
#> # A tibble: 3 × 4
#>   item_id class      attributes coef  
#>     <int> <chr>      <chr>      <glue>
#> 1      NA structural <NA>       eta[1]
#> 2      NA structural <NA>       eta[2]
#> 3      NA structural <NA>       eta[3]
```

The second improvement is additional checking of user-specified priors.
Specifically, `measr_dcm()` will now throw and error if we try to specify a prior for a class or coefficient that is inconsistent with our chosen DCM.
For example, in the previous example of structural model priors that there are different parameters depending on whether an unconstrained or independent structure is specified.
If we try to define a prior for `eta[1]`, which is only relevant for an independent structure, but an unconstrained structure is specified, we get an error.


```r
measr_dcm(data = ecpe_data, qmatrix = ecpe_qmatrix,
          resp_id = "resp_id", item_id = "item_id",
          attribute_structure = "unconstrained",
          prior = prior(beta(5,17), class = "structural", coef = "eta[1]"))
#> Error in `abort_bad_argument()`:
#> ! Prior for parameter `eta[1]` with class `structural` is not relevant for the chosen model or specified Q-matrix. See `?get_parameters()` for a list of relevant parameters.
```

As always, please [open an issue](https://github.com/wjakethompson/measr/issues) with any bugs or feature requests for future development!


## Acknowledgments {.appendix}

Featured photo by <a href="https://unsplash.com/@diana_pole?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Diana Polekhina</a> on <a href="https://unsplash.com/photos/silver-and-black-necklace-on-yellow-textile-iUfusOthmgQ?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Unsplash</a>.
  
  
