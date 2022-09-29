
clear
capture log close
set more off
//cd "/Users/uqfouyan/Dropbox/Teaching/UQ/financial econometrics/2019 ECON 7350/tutorials/tutorial 4"//
cd "E:\UQ\2019 S2\ECON7360 Micro Metrics\Tutorial\Tute7\

log using mytute7.log, replace

import delimited "E:\UQ\2019 S2\ECON7360 Micro Metrics\Tutorial\Tute7\psidw.csv", clear 
reshape long exper married female union educ blcak lwage, i(id) j(year)


*I-3
xtset id year
replace year=1976 if year==1
replace year=1977 if year==2
replace year=1978 if year==3
replace year=1979 if year==4

*I-4

gen exper2=exper^2
* Pooled OLS
reg lwage educ union married exper exper2 blcak female, vce(cluster id)

* Cross-section OLS
reg lwage educ union married exper exper2 blcak female if year==1976, vce(robust)
reg lwage educ union married exper exper2 blcak female if year==1977, vce(robust)
reg lwage educ union married exper exper2 blcak female if year==1978, vce(robust)
reg lwage educ union married exper exper2 blcak female if year==1979, vce(robust)

*I-5
* random effects estimator
xtreg lwage educ union married exper exper2 blcak female, re vce(cluster id)

* fixed effects estimator
xtreg lwage educ union married exper exper2 blcak female, fe vce(cluster id)

* with time fixed effects
* random effects estimator
xtreg lwage educ union married exper exper2 blcak female i.year, re vce(cluster id)

* fixed effects estimator
xtreg lwage educ union married exper exper2 blcak female i.year, fe vce(cluster id)

* I- (vi)
* fixed effects estimator: there are three distinct ways to implement FE estimation
areg lwage educ union married exper exper2 blcak female, absorb(id) vce(cluster id)
reg lwage educ union married exper exper2 blcak female i.id, vce(cluster id)
xtreg lwage educ union married exper exper2 blcak female, fe 

estimates store FE
* random effects estimator
xtreg lwage educ union married exper exper2 blcak female, re 
estimates store RE

* Importantly, you must list the models in the order "always consistent" first
* and "efficient under H0" second.

* Now Hausman test
hausman FE RE, sigmamore

* I- (vii)
* time-invariant unobserved factors, ci is perfectly correlated with black and female
* within transform or fixed effects take care of time-invariant effects both observed (black and female) 
* and unobserved, ci
* As we take care of time-invariant fixed effects, we can't only selectively take care of 
* unobserved factors


*****************************************************************************************
* Problem II: 
******************************************************************************************

use schautonomy1.dta, clear


* II- (i)
drop win_vote lose_vote lose_vote_2 win_vote_2
de
su
*passrate2: school performance after the change
*passrate0: schoo, performance before the change
*dpass is passrate2-passrate0
*vote: percentage of parents that voted in favour of GM schools
*win: if vote>50%-1; zero otherwise


*ii-(B)
reg dpass win, r

*replace vote=vote*100
//scatter dpass vote if vote>.15&vote<.85 || lfit dpass vote if vote>.15&vote < .50 || lfit dpass vote if vote>= .50&vote<.85 , legend(order(2 "vote < 50" 3 "vote >= 50"))

//scatter dpass vote if vote>.15&vote<.85 || qfit dpass vote if vote>.15&vote < .50 || qfit dpass vote if vote>= .50&vote<.85 , legend(order(2 "vote < 50" 3 "vote >= 50"))

************
* D

reg dpass win vote if vote>.15&vote<.85, r
*control for the distance from the threshold, dropping the two sides
*find the distance from the threshold from thoe who lost
*find the distance from the threshold for those who won 4.06
gen lose_vote=0 if win==1
replace lose_vote=-(vote-0.5) if win==0
*imagine a scool got 0.40 vote, this school is not going to be a GM
*0.40 is below 0.50 so this school will not be converted toa GM
*lose_vote=0.10 for this school (the distance from cutoff)

gen win_vote=0 if win==0
replace win_vote=(vote-0.5) if win==1
*imagine a school got 0.60 votes. This school is going to become a GM
*0.60 is above 0.50 so this school will be converted to a GM school
*lose_win=0.10 for this school (the distance from cutoff)

gen lose_vote_2=lose_vote^2
gen win_vote_2=win_vote^2
*also inclde the 2nd order polynomaials.
reg dpass win lose_vote lose_vote_2 win_vote win_vote_2 if vote>.15&vote<.85, r


*E
*The covariates should not change discontinusouly around the cutoff -testable
*How?, draw the graphical representation for each covariate
*there should be no manipulation around the cutoff. Perform a mCCrary test.
*Draw the density of the assignment variable and think!
*No misallocation of treatment of override of cutoff

*F
* F
*replace vote=vote/100
scatter dpass vote if vote>.15&vote<.85 || qfit dpass lose_vote_2 if vote>.15&vote < .50 || qfit dpass win_vote_2 if vote>= .50&vote<.85 , legend(order(2 "vote < 50" 3 "vote >= 50"))

*G
reg passrate2 win lose_vote lose_vote_2 win_vote win_vote_2 if vote>.15&vote<.85, r



*I
reg passrate0 win lose_vote lose_vote_2 win_vote win_vote_2 if vote>.15&vote<.85, r

*Yes, it has negative sign now
*at lest is is not statiticaly sign

*If it was sign that would be problematic
*This is like we are comparing the performance of school before the ballot 
*There have been stat sign differences in the passrate for teh school
*This would imply some covariates might not change continuously around cutt-off


log close
