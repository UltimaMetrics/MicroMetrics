

clear
capture log close
set more off
//cd "/Users/uqfouyan/Dropbox/Teaching/UQ/financial econometrics/2019 ECON 7350/tutorials/tutorial 4"//
cd "E:\UQ\2019 S2\ECON7360 Micro Metrics\Tutorial\Tute10\


log using mytute10econ7360.log, replace

use PS1incomes.dta






describe

table year, c(mean hincome sd hincome)
table year, c(p10 hincome p25 hincome p5 hincome p75 hincome p90 hincome)


*(ii)
*OLS estimate:
reg hincome educ exper expersq
*Qauntile estimates:
qreg hincome educ exper expersq, quantile(.1)
qreg hincome educ exper expersq, quantile(.25)
qreg hincome educ exper expersq, quantile(.50)
qreg hincome educ exper expersq, quantile(.75)
qreg hincome educ exper expersq, quantile(.9)


*(iii)
reg hincome educ exper expersq if year==1996
reg hincome educ exper expersq if year==1999
reg hincome educ exper expersq if year==2002
reg hincome educ exper expersq if year==2005
*The coeffiect of education is higher over time, so the returns to education are not constant over time.
*Education has a higher impact on income over time.

*(iv)
// robust standard errors is year is 1996
reg hincome educ exper expersq if year==1996
qreg hincome educ exper expersq if year==1996, quantile(.25)
qreg hincome educ exper expersq if year==1996, quantile(.50)
qreg hincome educ exper expersq if year==1996, quantile(.75)
qreg hincome educ exper expersq if year==1996, quantile(.90)

//bootstrapped standard errors with 10 repetition

reg hincome educ exper expersq if year==1996
bsqreg hincome educ exper expersq if year==1996, quantile(.25)
bsqreg hincome educ exper expersq if year==1996, quantile(.50)
bsqreg hincome educ exper expersq if year==1996, quantile(.75)
bsqreg hincome educ exper expersq if year==1996, quantile(.90)

// robust standard errors if year is 2005
reg hincome educ exper expersq if year==2005
qreg hincome educ exper expersq if year==2005, quantile(.25)
qreg hincome educ exper expersq if year==2005, quantile(.50)
qreg hincome educ exper expersq if year==2005, quantile(.75)
qreg hincome educ exper expersq if year==2005, quantile(.90)


*No the increase in the coefficients is not similar for different quantiles.
*The increase in the coefficient of education is massive for the highest quintiles.

*(v)

table year, c(p10 hincome p25 hincome p5 hincome p75 hincome p90 hincome)
*Income inequality in increasing


*exercise 2
clear all
use STAR_public_use.dta


*(i)

//Treatment group 1(SSP): Get the offer of support servies:
//-Advisor
//-Facilited study group

//-Treatment group 1(SSP): Get the offer of cash award incentives
//-Treatment group 2(SFP): Get the offer of cash awar incentives
//-Control group: eligible to be treated but untreated

*Note that the treated individuals were offered support and/or incentives

*i) prob of signing up for the STAR progarm(Signup)
*ii) prob of receiving SSP (used SSP)
*iii)prob of meeting/emailing the advisor (used_adv)
*iv) prob of attending and FSG meeting (used_fsg)
//FSG are class-specific sessions designed to improve students study habits

reg signup ssp sfp sfsp  
reg used_ssp ssp sfp sfsp  
reg used_adv ssp sfp sfsp  
reg used_fsg ssp sfp sfsp  

*(ii)

reg signup ssp sfp sfsp  if sex=="F"
reg signup ssp sfp sfsp  if sex=="M"

*girls are more likely to sign up for STAR

reg used_ssp ssp sfp sfsp  if sex=="F"
reg used_ssp ssp sfp sfsp  if sex=="M"
*girls are more likely to receive SSP services 


reg used_adv ssp sfp sfsp  if sex=="F"
reg used_adv ssp sfp sfsp  if sex=="M"
*girls are more likely to meet with or email an advisor

