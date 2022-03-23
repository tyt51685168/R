library(tidyr)
library(dplyr)
library(readr)

head(relig_income)

# A tibble: 6 x 11
  religion           `<$10k` `$10-20k` `$20-30k` `$30-40k` `$40-50k` `$50-75k` `$75-100k` `$100-150k` `>150k` `Don't know/refused`
  <chr>                <dbl>     <dbl>     <dbl>     <dbl>     <dbl>     <dbl>      <dbl>       <dbl>   <dbl>                <dbl>
1 Agnostic                27        34        60        81        76       137        122         109      84                   96
2 Atheist                 12        27        37        52        35        70         73          59      74                   76
3 Buddhist                27        21        30        34        33        58         62          39      53                   54

# 以下是最一般寬表格變長表格的做法
# cols 指定所有要變成 variable name 的欄位
# names_to 決定 variable name 的欄位名稱，cols 所指定的欄位其欄位名稱會變成此欄的內容(值)
# values_to 決定 value 的欄位名稱，cols 所指定的欄位值會變成此欄的內容(值)

relig_income %>%
  pivot_longer(cols = !religion, names_to = "income", values_to = "count")

# A tibble: 180 x 3
   religion income             count
   <chr>    <chr>              <dbl>
 1 Agnostic <$10k                 27
 2 Agnostic $10-20k               34
 3 Agnostic $20-30k               60



billboard 

billboard %>% 
  pivot_longer(
    cols = starts_with("wk"), 
    names_to = "week", 
    values_to = "rank",
    values_drop_na = TRUE
  )

billboard %>% 
  pivot_longer(
    cols = starts_with("wk"), 
    names_to = "week", 
    names_prefix = "wk",
    names_transform = list(week = as.integer),
    values_to = "rank",
    values_drop_na = TRUE,
  )

billboard %>% 
  pivot_longer(
    cols = starts_with("wk"), 
    names_to = "week", 
    names_transform = list(week = readr::parse_number),
    values_to = "rank",
    values_drop_na = TRUE,
  )

who

who %>% pivot_longer(
  cols = new_sp_m014:newrel_f65,
  names_to = c("diagnosis", "gender", "age"), 
  names_pattern = "new_?(.*)_(.)(.*)",
  values_to = "count"
)



family <- tribble(
  ~family,  ~dob_child1,  ~dob_child2, ~gender_child1, ~gender_child2,
  1L, "1998-11-26", "2000-01-29",             1L,             2L,
  2L, "1996-06-22",           NA,             2L,             NA,
  3L, "2002-07-11", "2004-04-05",             2L,             2L,
  4L, "2004-10-10", "2009-08-27",             1L,             1L,
  5L, "2000-12-05", "2005-02-28",             2L,             1L,
)
family <- family %>% mutate_at(vars(starts_with("dob")), parse_date)
family

family %>% 
  pivot_longer(
    !family, 
    names_to = c(".value", "child"), 
    names_sep = "_", 
    values_drop_na = TRUE
  )
