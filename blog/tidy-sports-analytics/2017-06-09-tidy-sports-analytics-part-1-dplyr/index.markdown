---
title: "Tidy Sports Analytics, Part 1: dplyr"
date: 2017-06-09
subtitle: ""
description: "Learn how to use dplyr for data manipulation as we explore NFL data."
image: "featured.jpg"
twitter-card:
  image: "featured.jpg"
open-graph:
  image: "featured.jpg"
categories:
  - R
  - sports
  - dplyr
  - tidyverse
---



Welcome to the first in a series of blog posts where I'll be using sports data to demonstrate the power of the [**tidyverse**](http://www.tidyverse.org/) tools in the context of sports analytics. The **tidyverse** is a suite of packages developed mainly by [Hadley Wickham](https://twitter.com/hadleywickham), with contributions from over 100 other people in the *R* community. The goal of the **tidyverse** is to provide easy to use *R* packages for a data science workflow that all follow a consistent philosophy and API. In each post in this series, I'll be focusing on one package within the **tidyverse** in order to demonstrate how each of the major pieces of the **tidyverse** works. In all of the posts, I'll be exploring the play-by-play data for every game of the 2016 NFL season. This data comes from [Armchair Analysis](http://armchairanalysis.com/), which is pay-walled. However, for a a one time flat rate, you can have access to their historical database with yearly updates forever.

