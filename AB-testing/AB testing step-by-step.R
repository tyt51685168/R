###########################################################################################
# This example is provided by the course A/B testing on Udacity.
# The link below refer to The project instrcution
# https://docs.google.com/document/u/1/d/1aCquhIqsUApgsxQ8-SQBAigFDcfWVVohLEXcV6jWbdI/pub
#
# A quick introduction about this project
# 1. test a change about asking more questions after click "start free trial" button.
# 2. the hypothesis is to reduce the number of frustrated students and imporve 
#    the overall student experience and improve coaches' capacity to support students
#    who are likely to complete the course
###########################################################################################


# 1. Baseline information (empirical estimation) --------------------------

# For total 40,000 pageviews, there will be 3200 clicks of "start free trial" button
# which means 8% click-through-probability (CTP)

# The retention rate refers to the probability of student remain enrolled after 14-days free trial
# (and thus make at least one payment)

n_pageviews <- 40000
n_clicks <- 3200 
# the number of user-ids
n_enrolls <- 660 
click_through_prob <- 0.08
retention_rate <- 0.53
# the probability of "free trial enrollment" which students click on the button
gross_conversion_rate <- n_enrolls / n_clicks
# the probability of making a payment which students enroll the free trial after clicking on the button
net_conversion_rate <- retention_rate * gross_conversion_rate 



############ Question 1 ############
# Given a sample size of 5,000 cookies visiting the course overview page,
# calculate the standard deviation for each metric I selected as an evaluation metric.
# the metrics I selected were: gross_conversion_rate, retention_rate, net_conversion_rate

n_sample <- 5000 # sample size

sample_clicks <- n_sample * n_clicks/n_pageviews # sample clicks is proportional to the baseline
sample_retention <- n_sample * n_enrolls/n_pageviews # sample retention is proportional to the baseline

# sd of gross_conversion_rate under sampling
sd_gross_conversion_rate <- sqrt(gross_conversion_rate * (1-gross_conversion_rate) / sample_clicks)
# sd of retention_rate under sampling
sd_retention_rate <- sqrt(retention_rate * (1-retention_rate) / sample_retention)
# sd of net_conversion_rate under sampling
sd_net_conversion_rate <- sqrt(net_conversion_rate * (1-net_conversion_rate) / sample_clicks)

# Answer 1
print(paste('SD of Gross Conversion Rate:', round(sd_gross_conversion_rate, 4)))
print(paste('SD of Retention Rate:', round(sd_retention_rate, 4)))
print(paste('SD of Net Conversion Rate:', round(sd_net_conversion_rate, 4)))
  

############ Question 2 ############

# 2. Calculate sample size ------------------------------------------------
# the answer could also be obtained from the website below:
# https://www.evanmiller.org/ab-testing/sample-size.html
# But here I try to use the code created by google to get the result.

setwd('C:/Users/JEFF TU/Desktop/AB testing')
source('Calculate Sample Size.R')


############ for gross_conversion_rate ############

### base line gross conversion rate = 0.20625
### d_min = 0.01 (per instruction)
### alpha = 0.05, beta = 0.2 (per instruction)

se <- sqrt(gross_conversion_rate*(1-gross_conversion_rate)*2) # n = 1/1 + 1/1 refers to 1 experiment and 1 control groups
req <- required_size(s = se, d_min = 0.01, alpha = 0.05, beta = 0.2, Ns = 1:100000) 

# due to the size above is the # of clicks, we need to calculate how many pageviews we need for the experiment
print(paste('Pageview needed for gross_conversion_rate:', 2 * round(req / click_through_prob))) # *2 due to two groups


############ for retention_rate ############

### base line gross conversion rate = 0.53
### d_min = 0.01 (per instruction)
### alpha = 0.05, beta = 0.2 (per instruction)

se <- sqrt(retention_rate*(1-retention_rate)*2) # n = 1/1 + 1/1 refers to 1 experiment and 1 control groups
req <- required_size(s = se, d_min = 0.01, alpha = 0.05, beta = 0.2, Ns = 1:10000000)

# due to the size above is the # of retention, we need to calculate how many pageviews we need for the experiment
print(paste('Pageview needed for retention_rate:', 2 * round(req / (n_enrolls/n_pageviews)))) # *2 due to two groups


############ for net_conversion_rate ############

