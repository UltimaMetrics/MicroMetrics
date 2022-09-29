***********************************************************
* Tutorial 10
* Instructor: Rigissa Megalokonomou
* The University of Queensland
****************

clear all

use "/Users/rigissa/Downloads/PS1incomes.dta"

describe

table year, c(mean hincome sd hincome)
table year, c(p10 hincome p25 hincome p5 hincome p75 hincome p90 hincome)


*(ii)
*OLS estimate:
reg hincome educ exper expersq,r
*Qauntile estimates:
qreg hincome educ exper expersq, quantile(.1) vce(robust)
qreg hincome educ exper expersq, quantile(.25) vce(robust)
qreg hincome educ exper expersq, quantile(.50) vce(robust)
qreg hincome educ exper expersq, quantile(.75) vce(robust)
qreg hincome educ exper expersq, quantile(.9) vce(robust)


*(iii)
reg hincome educ exper expersq if year==1996,r
reg hincome educ exper expersq if year==1999,r 
reg hincome educ exper expersq if year==2002,r
reg hincome educ exper expersq if year==2005,r
*The coeffiect of education is higher over time, so the returns to education are not constant over time.
*Education has a higher impact on income over time.


*(iv)
****
*robust standard errors
reg hincome educ exper expersq if year==1996,r
qreg hincome educ exper expersq if year==1996, quantile(.25) vce(robust)
qreg hincome educ exper expersq if year==1996, quantile(.50) vce(robust)
qreg hincome educ exper expersq if year==1996, quantile(.75) vce(robust)
qreg hincome educ exper expersq if year==1996, quantile(.90) vce(robust)

***
*bootstrapped standard errors with 10 repetitions
bsqreg hincome educ exper expersq if year==1996, quantile(.25) reps(10)
bsqreg hincome educ exper expersq if year==1996, quantile(.50) reps(10)
bsqreg hincome educ exper expersq if year==1996, quantile(.75) reps(10)
bsqreg hincome educ exper expersq if year==1996, quantile(.90) reps(10)

*****
*robust standard errors
reg hincome educ exper expersq if year==2005,r
qreg hincome educ exper expersq if year==2005, quantile(.25) vce(robust)
qreg hincome educ exper expersq if year==2005, quantile(.50) vce(robust)
qreg hincome educ exper expersq if year==2005, quantile(.75) vce(robust)
qreg hincome educ exper expersq if year==2005, quantile(.90) vce(robust)

****
*bootstrapped standard errors with 10 repetitions
bsqreg hincome educ exper expersq if year==2005, quantile(.25) reps(10)
bsqreg hincome educ exper expersq if year==2005, quantile(.50) reps(10)
bsqreg hincome educ exper expersq if year==2005, quantile(.75) reps(10)
bsqreg hincome educ exper expersq if year==2005, quantile(.90) reps(10)


*No the increase in the coefficients is not similar for different quantiles.
*The increase in the coefficient of education is massive for the highest quintiles.

*(v)
*Income inequality in increasing



*exercise 2
clear all
use "/Users/rigissa/Downloads/STARdatapost/STAR_public_use.dta"


*(i)
reg signup ssp sfp sfsp  
reg used_ssp ssp sfp sfsp 
reg used_adv ssp sfp sfsp 
reg used_fsg ssp sfp sfsp  

*(ii)

reg signup ssp sfp sfsp  if sex=="F",r
reg signup ssp sfp sfsp  if sex=="M",r

*girls are more likely to sign up for STAR

reg used_ssp ssp sfp sfsp  if sex=="F",r
reg used_ssp ssp sfp sfsp  if sex=="M",r
*girls are more likely to receive SSP services 


reg used_adv ssp sfp sfsp  if sex=="F",r
reg used_adv ssp sfp sfsp  if sex=="M",r
*girls are more likely to meet with or email an advisor

reg used_fsg ssp sfp sfsp  if sex=="F",r
reg used_fsg ssp sfp sfsp  if sex=="M",r
*girls are more likely to attend FSGs


*(iii)
*effect of the treatments on fall grade
reg grade_20059_fall ssp sfp sfsp,r 
reg grade_20059_fall ssp sfp sfsp if sex=="F",r
reg grade_20059_fall ssp sfp sfsp if sex=="M",r

*effect of the treatments on year gpa
reg GPA_year1 ssp sfp sfsp,r 
reg GPA_year1 ssp sfp sfsp if sex=="F",r
reg GPA_year1 ssp sfp sfsp if sex=="M",r

*(iv)
*counts the number of observations
gen id=_n

* STACK THE DATA
*change the format
reshape long GPA_year, i(id) j(year)

*(v)
reg GPA_year ssp sfp sfsp, r
qreg GPA_year ssp sfp sfsp, quantile(0.10) vce(robust)
qreg GPA_year ssp sfp sfsp, quantile(0.25) vce(robust)
qreg GPA_year ssp sfp sfsp, quantile(0.50) vce(robust)
qreg GPA_year ssp sfp sfsp, quantile(0.75) vce(robust)
qreg GPA_year ssp sfp sfsp, quantile(0.90) vce(robust)
*no statistically significant effect on gpa scores

*(vi)

reg GPA_year ssp sfp sfsp if sex=="F"
qreg GPA_year ssp sfp sfsp if sex=="F", quantile(0.10) vce(robust)
qreg GPA_year ssp sfp sfsp if sex=="F", quantile(0.25) vce(robust)
qreg GPA_year ssp sfp sfsp if sex=="F", quantile(0.50) vce(robust)
qreg GPA_year ssp sfp sfsp if sex=="F", quantile(0.75) vce(robust)
qreg GPA_year ssp sfp sfsp if sex=="F", quantile(0.90) vce(robust)


reg GPA_year ssp sfp sfsp if sex=="M"
qreg GPA_year ssp sfp sfsp if sex=="M", quantile(0.10) vce(robust)
qreg GPA_year ssp sfp sfsp if sex=="M", quantile(0.25) vce(robust)
qreg GPA_year ssp sfp sfsp if sex=="M", quantile(0.50) vce(robust)
qreg GPA_year ssp sfp sfsp if sex=="M", quantile(0.75) vce(robust)
qreg GPA_year ssp sfp sfsp if sex=="M", quantile(0.90) vce(robust)
*YES we find statistically significant effects for girls
*which are stronger at the lowest part of the distribution
*low achieving studnets gain more from the third treatment
