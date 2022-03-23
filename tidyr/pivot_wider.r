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
    names_from = wool, # wool 欄位值作轉置後新的欄位名稱
    values_from = breaks, # breaks 欄位值作轉置後的值
    values_fn = list(breaks = mean) 
   # pivot 時候所作的 aggregation 就想成是 group by ID 後再進行 summarize，此處可想做 group_by tension, summarize A & B 欄位, 方法是 mean
  )

 # A tibble: 3 × 3
   tension     A     B
   <fct>   <dbl> <dbl>
 1 L        44.6  28.2
 2 M        24    28.8
 3 H        24.6  18.8




# 3. 使用多個欄位合併轉置成新的欄位名稱

production
 # A tibble: 45 × 4
    product country  year production
    <chr>   <chr>   <int>      <dbl>
  1 A       AI       2000      0.264
  2 A       AI       2001      0.188

# 基本款，在 names_from 的時候直接使用 c() 多個欄位合併
production %>% pivot_wider(
  names_from = c(product, country), # 不指定 names_sep 分隔符號的話，預設為底線 _
  values_from = production
)
 # A tibble: 15 × 4
     year   A_AI    B_AI     B_EI
    <int>  <dbl>   <dbl>    <dbl>
  1  2000  0.264 -0.137  -0.134  
  2  2001  0.188 -0.569   0.00650

# 指定分隔符號跟前綴
production %>% pivot_wider(
  names_from = c(product, country), 
  values_from = production,
  names_sep = ".", # 分隔符號
  names_prefix = "prod." # 新增前綴
)
 # A tibble: 15 × 4
     year prod.A.AI prod.B.AI prod.B.EI
    <int>     <dbl>     <dbl>     <dbl>
  1  2000     0.264   -0.137   -0.134  
  2  2001     0.188   -0.569    0.00650

# 自行控制欄位值要塞成怎樣的欄位名稱，將欄位名稱當作變數看待，在 names_glue 中用 {} 去指定字串的哪個位置要放入變數，就是字串列印時可以 % 取變數的概念
production %>% pivot_wider(
  names_from = c(product, country), 
  values_from = production,
  names_glue = "prod_{product}_{country}"
)
#> # A tibble: 15 × 4
#>     year prod_A_AI prod_B_AI prod_B_EI
#>    <int>     <dbl>     <dbl>     <dbl>
#>  1  2000     0.264   -0.137   -0.134  
#>  2  2001     0.188   -0.569    0.00650
#>  3  2002    -0.710   -0.508   -0.519 

# source: https://tidyr.tidyverse.org/articles/pivot.html
