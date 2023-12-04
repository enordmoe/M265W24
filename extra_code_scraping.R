---
  
  class: inverse, center, middle

# Functions to the Rescue

---
  
  ## Start at the Beginning
  
  Read and save data for the top 3 TV shows:
  
  ```{r message=FALSE}
library(tidyverse)
library(rvest)

wanda <- read_html("http://www.imdb.com/title/tt9140560/")
sinner <- read_html("http://www.imdb.com/title/tt6048596/")
behind <- read_html("http://www.imdb.com/title/tt9698442/")
```

---
  ## Why functions?
  
  Automate common tasks in a power powerful and general way than copy-and-pasting:  
  
  * Use names that indicate what the purpose of the function
+ Avoid reserved R names: like `c`, `sum`  

* Make updating code easier allowing you to update in just one place instead of many  

* Eliminate mistakes with copying and pasting  
+ Forgetting to make corresponding changes in all places  

* Learn to write and share your own functions!  
  ---
  
  
  ## When to consider writing a function? 
  
  "...whenever you’ve copied and pasted a block of code more than twice" [R4DS]

---
  ### When to consider writing a function? 
  
  *  Do you see any problems in the code below?  
  
  ```{r, eval=FALSE}
wanda_episode <- wanda %>%
  html_nodes(".np_right_arrow .bp_sub_heading") %>%
  html_text() %>%
  str_replace(" episodes", "") %>%
  parse_number()

sinner_episode <- sinner %>%
  html_nodes(".np_right_arrow .bp_sub_heading") %>%
  html_text() %>%
  str_replace(" episodes", "") %>%
  parse_number()

behind_episode <- behind %>%
  html_nodes(".np_right_arrow .bp_sub_heading") %>%
  html_text() %>%
  str_replace(" episodes", "") %>%
  parse_number()
```


---
  
  ## Inputs
  How many inputs does the following code have?
  
  ```{r eval=FALSE}
wanda_episode <- wanda %>%
  html_nodes(".np_right_arrow .bp_sub_heading") %>%
  html_text() %>%
  str_replace(" episodes", "") %>%
  parse_number()
```
---
  ## Turn your code into a function
  
  *  Pick a short but informative **name**, preferably a verb.  

*  List inputs, or **arguments**, to the function inside `function()`.  
+ With more than one input, we would have  `function(x, y, z)`.



```{r eval=FALSE}
scrape_episode <- function(x){  #<<
  
  
  
  
  
}  
```

---
  
  ## Turn your code into a function
  
  *  Pick a short but informative **name**, preferably a verb.  

*  List inputs, or **arguments**, to the function inside `function()`.  
+ With more than one input, we would have  `function(x, y, z)`.

* Place the **code** you have developed in body of the function, a `{` block that immediately follows `function(...)`.  

```{r}
scrape_episode <- function(x){
  x %>%                                                    #<<
    html_nodes(".np_right_arrow .bp_sub_heading") %>%      #<<
    html_text() %>%     #<<
    str_replace(" episodes", "") %>%    #<<
    parse_number()   #<<
}
```
---
  ## What do we get when we run it?  
  
  ```{r}
scrape_episode(wanda)
```

---
  ## Check your function
  
  ```{r, out.height = '10%', fig.align='center', fig.cap='',echo=FALSE}
knitr::include_graphics('figures/episode_wanda.png')
```

```{r}
scrape_episode(wanda)
```

```{r, out.height = '10%', fig.align='center', fig.cap='',echo=FALSE}
knitr::include_graphics('figures/episode_sinner.png')
```

```{r}
scrape_episode(sinner)
```

---
  ## Check your function
  
  ```{r, out.height = '10%', fig.align='center', fig.cap='',echo=FALSE}
knitr::include_graphics('figures/episode_behind.png')
```

```{r}
scrape_episode(behind)
```

---
  ## Naming functions
  
  * Names should be short but clearly evoke what the function does

* Names should be verbs, not nouns

* Multi-word names should be separated by underscores  
+ `snake_case` as opposed to `camelCase`