### base line gross conversion rate = 0.1093
### d_min = 0.0075 (per instruction)
### alpha = 0.05, beta = 0.2 (per instruction)

se <- sqrt(net_conversion_rate*(1-net_conversion_rate)*2) # n = 1/1 + 1/1 refers to 1 experiment and 1 control groups
req <- required_size(s = se, d_min = 0.0075, alpha = 0.05, beta = 0.2, Ns = 1:10000000)

# due to the size above is the # of clicks, we need to calculate how many pageviews we need for the experiment
print(paste('Pageview needed for net_conversion_rate:', 2 * round(req / click_through_prob))) # *2 due to two groups

############ Summary of sample size ############
# the calculation result shows that we need at least 4,739,878 pageviews for the experiment
# is this sample size too large ?
# therefore, we need to calculate the expected duration to see if we have enough resource/time to support the experiment




# 3. Experiment Duration --------------------------------------------------

fraction <- 1 # this means 100% of traffic are used for the experiment
n_pageview_needed_for_exp <- 4739878
n_pageview_needed_for_exp / n_pageviews / fraction # takes 119 days to complete the experiment, it's way too long

n_pageview_needed_for_exp <- 679300
n_pageview_needed_for_exp / n_pageviews / fraction # only takes 17 days, reasonable

# in terms of the duration, we might consider not to use retention rate as the metric




# 4. Sanity Check (for invariant) -----------------------------------------

# Use the dataset from google to check the sanity
# compute 95% confidence interval
# the goal of sanity check is to see there is no difference between the exp. & cont. groups for those invariants

############ data ############ 
dates <- c('Sat, Oct 11', 'Sun, Oct 12', 'Mon, Oct 13', 'Tue, Oct 14',
           'Wed, Oct 15', 'Thu, Oct 16', 'Fri, Oct 17', 'Sat, Oct 18',
           'Sun, Oct 19', 'Mon, Oct 20', 'Tue, Oct 21', 'Wed, Oct 22',
           'Thu, Oct 23', 'Fri, Oct 24', 'Sat, Oct 25', 'Sun, Oct 26',
           'Mon, Oct 27', 'Tue, Oct 28', 'Wed, Oct 29', 'Thu, Oct 30',
           'Fri, Oct 31', 'Sat, Nov 1', 'Sun, Nov 2', 'Mon, Nov 3',
           'Tue, Nov 4', 'Wed, Nov 5', 'Thu, Nov 6', 'Fri, Nov 7',
           'Sat, Nov 8', 'Sun, Nov 9', 'Mon, Nov 10', 'Tue, Nov 11',
           'Wed, Nov 12', 'Thu, Nov 13', 'Fri, Nov 14', 'Sat, Nov 15',
           'Sun, Nov 16')

pageviews_cont <- c(7723, 9102, 10511, 9871, 10014, 9670, 9008, 7434, 8459,
                    10667, 10660, 9947, 8324, 9434, 8687, 8896, 9535, 9363,
                    9327, 9345, 8890, 8460, 8836, 9437, 9420, 9570, 9921,
                    9424, 9010, 9656, 10419, 9880, 10134, 9717, 9192, 8630,
                    8970)

pageviews_exp <- c(7716, 9288, 10480, 9867, 9793, 9500, 9088, 7664, 8434,
                   10496, 10551, 9737, 8176, 9402, 8669, 8881, 9655, 9396,
                   9262, 9308, 8715, 8448, 8836, 9359, 9427, 9633, 9842,
                   9272, 8969, 9697, 10445, 9931, 10042, 9721, 9304, 8668,
                   8988)

clicks_cont <- c(687, 779, 909, 836, 837, 823, 748, 632, 691, 861, 867, 838, 665,
                 673, 691, 708, 759, 736, 739, 734, 706, 681, 693, 788, 781, 805,
                 830, 781, 756, 825, 874, 830, 801, 814, 735, 743, 722)

clicks_exp <- c(686, 785, 884, 827, 832, 788, 780, 652, 697, 860, 864, 801, 642,
                697, 669, 693, 771, 736, 727, 728, 722, 695, 724, 789, 743, 808,
                831, 767, 760, 850, 851, 831, 802, 829, 770, 724, 710)

enrolls_cont <- c(134, 147, 167, 156, 163, 138, 146, 110, 131, 165, 196, 162, 127,
                  220, 176, 161, 233, 154, 196, 167, 174, 156, 206)