reg used_fsg ssp sfp sfsp  if sex=="F"
reg used_fsg ssp sfp sfsp  if sex=="M"
*girls are more likely to attend FSGs


*(iii)
*effect of the treatments on fall grade
reg grade_20059_fall ssp sfp sfsp 
reg grade_20059_fall ssp sfp sfsp   if sex=="F"
reg grade_20059_fall ssp sfp sfsp  if sex=="M"

*effect of the treatments on year gpa
reg GPA_year1 ssp sfp sfsp 
reg GPA_year1 ssp sfp sfsp   if sex=="F"
reg GPA_year1 ssp sfp sfsp  if sex=="M"

*(iv)

gen id=_n

* STACK THE DATA
reshape long GPA_year, i(id) j(year)

*(v)
reg GPA_year ssp sfp sfsp 
qreg GPA_year ssp sfp sfsp, quantile(0.10)
qreg GPA_year ssp sfp sfsp, quantile(0.25)
qreg GPA_year ssp sfp sfsp, quantile(0.50)
qreg GPA_year ssp sfp sfsp, quantile(0.75)
qreg GPA_year ssp sfp sfsp, quantile(0.90)
*no statistically significant effect on gpa scores

*(vi)

reg GPA_year ssp sfp sfsp if sex=="F"
qreg GPA_year ssp sfp sfsp if sex=="F", quantile(0.10)
qreg GPA_year ssp sfp sfsp if sex=="F", quantile(0.25)
qreg GPA_year ssp sfp sfsp if sex=="F", quantile(0.50)
qreg GPA_year ssp sfp sfsp if sex=="F", quantile(0.75)
qreg GPA_year ssp sfp sfsp if sex=="F", quantile(0.90)


reg GPA_year ssp sfp sfsp if sex=="M"
qreg GPA_year ssp sfp sfsp if sex=="M", quantile(0.10)
qreg GPA_year ssp sfp sfsp if sex=="M", quantile(0.25)
qreg GPA_year ssp sfp sfsp if sex=="M", quantile(0.50)
qreg GPA_year ssp sfp sfsp if sex=="M", quantile(0.75)
qreg GPA_year ssp sfp sfsp if sex=="M", quantile(0.90)
*YES we find statistically significant effects for girls
*which are stronger at the lowest part of the distribution
*low achieving studnets gain more from the third treatment
gen id=_n

* STACK THE DATA
reshape long GPA_year, i(id) j(year)

*(v)
reg GPA_year ssp sfp sfsp 
qreg GPA_year ssp sfp sfsp, quantile(0.10)
qreg GPA_year ssp sfp sfsp, quantile(0.25)
qreg GPA_year ssp sfp sfsp, quantile(0.50)
qreg GPA_year ssp sfp sfsp, quantile(0.75)
qreg GPA_year ssp sfp sfsp, quantile(0.90)
*no statistically significant effect on gpa scores

*(vi)

reg GPA_year ssp sfp sfsp if sex=="F"
qreg GPA_year ssp sfp sfsp if sex=="F", quantile(0.10)
qreg GPA_year ssp sfp sfsp if sex=="F", quantile(0.25)
qreg GPA_year ssp sfp sfsp if sex=="F", quantile(0.50)
qreg GPA_year ssp sfp sfsp if sex=="F", quantile(0.75)
qreg GPA_year ssp sfp sfsp if sex=="F", quantile(0.90)


reg GPA_year ssp sfp sfsp if sex=="M"
qreg GPA_year ssp sfp sfsp if sex=="M", quantile(0.10)
qreg GPA_year ssp sfp sfsp if sex=="M", quantile(0.25)
qreg GPA_year ssp sfp sfsp if sex=="M", quantile(0.50)
qreg GPA_year ssp sfp sfsp if sex=="M", quantile(0.75)
qreg GPA_year ssp sfp sfsp if sex=="M", quantile(0.90)
*YES we find statistically significant effects for girls
*which are stronger at the lowest part of the distribution
*low achieving studnets gain more from the third treatment
