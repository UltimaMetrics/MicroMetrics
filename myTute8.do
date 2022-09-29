clear
capture log close
set more off
//cd "/Users/uqfouyan/Dropbox/Teaching/UQ/financial econometrics/2019 ECON 7350/tutorials/tutorial 4"//
cd "E:\UQ\2019 S2\ECON7360 Micro Metrics\Tutorial\Tute8\


log using mytute8.log, replace
use maimonides.dta

//A
de
drop classize_m fsc1 fsc

//B
sum classize, detail
sum avgmath,detail
sum avgverb,detail
sum perc_disadvantaged, detail
*you can do it one by one

//C
su
foreach var in classize avgmath avgverb perc_disadvantaged {
su `var', detail
}

*or you can just use the command "foreach"
*this is convenient when you have many variables
*is saves a lot of space in the do file


//D
sort enrollment

by enrollment: egen classize_m=mean(classize)
scatter classize_m enrollment


//E
su avgverb

*  Variable |       Obs        Mean    Std. Dev.       Min        Max
*-------------+--------------------------------------------------------
*     avgverb |      2024    74.44549    8.077355       34.8    187.606


reg avgverb classize, r
reg avgverb classize perc_disadvantaged, r
reg avgverb classize perc_disadvantaged enrollment , r

//F
gen fsc1=0 if enrollment<41
replace fsc1=1 if enrollment>=41

reg avgverb fsc1 perc_disadvantaged if enrollment>20&enrollment<60, r
reg avgverb fsc1 perc_disadvantaged enrollment if enrollment>20&enrollment<60, r
*being in a small class increases ones performance in grammer

reg avgmath fsc1 perc_disadvantaged if enrollment>20&enrollment<60, r
reg avgmath fsc1 perc_disadvantaged enrollment if enrollment>20&enrollment<60, r
*being in a small class increases ones performance in math


********
//G
gen fsc=enrollment/(int((enrollment-1)/40)+1)
di 40/(int((40-1)/40)+1)
di 41/(int((41-1_/40)+1)
di 60/(int((60-1)/40)+1)
di 150/(int((151-1)/40)+1)

*This captures the fact that MaimonidesÕ rule allows enrollment cohorts of 1Ð40 to be
*grouped in a single class, but enrollment cohorts of 41Ð80 are split
* into two classes of average size 20.5Ð40, enrollment cohorts of
*81Ð120 are split into three classes of average size 27Ð40, and so on.
*Although fsc is fixed within schools, in practice enrollment cohorts are not necessarily 
*divided into classes of equal size. In schools with two classes per grade, for example, only about
*one-quarter of the classes are of equal size.


//H
reg avgverb fsc perc_disadvantaged, r
reg avgverb fsc perc_disadvantaged enrollment, r

reg avgmath fsc perc_disadvantaged, r
reg avgmath fsc perc_disadvantaged enrollment, r


g enrollment2=(enrollment^2)/100


//I
ivregress 2sls avgverb (classize= fsc) perc_disadvantaged enrollment, r
ivregress 2sls avgverb (classize= fsc) perc_disadvantaged enrollment enrollment2, r

ivregress 2sls avgmath (classize= fsc) perc_disadvantaged enrollment, r
ivregress 2sls avgmath (classize= fsc) perc_disadvantaged enrollment enrollment2, r


//J

*repeat the exercise of this specific discontinuity sample: one IV, one endogenous variable 
ivregress 2sls avgverb (classize= fsc) perc_disadvantaged  if (enrollment>=36&enrollment<=45)|(enrollment>=76&enrollment<=85)|(enrollment>=116&enrollment<=125)|(enrollment>=156&enrollment<=165), r
*repeat the exercise of this specific discontinuity sample: two IVs, one endogenous variable 
ivregress 2sls avgverb (classize= fsc enrollment) perc_disadvantaged  if (enrollment>=36&enrollment<=45)|(enrollment>=76&enrollment<=85)|(enrollment>=116&enrollment<=125)|(enrollment>=156&enrollment<=165), r

*J: Fuzzy RDD around the discontinuities:
//Discontinuities:[36,456]; [76,85], [116,125];[156,165]
//IV1=fsc (exogenous rule associated with classize)
//IV2=enrollment (enrollment can be thought as exogenous and it's associated with classsize)

//K
*K

*Instrumental variables estimates constructed by using functions of MaimonidesÕ
*rule as instruments for class size while controlling for enrollment and pupil background consistently show a negative
*association between larger classes and student achievement.
*These effects are largest for the math than the reading scores

*Observational studies are often confounded by a failure to isolate a credible source of exogenous variation in school inputs (like class size). The
*regression-discontinuity research design overcomes these problems of confounding factors by exploiting exogenous variation that is originated in
*administrative rules. As in randomized trials like the STAR experiment, when this sort of exogenous variation is used to study
*class size, smaller classes appear beneficial.

*These reductions in the class size are beneficial for students, but clearly expensive to implement.


log close
