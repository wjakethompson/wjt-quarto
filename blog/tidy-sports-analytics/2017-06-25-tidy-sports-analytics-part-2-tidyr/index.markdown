---
title: "Tidy Sports Analytics, Part 2: tidyr"
date: 2017-06-25
subtitle: ""
description: "Learn how to use tidyr for making tidy data frames as we continue our exploration of NFL data."
image: "featured.jpg"
twitter-card:
  image: "featured.jpg"
open-graph:
  image: "featured.jpg"
categories:
  - R
  - sports
  - tidyr
  - tidyverse
---



This is the second in a series of posts that demonstrates how the [**tidyverse**](http://www.tidyverse.org/) can be used to easily explore and analyze NFL play-by-play data. In [part one](/blog/tidy-sports-analytics/2017-06-09-tidy-sports-analytics-part-1-dplyr/), I used the **dplyr** package to calculate the offensive success rate of each NFL offense in during the 2016 season. However, when we left off, I noted that really we should look at the success rate of both offenses and defenses in order to get a better idea of which teams were the best overall. For this, we'll use the [**tidyr**](http://tidyr.tidyverse.org/) package, which is main **tidyverse** package for tidying data. But first, let's talk about the pipe operator.

## Embrace the pipe

The pipe operator (`%>%`) comes from the [**magrittr**](http://magrittr.tidyverse.org/) package, and it is used to make code more readable. Compare the following two chunks of code.


```r
library(tidyverse)

nfl_pbp <- read_rds("data/nfl_pbp_2016.rds")

success <- select(nfl_pbp, game_id = gid, play_id = pid, offense = off,
                  defense = def, play_type = type, down = dwn,
                  to_go = ytg, gained = yds)
success <- filter(success, play_type %in% c("PASS", "RUSH"))
```


```r
library(tidyverse)

nfl_pbp <- read_rds("data/nfl_pbp_2016.rds")

success <- nfl_pbp %>%
  select(game_id = gid, play_id = pid, offense = off, defense = def,
         play_type = type, down = dwn, to_go = ytg, gained = yds) %>%
  filter(play_type %in% c("PASS", "RUSH"))
```

Both code chunks read in the data and do some initial manipulations to calculate success rate using the **dplyr** package (see [part one](/blog/tidy-sports-analytics/2017-06-09-tidy-sports-analytics-part-1-dplyr/) of this series for a more in depth explanation of how these functions work). In the first chunk, the data has to be referenced multiple times to select some variables from `nfl_pbp` and then filter to only passing and rushing plays. However, in the second chunk, all of the data manipulation is contained in a single code stanza, which improves readability.

The pipe works by passing the output of the function on the left as the first argument to the function on the right. So `a %>% f(x, y) %>% g(z)` is interpreted by the computer as `g(f(a, x, y), z)`. These two statements are equivalent, but in the first, it is much easier to see that `a` is passes to function `f()`, which also has arguments `x` and `y`, and then the output of that is passes to function `g()`, which also has argument `z`. In the **tidyverse**, the first argument is always the data frame that the operation is being performed on, and a data frame with the specified operation performed is returned. Thus, all of the **tidyverse** functions are compatible with the `%>%` operator. Many other base *R* functions, such as `unique`, are also compatible with the pipe.

Throughout the rest of this post, and the following posts in this series, we'll use the `%>%` to make the code more readable and straight forward.

## tidyr

In this post, we'll be using the **tidyr** package to calculate the offensive and defensive success rate for each team. Let's remind ourselves what the data looks like.


```r
success
#> # A tibble: 34,149 × 8
#>    game_id play_id offense defense play_type  down to_go gained
#>      <int>   <int> <chr>   <chr>   <chr>     <int> <int>  <int>
#>  1    4257  697182 DEN     CAR     PASS          1    10     11
#>  2    4257  697183 DEN     CAR     PASS          1    10      0
#>  3    4257  697184 DEN     CAR     PASS          2    10      0
#>  4    4257  697185 DEN     CAR     PASS          3    10     12
#>  5    4257  697186 DEN     CAR     PASS          1    10      5
#>  6    4257  697187 DEN     CAR     RUSH          2     5     13
#>  7    4257  697188 DEN     CAR     RUSH          1    10      5
#>  8    4257  697189 DEN     CAR     RUSH          2     5      0
#>  9    4257  697190 CAR     DEN     RUSH          1    10      6
#> 10    4257  697191 CAR     DEN     RUSH          2     4     11
#> # … with 34,139 more rows
```

In the previous post, we grouped the data frame by offense in order to calculate success rate. Now, we want to group by team and offensive or defensive unit to calculate success rate. The problem we face is that there is no `unit` variable. Instead, the unit information is split across two columns: `offense` and `defense`. This is where the **tidyr** package comes into play. There are two main functions within **tidyr** that are used for tidying data:

- `gather`: collapse multiple columns into key-value pairs;
- `spread`: split key-value pairs into multiple columns.

I'll demonstrate how both of these functions are used in our analysis of NFL success rates.

## Using tidyr

Before we start using the **tidyr** package, let's calculate whether each play was a success or not using the processes from the [previous post](/blog/tidy-sports-analytics/2017-06-09-tidy-sports-analytics-part-1-dplyr/).


```r
success <- success %>%
  mutate(
    needed = case_when(
      down == 1 ~ to_go * 0.45,
      down == 2 ~ to_go * 0.60,
      TRUE ~ to_go * 1.00
    ),
    play_success = case_when(
      gained >= needed ~ TRUE,
      gained < needed ~ FALSE
    )
  )
success
#> # A tibble: 34,149 × 10
#>    game_id play_id offense defense play_type  down to_go gained needed
#>      <int>   <int> <chr>   <chr>   <chr>     <int> <int>  <int>  <dbl>
#>  1    4257  697182 DEN     CAR     PASS          1    10     11    4.5
#>  2    4257  697183 DEN     CAR     PASS          1    10      0    4.5
#>  3    4257  697184 DEN     CAR     PASS          2    10      0    6  
#>  4    4257  697185 DEN     CAR     PASS          3    10     12   10  
#>  5    4257  697186 DEN     CAR     PASS          1    10      5    4.5
#>  6    4257  697187 DEN     CAR     RUSH          2     5     13    3  
#>  7    4257  697188 DEN     CAR     RUSH          1    10      5    4.5
#>  8    4257  697189 DEN     CAR     RUSH          2     5      0    3  
#>  9    4257  697190 CAR     DEN     RUSH          1    10      6    4.5
#> 10    4257  697191 CAR     DEN     RUSH          2     4     11    2.4
#> # … with 34,139 more rows, and 1 more variable: play_success <lgl>
```


In order to calculate the success rate for each team and unit combination, we first need to gather the unit information into key-value pairs using the `gather` function.


```r
success %>%
  gather(key = "team_unit", value = "team", offense:defense)
#> # A tibble: 68,298 × 10
#>    game_id play_id play_type  down to_go gained needed play_success team_unit
#>      <int>   <int> <chr>     <int> <int>  <int>  <dbl> <lgl>        <chr>    
#>  1    4257  697182 PASS          1    10     11    4.5 TRUE         offense  
#>  2    4257  697183 PASS          1    10      0    4.5 FALSE        offense  
#>  3    4257  697184 PASS          2    10      0    6   FALSE        offense  
#>  4    4257  697185 PASS          3    10     12   10   TRUE         offense  
#>  5    4257  697186 PASS          1    10      5    4.5 TRUE         offense  
#>  6    4257  697187 RUSH          2     5     13    3   TRUE         offense  
#>  7    4257  697188 RUSH          1    10      5    4.5 TRUE         offense  
#>  8    4257  697189 RUSH          2     5      0    3   FALSE        offense  
#>  9    4257  697190 RUSH          1    10      6    4.5 TRUE         offense  
#> 10    4257  697191 RUSH          2     4     11    2.4 TRUE         offense  
#> # … with 68,288 more rows, and 1 more variable: team <chr>
```

When using the `gather` function, the column names of the collapsed columns become the "key", and the values are the "value". In the function, we chose to name the column of keys `team_unit` and the column of values `team`. We then specified which columns should be collapsed. Each column can be named individually (i.e., `c(offense, defense)`), or you can specify all columns in a range (i.e., `offense:defense`).

Next, as I noted last time, play success is calculated such that it measures whether the play was a success for the offense. This means that if a play was successful for an offense it was unsuccessful for the defense, and vice versa. Therefore, we need to reverse the decision of whether or not a play was successful when we calculate defensive success rates.


```r
success %>%
  gather(key = "team_unit", value = "team", offense:defense) %>%
  mutate(
    play_success = case_when(
      team_unit == "defense" ~ !play_success,
      TRUE ~ play_success
    )
  )
#> # A tibble: 68,298 × 10
#>    game_id play_id play_type  down to_go gained needed play_success team_unit
#>      <int>   <int> <chr>     <int> <int>  <int>  <dbl> <lgl>        <chr>    
#>  1    4257  697182 PASS          1    10     11    4.5 TRUE         offense  
#>  2    4257  697183 PASS          1    10      0    4.5 FALSE        offense  
#>  3    4257  697184 PASS          2    10      0    6   FALSE        offense  
#>  4    4257  697185 PASS          3    10     12   10   TRUE         offense  
#>  5    4257  697186 PASS          1    10      5    4.5 TRUE         offense  
#>  6    4257  697187 RUSH          2     5     13    3   TRUE         offense  
#>  7    4257  697188 RUSH          1    10      5    4.5 TRUE         offense  
#>  8    4257  697189 RUSH          2     5      0    3   FALSE        offense  
#>  9    4257  697190 RUSH          1    10      6    4.5 TRUE         offense  
#> 10    4257  697191 RUSH          2     4     11    2.4 TRUE         offense  
#> # … with 68,288 more rows, and 1 more variable: team <chr>
```

Here, we're saying if the `team_unit` for the observation is equal to defense, `play_success` is equal to the opposite of the current value of play success. If `play_success` is not equal to defense, then the value is unchanged. We can now group by `team` and `team_unit` to calculate the success rate of each offense and defense.


```r
success %>%
  gather(key = "team_unit", value = "team", offense:defense) %>%
  mutate(
    play_success = case_when(
      team_unit == "defense" ~ !play_success,
      TRUE ~ play_success
    )
  ) %>%
  group_by(team, team_unit) %>%
  summarize(success_rate = mean(play_success, na.rm = TRUE))
#> # A tibble: 64 × 3
#> # Groups:   team [32]
#>    team  team_unit success_rate
#>    <chr> <chr>            <dbl>
#>  1 ARI   defense          0.579
#>  2 ARI   offense          0.458
#>  3 ATL   defense          0.512
#>  4 ATL   offense          0.500
#>  5 BAL   defense          0.580
#>  6 BAL   offense          0.410
#>  7 BUF   defense          0.553
#>  8 BUF   offense          0.464
#>  9 CAR   defense          0.542
#> 10 CAR   offense          0.420
#> # … with 54 more rows
```

Finally, we want to spread the data frame back out so there is only one row per team. This is where the `spread` function comes into play.


```r
success %>%
  gather(key = "team_unit", value = "team", offense:defense) %>%
  mutate(
    play_success = case_when(
      team_unit == "defense" ~ !play_success,
      TRUE ~ play_success
    )
  ) %>%
  group_by(team, team_unit) %>%
  summarize(success_rate = mean(play_success, na.rm = TRUE)) %>%
  spread(key = team_unit, value = success_rate)
#> # A tibble: 32 × 3
#> # Groups:   team [32]
#>    team  defense offense
#>    <chr>   <dbl>   <dbl>
#>  1 ARI     0.579   0.458
#>  2 ATL     0.512   0.500
#>  3 BAL     0.580   0.410
#>  4 BUF     0.553   0.464
#>  5 CAR     0.542   0.420
#>  6 CHI     0.550   0.461
#>  7 CIN     0.558   0.464
#>  8 CLE     0.546   0.409
#>  9 DAL     0.521   0.511
#> 10 DEN     0.594   0.423
#> # … with 22 more rows
```

The `spread` function takes the key-value pairs and spread them out into their own columns. The "key" column becomes the column names, so a new column will be created for each value in the "key". We have only two values (offense and defense), meaning that these are the two new columns that are created. Each column is populated with the values associated with that observation in the "value" column specified in the call to the `spread` function. Now we're back to one row per team, so it's easier to see the success rate of each unit for all of the teams.

## Conclusion

This post shows how the **tidyr** package, which is main the data cleaning package in the **tidyverse**, can be used to quickly reshape data in order to facilitate and perform analyses. In the next post, I'm going to demonstrate how the **ggplot2** package can be used to visualize these results. For more **tidyr** resources, check out:

- [tidyr.tidyverse.org](http://tidyr.tidyverse.org/)
- [*R for Data Science*, Tidy Data](http://r4ds.had.co.nz/tidy-data.html)
- [Tidy Data, *Journal of Statistical Software*](http://vita.had.co.nz/papers/tidy-data.html)


## Acknowledgments {.appendix}

Featured photo by <a href="https://unsplash.com/@thomascpark?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Thomas Park</a> on <a href="https://unsplash.com/photos/green-and-white-stripe-pathway-fDmpxdV69eA?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Unsplash</a>.
  
