*-----*------*
*  ****        MPI for Bolivia      ****************
* Por: Edison Choque-Sánchez
*-----*------*

*Para importar la base de datos: Archivo, Importar, Datos de texto (delimitados)
*csv....)
*Si sale solo en una columna, fijarse lo que se repite mas (: ; -) y seleccionar
*La ultima opción (Personalizado)
*Para convertir con R, no olvidar poner .dta al nombre del documento

cd ""

*--------Renombrar varibles--------*
ren s02a_03 edad
ren s02a_05 parentesco
ren s02a_02 sexo
*----------------*-----------------*

 *--------------*-------------*
 *D1 Dimensión de la Educación
 {*--------------*-------------*

*V1: TIC1 -> Acceso a internet -> Pregunta 31, sección 1 , base: Vivienda
use EH2019_Vivienda, clear 
ren s01a_31 acceso_internet
gen acceso_internet_a=(acceso_internet==2)

*V2: TIC2 -> uso de compu, tablet, etc -> Pregunta 19, sección 5
use EH2019_PersonaR, clear

ren s05d_19a uso_tic 
gen uso_tic_a = (uso_tic==2) if edad>10 & parentesco==1

*V3: Matricula escolar de niños entre 6 y 12 años -> Pregunta 4, sección 5
use EH2019_PersonaR, clear

ren s05a_04 matricula
**Variable kids (6-12)
gen kids = (edad <= 12 & edad>=6)/*-> variable que tiene el valor de 1 para los miembros que tengan entre 6 y 12 años*/
egen kidsa=total(kids), by (folio)
label var kidsa "Número de niños 6-12 años"
	gen kidsb= (kidsa >0)
	label var kidsb "Presencia de niños 6-12 años" 
	label define kidsb  1 "Con niños"  0 "Sin niños" 
	label values kidsb kidsb
***Creación de la V3
gen matricula_a=(matricula==2) if kidsb==1 & kids==1
egen matricula_b=max(matricula_a), by (folio) 
tab matricula_b if kidsb==1 & parentesco==1

*------------Para observar las tablas creadas------------*
br folio parentesco edad sexo matricula if matricula==. 
br folio parentesco edad sexo kids kidsa kidsb
br folio parentesco edad sexo kids matricula matricula_a matricula_b
*---------------------------**---------------------------*

*V4: Años de Educación
codebook aestudio
sum aestudio if edad>10
gen aestudio_a=(aestudio<=12) if edad>10 & parentesco==1
tab aestudio_a if edad>10 & parentesco==1

}
 *------------------*-----------------*
 *D2 Dimensión de la Salud y Nutrición*
 {*------------------*-----------------*
*Se utilizó la base de datos Personas

*V1: Mortalidad de los hijos -> Preguntas 12 y 13, sección 4
/*Se usa folio para que se repita en todo el grupo de la familia*/

ren s04b_12 nac_vivos
ren s04b_13 vivos_hoy
egen nac_vivos_a = max(nac_vivos), by (folio) 
egen vivos_hoy_a = max(vivos_hoy), by (folio) 
gen mortalidad = nac_vivos_a - vivos_hoy_a
gen mortalidad_a = 0 if mortalidad==0
replace mortalidad_a = 1 if mortalidad==1 | mortalidad==2 | mortalidad==3 | mortalidad==4 | mortalidad==5

*V2:Seguro de Salud -> Pregunta 4, sección 4 

use EH2019_PersonaR, clear  

ren s04a_04a Seg_Salud
gen Seg_Salud_a = 1 if Seg_Salud==6
replace Seg_Salud_a = 0 if Seg_Salud==1 | Seg_Salud==2 | Seg_Salud==3 | Seg_Salud==4 | Seg_Salud==5
gen Seg_Salud_b = (Seg_Salud_a==1) if parentesco==1 & edad>10

*V3: Nutrición -> Preguntas 3, 6, 11 y 14, sección 9 para mayor a 10 años

*Base de datos: Seguridad Alimentaria
use EH2019_SeguridadAlimentaria, clear

ren s09a_03 saludable_a
ren s09a_06 insuficiente_a
ren s09a_11 saludable_b
ren s09a_14 insuficiente_b

gen nutricion = 0 if (saludable_a==2 & saludable_b==2 & insuficiente_a==2 & insuficiente_b==2)
replace nutricion= 1 if (saludable_a==1 | saludable_b==1 | insuficiente_a==1 | insuficiente_b==1)
replace nutricion=0 if nutricion==.
replace nutricion=. if (saludable_a==3 | saludable_b==3 | insuficiente_a==3 | insuficiente_b==3)

save "cr_eh2019seg_alimentaria", replace 
}

 *----------*---------*
 *D3 Dimension Económia
{*----------*---------* 

*Base de Datos: Personas

*V1: Linea de Pobreza Oficial -> No tiene pregunta, el INE ya lo calcula

gen pobreza_moderada = (p0==1) if parentesco==1 & edad>10

}
 *---------------*---------------*
 *D4 Dimensión de Trabajo y Empleo
{*---------------*---------------*

*Estrato:Es la calificación que nos muestra el estrado de los hogares,
*en donde existen 4 calificaciones:
*Estrato bajo, bajo medio, alto medio y alto
*Toma en cuenta no solo de ingreso sino tambien variables socioeconómicas
*como la educación y vivienda (que tipo de vivienda tiene)

*V1: Estrato (Estrato Bajo)-> No tiene pregunta ni sección, el INE lo calcula
 
gen estrato_bajo = 0
replace estrato_bajo = 1 if estrato=="11" | estrato=="12" | estrato=="13" | estrato=="14" & edad>10 & parentesco==1

*V2: Empleo -> Horas de trabajo total, Pregunta 1, 48 sección 6

*tothrs
ren s06a_01 trabajo
ren s06g_48 disponible_mashrs

gen trabajo_carencia= 0
replace trabajo_carencia= 1 if disponible_mashrs==1 & tothrs<40 & edad>10

egen trabajo_carencia_a=max(trabajo_carencia), by (folio)

}

 *----------*-----------*
 *D5: Dimensión del Hogar
{*----------*-----------*

use EH2019_ViviendaR, clear

*V1: Agua -> Pregunta 14, sección 1

ren s01a_14_1   agua_limpia
gen agua_limpia_a=(agua_limpia==2)

*V2: Seneamiento -> Pregunta 16, sección 1

ren s01a_16   sanitario
gen sanitario_carencia=0
replace sanitario_carencia=1 if sanitario==2 | sanitario==3 | sanitario==4
replace sanitario_carencia=. if sanitario==. 

*V3: Energia Electrica -> Pregunta 19, sección 1

ren s01a_19 Electricidad
gen Electricidad_a=(Electricidad==2)

*V4: Combustible -> Pregunta 25, sección 1

ren s01a_25 Combustible
gen Combustible_a=0
replace Combustible_a=1 if Combustible==1 | Combustible ==2 | Combustible==3 | Combustible==5 | Combustible==6 | Combustible==7

save "cr_eh2019_vivienda", replace
}
  

  ** Merge **
