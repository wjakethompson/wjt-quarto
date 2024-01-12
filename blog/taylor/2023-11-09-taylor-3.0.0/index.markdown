---
title: "taylor 3.0.0"
date: 2023-11-09
subtitle: ""
description: "taylor 3.0.0 is a major release to include data from <em>1989 (Taylor's Version)</em> and <em>Speak Now (Taylor's Version)</em>."
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





I'm overjoyed to announce the release of [taylor](https://taylor.wjakethompson.com) 3.0.0.
taylor provides data on Taylor Swift's discography, including lyrics from [Genius](https://genius.com/artists/Taylor-swift) and song characteristics from [Spotify](https://open.spotify.com/artist/06HL4z0CvFAxyc27GXpf02).

You can install it from CRAN with:


```r
install.packages("taylor")
```

This blog post will highlight the major changes in this release, including the addition of data from *Speak Now (Taylor's Version)* and *1989 (Taylor's Version)*.


```r
library(taylor)
```


## Entering Our *Taylor's Version* Era

Over the past few months Taylor has released two new rerecords: *Speak Now (Taylor's Version)* and *1989 (Taylor's Version)*.
You can now find Spotify data and lyrics for both albums in [`taylor_all_songs`](https://taylor.wjakethompson.com/reference/taylor_songs.html).
There is one Target-exclusive from from *1989 (Taylor's Version)*, "Sweeter Than Fiction (Taylor's Version)," which is not yet on Spotify and therefore doesn't have audio data.
For now, only lyrics are available for this track.
Spotify audio data will be added in the future if and when it gets added to Spotify.


```r
library(tidyverse)

taylor_all_songs %>% 
  filter(album_name == "Speak Now (Taylor's Version)")
#> # A tibble: 22 × 29
#>    album_name       ep    album_release track_number track_name artist featuring
#>    <chr>            <lgl> <date>               <int> <chr>      <chr>  <chr>    
#>  1 Speak Now (Tayl… FALSE 2023-07-07               1 Mine (Tay… Taylo… <NA>     
#>  2 Speak Now (Tayl… FALSE 2023-07-07               2 Sparks Fl… Taylo… <NA>     
#>  3 Speak Now (Tayl… FALSE 2023-07-07               3 Back To D… Taylo… <NA>     
#>  4 Speak Now (Tayl… FALSE 2023-07-07               4 Speak Now… Taylo… <NA>     
#>  5 Speak Now (Tayl… FALSE 2023-07-07               5 Dear John… Taylo… <NA>     
#>  6 Speak Now (Tayl… FALSE 2023-07-07               6 Mean (Tay… Taylo… <NA>     
#>  7 Speak Now (Tayl… FALSE 2023-07-07               7 The Story… Taylo… <NA>     
#>  8 Speak Now (Tayl… FALSE 2023-07-07               8 Never Gro… Taylo… <NA>     
#>  9 Speak Now (Tayl… FALSE 2023-07-07               9 Enchanted… Taylo… <NA>     
#> 10 Speak Now (Tayl… FALSE 2023-07-07              10 Better Th… Taylo… <NA>     
#> # ℹ 12 more rows
#> # ℹ 22 more variables: bonus_track <lgl>, promotional_release <date>,
#> #   single_release <date>, track_release <date>, danceability <dbl>,
#> #   energy <dbl>, key <int>, loudness <dbl>, mode <int>, speechiness <dbl>,
#> #   acousticness <dbl>, instrumentalness <dbl>, liveness <dbl>, valence <dbl>,
#> #   tempo <dbl>, time_signature <int>, duration_ms <int>, explicit <lgl>,
#> #   key_name <chr>, mode_name <chr>, key_mode <chr>, lyrics <list>

taylor_all_songs %>% 
  filter(album_name == "1989 (Taylor's Version)")
#> # A tibble: 23 × 29
#>    album_name       ep    album_release track_number track_name artist featuring
#>    <chr>            <lgl> <date>               <int> <chr>      <chr>  <chr>    
#>  1 1989 (Taylor's … FALSE 2023-10-27               1 Welcome T… Taylo… <NA>     
#>  2 1989 (Taylor's … FALSE 2023-10-27               2 Blank Spa… Taylo… <NA>     
#>  3 1989 (Taylor's … FALSE 2023-10-27               3 Style (Ta… Taylo… <NA>     
#>  4 1989 (Taylor's … FALSE 2023-10-27               4 Out Of Th… Taylo… <NA>     
#>  5 1989 (Taylor's … FALSE 2023-10-27               5 All You H… Taylo… <NA>     
#>  6 1989 (Taylor's … FALSE 2023-10-27               6 Shake It … Taylo… <NA>     
#>  7 1989 (Taylor's … FALSE 2023-10-27               7 I Wish Yo… Taylo… <NA>     
#>  8 1989 (Taylor's … FALSE 2023-10-27               8 Bad Blood… Taylo… <NA>     
#>  9 1989 (Taylor's … FALSE 2023-10-27               9 Wildest D… Taylo… <NA>     
#> 10 1989 (Taylor's … FALSE 2023-10-27              10 How You G… Taylo… <NA>     
#> # ℹ 13 more rows
#> # ℹ 22 more variables: bonus_track <lgl>, promotional_release <date>,
#> #   single_release <date>, track_release <date>, danceability <dbl>,
#> #   energy <dbl>, key <int>, loudness <dbl>, mode <int>, speechiness <dbl>,
#> #   acousticness <dbl>, instrumentalness <dbl>, liveness <dbl>, valence <dbl>,
#> #   tempo <dbl>, time_signature <int>, duration_ms <int>, explicit <lgl>,
#> #   key_name <chr>, mode_name <chr>, key_mode <chr>, lyrics <list>
```

Both rerecords have also been added to [`taylor_albums`](https://taylor.wjakethompson.com/reference/taylor_albums.html).


```r
taylor_albums
#> # A tibble: 16 × 5
#>    album_name                    ep    album_release metacritic_score user_score
#>    <chr>                         <lgl> <date>                   <int>      <dbl>
#>  1 Taylor Swift                  FALSE 2006-10-24                  67        8.4
#>  2 The Taylor Swift Holiday Col… TRUE  2007-10-14                  NA       NA  
#>  3 Beautiful Eyes                TRUE  2008-07-15                  NA       NA  
#>  4 Fearless                      FALSE 2008-11-11                  73        8.4
#>  5 Speak Now                     FALSE 2010-10-25                  77        8.6
#>  6 Red                           FALSE 2012-10-22                  77        8.6
#>  7 1989                          FALSE 2014-10-27                  76        8.3
#>  8 reputation                    FALSE 2017-11-10                  71        8.3
#>  9 Lover                         FALSE 2019-08-23                  79        8.4
#> 10 folklore                      FALSE 2020-07-24                  88        9  
#> 11 evermore                      FALSE 2020-12-11                  85        8.9
#> 12 Fearless (Taylor's Version)   FALSE 2021-04-09                  82        8.9
#> 13 Red (Taylor's Version)        FALSE 2021-11-12                  91        8.9
#> 14 Midnights                     FALSE 2022-10-21                  85        8.3
#> 15 Speak Now (Taylor's Version)  FALSE 2023-07-07                  81        9.2
#> 16 1989 (Taylor's Version)       FALSE 2023-10-27                  95       NA
```

The color palettes have also been updated to include palette inspired by the each album cover and can be accessed in the [`album_palettes`](https://taylor.wjakethompson.com/reference/album_palettes.html) list.

<img src="index_files/figure-html/unnamed-chunk-5-1.png" alt="The five colors of the Speak Now (Taylor's Version) color palette." width="80%" style="display: block; margin: auto;" />

<img src="index_files/figure-html/unnamed-chunk-6-1.png" alt="The five colors of the 1989 (Taylor's Version) color palette." width="80%" style="display: block; margin: auto;" />

These palettes can be used inside any of the [`scale_*_taylor()`](https://taylor.wjakethompson.com/reference/scale_taylor.html) functions.


```r
taylor_album_songs %>% 
  filter(album_name == "1989 (Taylor's Version)", !is.na(energy)) %>% 
  mutate(track_name = fct_inorder(track_name)) %>% 
  ggplot(aes(x = energy, y = fct_rev(track_name))) +
  geom_col(aes(fill = track_name), show.legend = FALSE) +
  scale_fill_taylor_d(album = "1989 (Taylor's Version)") +
  labs(x = "Song Energy (From Spotify)", y = NULL)
```

<img src="index_files/figure-html/unnamed-chunk-7-1.png" alt="A horizontal bar graph showing track names on the y-axis and song energey on the x-axis. Bars a filled with colors derived from the 1989 (Taylor's Version) color palette, ranging from blue to tan." width="100%" style="display: block; margin: auto;" />

Finally, the [package website](https://taylor.wjakethompson.com) has been updated with a new theme and logo, inspired by the *1989 (Taylor's Version)* album cover.

## The Eras Tour Data

This release also comes with a new data set, [`eras_tour_surprise`](https://taylor.wjakethompson.com/reference/eras_tour_surprise.html).
This data set includes all of the surprise that Taylor has played, including the location, the night, and the instrument that was used.


```r
eras_tour_surprise
#> # A tibble: 114 × 8
#>    leg           date       city          night dress instrument song      guest
#>    <chr>         <date>     <chr>         <int> <chr> <chr>      <chr>     <chr>
#>  1 North America 2023-03-17 Glendale, AZ      1 red   guitar     mirrorba… <NA> 
#>  2 North America 2023-03-17 Glendale, AZ      1 red   piano      Tim McGr… <NA> 
#>  3 North America 2023-03-18 Glendale, AZ      2 green guitar     this is … <NA> 
#>  4 North America 2023-03-18 Glendale, AZ      2 green piano      State Of… <NA> 
#>  5 North America 2023-03-24 Las Vegas, NV     1 red   guitar     Our Song  <NA> 
#>  6 North America 2023-03-24 Las Vegas, NV     1 red   piano      Snow On … <NA> 
#>  7 North America 2023-03-25 Las Vegas, NV     2 green guitar     cowboy l… Marc…
#>  8 North America 2023-03-25 Las Vegas, NV     2 green piano      White Ho… <NA> 
#>  9 North America 2023-03-31 Arlington, TX     1 green guitar     Sad Beau… <NA> 
#> 10 North America 2023-03-31 Arlington, TX     1 green piano      Ours (Ta… <NA> 
#> # ℹ 104 more rows
```

We can use this data to, for example, look at how many and when songs have been played from each album.

<details><summary>Plot code</summary>


```r
eras_tour_surprise |> 
  left_join(taylor_all_songs %>%
               filter(is.na(ep) | !ep) %>%
               distinct(track_name, album_name),
             join_by(song == track_name),
             relationship = "many-to-one") |> 
  select(date, city, night, album_name, song) |> 
  mutate(total = 1:n(),
         .by = album_name) |> 
  complete(nesting(date, city, night), album_name) |> 
  select(-song) |>
  slice_max(total, by = c(date, city, night, album_name)) |>
  arrange(album_name, date) |> 
  group_by(album_name) |> 
  fill(total, .direction = "down") |> 
  ungroup() |> 
  mutate(total = replace_na(total, 0L),
         show = 1:n(),
         .by = album_name) |> 
  filter(!is.na(album_name)) |> 
  mutate(album_name = factor(album_name, album_levels)) |> 
  ggplot() +
  facet_wrap(~album_name, ncol = 3) +
  geom_line(data = ~rename(.x, album = album_name),
            aes(x = show, y = total, group = album),
            color = "grey80") +
  geom_line(aes(x = show, y = total, color = album_name),
            linewidth = 2, show.legend = FALSE) +
  scale_color_albums() +
  labs(x = "Shows", y = "Surprise Songs")
```

</details>

<img src="index_files/figure-html/eras-plot-1.png" alt="Line plot showing the cumulative number of songs played as surprise songs from each album over the course of The Eras Tour." width="100%" style="display: block; margin: auto;" />

## Minor Changes

There were also a number of minor improvements:

* Spotify data was added for "Hits Different," "Snow on the Beach (More Lana Del Rey)," and "Karma (Remix)" after they were released to streaming as part of *Midnights (The Til Dawn Edition)*.
* Additional non-album songs have been added to `taylor_all_songs`: "All of the Girls You Loved Before" from *The More Lover Chapter*, "Eyes Open (Taylor's Version)" and "Safe & Sound (Taylor's Version)" from *The More Red (Taylor's Version) Chapter*, and "If This Was a Movie (Taylor's Version)" from *The More Fearless (Taylor's Version) Chapter*.
* "This Love (Taylor's Version)" and "Wildest Dreams (Taylor's Version)" have been removed from the non-album singles now that *1989 (Taylor's Version)* has been released.

See the [changelog](https://taylor.wjakethompson.com/news/index.html) for a complete list of changes.


## Acknowledgments {.appendix}

Featured photo by <a href="https://unsplash.com/@allvar?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Carl Tronders</a> on <a href="https://unsplash.com/photos/a-white-bird-flying-through-a-blue-sky-_KdMdj8cD2s?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Unsplash</a>.
  
