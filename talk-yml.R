library(yaml)

filter_yaml <- function(x) {
  cur_talks <- read_yaml(x)
  future <- vapply(cur_talks,
                   \(t) as.Date(t$date) > Sys.Date(),
                   logical(1))
  
  cur_talks[!future]
}


talks <- c("talk/talks_old.yml",
           list.files("talk", pattern = "talks_[0-9]{4}\\.yml",
                      full.names = TRUE))
  
unlist(lapply(talks, filter_yaml), recursive = FALSE) |> 
  write_yaml("talk/about_talks.yml")