enrolls_exp <- c(105, 116, 145, 138, 140, 129, 127,  94, 120, 153, 143, 128, 122,
                 194, 127, 153, 213, 162, 201, 207, 182, 142, 182)

payment_cont <- c(70,  70,  95, 105,  64,  82,  76,  70,  60,  97, 105,  92,  56,
                  122, 128, 104, 124,  91,  86,  75, 101,  93,  67)

payment_exp <- c(34,  91,  79,  92,  94,  61,  44,  62,  77,  98,  71,  70,  68,
                 94,  81, 101, 119, 120,  96,  67, 123, 100, 103)

############ for pageviews (assumed equally sign to exp. & cont. groups) ############
se <- sqrt(0.5*0.5 / (sum(pageviews_cont) + sum(pageviews_exp)))
margin_of_error <- 1.96 * se

# C.I.
ci <- round(c(-1, 1) * margin_of_error + 0.5, 4)
# observed prob.
obs <- round(sum(pageviews_cont) / (sum(pageviews_cont) + sum(pageviews_exp)), 4)

# evaluating
print(paste('Is observed prob. within the C.I?: ', 
            ifelse(ci[1] < obs & ci[2] > obs, 'Yes, sanity check passed', 'No, sanity check failed')))


############ for clicks (assumed equally sign to exp. & cont. groups) ############

se <- sqrt(0.5*0.5 / (sum(clicks_cont) + sum(clicks_exp)))
margin_of_error <- 1.96 * se

# C.I.
ci <- round(c(-1, 1) * margin_of_error + 0.5, 4)
# observed prob.
obs <- round(sum(clicks_cont) / (sum(clicks_cont) + sum(clicks_exp)), 4)
# evaluating
print(paste('Is observed prob. within the C.I?: ', 
            ifelse(ci[1] < obs & ci[2] > obs, 'Yes, sanity check passed', 'No, sanity check failed')))

############ for CTP (assumed equally sign to exp. & cont. groups) ############

CTP_cont <- sum(clicks_cont) / sum(pageviews_cont)
CTP_exp <-sum(clicks_exp) / sum(pageviews_exp)
CTP_pool <- (sum(clicks_cont) + sum(clicks_exp)) / (sum(pageviews_cont) + sum(pageviews_exp))

se <- sqrt(CTP_pool*(1-CTP_pool) * (1/sum(pageviews_cont) + 1/sum(pageviews_exp)))
margin_of_error <- 1.96 * se

# C.I.
ci <- round(c(-1, 1) * margin_of_error , 4)
# observed diff
obs <- round(CTP_exp - CTP_cont, 4)

# evaluating
print(paste('Is C.I. contains zero?: ',
            ifelse(ci[1] < 0 & ci[2] > 0, 'Yes', 'No'))) # statistical significance test

print(paste('Is observed prob. within the C.I?: ', 
            ifelse(ci[1] < obs & ci[2] > obs, 'Yes, sanity check passed', 'No, sanity check failed'))) # practical significance test





# 5. A/B testing, difference testing for selected metrics, evaluat --------
############ for gross_conversion_rate ############ 
n <- length(enrolls_exp) # the length of enroll & click are different, pick the smaller one
d_min <- 0.01 # per instruction

conversion_rate_cont <- sum(enrolls_cont) / sum(clicks_cont[1:n])
conversion_rate_exp <- sum(enrolls_exp) / sum(clicks_exp[1:n])
conversion_rate_pool <- (sum(enrolls_cont) + sum(enrolls_exp)) / (sum(clicks_cont[1:n]) + sum(clicks_exp[1:n]))

se_pool <- sqrt(conversion_rate_pool * (1-conversion_rate_pool) * (1/sum(clicks_cont[1:n]) + 1/sum(clicks_exp[1:n])))
margin_of_error <- 1.96 * se_pool

# observed diff
obs <- conversion_rate_exp - conversion_rate_cont

# C.I.
ci <- round(c(-1, 1) * margin_of_error + obs, 4)

# evaluating
print(paste('Is C.I. contains zero?: ',
            ifelse(ci[1] < 0 & ci[2] > 0, 'Yes', 'No'))) # statistical significance test

print(paste('Is C.I. contains d_min or -d_min: ',
            ifelse((ci[1] < d_min & ci[2] > d_min) | 
                   (ci[1] < -d_min & ci[2] > -d_min), 'Yes, cannot reject H0', 'No, reject H0'))) # practical significance test