*  A family of functions should be named similarly 
+ `scrape_title`, `scrape_episode`, `scrape_genre`, etc.
---
  ## Scraping show info
  
  ```{r}
scrape_show_info <- function(x){
  
  title <- x %>% #<<
    html_node("#title-overview-widget h1") %>%
    html_text() %>%
    str_trim()
  
  runtime <- x %>% #<<
    html_node("#titleDetails time") %>%
    html_text() %>%
    str_replace("\\n", "") %>%
    str_replace("min", "") %>%
    str_trim()
  
  genres <- x %>% #<<
    html_nodes(".see-more.canwrap~ .canwrap a") %>%
    html_text() %>%
    str_trim() %>%
    paste(collapse = ", ")
  
  tibble(title = title, runtime = runtime, genres = genres) #<<
}
```
---
  ## Using our function
  
  ```{r}
scrape_show_info(wanda)
scrape_show_info(sinner)
scrape_show_info(behind)
```

---
  
  ## Toward a still more powerful function
  
  How would you update the following function to use the URL of the page as an argument?
  
  .scroll-box-20[
    ```{r eval=FALSE}
    scrape_show_info <- function(x){
      
      title <- x %>%
        html_node("#title-overview-widget h1") %>%
        html_text() %>%
        str_trim()
      
      runtime <- x %>%
        html_node("#titleDetails time") %>%
        html_text() %>%
        str_replace("\\n", "") %>%
        str_replace("min", "") %>%
        str_trim()
      
      genres <- x %>%
        html_nodes(".see-more.canwrap~ .canwrap a") %>%
        html_text() %>%
        str_trim() %>%
        paste(collapse = ", ")
      
      tibble(title = title, runtime = runtime, genres = genres)
    }
    ```
  ]

---
  
  
  .scroll-output[
    ```{r}
    
    scrape_show_info <- function(x){
      
      y <- read_html(x) #<<
      
      
      title <- y %>%
        html_node("#title-overview-widget h1") %>%
        html_text() %>%
        str_trim()
      
      runtime <- y %>%
        html_node("#titleDetails time") %>%
        html_text() %>%
        str_replace("\\n", "") %>%
        str_replace("min", "") %>%
        str_trim()
      
      genres <- y %>%
        html_nodes(".see-more.canwrap~ .canwrap a") %>%
        html_text() %>%
        str_trim() %>%
        paste(collapse = ", ")
      
      tibble(title = title, runtime = runtime, genres = genres)
    }
    ```
  ]

---
  
  ## Let's check
  
  ```{r}
wanda_url <- "https://www.imdb.com/title/tt9140560/"
sinner_url <- "http://www.imdb.com/title/tt6048596/"
behind_url <- "http://www.imdb.com/title/tt9698442/"

```

---
  
  ## Let's check
  
  ```{r}
scrape_show_info(wanda_url)
scrape_show_info(sinner_url)
scrape_show_info(behind_url)
```

---
  
  ## Automation?  
  
  * We now have a function for scraping TV show info given URL  

* Where can we get a list of URLS ot top 100 TV shows on IMDB?  
  
  * Your turn: Write the code that will do this!  
  + Hint: You'll need the `paste()` function to construct the URL

---

.scroll-output[
```{r}
urls <- read_html("http://www.imdb.com/chart/tvmeter") %>%
  html_nodes(".titleColumn a") %>%
  html_attr("href") %>%
  paste("http://www.imdb.com", ., sep = "") %>%
  str_extract(".*tt[0-9]{7,8}")  
head(urls)
```
]


---
### Go to each page, scrape show info 

* Now we need a way to tell R to go to each page on the `urls` list and run the `scrape_show_info()` function on that page.

.scroll-box-20[
```{r}
# This could get a bit much!
scrape_show_info(urls[1])
scrape_show_info(urls[2])
scrape_show_info(urls[3])
```
]

---
class: inverse, center, top

background-image: url(figures/purrr.png)
background-position: 50% 75%
background-size: 50% 50%

## We have the `purrr`fect solution!  


---

## Go to each page, scrape show info 

In other words, we want to **map** the `scrape_show_info` function to each element of `show_urls`:

```{r eval=FALSE}
top_100_shows <- map_df(urls, scrape_show_info)
top_100_shows
```

* Visits `urls` one after another and scrapes the info.  

* `map_df` outputs a data frame (tibble) by binding rows together

---

## Caution  

* If you get `HTTP Error 429 (Too many requests)` you might want to slow down your hits.

* You can add a `Sys.sleep()` call to slow down your function:

```{r eval=FALSE}
scrape_show_info <- function(x){
  Sys.sleep(runif(1))  #<<
  ...

}
```
