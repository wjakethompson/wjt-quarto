---
title: "Previewing the 2017 men's NCAA basketball tournament"
date: 2017-03-13
subtitle: ""
description: "Who got the toughest draw, and who is the best bet to cut down the nets?"
image: "featured.jpg"
twitter-card:
  image: "featured.jpg"
open-graph:
  image: "featured.jpg"
categories:
  - R
  - sports
---



March Madness officially tips off tomorrow with the First Four games in Dayton before the round of 64 begins on Thursday. In this post, we'll look at each team's chance of advancing and winning the national title. We'll also look at who was help and hurt most by how the committee seeded the tournament.

As always, the code and data for this post are available on my [Github](https://github.com/wjakethompson/wjakethompson.com) page.


## The Ratings

Using the composite ratings (based off of Elo ratings and adjusted efficiencies), we can calculate the probability of any team beating another using the [Log-5 formula](https://en.wikipedia.org/wiki/Log5). Using those probabilities, we can calculate the probability of any team advancing to each round.


```r
library(dplyr)
library(ggplot2)

bracket2017 <- readRDS("data/2017bracket.rds")
```

## Round by Round Probabilities


```r
bracket2017 %>%
  select(Seed, School, Region, Round_3:Champion) %>%
  knitr::kable(digits = 3, col.names = gsub("_", " ", colnames(.)),
    align = "c", booktabs = TRUE)
```



| Seed |          School           | Region  | Round 3 | Sweet 16 | Elite 8 | Final 4 | Final | Champion |
|:----:|:-------------------------:|:-------:|:-------:|:--------:|:-------:|:-------:|:-----:|:--------:|
|  1   |          Gonzaga          |  West   |  0.976  |  0.825   |  0.539  |  0.399  | 0.245 |  0.158   |
|  1   |      North Carolina       |  South  |  0.976  |  0.811   |  0.606  |  0.371  | 0.226 |  0.119   |
|  1   |         Villanova         |  East   |  0.977  |  0.712   |  0.418  |  0.277  | 0.163 |  0.101   |
|  2   |        Louisville         | Midwest |  0.962  |  0.636   |  0.423  |  0.257  | 0.143 |  0.072   |
|  4   |       West Virginia       |  West   |  0.909  |  0.651   |  0.311  |  0.208  | 0.110 |  0.061   |
|  2   |         Kentucky          |  South  |  0.952  |  0.571   |  0.375  |  0.210  | 0.119 |  0.058   |
|  1   |          Kansas           | Midwest |  0.958  |  0.703   |  0.415  |  0.224  | 0.114 |  0.052   |
|  5   |         Virginia          |  East   |  0.875  |  0.521   |  0.267  |  0.165  | 0.090 |  0.051   |
|  2   |           Duke            |  East   |  0.942  |  0.665   |  0.375  |  0.165  | 0.078 |  0.040   |
|  4   |          Florida          |  East   |  0.866  |  0.433   |  0.201  |  0.114  | 0.057 |  0.030   |
|  10  |       Wichita State       |  South  |  0.762  |  0.368   |  0.228  |  0.119  | 0.063 |  0.028   |
|  4   |          Purdue           | Midwest |  0.825  |  0.493   |  0.261  |  0.130  | 0.061 |  0.025   |
|  3   |          Baylor           |  East   |  0.888  |  0.510   |  0.274  |  0.111  | 0.049 |  0.023   |
|  3   |          Oregon           | Midwest |  0.910  |  0.584   |  0.261  |  0.130  | 0.058 |  0.023   |
|  3   |       Florida State       |  West   |  0.896  |  0.627   |  0.344  |  0.125  | 0.050 |  0.022   |
|  6   |    Southern Methodist     |  East   |  0.787  |  0.417   |  0.219  |  0.086  | 0.037 |  0.017   |
|  7   |     Saint Mary's (CA)     |  West   |  0.736  |  0.431   |  0.250  |  0.091  | 0.037 |  0.016   |
|  5   |        Iowa State         | Midwest |  0.770  |  0.401   |  0.197  |  0.091  | 0.039 |  0.015   |
|  4   |          Butler           |  South  |  0.884  |  0.583   |  0.220  |  0.091  | 0.037 |  0.013   |
|  3   |           UCLA            |  South  |  0.907  |  0.485   |  0.190  |  0.081  | 0.034 |  0.012   |
|  2   |          Arizona          |  West   |  0.925  |  0.471   |  0.248  |  0.079  | 0.028 |  0.011   |
|  6   |        Cincinnati         |  South  |  0.649  |  0.360   |  0.147  |  0.065  | 0.029 |  0.010   |
|  8   |         Wisconsin         |  East   |  0.732  |  0.244   |  0.098  |  0.047  | 0.020 |  0.009   |
|  7   |         Michigan          | Midwest |  0.536  |  0.202   |  0.106  |  0.049  | 0.020 |  0.007   |
|  5   |        Notre Dame         |  West   |  0.763  |  0.287   |  0.094  |  0.047  | 0.017 |  0.007   |
|  6   |         Creighton         | Midwest |  0.634  |  0.282   |  0.100  |  0.040  | 0.014 |  0.004   |
|  10  |      Oklahoma State       | Midwest |  0.464  |  0.160   |  0.078  |  0.034  | 0.013 |  0.004   |
|  8   |        Miami (FL)         | Midwest |  0.573  |  0.181   |  0.069  |  0.023  | 0.007 |  0.002   |
|  5   |         Minnesota         |  South  |  0.602  |  0.258   |  0.071  |  0.022  | 0.006 |  0.002   |
|  7   |      South Carolina       |  East   |  0.503  |  0.165   |  0.059  |  0.015  | 0.004 |  0.001   |
|  10  |         Marquette         |  East   |  0.497  |  0.162   |  0.057  |  0.014  | 0.004 |  0.001   |
|  11  |          Xavier           |  West   |  0.544  |  0.200   |  0.073  |  0.016  | 0.004 |  0.001   |
|  8   |         Arkansas          |  South  |  0.532  |  0.104   |  0.042  |  0.011  | 0.003 |  0.001   |
|  11  |       Kansas State        |  South  |  0.190  |  0.080   |  0.023  |  0.007  | 0.002 |  0.001   |
|  9   |        Vanderbilt         |  West   |  0.507  |  0.088   |  0.025  |  0.009  | 0.002 |  0.001   |
|  9   |      Michigan State       | Midwest |  0.427  |  0.111   |  0.035  |  0.010  | 0.002 |  0.000   |
|  8   |       Northwestern        |  West   |  0.493  |  0.084   |  0.023  |  0.008  | 0.002 |  0.000   |
|  6   |         Maryland          |  West   |  0.456  |  0.151   |  0.050  |  0.009  | 0.002 |  0.000   |
|  11  |       Rhode Island        | Midwest |  0.366  |  0.120   |  0.029  |  0.008  | 0.002 |  0.000   |
| 11a  |        Wake Forest        |  South  |  0.162  |  0.065   |  0.017  |  0.005  | 0.002 |  0.000   |
|  9   |        Seton Hall         |  South  |  0.468  |  0.083   |  0.031  |  0.007  | 0.002 |  0.000   |
|  7   |          Dayton           |  South  |  0.238  |  0.057   |  0.019  |  0.005  | 0.001 |  0.000   |
|  10  |   Virginia Commonwealth   |  West   |  0.264  |  0.092   |  0.032  |  0.006  | 0.001 |  0.000   |
|  12  |     Middle Tennessee      |  South  |  0.398  |  0.135   |  0.028  |  0.006  | 0.001 |  0.000   |
|  9   |       Virginia Tech       |  East   |  0.268  |  0.043   |  0.009  |  0.002  | 0.000 |  0.000   |
|  12  |          Nevada           | Midwest |  0.230  |  0.061   |  0.014  |  0.003  | 0.001 |  0.000   |
|  11  |        Providence         |  East   |  0.119  |  0.032   |  0.008  |  0.001  | 0.000 |  0.000   |
|  12  |         Princeton         |  West   |  0.237  |  0.042   |  0.006  |  0.001  | 0.000 |  0.000   |
|  13  |          Vermont          | Midwest |  0.175  |  0.045   |  0.009  |  0.002  | 0.000 |  0.000   |
| 11a  |    Southern California    |  East   |  0.094  |  0.023   |  0.005  |  0.001  | 0.000 |  0.000   |
|  12  | North Carolina-Wilmington |  East   |  0.125  |  0.025   |  0.004  |  0.001  | 0.000 |  0.000   |
|  13  |   East Tennessee State    |  East   |  0.134  |  0.021   |  0.003  |  0.000  | 0.000 |  0.000   |
|  13  |         Bucknell          |  West   |  0.091  |  0.020   |  0.002  |  0.000  | 0.000 |  0.000   |
|  14  |     New Mexico State      |  East   |  0.112  |  0.018   |  0.003  |  0.000  | 0.000 |  0.000   |
|  14  |    Florida Gulf Coast     |  West   |  0.104  |  0.022   |  0.003  |  0.000  | 0.000 |  0.000   |
|  13  |         Winthrop          |  South  |  0.116  |  0.024   |  0.002  |  0.000  | 0.000 |  0.000   |
|  14  |           Iona            | Midwest |  0.090  |  0.014   |  0.001  |  0.000  | 0.000 |  0.000   |
|  14  |        Kent State         |  South  |  0.093  |  0.010   |  0.001  |  0.000  | 0.000 |  0.000   |
|  15  |           Troy            |  East   |  0.058  |  0.007   |  0.001  |  0.000  | 0.000 |  0.000   |
|  15  |     Northern Kentucky     |  South  |  0.048  |  0.004   |  0.000  |  0.000  | 0.000 |  0.000   |
|  15  |       North Dakota        |  West   |  0.075  |  0.006   |  0.001  |  0.000  | 0.000 |  0.000   |
|  16  |  North Carolina Central   | Midwest |  0.031  |  0.004   |  0.000  |  0.000  | 0.000 |  0.000   |
|  15  |    Jacksonville State     | Midwest |  0.038  |  0.003   |  0.000  |  0.000  | 0.000 |  0.000   |
|  16  |    South Dakota State     |  West   |  0.024  |  0.003   |  0.000  |  0.000  | 0.000 |  0.000   |
|  16  |      Texas Southern       |  South  |  0.024  |  0.003   |  0.000  |  0.000  | 0.000 |  0.000   |
| 16a  |        New Orleans        |  East   |  0.013  |  0.001   |  0.000  |  0.000  | 0.000 |  0.000   |
| 16a  |         UC-Davis          | Midwest |  0.011  |  0.001   |  0.000  |  0.000  | 0.000 |  0.000   |
|  16  |     Mount St. Mary's      |  East   |  0.010  |  0.001   |  0.000  |  0.000  | 0.000 |  0.000   |

Gonzaga comes in as the favorite using my ratings with a 15.8% chance winning the title, followed by North Carolina and overall number 1 seed Villanova. Kansas, the other number 1 seed is the 7th most likely team to cut down the nets with a 5.2% chance.

## Region Difficulty

To see who got help and hurt by their seeding, we can first look at the talent level in each region. To do this, I'll take the average offensive and defensive rating of all the teams in a region, and then calculate a net rating. To keep the extra teams playing in the First Four from bringing down the region average, I'll keep only favorite from each of the play in games.


```r
bracket2017 %>%
  filter(!grepl("a", Seed)) %>%
  group_by(Region) %>%
  summarize(Offense = mean(Offense), Defense = mean(Defense)) %>%
  mutate(Net = Offense - Defense) %>%
  arrange(desc(Net)) %>%
  knitr::kable(digits = 2, align = "c", booktabs = TRUE)
```



| Region  | Offense | Defense |  Net  |
|:-------:|:-------:|:-------:|:-----:|
|  East   | 113.21  |  93.71  | 19.50 |
| Midwest | 113.43  |  94.62  | 18.81 |
|  West   | 112.41  |  94.76  | 17.66 |
|  South  | 112.24  |  94.95  | 17.29 |

Villanova and Kansas, although the top two seeds in the tournament, weren't given any favors, as they ended up in the two toughest regions in field. North Carolina, on the other hand, has the easiest region using these ratings.

We can also look at the direct impact of the seeding process. Using the consensus bracket from the [Bracket Matrix](http://www.bracketmatrix.com/), we can get a good gauge of where teams should have been seeded. I have calculated the probability of each team making the Final Four using the consensus bracket so we can compare these numbers to the probabilities from the real bracket.


```r
seeding <- bracket2017 %>%
  select(Seed, School, Region, Con_Final4, Final_4) %>%
  mutate(Change = Final_4 - Con_Final4) %>%
  select(-(Con_Final4:Final_4)) %>%
  arrange(desc(Change))

knitr::kable(head(seeding), digits = 3, align = "c", booktabs = TRUE)
```



| Seed |     School     | Region  | Change |
|:----:|:--------------:|:-------:|:------:|
|  1   | North Carolina |  South  | 0.073  |
|  1   |     Kansas     | Midwest | 0.064  |
|  1   |    Gonzaga     |  West   | 0.046  |
|  4   | West Virginia  |  West   | 0.036  |
|  4   |     Butler     |  South  | 0.033  |
|  2   |   Louisville   | Midwest | 0.033  |

Although Kansas is in the second hardest region, they are 6.4% more likely to make the Final Four under the real bracket compared to the consensus bracket. This is because the bottom half of the Midwest region is much stronger relative to other regions, while the top half is slightly easier. Thus, the region as a whole is strong, but Kansas would only have to beat one of the teams from the bottom half in order to advance to the Final Four. Unsurprisingly, North Carolina, who is in the easiest region, benefits the most from the real seeding. They are 7.3% more likely to make the Final Four than when using the consensus bracket.


```r
knitr::kable(tail(seeding), digits = 3, align = "c", booktabs = TRUE)
```



| Seed |  School   | Region | Change |
|:----:|:---------:|:------:|:------:|
|  8   | Wisconsin |  East  | -0.020 |
|  3   |  Baylor   |  East  | -0.038 |
|  2   |   Duke    |  East  | -0.054 |
|  4   |  Florida  |  East  | -0.056 |
|  2   | Kentucky  | South  | -0.059 |
|  1   | Villanova |  East  | -0.129 |

On the other end of the spectrum, Villanova was hurt the most by the real bracket by far. They are 12.9% less likely to make the Final Four than if the consensus bracket were used. In fact, this list is dominated by good teams who were all placed in the East region, and therefore have to fight each other to get out. The exception is Kentucky, who is 5.9% less likely to make the Final Four after drawing potential matchups with Wichita State, UCLA, and North Carolina.


## Acknowledgments {.appendix}

Featured photo by <a href="https://unsplash.com/@markusspiske?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Markus Spiske</a> on <a href="https://unsplash.com/photos/ball-under-basketball-ring-BfphcCvhl6E?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Unsplash</a>.
  
