** stochastic dominance 
cd "H:\My Drive\Consultorias\UCB_tesis_david\data"
use cr_eh2019persona, clear 

egen n_missing1=rowmiss(uso_tic_a matricula_b aestudio_a mortalidad_a Seg_Salud_b pobreza_moderada estrato_bajo trabajo_carencia_a nutricion acceso_internet_a agua_limpia_a sanitario_carencia Electricidad_a Combustible_a)

label variable n_missing "Number of missing variables by individual"
gen missing=(n_missing>0)
label variable missing "Individual with missing variables"


foreach var in uso_tic_a matricula_b aestudio_a mortalidad_a Seg_Salud_b pobreza_moderada estrato_bajo trabajo_carencia_a nutricion acceso_internet_a agua_limpia_a sanitario_carencia Electricidad_a Combustible_a {
gen `var'_miss=1 if `var'==.
replace `var'_miss=0 if `var'!=.
}


/*
1. replace missing por 0
2. seguir el paper y trabajar con una muestra mas pequeña 
*/
** 1 
foreach var in uso_tic_a matricula_b aestudio_a mortalidad_a Seg_Salud_b pobreza_moderada estrato_bajo trabajo_carencia_a nutricion acceso_internet_a agua_limpia_a sanitario_carencia Electricidad_a Combustible_a {
replace `var'=0 if `var'==. 
}

g healthpoor=(mortalidad_a | Seg_Salud_b | nutricion) 
g edupoor=(uso_tic_a | matricula_b | aestudio_a | acceso_internet_a)
g ecopoor=(pobreza_moderada)
g workpoor=(estrato_bajo | trabajo_carencia_a)
g vivpoor=(agua_limpia_a | sanitario_carencia | Electricidad_a | Combustible_a)


* opcion 2 tab depto healthpoor [aw=factor] if missing==0, row nofre

tab depto healthpoor [aw=factor], row nofre

tab healthpoor [aw=factor]
tab edupoor [aw=factor]
tab ecopoor [aw=factor]
tab workpoor [aw=factor]
tab vivpoor [aw=factor]



foreach var of varlist  healthpoor edupoor ecopoor workpoor vivpoor{
lab var `var' "Pobreza Multidimensional"

}

*Pesos de las dimensiones

gen mpiwtscore=((1/5)*(1/3))*mortalidad_a+((1/5)*(1/3))*Seg_Salud_b+((1/5)*(1/3))*nutricion+((1/5)*(1/4))*uso_tic_a + /*
               */((1/5)*(1/4))*matricula_b+((1/5)*(1/4))*aestudio_a+((1/5)*(1/4))*acceso_internet_a+((1/5)*(1/1))*pobreza_moderada /*
              */ +((1/5)*(1/1))*trabajo_carencia_a+((1/5)*(1/4))*agua_limpia_a+((1/5)*(1/4))*sanitario_carencia /*
              */ + ((1/5)*(1/4))*Electricidad_a+((1/5)*(1/4))*Combustible_a 
label var mpiwtscore "Puntuación de Pobreza"

hist mpiwtscore
summarize mpiwtscore
table area [aw=factor], c (mean mpiwtscore median mpiwtscore sd mpiwtscore)

gen mpoor = (mpiwtscore>0.33)
lab var mpoor "Pobreza Multidimensional (k=0.33)"
tab mpoor [aw=factor]
tab depto mpoor [aw=factor], row nofre

* Dominance Analysis
 recode mpiwtscore (0/.1=0 "non-poor") (.1/max=1 "Poor"), g(mpoor_1)
recode mpiwtscore (0/.2=0 "non-poor") (.2/max=1 "Poor"), g(mpoor_2)
recode mpiwtscore (0/.3=0 "non-poor") (.3/max=1 "Poor"), g(mpoor_3)
recode mpiwtscore (0/.4=0 "non-poor") (.4/max=1 "Poor"), g(mpoor_4)
recode mpiwtscore (0/.5=0 "non-poor") (.5/max=1 "Poor"), g(mpoor_5)
recode mpiwtscore (0/.6=0 "non-poor") (.6/max=1 "Poor"), g(mpoor_6)
recode mpiwtscore (0/.7=0 "non-poor") (.7/max=1 "Poor"), g(mpoor_7)
recode mpiwtscore (0/.8=0 "non-poor") (.8/max=1 "Poor"), g(mpoor_8)
recode mpiwtscore (0/.9=0 "non-poor") (.9/max=1 "Poor"), g(mpoor_9)
recode mpiwtscore (0/0.5=0 "non-poor") (0.5/max=1 "Poor"), g(mpoor_p5)

 *tab
 tab depto mpoor_p5  [aw=factor], row nofre
* mejor codigo es: 
tabout  mpoor_p5 mpoor_1 mpoor_2 mpoor_3 mpoor_4 mpoor_5 mpoor_6 mpoor_7 mpoor_8 mpoor_9 depto using dom_mpi.xls [aw=factor], c(col) f(1)  dpcomma replace 

