contacts <- tribble(
  ~field, ~value,
  "name", "Jiena McLellan",
  "company", "Toyota", 
  "name", "John Smith", 
  "company", "google", 
  "email", "john@google.com",
  "name", "Huxley Ratcliffe"
)

# 今天這個資料集要 pivoting 之前需要先產生 id，識別哪些資料屬於同一個人
# 藉由觀察資料的排列情形，發現每當到 name 的那一列開始就是新一個人的資料
# cumsum 一般用作 Cumulative Sums，在此處我們希望每次遇到 name 的時候都給他一個 unique ID，這個 ID 就簡單地從 1 開始給號
# 程式的邏輯就很簡單了，每當該列有 name 才 +1，直到下一個 name 出現之前都必須給相同的 ID number
# 這裡不需要透過迴圈或其他複雜的條件判斷式去實現，而是巧妙的應用一個邏輯判斷 + cumsum() 的累加功能去給 ID

(contacts <- contacts %>% 
    mutate(
      person_id = cumsum(field == "name")
    ))


# credit & source: https://bookdown.org/Maxine/r4ds/pivoting.html
