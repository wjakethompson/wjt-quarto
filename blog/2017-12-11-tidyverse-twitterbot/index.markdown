---
title: "Using rtweet to Create a tidyverse Twitterbot"
date: 2017-12-11
subtitle: ""
description: "See the inner workings of a Twitter bot that sends out new tidyverse questions."
image: "featured-rtweet-hex.png"
twitter-card:
  image: "featured-rtweet-hex.png"
open-graph:
  image: "featured-rtweet-hex.png"
categories:
  - R
  - tidyverse
  - rtweet
---

A while back, I was inspired by this Twitter exchange to create a bot that would tweet out tidyverse related material.

{{< tweet agentzeronine 930526766116073473 >}}

Last week I finally had enough time to sit and put some work in to get this idea up and running! This post will walk through how I created the [@tidyversetweets](https://twitter.com/tidyversetweets) Twitter bot using the great [**rtweet**](https://docs.ropensci.org/rtweet/) package by [Mike Kearney](https://twitter.com/kearneymw).

## Step 1: Get the data

Before we can tweet out anything, we need to know what we are going to tweet. As of the writing of this post, [@tidyversetweets](https://twitter.com/tidyversetweets) will tweet out new tidyverse questions on StackOverflow, and new discussions from certain topics on the [RStudio Community](https://community.rstudio.com/). Let’s start by pulling in data from StackOverflow API. This is made easy using the [**stackr**](https://github.com/dgrtwo/stackr) package from StackOverflow data scientist [David Robinson](https://twitter.com/drob).

First, we’ll define a couple of functions to easily query questions, given a tag. We can use the `safely` function from the [**purrr**](http://purrr.tidyverse.org/) package to handle errors (e.g., no questions for a given tag are found).

``` r
library(tidyverse)
library(stackr)

safe_stack_questions <- safely(stack_questions)
query_tag <- function(tag) {
  query <- safe_stack_questions(pagesize = 100, tagged = tag)
  return(query)
}
```

We can then define the tags that we want to look up on StackOverflow. For now, I’ve listed all the packages that are included in the [official list of tidyverse packages](https://www.tidyverse.org/packages/).

``` r
tidyverse <- c("tidyverse", "ggplot2", "dplyr", "tidyr", "readr", "purrr",
  "tibble", "readxl", "haven", "jsonlite", "xml2", "httr", "rvest", "DBI;r",
  "stringr", "lubridate", "forcats", "hms", "blob;r", "rlang", "magrittr",
  "glue", "recipes", "rsample", "modelr")
```

Finally, we can use the `map` function (also from the **purrr** package) to query all of the defined tags, and pull out the results to a data frame using `map_dfr`. We then do a little bit of clean up to correct some character encoding issues, remove duplicate questions that were collected under multiple tags (e.g., a question that was tagged `tidyverse` and `dplyr`), and arrange by the time the question was posted.

``` r
tidy_so <- map(tidyverse, query_tag) %>%
  map_dfr(~(.$result %>% as.tibble())) %>%
  select(title, creation_date, link) %>%
  mutate(
    title = str_replace_all(title, "&#39;", "'"),
    title = str_replace_all(title, "&quot;", '"')
  ) %>%
  distinct() %>%
  arrange(creation_date)

tidy_so
#> # A tibble: 1,836 × 3
#>    title                        creation_date       link                        
#>    <chr>                        <dttm>              <chr>                       
#>  1 "ggplot with 2 y axes on ea… 2010-06-23 00:52:19 https://stackoverflow.com/q…
#>  2 "How do you read multiple .… 2010-08-03 10:08:55 https://stackoverflow.com/q…
#>  3 "How can I extract plot axe… 2011-10-09 12:50:40 https://stackoverflow.com/q…
#>  4 "R : readBin and writeBin (… 2012-07-23 00:22:16 https://stackoverflow.com/q…
#>  5 "How to display only intege… 2013-03-25 13:23:29 https://stackoverflow.com/q…
#>  6 "R re-arrange dataframe: so… 2013-10-13 09:01:37 https://stackoverflow.com/q…
#>  7 "annotation_logticks() and … 2013-12-08 16:50:34 https://stackoverflow.com/q…
#>  8 "filter for complete cases … 2014-03-12 08:50:15 https://stackoverflow.com/q…
#>  9 "passing function argument … 2014-04-07 12:43:24 https://stackoverflow.com/q…
#> 10 "Speed up API calls in R"    2014-04-10 06:27:48 https://stackoverflow.com/q…
#> # … with 1,826 more rows
```

The next step is to pull new topics that have been posted to the RStudio Community site. To do this, we can use the [**feedeR**](https://github.com/DataWookie/feedeR) package from [Andrew Collier](https://twitter.com/DataWookie). This package is great for dealing with RSS feeds in *R*. As we did when querying StackOverflow, we’ll first define a function to query the RSS feed we’re interested in. This function uses the [**glue**](http://glue.tidyverse.org/) package to construct the RSS feed URL from the category that is supplied.

``` r
library(feedeR)
library(glue)

query_community <- function(category) {
  query <- feed.extract(glue("https://community.rstudio.com/c/{category}.rss"))
  return(query)
}
```

For now, only the `tidyverse` and `teaching` categories are queried for the [@tidyversetweets](https://twitter.com/tidyversetweets). This is because other categories generally have topics that are not directly related to the tidyverse, which is the focus of this bot. Once the `query_community` function is defined, the process for scraping the information is very similar to that used for StackOverflow. There is, however, one additional layer of complexity for the RSS data. In the raw data, a new entry is created for each comment that is made within the category. For the Twitterbot, we only want to tweet out new topics, meaning that we only want the first entry for each topic. Therefore, we can group by the topic, and select only the entry with the earliest creation date within each topic.

``` r
rstudio <- c("tidyverse", "teaching")

tidy_rc <- map(rstudio, query_community) %>%
  map_dfr(~(.$items %>% as.tibble())) %>%
  select(title, creation_date = date, link) %>%
  group_by(title) %>%
  top_n(n = -1, wt = creation_date) %>%
  arrange(creation_date)

tidy_rc
#> # A tibble: 50 × 3
#> # Groups:   title [50]
#>    title                        creation_date       link                        
#>    <chr>                        <dttm>              <chr>                       
#>  1 Hide solution but check ans… 2021-01-08 22:35:42 https://community.rstudio.c…
#>  2 Support education of low-in… 2021-01-19 19:30:52 https://community.rstudio.c…
#>  3 Best practice for rstudio.c… 2021-01-26 16:03:45 https://community.rstudio.c…
#>  4 Writing on html slides crea… 2021-01-28 17:52:48 https://community.rstudio.c…
#>  5 unable to compile tutorial   2021-02-04 22:42:38 https://community.rstudio.c…
#>  6 How to create a reprex cont… 2021-02-06 12:11:09 https://community.rstudio.c…
#>  7 Thread for students in Gov … 2021-02-14 16:31:04 https://community.rstudio.c…
#>  8 Thread for STATS 412/612 st… 2021-02-23 16:19:00 https://community.rstudio.c…
#>  9 Looking for a learnr contri… 2021-02-25 16:52:46 https://community.rstudio.c…
#> 10 Can you prevent skipping qu… 2021-03-04 17:50:11 https://community.rstudio.c…
#> # … with 40 more rows
```

Now that we have all of the data, it’s time to tweet!

## Step 2: Tweet!

We don’t want to tweet every question and topic that have ever been submitted, just the new ones. I have set up [@tidyversetweets](https://twitter.com/tidyversetweets) to run every five minutes, therefore we can filter the questions and topics to only those that were posted in the last five minutes since the bot ran.

``` r
library(lubridate)

cur_time <- ymd_hms(Sys.time(), tz = Sys.timezone())

all_update <- bind_rows(tidy_so, tidy_rc) %>%
  arrange(creation_date) %>%
  filter(creation_date > cur_time - dminutes(5))
```

Finally, we cycle through the questions and topics to tweet. The tweet text is always the title of the question or topic, followed by the [#tidyverse](https://twitter.com/hashtag/tidyverse?src=hash) and [#rstats](https://twitter.com/hashtag/rstats?src=hash) hashtags, and then the link to the original post. To make sure we don’t exceed Twitter’s character limit, we can first do some checking to make sure that the title is never more than 250 characters, and truncate the title if it does go over 250. Yay for the higher limit!

We can then compose the tweet’s text using the **glue** package. Finally, the **rtweet** package makes it super easy to tweet from *R*. **rtweet** makes the connection to Twitter seamless for querying, streaming, and analyzing tweets. It does take a little bit of extra setup in order to post tweets, but the package has great documentation for [how to do that](https://cran.r-project.org/web/packages/rtweet/vignettes/auth.html). And that’s it! Once **rtweet** is setup, we’re ready to send out our tweets of new questions!

``` r
library(rtweet)

pwalk(.l = all_update, .f = function(title, creation_date, link) {
  if (nchar(title) > 250) {
    trunc_points <- str_locate_all(title, " ") %>%
      .[[1]] %>%
      .[,1]
    trunc <- max(trunc_points[which(trunc_points < 247)]) - 1
    title <- paste0(str_sub(title, start = 1, end = trunc), "...")
  }
  
  tweet_text <- glue("{title} #tidyverse #rstats {link}")
  post_tweet(tweet_text)
})
```

Ultimately, I’d like set up [@tidyversetweets](https://twitter.com/tidyversetweets) to run off of webhooks and updating instantaneously, rather than relying on a script to run every five minutes. But for now, this does a decent enough job, and was an excellent opportunity to demonstrate how easy it is to interact with Twitter using **rtweet**. If you have any questions or suggestions for improvement, feel free to leave a comment here, reach out to me on Twitter ([@wjakethompson](https://twitter.com/wjakethompson)), or file an issue on [Github](https://github.com/wjakethompson/tidyverse-tweets/issues).
