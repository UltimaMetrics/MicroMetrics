clear
capture log close
set more off
//cd "/Users/uqfouyan/Dropbox/Teaching/UQ/financial econometrics/2019 ECON 7350/tutorials/tutorial 4"//
cd "E:\UQ\2019 S2\ECON7360 Micro Metrics\Tutorial\Tute11\

log using mytute11econ7360.log, replace

use loanapp.dta
* I-(i)
* This study investigate whether high % denial of loan application for black is due to race or other characteristics that are associated with race.

de
* If there exist discrimination against non-whilte, the coefficient on white should be positive and significant
* while if we can attribute observed difference in mortgate denial rate to other characteristics that are associate with race
* the coefficient on white should not be different from zero once we control the appropriate factors

* I-(ii)
* Linear probability model: dependent variable is probability 
* interpreting the coefficient estimate on white
reg approve white
*coef=0.2005957 with P-value=0
* being white increases the probability of approval by 20% compared to non-white
* The estimated probabilities of loan approval for white and nonwhite applicants.
* Rounded to three decimal places these are .708 for nonwhites and .908 for whites.
* the coefficient estimate on white is statistically significant and practically large.


* I- (iii) 
reg approve white hrat obrat loanprc unem male married dep sch cosign chist pubrec mortlat1 mortlat2 vr, r
* the coeff of white now becomes  0.1288 with P-value=0
* Not much has changed in terms of the sign and the signficance of the coefficient on white. It is reduced in magnitude, but still positive and statistically significant
* Therefore, even after controling for many observed variables, there is still very strong evidence of discrimination against nonwhites.


* I- (iv)
* Probit estimation that is equivalent to LPM estimation
probit approve white, r
*the probit coefficient is equal to 0.784 with P-value=0
*its almost 3 times the linear probabality estimate and they are both very statistically significant.
* Predicted probability of approval for white
predict p_white if white==1
* Predicted probability of approval for non-white
predict p_black if white==0

sum p*

* predicted probability change by race(marginal effect):
di .908-.708
* .200



* I- (v) 
probit approve white hrat obrat loanprc unem male married dep sch cosign chist pubrec mortlat1 mortlat2 vr
*probit coefficient=0.520 with P-value=0
* Not much has changed in terms of the sign and the signficance of the coefficient on white.
* Again, even after controling for many observed variables, there is still very strong evidence of discrimination against nonwhites.
* Predicted probability of approval for white
predict p_white_controls if white==1
* Predicted probability of approval for non-white
predict p_black_controls if white==0

su p*


* I- (vi) 

logit approve white
*coefficient=1.409 with P-value=0
*it is almost double the probit coefficient and they are both statistically significant

margins, dydx(white)
*the coefficient is 0.144
* being white increases the probability of approval by 14.4% compared to non-white.


 

* II- (i)
clear

use jtrain2.dta


de
tab train
* 185 received job training and 260 did not receive job training in the sample
tab mostrn
* 24 months

* II- (ii)
* we want to investigate of past unemployment on job training
* or to be precise the effect of past unemployment on the probability of getting the job training
reg train unem74 unem75 age educ black hisp married
*the effect of unemployment on job training is not statistically significant
test unem74 unem75 age educ black hisp married
* The F statistic for joint significance of the explanatory variables is F(7,437) = 1.43 with p-value = .19. 
* Therefore, they are jointly insignificant at even the 15% level.
* Note that, even though we have estimated a linear probability model, the null hypothesis we are testing is that all slope coefficients are zero, and so there is no heteroskedasticity under H0. 

* II- (iii)
probit train unem74 unem75 age educ black hisp married
*the probit coefficients are larger than the LPM ones
*the signs and the significance pattern is similar
*the only coefficient that is statistically significant is hispanic


* II- (iv)

*Training eligibility was randomly assigned among the participants, so it is not surprising that train appears to be independent of other observed factors (except of hisp).

* II- (v)
reg unem78 train
* Participating in the job training program lowers the estimated probability of being unemployed in 1978 by .111, or 11.1 percentage points with P-value=0.013.
* This is a large effect: the probability of being unemployed without participation is .354 (sum unem78 if train==0), and the training program reduces it to .243 (sum unem78 if train==1).
* The differences are statistically significant at almost the 1% level against at two-sided alternative.
predict p_train_LPM
tab p_train_LPM

* II- (vi)
probit unem78 train
*the probit coefficient is  -0.321 with P-value=0.012
predict p_train_prob
tab p_train_prob
* It does not make sense to compare the coefficient on train for the probit, -.321, with the LPM estimate. 
* The probabilities have different functional forms. However, note that the probit and LPM t-statistics are essentially the same.
* although the LPM standard errors should be made robust to heteroskedasticity.

*using the margins command:
margins, dydx(train)
*-0.111

*or alternatively you can find the marginal effects:
predict p_train if train==1
predict p_notrain if train==0
su p*
di .2432432-.3538462 
* -.110603
*these two methods give the same result


* II- (vii)
* There are only two fitted values in each case, and they are the same: .354 when train = 0 and .243 when train = 1. 
* the estimated fitted probabilities are the same.
*perfect correlation between the two
pwcorr p_train_prob p_train_LPM


* II- (viii)
probit unem78 train unem74 unem75 age educ black hisp married

predict p_train_probit if train==1
predict p_notrain_probit if train==0
su p*

* marginal effect 
di .2425413  -.3540803
* -.111539
* LPM -.1117028
* Interestingly, rounded to three decimal places, this is the same as the coefficient on train in the linear regression. 
* In other words, the linear probability model and probit give virtually the same estimated APE (average partial effect).
* The effect of the LPM should should be similar to the marginal effect of probit and logit.































