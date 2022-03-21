library(dplyr)
set.seed(123)

# build a testing data set
my_data <- data.frame(matrix(data = rnorm(25, 5, 3), ncol = 5, nrow = 5))

my_data %>%
  summarise(n = n(), min = min(X1), max = max(X1))

# the expected out put will be
#n　min　     max 
#5  3.318573  9.676125


# test function 1 will return error due to object 'X1' not found
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
for (var in names(my_data)) {
  my_data %>% count(.data[[var]]) %>% print()
}

my_data %>% count(X1)

# Note that .data is not a data frame;
# it’s a special construct, a pronoun, that allows you to access the current variables either directly,
# with .data$x or indirectly with .data[[var]]. Don’t expect other functions to work with it.
