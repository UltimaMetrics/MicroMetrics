clear
capture log close
set more off
//cd "/Users/uqfouyan/Dropbox/Teaching/UQ/financial econometrics/2019 ECON 7350/tutorials/tutorial 4"//
cd "E:\UQ\2019 S2\ECON7360 Micro Metrics\Tutorial\Tute5\
log using mytute5.log, replace
use injury.dta

de

* II- (ii)
*outcome variable: duration of benefits
* Diff-in-diff estimate: (ldurat_after_highearn - ldurat_before_highearn) - (ldurat_after_lowearn - ldurat_before_lowearn)

* ldurat_after_highearn
mean ldurat if afchnge==1&highearn==1&ky==1
* 1.580352 

* ldurat_before_highearn
mean ldurat if afchnge==0&highearn==1&ky==1
* 1.382094  

* ldurat_after_lowearn
mean ldurat if afchnge==1&highearn==0&ky==1
* 1.133273 

* ldurat_before_lowearn
mean ldurat if afchnge==0&highearn==0&ky==1
* 1.125615

* DID estimate:  (1.580352 -1.382094 )- (1.133273 -1.125615)
di (1.580352 -1.382094 )- (1.133273 -1.125615)
* .1906


* DID estimate is the coefficient on afhigh in the regression
*without robust standard errors
reg ldurat afchnge highearn afhigh if ky==1
*with robust standard errors (preferred)
reg ldurat afchnge highearn afhigh if ky==1, robust


* II- (iii)
*add explanatory variables male and married and industry dummies and injury type dummies
reg ldurat afchnge highearn afhigh male married i.indust i.injtype if ky==1, robust

* The coefficient on afchnge*highearn becomes .231 (se =.070) 
*and is statistically significant
* the estimated effect and  t statistic are 
*now larger than when we omitted the control variables. 
* The estimate of .231 implies a substantial response 
*of durat to the change in the cap for high-earnings workers.

* II- (iv)

* The R-squared in part (ii) is about 0.021
* The R-squared in part (iii) is about 0.041,
* which means we are explaining only a 4.1% of the variation in log(durat). 
* This means that there are some very important 
*factors that affect log(durat) that we are controlling for.
* While this means that predicting log(durat) 
*would be very difficult for a particular individual, 
* it does not mean that there is anything biased 
*about interaction term: 
* it could still be an unbiased estimator of the causal 
*effect of changing the earnings cap for workers' compensation.



* II- (v)
reg ldurat afchnge highearn afhigh if mi==1, robust

* The estimate of interaction term, .192, is remarkably close to the 
*estimate obtained for Kentucky (.191). 
* However, the standard error for the Michigan
* estimate is much higher (.158 compared with .069). 
* The estimate for Michigan is not statistically significant.
* Even though we have over 1,500 observations,
* we cannot get a very precise estimate. (For Kentucky, we had over 5,600 observations.)
* This is maybe due to some very important factors
* that affect log(durat) that we have not controlled for.



use minwage.dta, clear

de

* III- (ii)
tab nj after, su(fte) means

* (17.583627 - 17.301056) - (18.253846 -20.3) 
di (17.583627 - 17.301056) - (18.253846 -20.3) 
* 2.328725
* Surprisingly, employment rose in NJ relative to PA after the minimum wage change.

* III- (iii)
reg fte nj after njafter

* coefficient on njafter which is DID estimate is 2.328724
* Let say coefficients on constant, nj, after, 
*and njafter are a1, a2, a3, and a4 respectively
* PA pre-treatment: a1
* PA post-treatment: a1+a3
* NJ pre-treatment: a1+a2
* NJ post-treatment: a1+a2+a3+a4
* DID=(NJ post- NJ pre)-(PA post - PA per)= (a3+a4)-(a3)=a4


reg fte nj after njafter, robust

* The difference is sizeable because we suspect: 
*1)heteroskedastic error or 2)serial correlation.

*we prefer the robust standard errors

* III- (iv)
xtreg fte nj after njafter, fe robust
 
* We are interested in the coefficient on njafter

* III- (v)
* Key assumption for DID strategy is:
* the outcome in treatment and control group would follow the
* same time trend in the absence of the treatment.
* common trend assumption is difficult to verify but
* one often uses pre-treatment data to show that the trends are the same.
* Even if pre-trend are the same one still has 
*to worry about other policies changing at the same time.

* III- (vi)
* They are equivalent
* reg fte nj after njafter is a dummy variable approach
* where nj is c_i, state specific effect
* Thus, it is the same as the within estimator 
*or FE estimator: xtreg fte after njafter, fe cluster(sheet)
* The dummy variable approach and the 
*within estimator  (or FE) are  equivalent estimators
log close



