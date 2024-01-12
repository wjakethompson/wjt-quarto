---
title: "taylor 0.2.0"
date: 2021-09-01
subtitle: ""
description: "Initial release of taylor for accessing data on Taylor Swift's discography"
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



I'm delighted to announce the release of [taylor](https://taylor.wjakethompson.com) 0.2.0.
taylor provides data on Taylor Swift's discography, including lyrics from [Genius](https://genius.com/artists/Taylor-swift) and song characteristics from [Spotify](https://open.spotify.com/artist/06HL4z0CvFAxyc27GXpf02).

You can install it from CRAN with:


```r
install.packages("taylor")
```

This blog post will highlight the main features of the package.


```r
library(taylor)
```


## Data sets

The main focus of taylor is to provide data for Taylor Swift's discography.
There most  data sets.
The first is [`taylor_all_songs`](https://taylor.wjakethompson.com/reference/taylor_all_songs.html).
This data set contains meta data about each song (e.g., album, track number, release date); audio characteristics from the Spotify API such as the key, danceability, and valence; and a list column, `lyrics`, that contains the lyrics for each song.
See [`?taylor_all_songs`](https://taylor.wjakethompson.com/reference/taylor_all_songs.html) for a complete description of all the variables that are included.


```r
taylor_all_songs
#> # A tibble: 213 × 29
#>    album_name  ep    album_release track_number track_name     artist  featuring
#>    <chr>       <lgl> <date>               <int> <chr>          <chr>   <chr>    
#>  1 Taylor Swi… FALSE 2006-10-24               1 Tim McGraw     Taylor… <NA>     
#>  2 Taylor Swi… FALSE 2006-10-24               2 Picture To Bu… Taylor… <NA>     
#>  3 Taylor Swi… FALSE 2006-10-24               3 Teardrops On … Taylor… <NA>     
#>  4 Taylor Swi… FALSE 2006-10-24               4 A Place In Th… Taylor… <NA>     
#>  5 Taylor Swi… FALSE 2006-10-24               5 Cold As You    Taylor… <NA>     
#>  6 Taylor Swi… FALSE 2006-10-24               6 The Outside    Taylor… <NA>     
#>  7 Taylor Swi… FALSE 2006-10-24               7 Tied Together… Taylor… <NA>     
#>  8 Taylor Swi… FALSE 2006-10-24               8 Stay Beautiful Taylor… <NA>     
#>  9 Taylor Swi… FALSE 2006-10-24               9 Should've Sai… Taylor… <NA>     
#> 10 Taylor Swi… FALSE 2006-10-24              10 Mary's Song (… Taylor… <NA>     
#> # … with 203 more rows, and 22 more variables: bonus_track <lgl>,
#> #   promotional_release <date>, single_release <date>, track_release <date>,
#> #   danceability <dbl>, energy <dbl>, key <int>, loudness <dbl>, mode <int>,
#> #   speechiness <dbl>, acousticness <dbl>, instrumentalness <dbl>,
#> #   liveness <dbl>, valence <dbl>, tempo <dbl>, time_signature <int>,
#> #   duration_ms <int>, explicit <lgl>, key_name <chr>, mode_name <chr>,
#> #   key_mode <chr>, lyrics <list>
```

We can see the lyrics using [`tidyr::unnest()`](https://tidyr.tidyverse.org/reference/nest.html).
For example, if we want all of the lyrics from *Lover*, we can see those with


```r
library(tidyverse)

taylor_all_songs %>%
  filter(album_name == "Lover") %>%
  select(album_name, track_name, lyrics) %>%
  unnest(lyrics)
#> # A tibble: 931 × 6
#>    album_name track_name        line lyric               element  element_artist
#>    <chr>      <chr>            <int> <chr>               <chr>    <chr>         
#>  1 Lover      I Forgot That Y…     1 How many days did … Verse 1  Taylor Swift  
#>  2 Lover      I Forgot That Y…     2 'Bout how you did … Verse 1  Taylor Swift  
#>  3 Lover      I Forgot That Y…     3 Lived in the shade… Verse 1  Taylor Swift  
#>  4 Lover      I Forgot That Y…     4 'Til all of my sun… Verse 1  Taylor Swift  
#>  5 Lover      I Forgot That Y…     5 And I couldn't get… Verse 1  Taylor Swift  
#>  6 Lover      I Forgot That Y…     6 In my feelings mor… Verse 1  Taylor Swift  
#>  7 Lover      I Forgot That Y…     7 Your name on my li… Verse 1  Taylor Swift  
#>  8 Lover      I Forgot That Y…     8 Free rent, living … Verse 1  Taylor Swift  
#>  9 Lover      I Forgot That Y…     9 But then something… Pre-Cho… Taylor Swift  
#> 10 Lover      I Forgot That Y…    10 I forgot that you … Chorus   Taylor Swift  
#> # … with 921 more rows
```

The lyrics is are in a nice tidy format with one row in the tibble per line in the song.
The goal is to make the lyrics as ready for text analysis as possible.
If you're into that sort of thing, I highly recommended checking out [Emil Hvitfeldt](https://twitter.com/Emil_Hvitfeldt) and [Julia Silge's](https://twitter.com/juliasilge) [*Supervised Machine Learning for Text Analysis in R*](https://smltar.com/).

In addition to `taylor_all_songs`, there are two additional data sets included.
The first is [`taylor_album_songs`](https://taylor.wjakethompson.com/reference/taylor_album_songs.html).
This is just a filtered version of `taylor_all_songs` that includes only songs from Taylor's studio albums.
This means that single-only releases (e.g. *Only the Young*, *Christmas Tree Farm*) are not included, nor are songs that Taylor is only featured on (e.g., *Renegade* by Big Red Machine, *Gasoline (Remix)* by HAIM).
Additionally, this data only includes versions of the songs Taylor owns where possible.
For example, *Fearless (Taylor's Version)* is included in `taylor_album_songs`, and the original *Fearless*.
Additionally, although *Red* is currently included, it will be removed in favor of *Red (Taylor's Version)* when that album is released in November.


```r
taylor_all_songs
#> # A tibble: 213 × 29
#>    album_name  ep    album_release track_number track_name     artist  featuring
#>    <chr>       <lgl> <date>               <int> <chr>          <chr>   <chr>    
#>  1 Taylor Swi… FALSE 2006-10-24               1 Tim McGraw     Taylor… <NA>     
#>  2 Taylor Swi… FALSE 2006-10-24               2 Picture To Bu… Taylor… <NA>     
#>  3 Taylor Swi… FALSE 2006-10-24               3 Teardrops On … Taylor… <NA>     
#>  4 Taylor Swi… FALSE 2006-10-24               4 A Place In Th… Taylor… <NA>     
#>  5 Taylor Swi… FALSE 2006-10-24               5 Cold As You    Taylor… <NA>     
#>  6 Taylor Swi… FALSE 2006-10-24               6 The Outside    Taylor… <NA>     
#>  7 Taylor Swi… FALSE 2006-10-24               7 Tied Together… Taylor… <NA>     
#>  8 Taylor Swi… FALSE 2006-10-24               8 Stay Beautiful Taylor… <NA>     
#>  9 Taylor Swi… FALSE 2006-10-24               9 Should've Sai… Taylor… <NA>     
#> 10 Taylor Swi… FALSE 2006-10-24              10 Mary's Song (… Taylor… <NA>     
#> # … with 203 more rows, and 22 more variables: bonus_track <lgl>,
#> #   promotional_release <date>, single_release <date>, track_release <date>,
#> #   danceability <dbl>, energy <dbl>, key <int>, loudness <dbl>, mode <int>,
#> #   speechiness <dbl>, acousticness <dbl>, instrumentalness <dbl>,
#> #   liveness <dbl>, valence <dbl>, tempo <dbl>, time_signature <int>,
#> #   duration_ms <int>, explicit <lgl>, key_name <chr>, mode_name <chr>,
#> #   key_mode <chr>, lyrics <list>
```

Finally, there is a small data, [`taylor_albums`](https://taylor.wjakethompson.com/reference/taylor_albums.html), that contains meta data for Taylor's albums, including the release date and the [Metacritic](https://www.metacritic.com/person/taylor-swift) score.
A full description of all the variables can be seen using [`?taylor_albums`](https://taylor.wjakethompson.com/reference/taylor_albums.html).


```r
taylor_albums
#> # A tibble: 12 × 4
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
```

## Other Features

Although the main focus of taylor is to provide access to audio characteristics and lyrics, I also built in a few additional features, mostly as an opportunity to learn some new tools!
Each of these features will get detail in future posts, but I'll provide a high level overview here.

### Color Palettes

First, inspired by [Josiah Parry's](https://twitter.com/JosiahParry) work on the [cpcinema](https://github.com/JosiahParry/cpcinema) package, taylor includes a special vector class that allow users to build and visualize their own color palettes.
The color palettes are built using the [vctrs](https://vctrs.r-lib.org) package.
In a future post, I'll describe how the `color_palette` class works internally.
Several palettes are built into taylor based on Taylor's album covers.
For example, here a palette based on Taylor's debut album, *Taylor Swift*:


```r
album_palettes$taylor_swift
#> <color_palette[5]>
#>     #1D4737 
#>     #1BAEC6 
#>     #523d28 
#>     #AD8562 
#>     #E7DBCC
```

The full printing is not rendered here, but in your console, you will see a color swatch next to each hex code showing the color.
All of the album-based palettes can be see, with full rendering, can be seen on the [taylor website](https://taylor.wjakethompson.com/reference/album_palettes.html).
In addition, there is an [`album_compare`](https://taylor.wjakethompson.com/reference/album_palettes.html) palette which includes one color from each individual album palette.

### ggplot2 Scales

The other feature is a set of ggplot2 color scales that can be used to easily apply the color palettes to plots.
For an example, let's look at the [palmerpenguins](https://allisonhorst.github.io/palmerpenguins/) data.
We can use [`scale_color_taylor_d()`](https://taylor.wjakethompson.com/reference/scale_taylor.html) to apply an album color palette to a discrete variable.
As might be expected there are also [`scale_color_taylor_c()`](https://taylor.wjakethompson.com/reference/scale_taylor.html) and [`scale_color_taylor_b()`](https://taylor.wjakethompson.com/reference/scale_taylor.html) variants for continuous and binned scales as well.


```r
library(palmerpenguins)

ggplot(penguins, aes(x = bill_length_mm, y = bill_depth_mm)) +
  geom_point(aes(color = species, shape = species)) +
  # scale_color_manual(values = album_palettes$evermore[1:3])
  scale_color_taylor_d(album = "Lover")
```

<img src="index_files/figure-html/unnamed-chunk-8-1.png" width="80%" style="display: block; margin: auto;" />

There is also the [`scale_fill_albums()`](https://taylor.wjakethompson.com/reference/scale_albums.html) function, which will automatically map colors from each album palette to the appropriate album name.


```r
taylor_albums %>%
  filter(!ep) %>%
  mutate(album_name = factor(album_name, levels = album_levels)) %>%
  ggplot(aes(x = metacritic_score, y = album_name)) +
  geom_col(aes(fill = album_name), show.legend = FALSE) +
  scale_fill_albums()
```

<img src="index_files/figure-html/unnamed-chunk-9-1.png" width="80%" style="display: block; margin: auto;" />

For more examples, check out the [plotting article](https://taylor.wjakethompson.com/articles/plotting.html) on the taylor website.
In a future post I'll describe how I built ggplot2 scales on top of the color palettes.

## Conclusion

This is the initial release of taylor, so I expect that you will find bugs, or maybe even a song or two that I missed.
If you do, please file an issue on the [GitHub repository](https://github.com/wjakethompson/taylor).
I'm planning another release of taylor in November after *Red (Taylor's Version)* drops, so I will aim to have any fixed in place by then.
In the mean time, stay tuned for my upcoming posts on using vctrs classes and creating ggplot2 scales within taylor!

<img src="https://media.giphy.com/media/geuXiMq0MNqfAyxS7b/giphy.gif" width="80%" style="display: block; margin: auto;" />


## Acknowledgments {.appendix}

Featured photo by <a href="https://unsplash.com/@getuliodt?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Getúlio Moraes</a> on <a href="https://unsplash.com/photos/brown-acoustic-guitar-lhM8m_il8BQ?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Unsplash</a>.
  