############ for retention_rate ############
d_min <- 0.01 # per instruction
retention_rate_cont <- sum(payment_cont) / sum(enrolls_cont)
retention_rate_exp <- sum(payment_exp) / sum(enrolls_exp)
retention_rate_pool <- (sum(payment_cont) + sum(payment_exp)) / (sum(enrolls_cont) + sum(enrolls_exp))

se_pool <- sqrt(retention_rate_pool*(1-retention_rate_pool)*(1/sum(enrolls_cont) + 1/sum(enrolls_exp)))
margin_of_error <- 1.96 * se_pool

# observed diff
obs <- retention_rate_exp - retention_rate_cont

# C.I.
ci <- round(c(-1, 1) * margin_of_error + obs, 4)

# evaluating
print(paste('Is C.I. contains zero?: ',
            ifelse(ci[1] < 0 & ci[2] > 0, 'Yes', 'No'))) # statistical significance test

print(paste('Is C.I. contains d_min or -d_min: ',
            ifelse((ci[1] < d_min & ci[2] > d_min) | 
                   (ci[1] < -d_min & ci[2] > -d_min), 'Yes, cannot reject H0', 'No, reject H0'))) # practical significance test


############ for net_conversion_rate ############ 
n <- length(payment_exp) # the length of payment & click are different, pick the smaller one
d_min <- 0.0075 # per instruction

net_conversion_rate_cont <- sum(payment_cont) / sum(clicks_cont[1:n])
net_conversion_rate_exp <- sum(payment_exp) / sum(clicks_exp[1:n])
net_conversion_rate_pool <- (sum(payment_cont) + sum(payment_exp)) / (sum(clicks_cont[1:n]) + sum(clicks_exp[1:n]))

se_pool <- sqrt(net_conversion_rate_pool*(1-net_conversion_rate_pool)*(1/sum(clicks_cont[1:n]) + 1/sum(clicks_exp[1:n])))
margin_of_error <- 1.96 * se_pool

# observed diff
obs <- net_conversion_rate_exp - net_conversion_rate_cont

# C.I.
ci <- round(c(-1, 1) * margin_of_error + obs, 4)

# evaluating
print(paste('Is C.I. contains zero?: ',
            ifelse(ci[1] < 0 & ci[2] > 0, 'Yes', 'No'))) # statistical significance test

print(paste('Is C.I. contains d_min or -d_min: ',
            ifelse((ci[1] < d_min & ci[2] > d_min) | 
                   (ci[1] < -d_min & ci[2] > -d_min), 'Yes, cannot reject H0', 'No, reject H0'))) # practical significance test



# 6. Sign test for each day -----------------------------------------------
############ for gross_conversion_rate ############ 
n <- length(enrolls_exp)

gc_cont <- enrolls_cont / clicks_cont[1:n]
gc_exp <- enrolls_exp / clicks_exp[1:n]
positives <- sum(gc_exp - gc_cont > 0)

print(paste('Is p-value < 0.05?: ',
            binom.test(x = positives, n = n, p = 0.5)$p.value < 0.05))

############ for retention rate ############ 
n <- length(payment_exp)

rr_cont <- payment_cont / enrolls_cont[1:n]
rr_exp <- payment_exp / enrolls_exp[1:n]
positives <- sum(rr_exp - rr_cont > 0)

print(paste('Is p-value < 0.05?: ',
            binom.test(x = positives, n = n, p = 0.5)$p.value < 0.05))

############ for net_conversion_rate ############ 
n <- length(payment_exp)

nc_cont <- payment_cont / clicks_cont[1:n]
nc_exp <- payment_exp / clicks_exp[1:n]
positives <- sum(nc_exp - nc_cont > 0)

print(paste('Is p-value < 0.05?: ',
            binom.test(x = positives, n = n, p = 0.5)$p.value < 0.05))


# 7. Make a recommendation ------------------------------------------------

# I would suggest not to launch the change due to the reasons below:
#   a. We cannot see there is a significant diffence in terms of the metric - Net conversion in both hypothesis tests,
#      and we even give a smaller detectable effect by 0.75%.
#   b. The testing result of the metric - Retention rate is not consistent between both hypothesis tests,
#      which means it might be just a random event/occurrence during the experiment period.
#   c. The gross conversion rate is getting even worse.


