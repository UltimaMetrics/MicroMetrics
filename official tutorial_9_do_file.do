***********************************************************
* Tutorial 9: PSM
* Instructor: Rigissa Megalokonomou
* The University of Queensland
****************

*(1)
use "E:\dropbox\Dropbox\teaching\3360\PSM\nsw.dta", clear
de

*(2) 
findit psmatch2
ssc install psmatch2

*(3)
tab sample
* 1 is experimental data and 3 is PSID data (non-experimental survey data)
tab treated
tab treated, su(age) means
* age is similar in both treatment group and control group
tab treated, su(educ) means
tab treated, su(black) means
tab treated, su(married) means
tab treated, su(nodegree) means
tab treated, su(hisp) means
tab treated, su(re75) means

* If this is a randomized experiment, we would expect to observe minimal 
* difference between the variables in the treatment and control group.

*(4) Perform t-test for difference in means
* t-test
ttest age, by(treated)
ttest black, by(treated)
ttest hisp, by(treated)
ttest married, by(treated)
ttest educ, by(treated)
ttest nodegree, by(treated)
ttest re75, by(treated)

* there is evidence of a statistically significant difference between 
* average qualifications (nodegree) of treatment group and control groups.
**************************************************************************************************
* Alternatively, we could use probit estimation (more details about this in next week's tutorial)
* probit treated age black hisp married educ nodegree re75 if sample==1

* Result
* probit treated age black hisp married educ nodegree re75 if sample==1
*
*Iteration 0:   log likelihood = -489.04581  
*Iteration 1:   log likelihood = -485.12973  
*Iteration 2:   log likelihood = -485.12965  
*Iteration 3:   log likelihood = -485.12965  
*
*Probit regression                               Number of obs     =        722
*                                                LR chi2(7)        =       7.83
*                                                Prob > chi2       =     0.3476
*Log likelihood = -485.12965                     Pseudo R2         =     0.0080
*
*------------------------------------------------------------------------------
*     treated |      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
*-------------+----------------------------------------------------------------
*         age |  -.0010223   .0074943    -0.14   0.891     -.015711    .0136663
*       black |  -.0608169   .1642376    -0.37   0.711    -.3827166    .2610828
*        hisp |  -.1557623   .2156858    -0.72   0.470    -.5784987    .2669742
*     married |   .0573417   .1341806     0.43   0.669    -.2056474    .3203308
*        educ |  -.0145797   .0369557    -0.39   0.693    -.0870116    .0578522
*    nodegree |   -.329541    .152014    -2.17   0.030     -.627483    -.031599
*        re75 |  -1.80e-06   9.59e-06    -0.19   0.851    -.0000206     .000017
*       _cons |   .2674323   .5340568     0.50   0.617    -.7792999    1.314164
*------------------------------------------------------------------------------

* If this is a randomized experiment, all coefficients should be insignificant
* single parameter test shows that nodegree is correlated with treated
* we may consider that conditional independence. 
* There is evidence that person with degree is more likely to be assigned to program

* joint test
*test age black hisp married educ nodegree re75
* we cannot reject the null that all coefficients are zero as p-value is 0.35
******************************************************************************************************



* (5) Experimental Estimates using OLS
reg re78 treated, r
* participating in the program increases real earnings in 1978 by $886.

reg re78 treated age educ black hisp married nodegree re75, r
* After conditioning on the control variables, participating in the program 
* is expexted to increase real earnings in 1978 by $806.
* Difference of the estimates:
* (886.3-806.5)=79.8

* Both estimates are weakly significant (significance level of 0.1), not significant at significance level 0.05
* S.E. decreases with more controls: from 488 to 485
* Thus, even in experimental data, we want to include controls

g age2=age^2
reg re78 treated age educ black hisp married nodegree re75 age2, r

* (6) Perform t-test for differences in means in matching
* PSID is survey data
tab sample
* compare the mean
gen nsw=1 if sample==1
replace nsw=0 if sample==3
* controls: age educ black hisp married nodegree re75

ttest age, by(nsw)
ttest educ, by(nsw)
ttest black, by(nsw)
ttest hisp, by(nsw)
ttest married, by(nsw)
ttest nodegree, by(nsw)
ttest re75, by(nsw)

* In all included variables t-stat are highly statistically significant

* (7) 
* re75 is the pre-treatment characteristics 

reg re75 nsw,r
reg re75 nsw age educ black hisp married nodegree re74,r

* After controlling for the control characteristics, the coefficient of nsw
* is still significant which indicates that the differences between the two samples are still
* significant after controlling for all these observed variables. 

****************************************************************************************
* Propensity score matching approach
*****************************************************************************************



* (ix) 
* Firstly, we want to drop the experimental control group
* We seek to compare the experimental treatment group with those in the PISD sample.

gen treat=0 if sample==3
replace treat=1 if sample==1&treated==1

rename age2 agesq
reg re78 treat age agesq educ black hisp married nodegree re74 re75, r 
* The coefficient of treatment is negative -1112 and (marginally) insignificant.


* Mechanism of propensity score matching (PSM)

* (i) probit estimation to aquire score
* (ii) saved prediction to get pr=(D=1/x) and we can calculate the marginal effects 
* and also draw graph
* (iii)"psmatch2"--to match treated/untreated 
* caliper/neighbouhood 
* kernel density 
* in the end, evaluate the quality of matching


* To acquire the propensity scores 
 
probit treat age black hisp married nodegree educ re75
predict double score
margins, dydx(*)

* Graph
* psgraph graph the propensity score histogram by treatment status 
psgraph, treated (treat) pscore(score) bin(100) saving(psm2a, replace)
* for control group, there exists a largest density around p=0


* Now for the matching
psmatch2 treat, pscore(score) outcome(re78) caliper(0.01)
* bandwidth of common support is 0.01

*(x)

* Now for the matching
psmatch2 treat, pscore(score) outcome(re78) caliper(0.01)
* bandwidth of common support is 0.01
* as it becomes smaller, bandwidth for strata(common support) is narrowing down
psmatch2 treat, pscore(score) outcome(re78) caliper(0.005)
* To satisfy common support assumption, we need to increase caliper 0.03
psmatch2 treat, pscore(score) outcome(re78) caliper(0.025)
*results change a lot
*this method is not robust to using diffeerent calipers


* (xi)
* Nearest Neighbours PSM on common support
psmatch2 treat, pscore(score) outcome(re78) neighbor(1)

* (xii)
*nearest neighbor gives similar results to caliper method when no treated observation is dropped


* (xiii)

* With common support assumption and PSM method
psmatch2 treat, pscore(score) outcome(re78) caliper(0.025)
reg re78 treat age agesq educ black hisp married nodegree re74 re75 [fweight=_weight]
* The treatment effect is positive 630.3,  but insignificant with a s.d of 527.36.

* Compare to previous OLS regression with experimental sample 
reg re78 treated age agesq educ black hisp married nodegree re74 re75, r
* The treatment effect is 818.7 and only significant at 10% level.

* With non-experimental data (PSID survey data)
reg re78 nsw age agesq educ black hisp married nodegree re74 re75, r
* the sign is negative -2178 and significant at 1% level. 




* (xiv)

* Quality of matching

pstest age black educ hisp nodegree married re75, sum

* no t-test rejects common means between treatment and control groups.
pstest age black educ hisp nodegree married re75, graph

* see how the dot represent re75 close to the middle (0 bias) 


reg re75 treat age educ black hisp married nodegree re74,r
 
 *it is more balanced now that the treatment group is done using propensity score matching methods

* (xv)

* Kernel Method 

psmatch2 treat, pscore(score) outcome(re78) kernel k(normal) bw(0.01)


