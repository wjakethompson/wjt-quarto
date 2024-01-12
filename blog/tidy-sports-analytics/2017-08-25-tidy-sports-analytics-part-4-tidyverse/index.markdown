---
title: "Tidy Sports Analytics, Part 4: tidyverse"
date: 2017-08-25
subtitle: ""
description: "In our concluding entry, we reflect on the tidyverse and look at resources for future learning."
image: "featured.jpg"
twitter-card:
  image: "featured.jpg"
open-graph:
  image: "featured.jpg"
categories:
  - R
  - sports
  - tidyverse
layout: single-series
---



This is the final post in the tidy sports analytics series, in which I've been using play-by-play from the 2016 NFL season to demonstrate the power of the [**tidyverse**](http://www.tidyverse.org/). Previously, I've discussed:

- [Part 1](/blog/tidy-sports-analytics/2017-06-09-tidy-sports-analytics-part-1-dplyr/): Data manipulation using **dplyr**;
- [Part 2](/blog/tidy-sports-analytics/2017-06-25-tidy-sports-analytics-part-2-tidyr/): Data reshaping and tidying using **tidyr**;
- [Part 3](/blog/tidy-sports-analytics/2017-07-20-tidy-sports-analytics-part-3-ggplot2/): Data visualization using **ggplot2**.

This post doesn't feature any new data analysis. Instead, I want to use this last post to talk about the **tidyverse** more generally and cover some of other advantages of using these packages for data analysis.

## tidyverse

Although I chose three of the main **tidyverse** packages to highlight in these posts, there are many more packages that fall under this umbrella. In addition to [**dplyr**](http://dplyr.tidyverse.org/), [**tidyr**](http://tidyr.tidyverse.org/), and [**ggplot2**](http://ggplot2.tidyverse.org/), the core **tidyverse** also includes [**readr**](http://readr.tidyverse.org/) for reading in data, [**purrr**](http://purrr.tidyverse.org/) for functional programming, and [**tibble**](http://tibble.tidyverse.org/) for a new type of data frame. There are also packages [outside of the core](http://www.tidyverse.org/packages/) **tidyverse** for importing data, wrangling data, programming, and modeling. These packages are all used for more specific use cases, rather than the general use of the core packages. For example, [**lubridate**](http://lubridate.tidyverse.org/) is used for date-time variables, [**magrittr**](http://magrittr.tidyverse.org/) provides the forward pipe (`%>%`) along with other piping operations, and [**glue**](https://github.com/tidyverse/glue) makes it easier to combine string and date variables.

Because all of these packages use a consistent API, they are all compatible with the pipe operator, making data analysis more streamlined and also more reproducible. By using the pipe operator, your code becomes more readable for others, which facilitates code review and reproducible research.

## Community support

In addition to the programming benefits of the **tidyverse**, there is a supportive community that contributes to the development of the **tidyverse** packages and environment. The "tidyverse" tags on [Twitter](https://twitter.com/search?q=%23tidyverse&src=typd) and [Stack Overflow](https://stackoverflow.com/questions/tagged/tidyverse) are great places to go for help. Here, you'll be able to ask your questions and get feedback to help solve your problems or answer any questions you might have.

In addition, there are many developers that are creating **tidyverse**-adjacent packages. These packages aren't technically part of the **tidyverse**, but they enhance and further functionality. For example, there is a large development environment around **ggplot2**. These [extensions to **ggplot2**](https://exts.ggplot2.tidyverse.org/) provide additional compatible tools such as [network graphs](https://github.com/thomasp85/ggraph), [joy plots](https://github.com/clauswilke/ggjoy), and [animation](https://github.com/dgrtwo/gganimate). Another good example is the [**tidytext**](https://github.com/juliasilge/tidytext) package, which is used for analyzing text passages.

However, these are not the only ways to [contribute to the **tidyverse**](http://www.tidyverse.org/contribute/). You don't have to be a developer or even be able to answer questions on Twitter or Stack Overflow in order to contribute. You can also contribute by using the [**reprex**](http://reprex.tidyverse.org/) package to report issues that you find or contribute documentation to existing packages. No matter how advanced your *R* skills are, there are ways for you to not only use the **tidyverse**, but also contribute to the community!

## Conclusion

The **tidyverse** is a great resource for the greater *R* community. This group of packages provide tools for data science that have a consistent API and greatly improve the readability and reproducibility of your code. In this series of posts, I used NFL play-by-play data as a use case to show how the main components of the **tidyverse** work. We talked about using:

- [**dplyr**](/blog/tidy-sports-analytics/2017-06-09-tidy-sports-analytics-part-1-dplyr/) for data manipulation;
- [**tidyr**](/blog/tidy-sports-analytics/2017-06-25-tidy-sports-analytics-part-2-tidyr/) for reshaping and tidying data;
- [**ggplot2**](/blog/tidy-sports-analytics/2017-07-20-tidy-sports-analytics-part-3-ggplot2/) for data visualization.

With the huge amount of data that is now available for analyzing sports data, the **tidyverse** is able to efficiently wrangle and manipulate data with just a few lines of code, making it an invaluable resource for this and many other analysis projects. For more **tidyverse** resources, checkout:

- [tidyverse.org](http://www.tidyverse.org/)
- [*R for Data Science*](http://r4ds.had.co.nz/)
- [RStudio cheatsheets](https://www.rstudio.com/resources/cheatsheets/)


## Acknowledgments {.appendix}

Featured photo by <a href="https://unsplash.com/@hencetheboom?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Adrian Curiel</a> on <a href="https://unsplash.com/photos/photo-of-assorted-nfl-football-collection-uS4an493LkY?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Unsplash</a>.
  
