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
[0.36124]



# Reference:
# https://stats.stackexchange.com/questions/7402/how-do-i-find-the-probability-of-a-type-ii-error
