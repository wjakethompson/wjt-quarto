---
title: "taylor 1.0.0"
date: 2021-12-17
subtitle: ""
description: "Initial release of taylor for accessing data on Taylor Swift's discography."
image: "sidebar-hex.png"
twitter-card:
  image: "sidebar-hex.png"
open-graph:
  image: "sidebar-hex.png"
categories:
  - R
  - package
  - taylor
  - Taylor Swift
---





I'm all too excited to announce the release of [taylor](https://taylor.wjakethompson.com) 1.0.0.
taylor provides data on Taylor Swift's discography, including lyrics from [Genius](https://genius.com/artists/Taylor-swift) and song characteristics from [Spotify](https://open.spotify.com/artist/06HL4z0CvFAxyc27GXpf02).

You can install it from CRAN with:


```r
install.packages("taylor")
```

This blog post will highlight the major changes in this release, including the addition of data from *Red (Taylor's Version)* and other updates to [color palette functionality](/blog/taylor/2021-10-16-taylor-palettes/).


```r
library(taylor)
```


## Red (Taylor's Version)

The biggest update is the addition of data from *Red (Taylor's Version)*
You can now find Spotify data and lyrics for all 30(!!) songs in [`taylor_all_songs`](https://taylor.wjakethompson.com/reference/taylor_all_songs.html).


```r
library(tidyverse)

taylor_all_songs %>% 
  filter(album_name == "Red (Taylor's Version)")
#> # A tibble: 30 × 29
#>    album_name   ep    album_release track_number track_name     artist featuring
#>    <chr>        <lgl> <date>               <int> <chr>          <chr>  <chr>    
#>  1 Red (Taylor… FALSE 2021-11-12               1 State Of Grac… Taylo… <NA>     
#>  2 Red (Taylor… FALSE 2021-11-12               2 Red (Taylor's… Taylo… <NA>     
#>  3 Red (Taylor… FALSE 2021-11-12               3 Treacherous (… Taylo… <NA>     
#>  4 Red (Taylor… FALSE 2021-11-12               4 I Knew You We… Taylo… <NA>     
#>  5 Red (Taylor… FALSE 2021-11-12               5 All Too Well … Taylo… <NA>     
#>  6 Red (Taylor… FALSE 2021-11-12               6 22 (Taylor's … Taylo… <NA>     
#>  7 Red (Taylor… FALSE 2021-11-12               7 I Almost Do (… Taylo… <NA>     
#>  8 Red (Taylor… FALSE 2021-11-12               8 We Are Never … Taylo… <NA>     
#>  9 Red (Taylor… FALSE 2021-11-12               9 Stay Stay Sta… Taylo… <NA>     
#> 10 Red (Taylor… FALSE 2021-11-12              10 The Last Time… Taylo… Gary Lig…
#> # … with 20 more rows, and 22 more variables: bonus_track <lgl>,
#> #   promotional_release <date>, single_release <date>, track_release <date>,
#> #   danceability <dbl>, energy <dbl>, key <int>, loudness <dbl>, mode <int>,
#> #   speechiness <dbl>, acousticness <dbl>, instrumentalness <dbl>,
#> #   liveness <dbl>, valence <dbl>, tempo <dbl>, time_signature <int>,
#> #   duration_ms <int>, explicit <lgl>, key_name <chr>, mode_name <chr>,
#> #   key_mode <chr>, lyrics <list>
```

*Red (Taylor's Version)* has also replaced the original *Red* in [`taylor_album_songs`](https://taylor.wjakethompson.com/reference/taylor_album_songs.html).
So if you want only songs from Taylor's albums, you will get *Red (Taylor's Version)*, and *Fearless (Taylor's Version)*, by default, because we stan artists owning their art.

<img src="https://media.giphy.com/media/gromG2nn1K3Tg50ojX/giphy.gif" title="Taylor Swift happily dancing on the Tonight Show with Jimmy Fallon." alt="Taylor Swift happily dancing on the Tonight Show with Jimmy Fallon." width="80%" style="display: block; margin: auto;" />


```r
taylor_album_songs %>% 
  distinct(album_name)
#> # A tibble: 9 × 1
#>   album_name                 
#>   <chr>                      
#> 1 Taylor Swift               
#> 2 Fearless (Taylor's Version)
#> 3 Speak Now                  
#> 4 Red (Taylor's Version)     
#> 5 1989                       
#> 6 reputation                 
#> 7 Lover                      
#> 8 folklore                   
#> 9 evermore
```

*Red (Taylor's Version)* has also been added to [`taylor_albums`](https://taylor.wjakethompson.com/reference/taylor_albums.html), and has the highest Metacritic score of any of Taylor's albums.


```r
taylor_albums
#> # A tibble: 13 × 4
#>    album_name                          ep    album_release metacritic_score
#>    <chr>                               <lgl> <date>                   <int>
#>  1 Taylor Swift                        FALSE 2006-10-24                  NA
#>  2 The Taylor Swift Holiday Collection TRUE  2007-10-14                  NA
#>  3 Beautiful Eyes                      TRUE  2008-07-15                  NA
#>  4 Fearless                            FALSE 2008-11-11                  73
#>  5 Speak Now                           FALSE 2010-10-25                  77
#>  6 Red                                 FALSE 2012-10-22                  77
#>  7 1989                                FALSE 2014-10-27                  76
#>  8 reputation                          FALSE 2017-11-10                  71
#>  9 Lover                               FALSE 2019-08-23                  79
#> 10 folklore                            FALSE 2020-07-24                  88
#> 11 evermore                            FALSE 2020-12-11                  85
#> 12 Fearless (Taylor's Version)         FALSE 2021-04-09                  82
#> 13 Red (Taylor's Version)              FALSE 2021-11-12                  96
```

Finally, a new color palette inspired by the *Red (Taylor's Version)* album cover has been added to the [`album_palettes`](https://taylor.wjakethompson.com/reference/album_palettes.html), and the [package website](https://taylor.wjakethompson.com) has been updated with a new theme and logo, also inspired by the album cover.

<img src="index_files/figure-html/unnamed-chunk-7-1.png" width="80%" style="display: block; margin: auto;" />

## Breaking Changes

In addition to *Red (Taylor's Version)* replacing *Red* in [`taylor_album_songs`](https://taylor.wjakethompson.com/reference/taylor_album_songs.html), there is one other breaking change in this release.
The `type` argument of [`color_palette()`](https://taylor.wjakethompson.com/reference/color_palette.html) has been deprecated in favor of an automatic interpolation.

In previous version, if we wanted to interpolate additional colors from a smaller color palette, we needed to specify `type = "continuous"`.


```r
my_colors <- c(ku_blue = "#0051ba", "firebrick", "#ffc82d")
my_palette <- color_palette(my_colors)

# old
color_palette(my_palette, n = 10, type = "continuous")
color_palette(my_palette, n = 2, type = "discrete")
```

In the latest release, this happens automatically.
If you specify an `n` that is larger than the size of the palette (for example, `n = 10` when `my_palette` has only 3 colors), we now automatically interpolate additional colors.
Similarly, if you specify an `n` that is smaller than the number of colors in the palette, an evenly spaced sample will be taken.

## Minor Changes

There were also a number of minor improvements:

* "Wildest Dreams (Taylor's Version)" has been added as a non-ablum song. Presumably, this song will eventually move to *1989 (Taylor's Version)*.
* [`color_palette()`](https://taylor.wjakethompson.com/reference/color_palette.html) now preserves color names, either through values in [`colors()`](https://rdrr.io/r/grDevices/colors.html), or a named vector supplied to `pal`.

See the [changelog](https://taylor.wjakethompson.com/news/index.html) for a complete list of changes.