This post will focus on the [**dplyr**](http://dplyr.tidyverse.org/) package, which is used for data manipulation.

## dplyr

Before we get into how **dplyr** works, let's first load in our data.


```r
library(tidyverse)

nfl_pbp <- read_rds("data/nfl_pbp_2016.rds")
nfl_pbp
#> # A tibble: 44,385 × 30
#>      gid    pid off   def   type   dseq   len   qtr   min   sec  ptso  ptsd
#>    <int>  <int> <chr> <chr> <chr> <int> <int> <int> <int> <int> <int> <int>
#>  1  4257 697181 DEN   CAR   KOFF      0     6     1    15     0     0     0
#>  2  4257 697182 DEN   CAR   PASS      1    30     1    15     0     0     0
#>  3  4257 697183 DEN   CAR   PASS      2     4     1    14    17     0     0
#>  4  4257 697184 DEN   CAR   PASS      3     5     1    14    13     0     0
#>  5  4257 697185 DEN   CAR   PASS      4    26     1    14     8     0     0
#>  6  4257 697186 DEN   CAR   PASS      5    41     1    13    42     0     0
#>  7  4257 697187 DEN   CAR   RUSH      6    38     1    13     1     0     0
#>  8  4257 697188 DEN   CAR   RUSH      7    36     1    12    23     0     0
#>  9  4257 697189 DEN   CAR   RUSH      8    10     1    11    47     0     0
#> 10  4257 697190 CAR   DEN   RUSH      1    36     1    11    37     0     0
#> # … with 44,375 more rows, and 18 more variables: timo <int>, timd <int>,
#> #   dwn <int>, ytg <int>, yfog <int>, zone <int>, fd <int>, sg <int>, nh <int>,
#> #   pts <int>, tck <int>, sk <int>, pen <int>, ints <int>, fum <int>,
#> #   saf <int>, blk <int>, yds <int>
```

Here we can see that there were a total of 44,385 plays in the 2016 NFL season, and we have 30 variables for each play. The **dplyr** package provides a way to manipulate this data so that we can easily answer research questions. There are five main functions in **dplyr** that take care of the majority of data manipulation tasks:

- `arrange`: sort the data by a variable or set of variables;
- `filter`: filter observations based on one or more criteria;
- `mutate`: create new variables as functions of existing variables;
- `select`: choose variables by name, or rename variables;
- `summarize`: calculate summary statistics according to one or more grouping variables.

To demonstrate how these functions work, let's calculate the rate of successful plays for each team. For the NFL, we'll consider a play successful if the team gains a certain percentage of the yards necessary, that varies by down. Specifically, the yards needed in order for they play to be successful by down is as follows:

- 1st down: 45 percent of the needed yards;
- 2nd down: 60 percent of the needed yards;
- 3rd and 4th down: 100 percent of the needed yards

These values comes from Bob Carroll, Pete Palmer, and John Thorn in [*The Hidden Game of Football*](https://www.amazon.com/Hidden-Game-Football-Bob-Carroll/dp/0446514144). In this definition, each play is independent. Say for example that a team starts with a 1st down and 10 yards to go. In order for the play to be successful, they need to gain 4.5 yards. They gain 6, so this play is successful. Now it is 2nd and 4. For this play to be successful, they need 60 percent of the 4 yards remaining, meaning they need to gain 2.4 yards. Instead they lose 1 yard, so this play is unsuccessful and it is now 3rd and 5. On third down they need all 5 yards (meaning they need to make the new set of downs), in order for the play to be successful. The calculations continue in this way for every play in the data set.

## Using dplyr

First I'll pull out the needed variables using the `select` function.


```r
success <- select(nfl_pbp, game_id = gid, play_id = pid, offense = off,
  defense = def, play_type = type, down = dwn, to_go = ytg, gained = yds)
success
#> # A tibble: 44,385 × 8
#>    game_id play_id offense defense play_type  down to_go gained
#>      <int>   <int> <chr>   <chr>   <chr>     <int> <int>  <int>
#>  1    4257  697181 DEN     CAR     KOFF          0     0     NA
#>  2    4257  697182 DEN     CAR     PASS          1    10     11
#>  3    4257  697183 DEN     CAR     PASS          1    10      0
#>  4    4257  697184 DEN     CAR     PASS          2    10      0
#>  5    4257  697185 DEN     CAR     PASS          3    10     12
#>  6    4257  697186 DEN     CAR     PASS          1    10      5
#>  7    4257  697187 DEN     CAR     RUSH          2     5     13
#>  8    4257  697188 DEN     CAR     RUSH          1    10      5
#>  9    4257  697189 DEN     CAR     RUSH          2     5      0
#> 10    4257  697190 CAR     DEN     RUSH          1    10      6
#> # … with 44,375 more rows
```

Notice that in the `select` statement, we not only chose the variables we wanted, but we also gave them new names that more clearly convey the information included in that variable. For example, we chose to keep the unique game identifier, but we renamed it from `gid` to `game_id`.

Next, we need to filter out plays that don't fall into our operational definition of success. For example, under the definition above, how would we determine if a kickoff was successful? Since only passing or rushing plays have criteria for success, we will use the `filter` function to select only passing or rushing plays.


```r
success <- filter(success, play_type %in% c("PASS", "RUSH"))
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

This leaves us with 34,149 plays. The next step is to calculate the number of yards needed in order for the play to be deemed successful. This can be done using the `mutate` function along with the `case_when` function. The `case_when` function acts like a series of if statements to determine the proper condition.


```r
success <- mutate(success, needed = case_when(
  down == 1 ~ to_go * 0.45,
  down == 2 ~ to_go * 0.60,
  TRUE ~ to_go * 1.00
))
success
#> # A tibble: 34,149 × 9
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
#> # … with 34,139 more rows
```

In this chunk, I'm saying if the down is equal to 1, then the yards needed is equal to 45 percent of the yards to go. If the down isn't equal to 1, then we go to the second condition. If the down is equal to 2, the yards needed is equal to 60 percent of the yards to go. Finally, if the down isn't equal to 2, then we go to the final condition which says that for all other downs, yards needed is equal to 100 percent of the yards to go. We can then determine which plays were a success by using mutate again to calculate if the yards gained is greater than the yards needed.


```r
success <- mutate(success, play_success = case_when(
  gained >= needed ~ TRUE,
  gained < needed ~ FALSE
))
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

Now that we've calculated whether each play was a success, we can calculate the overall success rate for each team. To do this, we need to group our data by team. This can be accomplished using the `group_by` function. This function doesn't do anything to the data, but it will allow other functions to operate within each of the groups. Specifically, we will use the `summarize` function to calculate the rate of successful plays within each group.


```r
success <- group_by(success, team = offense)
success <- summarize(success, success_rate = mean(play_success, na.rm = TRUE))
success
#> # A tibble: 32 × 2
#>    team  success_rate
#>    <chr>        <dbl>
#>  1 ARI          0.458
#>  2 ATL          0.500
#>  3 BAL          0.410
#>  4 BUF          0.464
#>  5 CAR          0.420
#>  6 CHI          0.461
#>  7 CIN          0.464
#>  8 CLE          0.409
#>  9 DAL          0.511
#> 10 DEN          0.423
#> # … with 22 more rows
```

Finally, I will use the `arrange` function to sort this data set by the success rate, allowing us to see which teams were the most successful on average. Note that I use the `desc` function to sort success rate in a descending manner, so that the teams with the highest success rates are first. By default the `arrange` function sorts ascending.


```r
success <- arrange(success, desc(success_rate))
success
#> # A tibble: 32 × 2
#>    team  success_rate
#>    <chr>        <dbl>
#>  1 NO           0.518
#>  2 DAL          0.511
#>  3 ATL          0.500
#>  4 WAS          0.478
#>  5 GB           0.478
#>  6 IND          0.471
#>  7 TEN          0.469
#>  8 BUF          0.464
#>  9 CIN          0.464
#> 10 PIT          0.461
#> # … with 22 more rows
```

One consideration from these results is that I grouped by the offensive team. Thus, this analysis tells us how often the teams' offenses were successful. To evaluate a team overall, you would also want to examine defensive success rates. However, these results do seem to make intuitive sense, as the top three teams (New Orleans, Dallas, and Atlanta), all had very good offenses last season.

## Conclusion

This post shows how the **dplyr** package, which is the main data manipulation package in the **tidyverse**, can be used to quickly manipulate and analyze data with just a few lines of code. In the upcoming posts I'll be using the **tidyr** package to help tidy data and **ggplot2** to visualize data. I'll also be introducing the pipe operator in the next post, which will make our code more readable. For more **dplyr** resources, check out:

- [dplyr.tidyverse.org](http://dplyr.tidyverse.org/)
- [*R for Data Science*, Data Transformation](http://r4ds.had.co.nz/transform.html)


## Acknowledgments {.appendix}

Featured photo by <a href="https://unsplash.com/@aussiedave?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Dave Adamson</a> on <a href="https://unsplash.com/photos/brown-and-black-wilson-football--nATH0CrkMU?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Unsplash</a>.
  
