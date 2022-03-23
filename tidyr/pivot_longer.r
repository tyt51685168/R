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



# pivot_longer 針對複雜的欄位名稱也有很多處理方式，以下列舉介紹


# 1. 當你想要指定轉置的欄位有特殊 pattern，下例是開頭為 "wk" 的情況當作 variable
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
    names_prefix = "wk", # 正規表達式 regular expression，將所列的字眼通通刪除，以此例來說就是把欄位名稱的 "wk" 拿掉
    names_transform = list(week = as.integer), # week 欄位直接變更資料型態為 integer
    values_to = "rank",
    values_drop_na = TRUE,
  )

billboard %>% 
  pivot_longer(
    cols = starts_with("wk"), 
    names_to = "week", 
    names_transform = list(week = readr::parse_number), 
    # 除了用上面的方法可以拿掉特定字眼外，pivot_longer 也提供 names_transform 的參數
    # 提供自定義變更 pivot 後值的內容，此例就是透過 parse_number 取數字的用法
    values_to = "rank",
    values_drop_na = TRUE,
  )

# 2. 當 variable name 有特殊 pattern 要處理，以此例來說，欄位名稱依照底線 _ 區分成三部分
# names_to 就先指定 variable name 會有三個，接著透過 names_pattern 使用正規表達式取值
# 得出來的解過就會是第一個底線前的欄位名稱被塞到 "diagnosis" 欄位中當值；中間的部分塞到 "gender" 欄位當值；底線的最後則是塞到 "age" 當值

> who
# A tibble: 7,240 x 60
   country     iso2  iso3   year new_sp_m014 new_sp_m1524 new_sp_m2534 new_sp_m3544 new_sp_m4554 new_sp_m5564 new_sp_m65 new_sp_f014
   <chr>       <chr> <chr> <int>       <int>        <int>        <int>        <int>        <int>        <int>      <int>       <int>
 1 Afghanistan AF    AFG    1980          NA           NA           NA           NA           NA           NA         NA          NA
 2 Afghanistan AF    AFG    1981          NA           NA           NA           NA           NA           NA         NA          NA
 3 Afghanistan AF    AFG    1982          NA           NA           NA           NA           NA           NA         NA          NA


who %>% pivot_longer(
  cols = new_sp_m014:newrel_f65,
  names_to = c("diagnosis", "gender", "age"), 
  names_pattern = "new_?(.*)_(.)(.*)",
  values_to = "count"
)

# A tibble: 405,440 x 8
   country     iso2  iso3   year diagnosis gender age   count
   <chr>       <chr> <chr> <int> <chr>     <chr>  <chr> <int>
 1 Afghanistan AF    AFG    1980 sp        m      014      NA
 2 Afghanistan AF    AFG    1980 sp        m      1524     NA
 3 Afghanistan AF    AFG    1980 sp        m      2534     NA


# -------------------------------------------------

# 3. 以下為超特殊情形，欄位沒辦法單純的用分隔符號區分
# 如果開頭是 dob (date of birth) 那該欄位的值就會是日期；如果開頭是 gebder 那該欄位的值就會是1或2
# 要是直接使用 pivot_longer 會出錯，因為兩種欄位的值資料型態不同
# 用 names_transform 硬轉資料型態為 char 會過沒錯，但意義上這兩種值要被拆成兩個 variable 看待
# 這裡介紹一個 pivot_longer (應該也是 tidyr) 的保留字  .value
# 一樣是在 names_to 的時候先告訴程式即將要依照某種特殊 pattern 去拆欄位，再加上保留字 .value 讓程式去識讀不同的字眼要被拆成不同欄位(variable name)

family <- tribble(
  ~family,  ~dob_child1,  ~dob_child2, ~gender_child1, ~gender_child2,
  1L, "1998-11-26", "2000-01-29",             1L,             2L,
  2L, "1996-06-22",           NA,             2L,             NA,
  3L, "2002-07-11", "2004-04-05",             2L,             2L,
  4L, "2004-10-10", "2009-08-27",             1L,             1L,
  5L, "2000-12-05", "2005-02-28",             2L,             1L,
)
family <- family %>% mutate_at(vars(starts_with("dob")), parse_date)

family %>% 
  pivot_longer(
    !family, 
    names_to = c(".value", "child"), # 透過觀察得知，欄位名稱有 dob_child 與 gender_child 兩種，我們希望開頭不同的欄位可以在轉置後變成不同 variable
    names_sep = "_", # pattern 是透過底線分隔
    values_drop_na = TRUE
  )

#得到的結果就會自動辨別 .value = dob, gender 並拆分成兩個 varible
# A tibble: 9 x 4
  family child  dob        gender
   <int> <chr>  <date>      <int>
1      1 child1 1998-11-26      1
2      1 child2 2000-01-29      2
3      2 child1 1996-06-22      2



# https://tidyr.tidyverse.org/articles/pivot.html
