# 在撰寫 function 時若需使用到 dplyr 套件，經常會遇到一種狀況是要以欄位當作參數傳入，
# 但以 dplyr 來說，在使用 function 時所輸入的參數除了資料表 x 以外，常常都是直接寫欄位名稱，並非使用 index 或加上雙引號" "的欄位名稱，
# 這也就導致如果要嘗試用 dplyr 傳參數的邏輯去應用在寫 function 的話，往往程式會告訴你 variable not found，
# 為解決這種困境 dplyr 套件本身提出了兩種以上的解決方案，其一是 function 使用字串當作參數傳入，但慣用的 dplyr function 必須多加一個底線（實為另一個 function）
# 例如：group_by() 須改為使用 group_by_()，而 group_by_() 所需傳入的參數即為字串。

# 而下方則是官方新釋出的解法，將 env-variable 當作 data-variable 使用的方式

library(dplyr)
set.seed(123)

# build a testing data set
my_data <- data.frame(matrix(data = rnorm(25, 5, 3), ncol = 5, nrow = 5))

my_data %>%
  summarise(n = n(), min = min(X1), max = max(X1))

# the expected output will be
#n　min　     max 
#5  3.318573  9.676125

# my_func_1 will return errors due to object 'X1' not found
my_func_1 <- function(data, column1){
  data %>%
    summarise(n = n(), min = min(column1), max = max(column1))
}

my_func_1(my_data, X1)


# when you want to get the data-variable from an env-variable
# instead of directly typing the data-variable’s name.
# There are two main cases:

# you need to embrace the argument by surrounding it in doubled braces, like filter(df, {{ var }})
my_func_2 <- function(data, column1){
  data %>%
    summarise(n = n(), min = min({{column1}}), max = max({{column1}}))
}

my_func_2(my_data, X1)


# The following example uses .data to count the number of unique values in each variable of test:
# 以下的做法比較 general，並非只能應用在 dplyr 上，
# 只是當使用 dplyr function 時，可以用 .data 當作傳入的資料表名稱，
# 雙括號 [[var]] 的用法就只是單純的在 dataframe 中，用字串當作欄位索引值去取出整個 column vector 的常用作法。
for (var in names(my_data)) {
  my_data %>% count(.data[[var]]) %>% print()
}

my_data %>% count(X1)

# Note that .data is not a data frame;
# it’s a special construct, a pronoun, that allows you to access the current variables either directly,
# with .data$x or indirectly with .data[[var]]. Don’t expect other functions to work with it.


##### Resource: https://dplyr.tidyverse.org/
