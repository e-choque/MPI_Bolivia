
foreach var in death uweight enrol_school edu_complet poor_new incsour worker pwork water toilet fuel {
gen `var'_miss=1 if `var'==.
replace `var'_miss=0 if `var'!=.

}

{ /* Defining indicators of EducationalDimension
scchool enrolment status*** 6-14 years */

keep if ro5 >5 & <15
recode ED4 (0=0) (1=1) (else=.), g (scho_enro)
reshape wide sch_enro, i(stateid distid psuid hhid hhsplitid) j( personid)


g enrol_school=.
	replace enrol_school=1 if  sch_enro1==1 | sch_enro2==1 | sch_enro3==1 | sch_enro4==1 | sch_enro5==1 | sch_enro6==1 | sch_enro7==1 | sch_enro8==1 | sch_enro9==1 | sch_enro10==1 | sch_enro11==1 | sch_enro12==1 | sch_enro13==1 | sch_enro14==1 | sch_enro15==1 | sch_enro16==1 | sch_enro17==1 | sch_enro18==1 | sch_enro19==1 | sch_enro20==1 | sch_enro21==1 | sch_enro22==1 | sch_enro23==1 | sch_enro24==1 | sch_enro25==1 | sch_enro26==1 | sch_enro27==1 | sch_enro28==1 | sch_enro29==1 | sch_enro37==1
	replace enrol_school=3 if  sch_enro1==. & sch_enro2==. & sch_enro3==. & sch_enro4==. & sch_enro5==. & sch_enro6==. & sch_enro7==. & sch_enro8==. & sch_enro9==. & sch_enro10==. & sch_enro11==. & sch_enro12==. & sch_enro13==. & sch_enro14==. & sch_enro15==. & sch_enro16==. & sch_enro17==. & sch_enro18==. & sch_enro19==. & sch_enro20==. & sch_enro21==. & sch_enro22==. & sch_enro23==. & sch_enro24==. & sch_enro25==. & sch_enro26==. & sch_enro27==. & sch_enro28==. & sch_enro29==. & sch_enro37==.
	replace enrol_school=0 if enrol_school==.
	replace enrol_school=. if enrol_school==3


****education completed***15 years and more

recode ed5 (0/4=0) (5/15=1) (else=.), g (ed) 
label variable ed "education completed five years"
label define ed 0 "Not completed" 1 "completed 5 yrs"

keep if ro5>14 

reshape wide ed, i(stateid distid psuid hhid hhsplitid) j( personid)

g edu_complet=.
	replace edu_complet=0 if ed1==1 | ed2==1 | ed3==1 | ed4==1 | ed5==1 | ed6==1 | ed7==1 | ed8==1 | ed9==1 | ed10==1 | ed11==1 | ed12==1 | ed13==1 | ed14==1 | ed15==1 | ed16==1 | ed17==1 | ed18==1 | ed19==1 | ed20==1 | ed21==1 | ed22==1 | ed23==1 | ed24==1 | ed25==1 | ed26==1 | ed27==1 | ed28==1 | ed30==1 | ed31==1 | ed35==1 | ed36==1
	replace edu_complet=3 if ed1==. & ed2==. & ed3==. & ed4==. & ed5==. & ed6==. & ed7==. & ed8==. & ed9==. & ed10==. & ed11==. & ed12==. & ed13==. & ed14==. & ed15==. & ed16==. & ed17==. & ed18==. & ed19==. & ed20==. & ed21==. & ed22==. & ed23==. & ed24==. & ed25==. & ed26==. & ed27==. & ed28==. & ed30==. & ed31==. & ed35==. & ed36==.
	replace edu_complet=1 if edu_complet==.
}

