## Strategy: For a bunch of Ns, compute the z_star by achieving desired alpha, then
## compute what beta would be for that N using the acquired z_star. 
## Pick the smallest N at which beta crosses the desired value

# Inputs:
#   The desired alpha for a two-tailed test
# Returns: The z-critical value
第一個 function：計算 z 值，這裡作者是假設用雙尾檢定，所以 alpha 除以 2

get_z_star = function(alpha) {
    return(-qnorm(alpha / 2))
}

# Inputs:
#   z-star: The z-critical value
#   s: The variance of the metric at N=1
#   d_min: The practical significance level
#   N: The sample size of each group of the experiment
# Returns: The beta value of the two-tailed test
第二個 function：計算 beta 值，用作等下計算 sample size 使用，N 越大 SE 越小

*** 這裡特別注意一下 d_min 在課程中指的是最小要觀察到的差異
*** 那為什麼差異可以被當作平均值傳入計算 beta 的 function 使用呢？
*** 因為我們計算 critical value 的 function 1 是基於 N(0,1) 的常態分佈假設，我們要拿來比較的另一組資料平均值就會 = 跟 0 的差異（任何數 - 0 = 任何數本身）
*** 所以你想要觀察到的差異程度 = 另一個分布的平均值

get_beta = function(z_star, s, d_min, N) {
    SE = s /  sqrt(N)
    return(pnorm(z_star * SE, mean=d_min, sd=SE))
}

# Inputs:
#   s: The variance of the metric with N=1 in each group
#   d_min: The practical significance level
#   Ns: The sample sizes to try
#   alpha: The desired alpha level of the test
#   beta: The desired beta level of the test
# Returns: The smallest N out of the given Ns that will achieve the desired
#          beta. There should be at least N samples in each group of the experiment.
#          If none of the given Ns will work, returns -1. N is the number of
#          samples in each group.
第三個 function：輸入 standard deviation, d_min (期待觀測到的差異), 樣本的大小範圍 Ns, alpha 值, beta 值，得出 experiment 組需抽多少樣本
這裡的 Ns是一個 vector，原因是 function 跑迴圈去找最小的樣本數量，直到滿足計算出來的 beta 小於等於給定的預期 beta

required_size = function(s, d_min, Ns=1:20000, alpha=0.05, beta=0.2) {
    for (N in Ns) {
        if (get_beta(get_z_star(alpha), s, d_min, N) <= beta) {
            return(N)
        }
    }
    
    return(-1)
}

# Example analytic usage
# This is the example from Lesson 1, for which the online calculate gave 3,623
# samples in each group
# s is the pooled standard error for N=1 in each group,
# which is sqrt(p*(1-p)*(1/1 + 1/1))

*** 想法一
這裡第一個例子是控制組已經做完資料蒐集，結果為 p = 0.1
接著要計算實驗組要抽多少樣本才能夠觀察到 0.02 的差異
在比較兩個 binomail distribution 的差異時，要計算 pooled probability & pooled standard error
但這裡我們還沒針對實驗組進行資料蒐集，只能先假設 pooled probability = 控制組的 probability，並假設兩個組別 N = 1 

*** 想法二
在任何資料都還沒開始蒐集前，先有個 probability 的假設，例如這個例子是 p = 0.1，當然也可以用過往的資料當作假設
接著才是基於這個 p 的假設跟預計觀察到的 0.02 差異去計算控制組 & 實驗組各別所需的樣本數量
↑ 所以 pooled 的計算才會是 pooled probability = p = 0.1，且兩個組別的 N = 1 

*** 小結
因為什麼資料都還沒取得，所以要先用一個比較直接的想法假設可能的 standard error
接著就可以用類似跑模擬的方式得到 sample size
假設 standard error -> 跑迴圈測試當 N 變大時，standard error 變小 -> 看 standard error 小到什麼程度會使計算出的 beta 小於等於我們指定的 beta = 0.2 -> 得到 N

required_size(s=sqrt(0.1*0.9*2), d_min=0.02)

# Sizing: Example
# Cookie-based diversion
# Since the standard error is proportional to 1/sqrt(N), s, or
# the standard error for N=1, is equal to the mesaured standard error with 5000
# in each group times sqrt(5000)
required_size(s=0.00515*sqrt(5000), d_min=0.02)
# User-id-based diversion
required_size(s=0.0119*sqrt(5000), d_min=0.02)

# Sizing: Quiz
# Original size
required_size(s=0.0628*sqrt(1000), d_min=0.01, Ns=seq(10, 500000, 100))
# Size with event-based diversion
required_size(s=0.0209*sqrt(1000), d_min=0.01, Ns=seq(10, 500000, 100))
# Size with event-based diversion and English-only traffic
required_size(s=0.0188*sqrt(1000), d_min=0.015)
# Size with cookie-based diversion, English-only traffic, and 
# click-through-probability instead of click-through-rate
required_size(s=0.0445*sqrt(1000), d_min=0.015, Ns=seq(10, 500000, 100))


剩下的例子就是跟課程有關變更假設的 standard error & d_min
只要掌握 alpha, beta, how to compare two binomial distribution (包含 se, pooled probability 的計算) 的相關知識，
當然還有基礎的 hypothesis test 的概念就能夠明白如何計算 A/B testing 所需的樣本數量


# Reference
# Udacity online course: A/B testing 
# url: https://classroom.udacity.com/courses/ud257
