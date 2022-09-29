clear
capture log close
set more off
//cd "/Users/uqfouyan/Dropbox/Teaching/UQ/financial econometrics/2019 ECON 7350/tutorials/tutorial 4"//
cd "D:\UQ\2019 S2\ECON7360 Micro Metrics\Tutorial\Tute3\

use institution.dta
log using mytute3.log, replace


* I-(i)
de

* I-(ii)
sum 
list countryn
*64 countries


* I- (iii)
twoway (scatter lgdp prot) (lfit lgdp prot) //linear trend y=a+bx

twoway (scatter lgdp prot) (lfitci lgdp prot) //linear trend y=a+bx

twoway (scatter lgdp prot) (qfit lgdp prot) //y=a+bx+cx^2: quadratic trend

twoway (scatter lgdp prot) (qfitci lgdp prot) //quadratic trend and CI
********************************************
twoway (scatter prot logmort) (lfit prot logmort)
*twoway (scatter prot logmort) (lfitci prot logmort)

*I- (iv) 

reg lgdp logmort, r //reduced form
*coefficient on logmort is : -0.5697 (reduced form)

reg prot logmort, r //first stage
* coefficient on logmort is : -.6213181

ivregress 2sls lgdp (prot=logmort)
* coefficient on prot is : .9170798

di (-.5697983)/(-.6213181) //this is point estimate from IV regression
*.91707983
//Structural form is the model which contains true parameters


* I- (v) 
* IV regression by 2SLS method
ivregress 2sls lgdp (prot=logmort) //IV by 2 stages least square
ivregress liml lgdp (prot=logmort) //IV by limited information max likelihood
ivregress gmm lgdp (prot=logmort) //IV by generalized method of moments 


* Coefficient are the same but the standard errors are different 
* 2SLS requites homoskedastic error 
* If the error is homoskedastic, both 2SLS and GMM are valid in large sample
* If the error is heteroskedastic, only GMM is valid in large sample

* I- (vi) 
reg prot logmort, r //first stage
predict prothat, xb //here we are generating the predicted value for prot

reg lgdp prothat, r //second stage

* Let's compare standard error from this 2-step procedure to 1-step IV method by 2sls
ivregress 2sls lgdp (prot=logmort)
* correct standard error is .1478206 
* but two step with predictor provide a standard error of .1175696
* which is from "reg lgdp prothat, r" of second stage

* I- (vii) 
* Let's verify the statement first 
pwcorr euro lgdp
* correlation is .6556
pwcorr logmort euro
*correlation is -0.5240

* IV estimator from ivregress 2sls lgdp (prot=logmort)
* euro is omitted variables included in error, u
* E(z,u) is not equal to zero, z is logmort , u include euro
* E(logmort, euro) is not equal to zero
****************************************************************************************
* logmort and euro are negatively highly correlated: -0.5240
* Thus, we need to control for euro
* After control for euro, logmort is not correlated to omitted factors that affect lgdp


* I- (viii) 
* How to deal with the problem?
* By adding euro, conditional on euro logmort is not correlated to error (original error - euro)

* I- (ix) 
ivregress 2sls lgdp euro (prot=logmort)



log close
