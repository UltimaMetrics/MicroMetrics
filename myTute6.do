clear
capture log close
set more off
//cd "/Users/uqfouyan/Dropbox/Teaching/UQ/financial econometrics/2019 ECON 7350/tutorials/tutorial 4"//
cd "E:\UQ\2019 S2\ECON7360 Micro Metrics\Tutorial\Tute6\


log using mytute6.log, replace
use murder.dta


de
* I-(i)
* If there is a deterrent effect then beta1<0. The sign of beta2 is 
*not entirely obvious. One possible answer is that a better economy (low unemployment) 
* means less crime in general. This would imply beta2>0

* I-(ii)
reg mrdrte d93 exec unem if year==90|year==93

* I- (iii)
xtset id year
* help xtset
xtreg mrdrte d93 exec unem if year==90|year==93, fe
* help xtreg

* There is statistically significant deterrent effect: 10 more executions is 
*estimated to reduce the murder rate by 1.04, or one murder per 100,000 people
* In 1993, the average murder rate was about 8.7; a reduction 
*of one would be nontrivial.

*Better tha OLS because FE model control for state specific differences


* I- (iv) 
keep if year==90|year==93
replace year=1 if year==90
replace year=2 if year==93

xtset id year //checking the new dimension of the panel
reg D.(mrdrte d93 exec unem), nocon //no constant

reg D.(mrdrte d93 exec unem), nocon


* I- (v) 
* IV regression by 2SLS method
sort state
by state: sum exec if year==2
tab exec state if year==2

* texas 34 executions, the next largest state is VA which had 11 executions
xtset id year


* I- (vi) 
reg D.(mrdrte d93 exec unem) if state!="TX", nocon //drop Texas
reg D.(mrdrte d93 exec unem) if state!="TX", r nocon

* There is no evidence of a deterrent effect as the coefficients on exec 
*are insiginificant in both usual standard error and robust standard error.

* I- (vii) 
cscript
* This command `cscript' deletes local, variables, macro

use "murder.dta", clear  

replace year=1 if year==87
replace year=2 if year==90
replace year=3 if year==93

xtset id year
xtreg mrdrte d90 d93 exec unem, fe vce(robust)

use starwide.dta, clear

de

* II- (i)
*cumulative number of years in a small class
gen small_sum0=small0
egen small_sum1=rowtotal(small0 small1)
egen small_sum2=rowtotal(small0 small1 small2)
egen small_sum3=rowtotal(small0 small1 small2 small3)

*Cumulative number of years in a aide classroom
gen aide_sum0=aide0
egen aide_sum1=rowtotal(aide0 aide1)
egen aide_sum2=rowtotal(aide0 aide1 aide2)
egen aide_sum3=rowtotal(aide0 aide1 aide2 aide3)
*********************
* initial year appear in the sample 
gen ini_yr=0
replace ini_yr=1 if small0!=.

replace ini_yr=2 if small0==.&small1!=.
replace ini_yr=3 if small0==.&small1==.&small2!=.
replace ini_yr=4 if small0==.&small1==.&small2==.&small3!=.


* II- (ii)
reshape long small_sum aide_sum female wh_asn small regular aide frlunch inismall iniaide twhite tmaster tladder avesat schid tyears, i(stdntid) j(grade)

de

label variable grade "student grade 0-kinder, 1-1st grade, 2-2nd grade, 3-3rd grade"
label variable small "class type small"
label variable regular "class type regular"
label variable aide "class type regular with teacher aide(part time)"
label variable frlunch "free lunch status"
label variable inismall "initial assignment of class type small"
label variable iniaide "initial assignment of class type regular class with aide"
label variable twhite "teacher race =white"
label variable tmaster "teacher's highest degree, dummy=1 if master or above 0 otherwise"
label variable tladder "teacher career ladder level"
label variable avesat "SAT score, average over three subjects"


* II- (iii)

xtset stdntid grade

* II- (iv)
kdensity avesat if small==1&grade==0, lwidth(thick) addplot(kdensity avesat if regular==1&grade==0, lwidth(thick) ) legend(label(1 "small") label(2 "regular"))
kdensity avesat if small==1&grade==1, lwidth(thick) addplot(kdensity avesat if regular==1&grade==1, lwidth(thick) ) legend(label(1 "small") label(2 "regular")) 
kdensity avesat if small==1&grade==2, lwidth(thick) addplot(kdensity avesat if regular==1&grade==2, lwidth(thick) ) legend(label(1 "small") label(2 "regular")) 
kdensity avesat if small==1&grade==3, lwidth(thick) addplot(kdensity avesat if regular==1&grade==3, lwidth(thick) ) legend(label(1 "small") label(2 "regular"))












log close
