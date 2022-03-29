# lapply 是 apply 家族中對 list 進行操作的套件
# 當想要使用 lapply 對 list 中每個 element 作括號的取值時，可以使用 "[" 當作 function 參數傳入

weather[[1]][1,1] # 一般 list 中 [ ] 括號取值的方法

lapply(weather, "[", [1,1]) # 用 "[" 當作 function 參數，即可對 weather list 中每個 element 取出 [1,1] 的值