* Data seguridad alimentaria --> nutricion 
* Data Vivienda --> acceso_internet_a,  agua_limpia_a, sanitario_carencia
 /// Electricidad_a, Combustible_a 
* Data Persona --> uso_tic_a, matricula_b, aestudio_a, mortalidad_a, Seg_Salud_b
/// pobreza_moderada, estrato_bajo, trabajo_carencia_a
use EH2019_Persona, clear 

des uso_tic_a matricula_b aestudio_a mortalidad_a Seg_Salud_b pobreza_moderada estrato_bajo trabajo_carencia_a
des nutricion acceso_internet_a agua_limpia_a sanitario_carencia Electricidad_a Combustible_a
merge m:1 folio using "cr_eh2019seg_alimentaria", keepusing(nutricion)
drop _merge

merge m:1 folio using "cr_eh2019_vivienda", keepusing(acceso_internet_a agua_limpia_a sanitario_carencia Electricidad_a Combustible_a)
drop _merge
  
sort folio
by folio: keep if parentesco==1 

save "cr_eh2019persona", replace

*####################################################################3
use cr_eh2019persona, clear 

{
egen n_missing1=rowmiss(uso_tic_a matricula_b aestudio_a mortalidad_a Seg_Salud_b pobreza_moderada estrato_bajo trabajo_carencia_a nutricion acceso_internet_a agua_limpia_a sanitario_carencia Electricidad_a Combustible_a)

label variable n_missing "Number of missing variables by individual"
gen missing=(n_missing>0)
label variable missing "Individual with missing variables"

}

{

foreach var in uso_tic_a matricula_b aestudio_a mortalidad_a Seg_Salud_b pobreza_moderada estrato_bajo trabajo_carencia_a nutricion acceso_internet_a agua_limpia_a sanitario_carencia Electricidad_a Combustible_a {
gen `var'_miss=1 if `var'==.
replace `var'_miss=0 if `var'!=.
}

{
g healthpoor=(mortalidad_a | Seg_Salud_b | nutricion)
g edupoor=(uso_tic_a | matricula_b | aestudio_a | acceso_internet_a)
g ecopoor=(pobreza_moderada)
g workpoor=(estrato_bajo | trabajo_carencia_a)
g vivpoor=(agua_limpia_a | sanitario_carencia | Electricidad_a | Combustible_a)


tab depto healthpoor [aw=factor] if missing==0, row nofre


David 
}
foreach var of varlist  healthpoor edupoor workpoor faltaunadimension henvpoor{
lab var `var' "Dimensinal poor"
}

g mpiwtscore=((1/5)*(1/2))*death+((1/5)*(1/2))*uweight+((1/5)*(1/2))*edu_complet+((1/5)*(1/2))*enrol_school+ ///
	((1/5)*(1/1))*poor_new+((1/5)*(1/2))*incsour+((1/5)*(1/2))*worker+((1/5)*(1/3))*water+ ///
	((1/5)*(1/3))*toilet+((1/5)*(1/3))*fuel
	
label var mpiwtscore "weighted deprivation score"
	
recode mpiwtscore (0/.33=0 "Non-poor") (0.33/max=1 "Mpoor"), gen (mpoor)
lab var mpoor "multidimensional poor (k=0.33)"

tab stat para bolivia 

David 

/*g cnpersons=npersons*mpiwtscore if mpoor==1
lab var cnpersons "hh size * deprivation score"

tabstat npersons [aw=sweight] if missing==0, stat (sum) by (mpoor) format (%11.0g)
tabstat cnpersons if mpoor==1 [aw=sweight], stat (sum) format (%12.0g)*/

  *--------EXTRAS--------*
{
*se utiliza el comando "drop" para eliminar una variable
*Para ordenar los folio
sort folio
*---- by folio: keep if _n==1 -> no se uso este comando
save "eh_vivienda2", replace
*-----------*----------*

*V5: Telefono Fijo -> Pregunta 29, sección 1 
ren s01a_29 Tel_fijo
gen Tel_fijo_a=(Tel_fijo==2)
}



