# 以往自己都很習慣用 reshape package 中的 melt & cast function 去進行資料轉置(pivoting)
# 這裡試著學習使用 tidyr 套件中的 pivot_wider 將資料進行轉置

# 1. pivoting without aggregation: 標準的長表格轉寬表格，以下用 fish_encounters 作為示範

fish_encounters
 # A tibble: 114 × 3
   fish  station  seen
   <fct> <fct>   <int>
 1 4842  Release     1
 2 4842  I80_1       1
 3 4842  Lisbon      1

# 使用 names_from 指定原先哪個欄位要變成新的寬表格欄位；value_from 則是新的寬表格欄位值
fish_encounters %>% pivot_wider(names_from = station, values_from = seen)

# A tibble: 19 × 12
   fish  Release I80_1 Lisbon  Rstr Base_TD   BCE   BCW  BCE2  BCW2   MAE
   <fct>   <int> <int>  <int> <int>   <int> <int> <int> <int> <int> <int>
 1 4842        1     1      1     1       1     1     1     1     1     1
 2 4843        1     1      1     1       1     1     1     1     1     1
 3 4844        1     1      1     1       1     1     1     1     1     1
 4 4845        1     1      1     1       1    NA    NA    NA    NA    NA
 5 4847        1     1      1    NA      NA    NA    NA    NA    NA    NA
 6 4848        1     1      1     1      NA    NA    NA    NA    NA    NA
 
 
fish_encounters %>% pivot_wider(
  names_from = station, 
  values_from = seen,
  values_fill = 0 # 轉置時總會出現 #NA，透過 value_fill = 0 將 NA 補值為0
)


# 2. pivoting with aggregation: 轉置時順便將資料進行彙整(aggregate)
# 使用 values_fn 指定彙整的方式

warpbreaks <- warpbreaks %>% as_tibble() %>% select(wool, tension, breaks)
warpbreaks
 # A tibble: 54 × 3
    wool  tension breaks
    <fct> <fct>    <dbl>
  1 A     L           26
  2 A     L           30

warpbreaks %>% 
  pivot_wider(
    names_from = wool, 
    values_from = breaks,
    values_fn = list(breaks = mean)
  )