{ /* UNDER NUTRITION FOR EVER MARRIED WOMEN 15-49 YEARS */

keep if ro5>14 & ro5<50 & ro3==2 & mar_st==1 // EVER MARRIED WOMEN 15-49 YEARS OF AGE

g height_m=ap2/100 if ap2>1
label variable height_m "computed height in meters (ap2) for ever married women"
ta height_m

g bmi=ap4/(height_m*height_m) if ap4>1

recode bmi (1/18.49999=1 "Underweight") (18.5/max=0 "Not underweight"), g (bmi_status)
label variable bmi_status "BMI status of ever married women 15-49"

reshape wide bmi_status, i(stateid distid psuid hhid hhsplitid) j( personid)

g uweight=.    //uweight excludes the households not having ever married women (15-49) with anthropometry information
label variable uweight "bmi <18.5"
replace uweight=1 if bmi_status1==1 | bmi_status2==1 | bmi_status3==1 | bmi_status4==1 | bmi_status5==1 | bmi_status6==1 | bmi_status7==1 | bmi_status8==1 | bmi_status9==1 | bmi_status10==1 | bmi_status11==1 | bmi_status12==1 | bmi_status13==1 | bmi_status14==1 | bmi_status15==1 | bmi_status16==1 | bmi_status17==1 | bmi_status18==1 | bmi_status19==1 | bmi_status20==1 | bmi_status21==1 | bmi_status22==1 | bmi_status23==1 | bmi_status24==1 | bmi_status25==1 | bmi_status26==1 | bmi_status28==1 | bmi_status31==1 | bmi_status35==1
replace uweight=3 if bmi_status1==. & bmi_status2==. & bmi_status3==. & bmi_status4==. & bmi_status5==. & bmi_status6==. & bmi_status7==. & bmi_status8==. & bmi_status9==. & bmi_status10==. & bmi_status11==. & bmi_status12==. & bmi_status13==. & bmi_status14==. & bmi_status15==. & bmi_status16==. & bmi_status17==. & bmi_status18==. & bmi_status19==. & bmi_status20==. & bmi_status21==. & bmi_status22==. & bmi_status23==. & bmi_status24==. & bmi_status25==. & bmi_status26==. & bmi_status28==. & bmi_status31==. & bmi_status35==. 
replace uweight=0 if uweight==.
}
/* Income source poor define */
{
 /*lowpaid (classified households as low and high paid jobs according to the occupation (nf1) 
   lowpaid 1 = low paid occupation, 2= high paid occupation */
   
   label define lowpaid 1 "low paid occupation" 2 "Hig paid occupation"
   label value lowpaid lowpaid

   g lpd=.
   replace lpd=1 if lowpaid==1 & pci1<5000
   replace lpd=2 if lowpaid==1 & pci1>=5000
   replace lpd=3 if lowpaid==2 & pci1<5000
   replace lpd=4 if lowpaid==2 & pci1>=5000

   label variable lpd "grouping nonfarm business acording to pci"
   label define lpd 1 "lowpaid & <5000 pci" 2 "lowpaid & >=5000 pci" 3 "high paid & <5000 pci" 4 "high paid & >=5000 pci"
   label value lpd lpd

   recode  lpd (1 3=1) (2 4=0), g (lpdrec)
   label variable lpdrec "recode of lpd"
   label define lpdrec 1 "lowpaid jobs" 0 "high paid jobs"
   label value lpdrec lpdrec

   /* 8513    (8513 households are classified as poor by their occupation and income)

   other than non-farm business and cultivation(imputed income) */
   
   g lbr=.
   replace lbr=1 if hh_in==2 & pci1<5000 & lpdrec==.
   replace lbr=1 if hh_in==3 & lpdrec==.
   replace lbr=1 if hh_in==4 & lpdrec==.
   replace lbr=1 if hh_in==6 & pci1<5000 & lpdrec==.
   replace lbr=1 if hh_in==5 & pci1<5000 & lpdrec==.
   replace lbr=1 if hh_in==7 & pci1<5000 & lpdrec==.
   replace lbr=1 if hh_in==8 & pci1<5000 & lpdrec==.
   replace lbr=1 if hh_in==9 & pci1<5000 & lpdrec==.
   replace lbr=1 if hh_in==10 & pci1<5000 & lpdrec==.
   replace lbr=1 if hh_in==11 & pci1<5000 & lpdrec==.
   replace lbr=3 if hh_in==1 & lpdrec==.
   replace lbr=0 if lbr==. &  lpdrec==.
   replace lbr=. if lbr==3

   //24,292

   /*computing acre from local unit of land */
   g acre=fm4/fm2 if fm2>0.01

   g land=.
   replace land=acre if lbr==. & lpdrec==.
   recode land (0/2.5=1) (2.51/200=2), g (land_p)
   //8704
   //(8513+24292+8704=41509) remaining 45 households are not having information on any size of land holding 
   replace land_p=3 if pci1<5000 &  lpdrec==. & lbr==. & land_p==.  
   replace land_p=4 if pci1>=5000 & lpdrec==. & lbr==. & land_p==.

   recode land_p (1 3=1) (2 4=0), g (culti_poor)
   label variable culti_poor "cultivation poor"
   label define culti_poor 1 "cultivation poor" 0 "cultivation non-poor" 
   label value culti_poor culti_poor


   g incsour=.                                   //used in MPI construction
   replace incsour=1 if lpdrec==1
   replace incsour=1 if lbr==1
   replace incsour=1 if culti_poor==1
   replace incsour=0 if lpdrec==0
   replace incsour=0 if lbr==0
   replace incsour=0 if culti_poor==0
   }
 
  
{/* WORK AND EMPLOYMENT POOR */
reshape wide wkany, i( stateid distid psuid hhid hhsplitid) j( personid)
g wk_1559=.

replace wk_1559=1 if wkany1==1 | wkany2==1 | wkany3==1 | wkany4==1 | wkany5==1 | wkany6==1 | wkany7==1 | wkany8==1 | wkany9==1 | wkany10==1 | wkany11==1 | wkany12==1 | wkany13==1 | wkany14==1 | wkany15==1 | wkany16==1 | wkany17==1 | wkany18==1 | wkany19==1 | wkany20==1 | wkany21==1 | wkany22==1 | wkany23==1 | wkany24==1 | wkany25==1 | wkany26==1 | wkany27==1 | wkany28==1 | wkany30==1 | wkany31==1 | wkany35==1 | wkany36==1
replace wk_1559=0 if wk_1559==.

}
recode wa1 (1 2 3 5 9 10=0 "Improved water") (-1 4 6 7 8 11 80000=1 "non-improved water"), g (water)


