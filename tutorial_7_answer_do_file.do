***********************************************************
* Tutorial session 7: Stata Applications of Panel Data Method I 
* Instructor: Rigissa Megalokonomou
* The University of Queensland
***********************************************************

*****************************************************
* Problem I: Construction of Panel Data
*****************************************************

cscript

* I- (i)
insheet using "C:\teaching\EC3360\prac\session4\psidw.csv"


de
* I- (ii)
*use reshape to convert it from wide to long
reshape long exper married female union educ blcak lwage, i(id) j(year)
* i(cross-section-dimension) j(time-dimension)


* I- (iii)
*define panel data
xtset id year
replace year=1976 if year==1
replace year=1977 if year==2
replace year=1978 if year==3
replace year=1979 if year==4

* I- (iv)
*construct experience square 
gen exper2=exper^2
* Use a pooled OLS, which is simply an OLS pooled for some years.
reg lwage educ union married exper exper2 blcak female, vce(cluster id)

* Cross-section OLS
*cross-section regressions for each year separately:
reg lwage educ union married exper exper2 blcak female if year==1976, vce(robust)
reg lwage educ union married exper exper2 blcak female if year==1977, vce(robust)
reg lwage educ union married exper exper2 blcak female if year==1978, vce(robust)
reg lwage educ union married exper exper2 blcak female if year==1979, vce(robust)

* I- (v)

** without time fixed effects

* random effects estimator
xtreg lwage educ union married exper exper2 blcak female, re vce(cluster id)

* fixed effects estimator
xtreg lwage educ union married exper exper2 blcak female, fe vce(cluster id)

** with time fixed effects
* random effects estimator
xtreg lwage educ union married exper exper2 blcak female i.year, re vce(cluster id)

* fixed effects estimator
xtreg lwage educ union married exper exper2 blcak female i.year, fe vce(cluster id)


* I- (vi)
*fixed effects estimator
xtreg lwage educ union married exper exper2 blcak female, fe 
*store the fixed effects estimator
estimates store FE
* random effects estimator
xtreg lwage educ union married exper exper2 blcak female, re 
*store the random effects estimator
estimates store RE

* Now the Hausman test
hausman FE RE, sigmamore

*time-invariant unobserved factors, ci
* Test:  Ho:  E(Xitci)=0, or in other words difference in coefficients between RE and FE is not systematic
*                ---- Coefficients ----
*             |      (b)          (B)            (b-B)     sqrt(diag(V_b-V_B))
*             |       FE           RE         Difference          S.E.
*-------------+----------------------------------------------------------------
*       union |   -.0868517    -.0949164        .0080648        .0530075
*     married |   -.0101483     -.001731       -.0084173        .1209815
*       exper |    .1484721     .0675843        .0808878        .0191309
*      exper2 |   -.0010443    -.0009474       -.0000969        .0003529
*------------------------------------------------------------------------------

*                  chi2(4) = (b-B)'[(V_b-V_B)^(-1)](b-B)
*                          =       56.35
*                Prob>chi2 =      0.0000

*So we reject the null hypothesis. This means that E(Xitci) is different than 0 and thus we prefer the FE estimator.

* I- (vii)
* because the within or fixed effects model takes away the time-invariant variables (black and female) 
* remember how you produce the FE model: you substract the average value over time of each variable from the variable.
* so all time-invariant variables go away
* this is a annoying with FE





***************
* problem II
* REGRESSION DICSONTINUITY DESIGN
****************
* A
cscript
use "C:\teaching\EC3360\prac\prac10\schautonomy1.dta", clear
*please drop these, so that students produce them.
drop win_vote lose_vote lose_vote_2 win_vote_2

de
su

*passrate0  is the school performance before
*passrate2 is the school performance two years later

************
* B
reg dpass win, r
*replace vote=vote*100

*linear fit
scatter dpass vote if vote>.15&vote<.85 || lfit dpass vote if vote>.15&vote < .50 || lfit dpass vote if vote>= .50&vote<.85 ,xline(0)  legend(order(2 "vote < 50" 3 "vote >= 50"))
* quadratic fit
scatter dpass vote if vote>.15&vote<.85 || qfit dpass vote if vote>.15&vote < .50 || qfit dpass vote if vote>= .50&vote<.85 ,xline(0)  legend(order(2 "vote < 50" 3 "vote >= 50"))
*a general observation is that you see too many dots, because we have not used bins.
*if we group observations into bins the scatterplots will look a bit better


************
* C
*vote:vote share that expresses the percentage that voted in favor of GM schools

scatter dpass vote

*****************
*D

*control for the perentage of votes in favor of GM schools
reg dpass win vote if vote>.15&vote<.85, r
*control for the distance from the threshold.
*find the distance from the threshold for those who lost (
*find the distance from the threshold for those who won
*also include the 2nd order polynomials

g lose_vote=0 if win==1
replace lose_vote=-(vote-0.5) if win==0
*imagine a school got 0.40 votes. This school is not going to become a GM..
*0.40 is below 0.50 so this school will not be converted to a GM school
* lose_vote=-0.10 for this school (the distance from cutoff)


g win_vote=0 if win==0
replace win_vote=(vote-0.5) if win==1
*imagine a school got 0.60 votes. This school is  going to become a GM..
*0.60 is above 0.50 so this school will  be converted to a GM school
* lose_win=0.10 for this school (the distance from cutoff)


*we also include the 2nd order polynomials
g lose_vote_2=lose_vote^2
g win_vote_2=win_vote^2

reg dpass win lose_vote lose_vote_2 win_vote win_vote_2 if vote>.15&vote<.85, r

***************************


************
* E
* the covariates should not change discontineously around the cutoff-testable. How? draw the graphical representation for each covariate
* there should be no manipulation around the cutoff. Perform a McCrary test. Draw the density of the assignment variable and think!
* No Misallocation of Treatment or Overrides to the cutoff.

*******
*F

g lose_votee=0 if win==1
replace lose_votee=(vote-0.5) if win==0
g win_votee=0 if win==0
replace win_votee=(vote-0.5) if win==1
gen margin_vote=(vote-0.5)

scatter dpass margin_vote if vote>.15&vote<.85 || qfit dpass lose_votee if vote>.15&vote < .50 || qfit dpass win_votee if vote>= .50&vote<.85 ,  xline(0)  legend(order(2 "vote < 50" 3 "vote >= 50"))


*G
reg passrate2 win lose_vote lose_vote_2 win_vote win_vote_2 if vote>.15&vote<.85, r

* H
reg passrate2 win lose_vote lose_vote_2 win_vote win_vote_2 if vote>.15&vote<.85, r
*yes, it has a negative sign now
*at least it is not statistically significant

**********
* I
*replace the outcome with passrate0 instead of passrate2
reg passrate0 win lose_vote lose_vote_2 win_vote win_vote_2 if vote>.15&vote<.85, r
* again it is negative, but insignificant


* If it was significant that would be problematic.
* This is like we are comparing the performance of schools before the ballot and they were different from before.
* There have been statistically significant differences in the passrate for the schools at the left of cutoff at t=0 and that for for the schools at the right.
* ?his would imply some covariates might not change continuously arount cut-off. 




****************
*****************
