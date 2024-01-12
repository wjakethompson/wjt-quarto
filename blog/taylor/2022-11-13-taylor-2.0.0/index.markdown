---
title: "taylor 2.0.0"
date: 2022-11-13
subtitle: ""
description: "taylor 2.0.0 is a major release to include data from <em>Midnights</em>."
image: "featured.jpg"
twitter-card:
  image: "featured.jpg"
open-graph:
  image: "featured.jpg"
categories:
  - R
  - package
  - taylor
  - Taylor Swift
---





I'm remarkably excited to announce the release of [taylor](https://taylor.wjakethompson.com) 2.0.0.
taylor provides data on Taylor Swift's discography, including lyrics from [Genius](https://genius.com/artists/Taylor-swift) and song characteristics from [Spotify](https://open.spotify.com/artist/06HL4z0CvFAxyc27GXpf02).

You can install it from CRAN with:


```r
install.packages("taylor")
```

This blog post will highlight the major changes in this release, including the addition of data from *Midnights*.


```r
library(taylor)
```


## Midnights

The most important update is the addition of data from *Midnights*.
You can now find Spotify data and lyrics for all 23 songs in [`taylor_all_songs`](https://taylor.wjakethompson.com/reference/taylor_all_songs.html).
The Target-exclusive tracks ("Hits Different," "You're On Your Own, Kid (Strings Remix)," and "Sweet Nothing (Piano Remix)") are not yet on Spotify.
For now, only lyrics are available for these tracks.
Spotify audio data will be added if and when these tracks get added to Spotify.


```r
library(tidyverse)

taylor_all_songs %>% 
  filter(album_name == "Midnights")
#> # A tibble: 23 × 29
#>    album_name ep    album_re…¹ track…² track…³ artist featu…⁴ bonus…⁵ promotio…⁶
#>    <chr>      <lgl> <date>       <int> <chr>   <chr>  <chr>   <lgl>   <date>    
#>  1 Midnights  FALSE 2022-10-21       1 Lavend… Taylo… <NA>    FALSE   NA        
#>  2 Midnights  FALSE 2022-10-21       2 Maroon  Taylo… <NA>    FALSE   NA        
#>  3 Midnights  FALSE 2022-10-21       3 Anti-H… Taylo… <NA>    FALSE   NA        
#>  4 Midnights  FALSE 2022-10-21       4 Snow O… Taylo… Lana D… FALSE   NA        
#>  5 Midnights  FALSE 2022-10-21       5 You're… Taylo… <NA>    FALSE   NA        
#>  6 Midnights  FALSE 2022-10-21       6 Midnig… Taylo… <NA>    FALSE   NA        
#>  7 Midnights  FALSE 2022-10-21       7 Questi… Taylo… <NA>    FALSE   NA        
#>  8 Midnights  FALSE 2022-10-21       8 Vigila… Taylo… <NA>    FALSE   NA        
#>  9 Midnights  FALSE 2022-10-21       9 Bejewe… Taylo… <NA>    FALSE   NA        
#> 10 Midnights  FALSE 2022-10-21      10 Labyri… Taylo… <NA>    FALSE   NA        
#> # … with 13 more rows, 20 more variables: single_release <date>,
#> #   track_release <date>, danceability <dbl>, energy <dbl>, key <int>,
#> #   loudness <dbl>, mode <int>, speechiness <dbl>, acousticness <dbl>,
#> #   instrumentalness <dbl>, liveness <dbl>, valence <dbl>, tempo <dbl>,
#> #   time_signature <int>, duration_ms <int>, explicit <lgl>, key_name <chr>,
#> #   mode_name <chr>, key_mode <chr>, lyrics <list>, and abbreviated variable
#> #   names ¹​album_release, ²​track_number, ³​track_name, ⁴​featuring, …
```

*Midnights* has also been added to [`taylor_albums`](https://taylor.wjakethompson.com/reference/taylor_albums.html).
A user score provided by Metacritic has also been added to this data.


```r
taylor_albums
#> # A tibble: 14 × 5
#>    album_name                          ep    album_release metacritic_…¹ user_…²
#>    <chr>                               <lgl> <date>                <int>   <dbl>
#>  1 Taylor Swift                        FALSE 2006-10-24               67     9.2
#>  2 The Taylor Swift Holiday Collection TRUE  2007-10-14               NA    NA  
#>  3 Beautiful Eyes                      TRUE  2008-07-15               NA    NA  
#>  4 Fearless                            FALSE 2008-11-11               73     8.4
#>  5 Speak Now                           FALSE 2010-10-25               77     8.7
#>  6 Red                                 FALSE 2012-10-22               77     8.5
#>  7 1989                                FALSE 2014-10-27               76     8.2
#>  8 reputation                          FALSE 2017-11-10               71     8.3
#>  9 Lover                               FALSE 2019-08-23               79     8.4
#> 10 folklore                            FALSE 2020-07-24               88     9  
#> 11 evermore                            FALSE 2020-12-11               85     8.9
#> 12 Fearless (Taylor's Version)         FALSE 2021-04-09               82     8.9
#> 13 Red (Taylor's Version)              FALSE 2021-11-12               91     9  
#> 14 Midnights                           FALSE 2022-10-21               94     9  
#> # … with abbreviated variable names ¹​metacritic_score, ²​user_score
```

Finally, a new color palette inspired by the *Midnights* album cover has been added to the [`album_palettes`](https://taylor.wjakethompson.com/reference/album_palettes.html), and the [package website](https://taylor.wjakethompson.com) has been updated with a new theme and logo, also inspired by the album cover.

<img src="index_files/figure-html/unnamed-chunk-5-1.png" alt="The five colors of the Midnights color palette. The hexadecimal codes are #121D27, #5A658B, #6F86A2, #85A7BA, and #AA9EB6" width="80%" style="display: block; margin: auto;" />

This palette can be used inside any of the [`scale_*_taylor()`](https://taylor.wjakethompson.com/reference/scale_taylor.html) functions.


```r
taylor_album_songs %>% 
  filter(album_name == "Midnights", !is.na(energy)) %>% 
  mutate(track_name = fct_inorder(track_name)) %>% 
  ggplot(aes(x = energy, y = fct_rev(track_name))) +
  geom_col(aes(fill = track_name), show.legend = FALSE) +
  scale_fill_taylor_d(album = "Midnights") +
  labs(x = "Song Energy (From Spotify)", y = NULL)
```

<img src="index_files/figure-html/unnamed-chunk-6-1.png" alt="A horizontal bar graph showing track names on the y-axis and song energey on the x-axis. Bars a filled with colors derived from the Midnights color palette, ranging from navy to light blue and lavender." width="80%" style="display: block; margin: auto;" />


## Breaking Changes

In addition to adding *Midnights* to [`taylor_all_songs`](https://taylor.wjakethompson.com/reference/taylor_all_songs.html) and [`taylor_album_songs`](https://taylor.wjakethompson.com/reference/taylor_album_songs.html), other audio data has also been updated.
Spotify has updated the audio data for [*Red (Taylor's Version)*](https://github.com/wjakethompson/taylor/commit/4395cc107ce13afdc5ff535bd6c3d67ac8ed2567) and ["Renegade"](https://github.com/wjakethompson/taylor/commit/be95df878bb85ab5ee884ecf9d7e91ba99849e33#diff-16e84b1ed731fef624b1ef567ca9c073ddab95fc49cca127999c606c3d939918) (Taylor's feature with Big Red Machine) since the last release.
These data sets have been updated to reflect these changes accordingly.

## Minor Changes

There were also a number of minor improvements:

* Additional singles and remixes have been added to `taylor_all_songs`: "Lover (Remix)" with Shawn Mendes; "Carolina" from the *Where the Crawdads Sings* soundtrack; Ed Sheeran's "The Joker and the Queen;" Taylor's cover of Earth, Wind, and Fire's *September*; and "Three Sad Virgins" from Saturday Night Live.
* "This Love (Taylor's Version)" has been added as a non-ablum song. Presumably, this song will eventually move to *1989 (Taylor's Version)*.
* The album color palettes have been slightly tweaked to better capture the vibe of each album, rather than just pulling colors from the cover.

See the [changelog](https://taylor.wjakethompson.com/news/index.html) for a complete list of changes.


## Acknowledgments {.appendix}

Featured photo by <a href="https://unsplash.com/@maciaphoto?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Morgan Macia</a> on <a href="https://unsplash.com/photos/golden-bridge-during-night-4Le88a3LQLA?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Unsplash</a>.
  