{
egen n_missing1=rowmiss(death uweight enrol_school edu_complet poor_new incsour worker water toilet fuel)
label variable n_missing "Number of missing variables by individual"
gen missing=(n_missing>0)
label variable missing "Individual with missing variables"

}

{

foreach var in death uweight enrol_school edu_complet poor_new incsour worker water toilet fuel {
gen `var'_miss=1 if `var'==.
replace `var'_miss=0 if `var'!=.
}

{
g healthpoor=(death | uweight)
g edupoor=(enrol_school | edu_complet)
g workpoor=(incsour | worker)
g henvpoor=(water | toilet | fuel)


tab state_cat healthpoor [aw=sweight] if missing==0, r nofre
tab state_cat edupoor [aw=sweight] if missing==0, r nofre
tab state_cat poor_new [aw=sweight] if missing==0, r nofre
tab state_cat workpoor [aw=sweight] if missing==0, r nofre
tab state_cat henvpoor [aw=sweight] if missing==0, r nofre



}
foreach var of varlist  healthpoor edupoor workpoor henvpoor{
lab var `var' "Dimensinal poor"
}

g mpiwtscore=((1/5)*(1/2))*death+((1/5)*(1/2))*uweight+((1/5)*(1/2))*edu_complet+((1/5)*(1/2))*enrol_school+ ///
	((1/5)*(1/1))*poor_new+((1/5)*(1/2))*incsour+((1/5)*(1/2))*worker+((1/5)*(1/3))*water+ ///
	((1/5)*(1/3))*toilet+((1/5)*(1/3))*fuel
	
label var mpiwtscore "weighted deprivation score"
	
recode mpiwtscore (0/.33=0 "Non-poor") (0.33/max=1 "Mpoor"), g (mpoor)
lab var mpoor "multidimensional poor (k=0.33)"


g cnpersons=npersons*mpiwtscore if mpoor==1
lab var cnpersons "hh size * deprivation score"

tabstat npersons [aw=sweight] if missing==0, stat (sum) by (mpoor) format (%11.0g)
tabstat cnpersons if mpoor==1 [aw=sweight], stat (sum) format (%12.0g)



**#############################################################################
// MPI by states (rural and urban)
tabstat npersons [aw=sweight] if mpoor==1, stat (sum) by (stateid)  format (%11.0g)
tabstat npersons [aw=sweight] if missing==0, stat (sum) by (stateid) format (%12.0g)
tabstat cnpersons if mpoor==1 [aw=sweight], stat (sum) by (stateid) format (%12.0g)


bysort urban:tabstat npersons [aw=sweight] if mpoor==1, stat (sum) by (stateid) format (%12.0g)  //no of persons with c>0.33
bysort urban:tabstat npersons [aw=sweight] if missing==0, stat (sum) by (stateid) format (%12.0g)          // TOTAL PERSONS
bysort urban:tabstat cnpersons if mpoor==1 [aw=sweight], stat (sum) by (stateid) format (%12.0g)    //c*npersons where c is greater than 0.33


// MPI by regions of India
tabstat npersons if mpoor==1 [aw=sweight], stat (sum) by (region) format (%11.0g)
tabstat npersons [aw=sweight] if missing==0, stat (sum) by (region) format (%11.0g)
tabstat cnpersons if mpoor==1 [aw=sweight], stat (sum) by (region) format (%12.0g)

bysort urban:tabstat npersons if mpoor==1 [aw=sweight], stat (sum) by (region) format (%11.0g)
bysort urban:tabstat npersons [aw=sweight] if missing==0, stat (sum) by (region) format (%11.0g)
bysort urban:tabstat cnpersons if mpoor==1 [aw=sweight], stat (sum) by (region) format (%12.0g)

// MPI by age group

tabstat npersons if mpoor==1 [aw=sweight], stat (sum) by (age) format (%11.0g)
tabstat npersons [aw=sweight] if missing==0, stat (sum) by (age) format (%11.0g)
tabstat cnpersons if mpoor==1 [aw=sweight], stat (sum) by (age) format (%12.0g)

// MPI by Sex

tabstat npersons if mpoor==1 [aw=sweight], stat (sum) by (sex) format (%11.0g)
tabstat npersons [aw=sweight] if missing==0, stat (sum) by (sex) format (%11.0g)
tabstat cnpersons if mpoor==1 [aw=sweight], stat (sum) by (sex) format (%12.0g)


// MPI by caste groups

tabstat npersons if mpoor==1 [aw=sweight], stat (sum) by (caste) format (%11.0g)
tabstat npersons [aw=sweight] if missing==0, stat (sum) by (caste) format (%11.0g)
tabstat cnpersons if mpoor==1 [aw=sweight], stat (sum) by (caste) format (%12.0g)

// MPI by religion
 
tabstat npersons if mpoor==1 [aw=sweight], stat (sum) by (religion) format (%11.0g)
tabstat npersons [aw=sweight] if missing==0, stat (sum) by (religion) format (%11.0g)
tabstat cnpersons if mpoor==1 [aw=sweight], stat (sum) by (religion) format (%12.0g)


// MPI by type of household 

tabstat npersons if mpoor==1 [aw=sweight], stat (sum) by (hh_in) format (%11.0g)
tabstat npersons [aw=sweight] if missing==0, stat (sum) by (hh_in) format (%11.0g)
tabstat cnpersons if mpoor==1 [aw=sweight], stat (sum) by (hh_in) format (%11.0g)

// MPI by household assets

tabstat npersons if mpoor==1 [aw=sweight], stat (sum) by (assets) format (%11.0g)
tabstat npersons [aw=sweight] if missing==0, stat (sum) by (assets) format (%11.0g)
tabstat cnpersons if mpoor==1 [aw=sweight], stat (sum) by (assets) format (%12.0g)
}
* VALIDITY AND RELIABILITY  TEST OF MULTIDIMENSIONAL POOR 
*===========================================================

{//**** Alpha test of the indicators of MPI (K=0.33)

alpha death uweight  enrol_school edu_complet poor_new incsour worker water toilet fuel if missing==0, item
corre death uweight  enrol_school edu_complet poor_new incsour worker water toilet fuel if missing [aw=sweight]


/* Validity and reliablity of Multidimensional poverty (rural/urban, age, sex, caste, religion, years of schooling, 
mean consumption expenditure, income quintile, bpl card holders, ration card holders, LIC/Health insurance 
clasification of deprivation score by rural/urban */

tab urban mpiwtscore_cat [aw=sweight], r nofre
tab age_hh mpiwtscore_cat [aw=sweight], r nofre
tab sex mpiwtscore_cat [aw=sweight], r nofre
tab caste mpiwtscore_cat [aw=sweight], r nofre
tab religion mpiwtscore_cat [aw=sweight], r nofre
tab income_5 mpiwtscore_cat [aw=sweight], r nofre

tab hh_in mpoor_k35 [aw=sweight], r nofre
tab hh_in mpiwtscore_cat [aw=sweight], r nofre

tab mpoor_degree [aw=sweight], sum (hhed5adult)     //highest household adult (21+) education */
tab mpoor_degree [aw=sweight], sum (consumption)
tab mpoor_degree [aw=sweight], sum (hhassets)

tab bpl_card mpoor_degree [aw=sweight],col nofre 
tab lic mpoor_degree [aw=sweight],col nofre

tab urban mpoor_degree, chi2
tab age_hh mpoor_degree, chi2
tab sex mpoor_degree, chi2
tab caste mpoor_degree, chi2
tab religion mpoor_degree, chi2
tab income_5 mpoor_degree, chi2
tab hh_in mpoor_degree, chi2

ttest hhed5adult, by (mpoor)
ttest consumption, by (mpoor)
ttest hhassets, by (mpoor)

tab bpl_card mpiwtscore_cat,chi2  
tab lic mpiwtscore_cat,chi2


oneway consumption mpiwtscore
}


/* Decomposition of MPI by indicators ********* (censored headcount ratio)
_________________________________________________                          */
{
tabstat npersons if mpoor==1 & death==1 [aw=sweight], by (urban) stat(sum) format (%12.0g)
tabstat npersons if mpoor==1 & uweight==1 [aw=sweight], by (urban) stat(sum) format (%12.0g)
tabstat npersons if mpoor==1 & edu_complet==1 [aw=sweight], by (urban) stat(sum) format (%12.0g)
tabstat npersons if mpoor==1 & enrol_school==1 [aw=sweight], by (urban) stat(sum) format (%12.0g)
tabstat npersons if mpoor==1 & poor_new==1 [aw=sweight], by (urban) stat(sum) format (%12.0g)
tabstat npersons if mpoor==1 & worker==1 [aw=sweight], by (urban) stat(sum) format (%12.0g)
tabstat npersons if mpoor==1 & incsour==1 [aw=sweight], by (urban) stat(sum) format (%12.0g)
tabstat npersons if mpoor==1 & pwork==1 [aw=sweight], by (urban) stat(sum) format (%12.0g)
tabstat npersons if mpoor==1 & water==1 [aw=sweight], by (urban) stat(sum) format (%12.0g)
tabstat npersons if mpoor==1 & toilet==1 [aw=sweight], by (urban) stat(sum) format (%12.0g)
tabstat npersons if mpoor==1 & fuel==1 [aw=sweight], by (urban) stat(sum) format (%12.0g)

tabstat npersons if mpoor==1 & death==1 [aw=sweight], by (stateid) stat(sum) format (%12.0g)    // those who are multidimensionally poor and deprived in mortality indicator
tabstat npersons if mpoor==1 & underweight==1 [aw=sweight], by (stateid) stat(sum) format (%12.0g)
tabstat npersons if mpoor==1 & edu_complet==1 [aw=sweight], by (stateid) stat(sum) format (%12.0g)
tabstat npersons if mpoor==1 & enrol_school==1 [aw=sweight], by (stateid) stat(sum) format (%12.0g)
tabstat npersons if mpoor==1 & poor_new==1 [aw=sweight], by (stateid) stat(sum) format (%12.0g)
tabstat npersons if mpoor==1 & worker==1 [aw=sweight], by (stateid) stat(sum) format (%12.0g)
tabstat npersons if mpoor==1 & incsour==1 [aw=sweight], by (stateid) stat(sum) format (%12.0g)
tabstat npersons if mpoor==1 & pwork==1 [aw=sweight], by (stateid) stat(sum) format (%12.0g)
tabstat npersons if mpoor==1 & water_sour==1 [aw=sweight], by (stateid) stat(sum) format (%12.0g)
tabstat npersons if mpoor==1 & toilet==1 [aw=sweight], by (stateid) stat(sum) format (%12.0g)
tabstat npersons if mpoor==1 & fuel==1 aw=sweight], by (stateid) stat(sum) format (%12.0g)

tabstat npersons if mpoor==1 & death==1 [aw=sweight], by (region) stat(sum) format (%12.0g)  
tabstat npersons if mpoor==1 & uweight==1 [aw=sweight], by (region) stat(sum) format (%12.0g)
tabstat npersons if mpoor==1 & enrol_school==1 [aw=sweight], by (region) stat(sum) format (%12.0g)
tabstat npersons if mpoor==1 & edu_complet==1 [aw=sweight], by (region) stat(sum) format (%12.0g)
tabstat npersons if mpoor==1 & poor_new==1 [aw=sweight], by (region) stat(sum) format (%12.0g)
tabstat npersons if mpoor==1 & worker==1 [aw=sweight], by (region) stat(sum) format (%12.0g)
tabstat npersons if mpoor==1 & incsour==1 [aw=sweight], by (region) stat(sum) format (%12.0g)
tabstat npersons if mpoor==1 & water==1 [aw=sweight], by (region) stat(sum) format (%12.0g)
tabstat npersons if mpoor==1 & toilet==1 [aw=sweight], by (region) stat(sum) format (%12.0g)
tabstat npersons if mpoor==1 & fuel==1 [aw=sweight], by (region) stat(sum) format (%12.0g)


}

/* Decomposition by dimensions
__________________________________________*/

{

correlate death uweight enrol_school edu_complet poor_new incsour worker water toilet fue [aw=sweight] if missing==0, sig // gives p value
correlate death uweight enrol_school edu_complet poor_new incsour worker water toilet fue [aw=sweight] if missing==0, sig print(0.05) // 
correlate death uweight enrol_school edu_complet poor_new incsour worker water toilet fue [aw=sweight] if missing==0, sig star(0.05)
alpha death uweight enrol_school edu_complet poor_new incsour worker water toilet fue if missing==0, item 

recode mpiwtscore (0/.1=0 "non-poor") (.1/max=1 "Poor"), g(mpoor_1)
recode mpiwtscore (0/.2=0 "non-poor") (.2/max=1 "Poor"), g(mpoor_2)
recode mpiwtscore (0/.4=0 "non-poor") (.4/max=1 "Poor"), g(mpoor_4)
recode mpiwtscore (0/.5=0 "non-poor") (.5/max=1 "Poor"), g(mpoor_5)
recode mpiwtscore (0/.6=0 "non-poor") (.6/max=1 "Poor"), g(mpoor_6)
recode mpiwtscore (0/.7=0 "non-poor") (.7/max=1 "Poor"), g(mpoor_7)
recode mpiwtscore (0/.8=0 "non-poor") (.8/max=1 "Poor"), g(mpoor_8)
recode mpiwtscore (0/0.5=0 "non-poor") (0.5/max=1 "Poor"), g(mpoor_p5)

tabstat npersons [aw=sweight] if mpoor_6==1, stat (sum) by (state_cat)  format (%11.0g)
tabstat npersons [aw=sweight] if missing==0, stat (sum) by (state_cat) format (%12.0g)
tabstat cnpersons if mpoor_6==1 [aw=sweight], stat (sum) by (state_cat) format (%12.0g)

tabstat npersons [aw=sweight] if mpoor_7==1, stat (sum) by (state_cat)  format (%11.0g)
tabstat npersons [aw=sweight] if missing==0, stat (sum) by (state_cat) format (%12.0g)
tabstat cnpersons if mpoor_7==1 [aw=sweight], stat (sum) by (state_cat) format (%12.0g)

tabstat npersons [aw=sweight] if mpoor_8==1, stat (sum) by (state_cat)  format (%11.0g)
tabstat npersons [aw=sweight] if missing==0, stat (sum) by (state_cat) format (%12.0g)
tabstat cnpersons if mpoor_8==1 [aw=sweight], stat (sum) by (state_cat) format (%12.0g)

tabstat npersons [aw=sweight] if mpoor_p5==1, stat (sum) by (state_cat)  format (%11.0g)
tabstat npersons [aw=sweight] if missing==0, stat (sum) by (state_cat) format (%12.0g)
tabstat cnpersons if mpoor_p5==1 [aw=sweight], stat (sum) by (state_cat) format (%12.0g)

