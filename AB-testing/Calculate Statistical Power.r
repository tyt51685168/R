# 以下用 H1 > H0 的假設檢定作為範例

sigma <- 15    # theoretical standard deviation
mu0   <- 100   # expected value under H0
mu1   <- 130   # expected value under H1
alpha <- 0.05  # probability of type I error

# critical value for a level alpha test
# 先計算臨界值 (critical value)，這裡是右尾測試不需把 alpha 除以 2
# 我們一般查 z 表找的是：在 N(0,1) 的常態分佈下找臨界值，e.g. 雙尾測試 95% C.I. 5% alpha 就會得到 1.96 這個數字
# 而這個臨界值指的是：累積分布函數（CDF,Cumulative Distribution Function）把臨界值以前的數字出現的機率累加到 95% 為止
# 舉例來說 N(0,1) 的常態分佈把小於 1.96 的數值出現的機率累加起來就會是 95%，而加到 95% 為止的臨界值 1.96 就是我們要的邊界

# 那麼 R 語言的 qnrom() 就是用來幫我們找臨界值的 function，基於 CDF 的語法，輸入機率回傳臨界值
# 備註：當然也可以用查 z 表的方式先寫 qnorm(1-alpha, mean = 0, sd = 1) 得到 z 值後，再把這個 z 值當作倍率去乘上 standard deviation 得到臨界值
# 以上備註的做法就是一般考試手寫的計算方式，而現在透過程式語言可以直接積分計算 CDF 來得到準確的 critical value
crit <- qnorm(1-alpha, mu0, sigma)

# power: probability for values > critical value under H1
# 接著算 type II error 的機率就要使用 R 語言的 pnorm() function，一樣是基於 CDF 的語法，但輸入的是臨界值，回傳的是機率

(pow <- pnorm(crit, mu1, sigma, lower.tail=FALSE))
[1] 0.63876

# probability for type II error: 1 - power
(beta <- 1-pow)
[1] 0.36124

# !!!!! 此例 H1 > H0，確認 type II error 的機率（明明 H0 為真但卻拒絕接受假設）可以直接算 beta 就好 !!!!!
# 意即 H1 的資料小於臨界值的所有數值機率加總得到 beta
# 原回文者是先計算 statistical power 再用 1 - power 的方式得到 beta
(beta <- pnorm(crit, mu1, sigma, lower.tail = TRUE))
[1] 0.36124



總結一下 type I error & type II error 的概念：

1.
type I error 的機率 = 我們在假設檢定之前給定的 significance level（alpha），而 1-alpha = confidence level
最後就會得到大家常聽到的一句話，在給定 5% 的顯著水準(alpha)之下，我們有 95% 的信心水準確保真值（true value, true mean...）會落在我們目前計算的信賴區間（confidence interval）

實務上我們當然希望 type I error 的機率越小越好，因為不希望偽陽性的狀況發生，這有可能導致信賴區間變大，只能用更大的範圍把真值框出來
當然如果有更多的資源取得更多的樣本，mean & standard deviation 越精準，即便顯著水準下降了也會得到更窄的信賴區間

2.
type II error 的機率是必須依賴著 alpha，畢竟我們需要知道臨界值在哪邊，才有辦法計算偽陰性的機率

實務上也希望 type II error 的機率越小越好，而通常的做法就是提高抽樣數量，使實驗組或控制組的 mean & standard deviation 變得更精準
在 AB testing 中會希望給定一個 beta （跟 alpha 一樣希望被控制在某種程度，通常可接受 beta 20%，statistical power = 80%），
而一般情況則是在得到所有實驗數據後，檢定虛無假說是否為真的同時，也提供偽陰性的機率

# Reference:
# https://stats.stackexchange.com/questions/7402/how-do-i-find-the-probability-of-a-type-ii-error
