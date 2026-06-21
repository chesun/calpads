*** do file cleancsueradata.do for Stata
*** version 14.1
*** by Kramer

/* 

This .do file cleans the CSU ERA data. I crib code from the .do files Jake
wrote to clean the data whenever possible.

For some year / terms there are more than one raw file. I uploaded all the 
raw files to Sapper so that if anyone wants to compare the different files, 
they can.

However, I am only cleaning one file for each year / term. I am basically
chosing the most recent version of the file on the assumption that those are
most likely to be correct. HOWEVER, whenever I have the option to chose a
file from the "csu update 11-15-10" file as opposed to the "csu ascii file" I
alwasy choose files from the "csu update 11-15-10" folder. This update was 
specificaly to replace files from the "csu ascii file" folder that Jake thought
had issues.

OPSMAN = Enrollment Reporting System Operations Manual

*/

*********** Set Up
clear all
capture log close
cd "/home/research/sbac/data/restricted_access/"
log using "clean/csu actually clean/do and log files/cleancsueradata.smcl", smcl replace
set more off
version 14.1

****************************************************************************
 ***                             Begin File                             ***
****************************************************************************

*** Cleaning the variables that are in all the files

forvalues year = 1997 / 2017 {

forvalues term = 1/4 {

if `year' == 1997 & `term' == 1 | ///
   `year' == 1997 & `term' == 2 | ///
   `year' == 1997 & `term' == 3 | ///
   `year' == 1998 & `term' == 1 | ///
   `year' == 1998 & `term' == 3 | ///
   `year' == 1999 & `term' == 1 | ///
   `year' == 1999 & `term' == 3 | ///
   `year' == 2000 & `term' == 1 | ///
   `year' == 2001 & `term' == 1 | ///
   `year' == 2002 & `term' == 1 {
   
	display "No file exists for `year'`term' (1)"
	continue

   }
 
else if `year' == 1997 & `term' == 4 | ///
        `year' == 1998 & `term' == 2 | ///
        `year' == 1998 & `term' == 4 | ///
        `year' == 1999 & `term' == 2 | ///
        `year' == 1999 & `term' == 4 | ///
        `year' == 2000 & `term' == 2 | ///
        `year' == 2000 & `term' == 3 | ///
        `year' == 2000 & `term' == 4 | ///
        `year' == 2001 & `term' == 2 | ///
        `year' == 2001 & `term' == 3 | ///
        `year' == 2001 & `term' == 4 | ///
        `year' == 2002 & `term' == 2 {

	local filepath "1993or97to2007"
	local era "ERA"

  }  
  
else if `year' == 2004 & `term' == 3 | ///
        `year' == 2004 & `term' == 4 | ///
        `year' == 2005 | ///
        `year' == 2006 | ///
        `year' == 2007 | ///
        `year' == 2008 | ///
        `year' == 2009 & `term' == 1 | ///
        `year' == 2009 & `term' == 2 | ///
        `year' == 2009 & `term' == 3 {

	local filepath "2001or02to2009"
	local era "era"

  }   
  
else if `year' == 2002 & `term' == 3 | ///
        `year' == 2002 & `term' == 4 | ///
        `year' == 2003 | ///
        `year' == 2004 & `term' == 1 | ///
        `year' == 2004 & `term' == 2 {

	local filepath "csu update 11-15-10"
	local era "era"

  } 
  
else if `year' == 2009 & `term' == 4 | ///
        `year' == 2010 | ///
        `year' == 2011 | ///
        `year' == 2012 | ///
        `year' == 2013 & `term' == 1 | ///
        `year' == 2013 & `term' == 2 | ///
        `year' == 2013 & `term' == 3 {

	local filepath "CSU Data Update Jake"
	local era "era"

  }  

else if `year' == 2013 & `term' == 4 | ///
        `year' == 2014 & `term' == 1 | ///
        `year' == 2014 & `term' == 2 | ///
        `year' == 2014 & `term' == 3 {

	local filepath "CSU Update 7-15-2015"
	local era "era"

  } 
  
else if `year' == 2014 & `term' == 4 | ///
        `year' == 2015 | ///
        `year' == 2016 & `term' == 1 | ///
        `year' == 2016 & `term' == 2 {

	local filepath "CSU update 10-6-16"
	local era "era"

  }
  
else if `year' == 2016 & `term' == 3 | /// 
	`year' == 2016 & `term' == 4 | ///
	`year' == 2017 & `term' == 1 | ///
	`year' == 2017 & `term' == 2  {

	local filepath "CSU Update 10-23-17"
	local era "era"

  }
  
else if `year' == 2017 & `term' == 3 | ///
	`year' == 2017 & `term' == 4  {

	local filepath "CSU Update 11.29.17"
	local era "era"

  }
  
else {

	display "unhelpful error message 2.718"

 }

use "clean/csu/`filepath'/`era'`year'`term'.dta", clear

di "1 `year' `term'"

*** idunique (Social Security Number)
*    p 326 in 2016 OPSMAN

label variable idunique "Masked SSN"
* SSNs of 000-00-0000 and 999-99-9999 are not valid. 
* I check and none are in the data set.


*** year
*    p 410 in 2016 OPSMAN	

qui destring year, replace
qui replace year = . if year!=`year'
label variable year "Calendar Yr"


*** termcode
*    p 352 in 2016 OPSMAN

qui destring termcode, replace
qui replace termcode = . if termcode!=term
label variable termcode "Term"
rename termcode term
label define terml ///
1 "Winter" ///
2 "Spring" ///
3 "Summer" ///
4 "Fall" ///
9 "All"
label values term terml


*** admissionbasiscode
*    p 83 in 2016 OPSMAN

qui replace admissionbasiscode = trim(admissionbasiscode)

qui generate admissionbasis2=.
qui replace admissionbasis2 = 1 if admissionbasiscode=="A" | admissionbasiscode=="B" | admissionbasiscode=="C"
qui replace admissionbasis2 = 2 if admissionbasiscode=="H" | admissionbasiscode=="I"
qui replace admissionbasis2 = 3 if admissionbasiscode=="D" | admissionbasiscode=="E" | admissionbasiscode=="F"
qui replace admissionbasis2 = 4 if admissionbasiscode=="O" | admissionbasiscode=="X"
qui replace admissionbasis2 = 5 if admissionbasiscode=="T" | admissionbasiscode=="U"
qui replace admissionbasis2 = 6 if admissionbasiscode=="Q" | admissionbasiscode=="R" | admissionbasiscode=="W" | admissionbasiscode=="Y"
qui replace admissionbasis2 = 7 if admissionbasiscode=="N" | admissionbasiscode=="P"
qui replace admissionbasis2 = 8 if admissionbasiscode=="S" | admissionbasiscode=="Y" | admissionbasiscode=="Z"
qui replace admissionbasis2 = 9 if admissionbasiscode=="K"
qui replace admissionbasis2 = 10 if admissionbasiscode=="G" | admissionbasiscode=="J"
qui replace admissionbasis2 = 11 if admissionbasiscode=="1" | admissionbasiscode=="2" | admissionbasiscode=="3" | admissionbasiscode=="4" | admissionbasiscode=="5" 

label def admissionbasis2 1 "1st time Fresh, Reg"
label def admissionbasis2 2 "1st time Fresh, Exceptional", add
label def admissionbasis2 3 "1st time Fresh, Other", add
label def admissionbasis2 4 "Low Div Transf, Reg",add
label def admissionbasis2 5 "Low Div Transf, Exceptional",add
label def admissionbasis2 6 "Low Div Transf, Other",add
label def admissionbasis2 7 "Up Div Transf, Reg",add
label def admissionbasis2 8 "Up Div Transf, Other",add
label def admissionbasis2 9 "Transitory Student",add
label def admissionbasis2 10 "Summer Early Entry Transitory",add
label def admissionbasis2 11 "Postbac/Grad",add

label val admissionbasis2 admissionbasis2

rename admissionbasiscode admissionbasis
label var admissionbasis "Admission Basis Code"
label var admissionbasis2 "Admission Basis Recode"


*** exceptionadmissioncode
*    p 239 in 2016 OPSMAN

qui replace exceptionadmissioncode = trim(exceptionadmissioncode)

qui generate exceptionadmissioncode2=.
qui replace exceptionadmissioncode2 = .a if exceptionadmissioncode=="N" | exceptionadmissioncode=="" 
qui replace exceptionadmissioncode2 = 1 if exceptionadmissioncode=="1"
qui replace exceptionadmissioncode2 = 2 if exceptionadmissioncode=="2"
qui replace exceptionadmissioncode2 = 3 if exceptionadmissioncode=="3"
qui replace exceptionadmissioncode2 = 4 if exceptionadmissioncode=="4"
qui replace exceptionadmissioncode2 = 5 if exceptionadmissioncode=="5"

*count if exceptionadmissioncode2==. 
*di "`year' `term'"
*di "tab exceptionadmissioncode if exceptionadmissioncode2==., missing"
*tab exceptionadmissioncode if exceptionadmissioncode2==., missing
*di "tab admissionbasiscode if exceptionadmissioncode2==., missing"
*tab admissionbasis if exceptionadmissioncode2==., missing
	
label def exceptionadmission .a "No admiss basis code H or T"
label def exceptionadmission 1 "Scholarship", add
label def exceptionadmission 2 "Experience/maturity", add
label def exceptionadmission 3 "Athletic Ability",add
label def exceptionadmission 4 "Special abilities/talents",add
label def exceptionadmission 5 "Institutional commitment",add

drop exceptionadmissioncode
rename exceptionadmissioncode2 exceptionadmission
label val exceptionadmission exceptionadmission
label var exceptionadmission "Exception Admission Code"


*** admissionstatus
*    p 92 in 2016 OPSMAN

qui replace admissionstatus = trim(admissionstatus)

qui gen admissionstatus2=.

qui replace admissionstatus2 = 1 if admissionstatus=="H"
qui replace admissionstatus2 = 2 if admissionstatus=="A"
qui replace admissionstatus2 = 3 if admissionstatus=="F"

qui replace admissionstatus2 = 4 if admissionstatus=="N"

qui replace admissionstatus2 = 5 if admissionstatus=="P"
qui replace admissionstatus2 = 6 if admissionstatus=="C"

qui replace admissionstatus2 = 7 if admissionstatus=="E"
qui replace admissionstatus2 = 8 if admissionstatus=="I"

qui replace admissionstatus2 = 9 if admissionstatus=="W"

qui replace admissionstatus2 = 10 if admissionstatus=="T"
qui replace admissionstatus2 = 11 if admissionstatus=="U"
qui replace admissionstatus2 = 12 if admissionstatus=="D"

qui replace admissionstatus2 = .a if admissionstatus=="#"
qui replace admissionstatus2 = .b if admissionstatus=="B"
qui replace admissionstatus2 = .c if admissionstatus=="R"
qui replace admissionstatus2 = .d if admissionstatus=="S"

*count if admissionstatus2==.
*di "`year' `term'"
*tab admissionstatus if admissionstatus2==., missing

label def admissionstatus 1 "Admit with Honors(H)"
label def admissionstatus 2 "Admitted(A)", add
label def admissionstatus 3 "Admit on Probation(F)",add

label def admissionstatus 4 "Admitted-Will not attend(N)",add

label def admissionstatus 5 "Provisional Admit(P)",add
label def admissionstatus 6 "Conditional Admit(C)", add

label def admissionstatus 7 "In Evaluation(E)",add
label def admissionstatus 8 "Incomplete file(I)",add

label def admissionstatus 9 "Withdrew app before admiss(W)",add

label def admissionstatus 10 "Denied-CSU-elig redirected(T)",add
label def admissionstatus 11 "Denied-CSU-elig not redirect(U)",add
label def admissionstatus 12 "Denied admiss not CSU-elig(D)", add

label def admissionstatus .a "Not in codebook (#)",add
label def admissionstatus .b "Not in codebook (B)",add
label def admissionstatus .c "Not in codebook (R)",add
label def admissionstatus .d "Not in codebook (S)",add

drop admissionstatus
rename admissionstatus2 admissionstatus
label val admissionstatus admissionstatus
label var admissionstatus "Admission Status"

*** birthdatee
*    p 100 in 2016 OPSMAN

qui replace birthdatee = trim(birthdatee)

qui generate dob = date(birthdatee, "YMD")
format dob %td

*count if dob==.
*di "`year' `term'"
*count
*tab birthdatee if dob==., missing 
* these birthdays are really missing - always blank, 00000000, or obviously wrong

label variable dob "Date of Birth"
drop birthdatee


*** citizanshipcode
*    p 117 in 2016 OPSMAN

qui replace citizenshipcode = trim(citizenshipcode)

qui gen citizenshipcode2 =.
qui replace citizenshipcode2= 1 if citizenshipcode=="Y"
qui replace citizenshipcode2= 2 if citizenshipcode=="I"
qui replace citizenshipcode2= 3 if citizenshipcode=="F"
qui replace citizenshipcode2= 4 if citizenshipcode=="J"
qui replace citizenshipcode2= 5 if citizenshipcode=="O"
qui replace citizenshipcode2= 6 if citizenshipcode=="N"
qui replace citizenshipcode2= 7 if citizenshipcode=="R"
qui replace citizenshipcode2= 8 if citizenshipcode=="X"

*count if citizenshipcode2 ==.
*di "`year' `term'"
*tab citizenshipcode if citizenshipcode2==., missing 
* The vast majority of this is blank, but there are some things that are not 
* in the codebook. It looks mainly like typos, not missing catagories, so I'm
* going to keep those as "." and not break them out.

drop citizenshipcode
rename citizenshipcode2 citizenship

label def citizenship 1 "United States citizen(Y)"
label def citizenship 2 "Non-US citizen, immigrant I-551(I)", add
label def citizenship 3 "Non-US citizen, Fvisa(F)", add
label def citizenship 4 "Non-US citizen, Jvisa(J)", add
label def citizenship 5 "Non-US citizen, other visa(O)",add
label def citizenship 6 "Non-US cit, undetermined stat / not entering US(N)",add	 
label def citizenship 7 "Refugee/Asylee(R)",add	
label def citizenship 8 "Citizenship unknown",add

label val citizenship citizenship
label var citizenship "Citizenship Code"


*** countryofcitizenship
*    p 142 in 2016 OPSMAN

*di "`year' `term'"

qui replace countryofcitizenship = trim(countryofcitizenship)
qui replace countryofcitizenship = "." if countryofcitizenship=="****"
qui replace countryofcitizenship = "." if countryofcitizenship=="YU"
qui replace countryofcitizenship = "." if countryofcitizenship=="DO"
qui replace countryofcitizenship = "." if countryofcitizenship=="Y790"

qui destring countryofcitizenship,replace
qui replace countryofcitizenship =.a if countryofcitizenship==0
qui replace countryofcitizenship =.b if countryofcitizenship==9000
qui replace countryofcitizenship =.c if countryofcitizenship==9001
qui replace countryofcitizenship =.d if countryofcitizenship==9002
qui replace countryofcitizenship =.e if countryofcitizenship==9999

* count if countryofcitizenship<1 | (countryofcitizenship>7900 & countryofcitizenship<.)
* tab countryofcitizenship if countryofcitizenship<1 | (countryofcitizenship>7900 & countryofcitizenship<.), missing

qui replace countryofcitizenship=. if countryofcitizenship<1 | (countryofcitizenship>7900 & countryofcitizenship<.)
* Only 8 of these, I think they are data entry errors.

label def countryofcitizenship 1 "Alameda" 
label def countryofcitizenship 2 "Alpine" ,add
label def countryofcitizenship 3 "Amador" ,add
label def countryofcitizenship 4 "Butte" ,add
label def countryofcitizenship 5 "Calaveras" ,add
label def countryofcitizenship 6 "Colusa" ,add
label def countryofcitizenship 7 "Contra Costa" ,add
label def countryofcitizenship 8 "Del Norte" ,add
label def countryofcitizenship 9 "El Dorado" ,add
label def countryofcitizenship 10 "Fresno" ,add
label def countryofcitizenship 11 "Glenn" ,add
label def countryofcitizenship 12 "Humboldt" ,add
label def countryofcitizenship 13 "Imperial" ,add
label def countryofcitizenship 14 "Inyo" ,add
label def countryofcitizenship 15 "Kern" ,add
label def countryofcitizenship 16 "Kings" ,add
label def countryofcitizenship 17 "Lake" ,add
label def countryofcitizenship 18 "Lassen" ,add
label def countryofcitizenship 19 "Los Angeles" ,add
label def countryofcitizenship 20 "Madera" ,add
label def countryofcitizenship 21 "Marin" ,add
label def countryofcitizenship 22 "Mariposa" ,add
label def countryofcitizenship 23 "Mendocino" ,add
label def countryofcitizenship 24 "Merced" ,add
label def countryofcitizenship 25 "Modoc" ,add
label def countryofcitizenship 26 "Mono" ,add
label def countryofcitizenship 27 "Monterey" ,add
label def countryofcitizenship 28 "Napa" ,add
label def countryofcitizenship 29 "Nevada" ,add
label def countryofcitizenship 30 "Orange" ,add
label def countryofcitizenship 31 "Placer" ,add
label def countryofcitizenship 32 "Plumas" ,add
label def countryofcitizenship 33 "Riverside" ,add
label def countryofcitizenship 34 "Sacramento" ,add
label def countryofcitizenship 35 "San Benito" ,add
label def countryofcitizenship 36 "San Bernardino" ,add
label def countryofcitizenship 37 "San Diego" ,add
label def countryofcitizenship 38 "San Francisco" ,add
label def countryofcitizenship 39 "San Joaquin" ,add
label def countryofcitizenship 40 "San Luis Obispo" ,add
label def countryofcitizenship 41 "San Mateo" ,add
label def countryofcitizenship 42 "Santa Barbara" ,add
label def countryofcitizenship 43 "Santa Clara" ,add
label def countryofcitizenship 44 "Santa Cruz" ,add
label def countryofcitizenship 45 "Shasta" ,add
label def countryofcitizenship 46 "Sierra" ,add
label def countryofcitizenship 47 "Siskiyou" ,add
label def countryofcitizenship 48 "Solano" ,add
label def countryofcitizenship 49 "Sonoma" ,add
label def countryofcitizenship 50 "Stanislaus" ,add
label def countryofcitizenship 51 "Sutter" ,add
label def countryofcitizenship 52 "Tehama" ,add
label def countryofcitizenship 53 "Trinity" ,add
label def countryofcitizenship 54 "Tulare" ,add
label def countryofcitizenship 55 "Tuolumne" ,add
label def countryofcitizenship 56 "Ventura" ,add
label def countryofcitizenship 57 "Yolo" ,add
label def countryofcitizenship 58 "Yuba" ,add
label def countryofcitizenship 6001 "Alabama" ,add
label def countryofcitizenship 6002 "Alaska" ,add
label def countryofcitizenship 6003 "Arizona" ,add
label def countryofcitizenship 6004 "Arkansas" ,add
label def countryofcitizenship 6005 "Colorado" ,add
label def countryofcitizenship 6006 "Connecticut" ,add
label def countryofcitizenship 6007 "Delaware" ,add
label def countryofcitizenship 6008 "Florida" ,add
label def countryofcitizenship 6009 "Georgia" ,add
label def countryofcitizenship 6010 "Hawaii" ,add
label def countryofcitizenship 6011 "Idaho" ,add
label def countryofcitizenship 6012 "Illinois" ,add
label def countryofcitizenship 6013 "Indiana" ,add
label def countryofcitizenship 6014 "Iowa" ,add
label def countryofcitizenship 6015 "Kansas" ,add
label def countryofcitizenship 6016 "Kentucky" ,add
label def countryofcitizenship 6017 "Louisiana" ,add
label def countryofcitizenship 6018 "Maine" ,add
label def countryofcitizenship 6019 "Maryland" ,add
label def countryofcitizenship 6020 "Massachusetts" ,add
label def countryofcitizenship 6021 "Michigan" ,add
label def countryofcitizenship 6022 "Minnesota" ,add
label def countryofcitizenship 6023 "Mississippi" ,add
label def countryofcitizenship 6024 "Missouri" ,add
label def countryofcitizenship 6025 "Montana" ,add
label def countryofcitizenship 6026 "Nebraska" ,add
label def countryofcitizenship 6027 "Nevada" ,add
label def countryofcitizenship 6028 "New Hampshire" ,add
label def countryofcitizenship 6029 "New Jersey" ,add
label def countryofcitizenship 6030 "New Mexico" ,add
label def countryofcitizenship 6031 "New York" ,add
label def countryofcitizenship 6032 "North Carolina" ,add
label def countryofcitizenship 6033 "North Dakota" ,add
label def countryofcitizenship 6034 "Ohio" ,add
label def countryofcitizenship 6035 "Oklahoma" ,add
label def countryofcitizenship 6036 "Oregon" ,add
label def countryofcitizenship 6037 "Pennsylvania" ,add
label def countryofcitizenship 6038 "Rhode Island" ,add
label def countryofcitizenship 6039 "South Carolina" ,add
label def countryofcitizenship 6040 "South Dakota" ,add
label def countryofcitizenship 6041 "Tennessee" ,add
label def countryofcitizenship 6042 "Texas" ,add
label def countryofcitizenship 6043 "Utah" ,add
label def countryofcitizenship 6044 "Vermont" ,add
label def countryofcitizenship 6045 "Virginia" ,add
label def countryofcitizenship 6046 "Washington" ,add
label def countryofcitizenship 6047 "West Virginia" ,add
label def countryofcitizenship 6048 "Wisconsin" ,add
label def countryofcitizenship 6049 "Wyoming" ,add
label def countryofcitizenship 6050 "District of Columbia" ,add
label def countryofcitizenship 6061 "American Samoa" ,add
label def countryofcitizenship 6065 "Guam" ,add
label def countryofcitizenship 6069 "Midway Islands" ,add
label def countryofcitizenship 6070 "Northern Mariana" ,add
label def countryofcitizenship 6071 "Palau" ,add
label def countryofcitizenship 6073 "Okinawa" ,add
label def countryofcitizenship 6077 "Panama Canal Zone" ,add
label def countryofcitizenship 6081 "Puerto Rico" ,add
label def countryofcitizenship 6085 "Trust Territory of the Pacific" ,add
label def countryofcitizenship 6087 "United States Minor Outlying Islands" ,add
label def countryofcitizenship 6089 "Virgin Islands" ,add
label def countryofcitizenship 6093 "Wake Islands" ,add
	label def countryofcitizenship 7000 "Default To 7000" ,add
	label def countryofcitizenship 7004 "Peoples Dem Rep Yemen" ,add
	label def countryofcitizenship 7008 "Afghanistan" ,add
	label def countryofcitizenship 7009 "Bangladesh" ,add
	label def countryofcitizenship 7011 "Aland Islands" ,add
	label def countryofcitizenship 7012 "Albania" ,add
	label def countryofcitizenship 7016 "Algeria" ,add
	label def countryofcitizenship 7020 "Andorra" ,add
	label def countryofcitizenship 7024 "Angola" ,add
	label def countryofcitizenship 7025 "Anguilla" ,add
	label def countryofcitizenship 7026 "Antigua And Barbuda" ,add
	label def countryofcitizenship 7027 "Antarctica" ,add
	label def countryofcitizenship 7028 "Argentina" ,add
	label def countryofcitizenship 7029 "Aruba" ,add
	label def countryofcitizenship 7030 "Armenia" ,add
	label def countryofcitizenship 7032 "Australia" ,add
	label def countryofcitizenship 7036 "Austria" ,add
	label def countryofcitizenship 7038 "Azerbaijan" ,add
	label def countryofcitizenship 7044 "Bahamas" ,add
	label def countryofcitizenship 7048 "Bahrain" ,add
	label def countryofcitizenship 7052 "Barbados" ,add
	label def countryofcitizenship 7056 "Lesotho" ,add
	label def countryofcitizenship 7060 "Botswana" ,add
	label def countryofcitizenship 7063 "Belarus" ,add
	label def countryofcitizenship 7064 "Belgium" ,add
	label def countryofcitizenship 7066 "Belize (British Honduras)" ,add
	label def countryofcitizenship 7068 "Bermuda" ,add
	label def countryofcitizenship 7072 "Bhutan" ,add
	label def countryofcitizenship 7076 "Bolivia" ,add
	label def countryofcitizenship 7077 "Bouvet Island" ,add
	label def countryofcitizenship 7078 "Bosnia And Herzegowina" ,add
	label def countryofcitizenship 7079 "British Indian Ocean Terr." ,add
	label def countryofcitizenship 7080 "Brazil" ,add
	label def countryofcitizenship 7088 "St Kitts-Nevis (British West Indies)" ,add
	label def countryofcitizenship 7092 "Brunei Darussalam" ,add
	label def countryofcitizenship 7096 "Bulgaria" ,add
	label def countryofcitizenship 7100 "Myanmar (Burma)" ,add
	label def countryofcitizenship 7104 "Burundi" ,add
	label def countryofcitizenship 7106 "Byelorussian SSR" ,add
	label def countryofcitizenship 7108 "Cambodia" ,add
	label def countryofcitizenship 7112 "Cameroon" ,add
	label def countryofcitizenship 7116 "Canada" ,add
	label def countryofcitizenship 7120 "Cape Verde" ,add
	label def countryofcitizenship 7122 "Cayman Islands" ,add
	label def countryofcitizenship 7128 "Central African Republic" ,add
	label def countryofcitizenship 7132 "Sri Lanka (Ceylon)" ,add
	label def countryofcitizenship 7136 "Chad" ,add
	label def countryofcitizenship 7144 "Chile" ,add
	label def countryofcitizenship 7146 "Christmas Island" ,add
	label def countryofcitizenship 7148 "Peoples Rep of China" ,add
	label def countryofcitizenship 7152 "Taiwan" ,add
	label def countryofcitizenship 7154 "Cocos (Keeling) Islands" ,add
	label def countryofcitizenship 7156 "Colombia" ,add
	label def countryofcitizenship 7160 "Comoros" ,add
	label def countryofcitizenship 7164 "Congo, The Democratic Republic of" ,add
	label def countryofcitizenship 7165 "Congo, Republic of" ,add
	label def countryofcitizenship 7166 "Cook Islands" ,add
	label def countryofcitizenship 7167 "Coral Sea Islands Territory" ,add
	label def countryofcitizenship 7172 "Costa Rica" ,add
	label def countryofcitizenship 7174 "Croatia" ,add
	label def countryofcitizenship 7176 "Cuba" ,add
	label def countryofcitizenship 7180 "Cyprus" ,add
	label def countryofcitizenship 7184 "Czech Republic" ,add
	label def countryofcitizenship 7188 "Benin (Dahomey)" ,add
	label def countryofcitizenship 7192 "Denmark" ,add
	label def countryofcitizenship 7196 "Dominican Republic" ,add
	label def countryofcitizenship 7198 "Timor-Leste" ,add
	label def countryofcitizenship 7200 "Ecuador" ,add
	label def countryofcitizenship 7204 "El Salvador" ,add
	label def countryofcitizenship 7206 "Equatorial Guinea" ,add
	label def countryofcitizenship 7208 "Estonia" ,add
	label def countryofcitizenship 7220 "Ethiopia" ,add
	label def countryofcitizenship 7221 "Eritrea" ,add
	label def countryofcitizenship 7224 "Falkland Islands" ,add
	label def countryofcitizenship 7226 "Faroe Islands" ,add
	label def countryofcitizenship 7228 "Fiji" ,add
	label def countryofcitizenship 7232 "Finland" ,add
	label def countryofcitizenship 7236 "France" ,add
	label def countryofcitizenship 7240 "French Guiana" ,add
	label def countryofcitizenship 7244 "French Polynesia" ,add
	label def countryofcitizenship 7246 "French Southern Territories" ,add
	label def countryofcitizenship 7248 "Djibouti" ,add
	label def countryofcitizenship 7252 "Gabon" ,add
	label def countryofcitizenship 7256 "Gambia" ,add
	label def countryofcitizenship 7258 "Gaza" ,add
	label def countryofcitizenship 7262 "Republic of Georgia" ,add
	label def countryofcitizenship 7264 "Democratic & Federal Republic of Germany" ,add
	label def countryofcitizenship 7268 "Ghana" ,add
	label def countryofcitizenship 7272 "Gibraltar" ,add
	label def countryofcitizenship 7276 "Kiribati (Gilbert Islands)" ,add
	label def countryofcitizenship 7284 "Greece" ,add
	label def countryofcitizenship 7288 "Greenland" ,add
	label def countryofcitizenship 7290 "Grenada" ,add
	label def countryofcitizenship 7291 "Guadeloupe" ,add
	label def countryofcitizenship 7292 "French Antilles (formerly French Antilles)" ,add
	label def countryofcitizenship 7296 "Guatemala" ,add
	label def countryofcitizenship 7297 "Guernsey" ,add
	label def countryofcitizenship 7300 "Guinea" ,add
	label def countryofcitizenship 7304 "Guyana" ,add
	label def countryofcitizenship 7308 "Haiti" ,add
	label def countryofcitizenship 7310 "Heard And McDonald Islands" ,add
	label def countryofcitizenship 7312 "Honduras" ,add
	label def countryofcitizenship 7316 "Hong Kong" ,add
	label def countryofcitizenship 7320 "Hungary" ,add
	label def countryofcitizenship 7324 "Iceland" ,add
	label def countryofcitizenship 7325 "Isle of Man" ,add
	label def countryofcitizenship 7328 "India" ,add
	label def countryofcitizenship 7332 "Indonesia (West Irian)" ,add
	label def countryofcitizenship 7336 "Iran" ,add
	label def countryofcitizenship 7340 "Iraq" ,add
	label def countryofcitizenship 7344 "Ireland" ,add
	label def countryofcitizenship 7352 "Israel" ,add
	label def countryofcitizenship 7356 "Italy" ,add
	label def countryofcitizenship 7360 "Ivory Coast" ,add
	label def countryofcitizenship 7364 "Jamaica" ,add
	label def countryofcitizenship 7368 "Japan" ,add
	label def countryofcitizenship 7369 "Jersey" ,add
	label def countryofcitizenship 7372 "Jordan" ,add
	label def countryofcitizenship 7377 "Kazakhstan" ,add
	label def countryofcitizenship 7380 "Kenya" ,add
	label def countryofcitizenship 7382 "Kosovo" ,add
	label def countryofcitizenship 7384 "Korea, North (Democratic People's Republic of Korea)" ,add
	label def countryofcitizenship 7388 "Korea, South (Republic of Korea)" ,add
	label def countryofcitizenship 7392 "Kuwait" ,add
	label def countryofcitizenship 7394 "Kyrgyzstan" ,add
	label def countryofcitizenship 7396 "Laos" ,add
	label def countryofcitizenship 7398 "Latvia" ,add
	label def countryofcitizenship 7404 "Lebanon" ,add
	label def countryofcitizenship 7408 "Dominica (Leeward Islands)" ,add
	label def countryofcitizenship 7412 "Liberia" ,add
	label def countryofcitizenship 7416 "Libya" ,add
	label def countryofcitizenship 7420 "Liechtenstein" ,add
	label def countryofcitizenship 7422 "Lithuania" ,add
	label def countryofcitizenship 7428 "Luxembourg" ,add
	label def countryofcitizenship 7430 "Macao" ,add
	label def countryofcitizenship 7431 "Macedonia, The Former Yugoslav Rep. of" ,add
	label def countryofcitizenship 7432 "Madagascar" ,add
	label def countryofcitizenship 7436 "Malawi" ,add
	label def countryofcitizenship 7444 "Malaysia" ,add
	label def countryofcitizenship 7448 "Maldives" ,add
	label def countryofcitizenship 7452 "Mali" ,add
	label def countryofcitizenship 7456 "Malta" ,add
	label def countryofcitizenship 7458 "Martinique" ,add
	label def countryofcitizenship 7464 "Mauritania" ,add
	label def countryofcitizenship 7468 "Mauritius" ,add
	label def countryofcitizenship 7470 "Mayotte" ,add
	label def countryofcitizenship 7472 "Mexico" ,add
	label def countryofcitizenship 7474 "Moldova" ,add
	label def countryofcitizenship 7476 "Monaco" ,add
	label def countryofcitizenship 7482 "Mongolia" ,add
	label def countryofcitizenship 7483 "Montserrat" ,add
	label def countryofcitizenship 7484 "Morocco" ,add
	label def countryofcitizenship 7486 "Montenegro" ,add
	label def countryofcitizenship 7488 "Mozambique" ,add
	label def countryofcitizenship 7494 "Nauru" ,add
	label def countryofcitizenship 7496 "Nepal" ,add
	label def countryofcitizenship 7500 "Netherlands" ,add
	label def countryofcitizenship 7504 "Netherlands Antilles" ,add
	label def countryofcitizenship 7506 "New Caledonia" ,add
	label def countryofcitizenship 7516 "Vanuatu" ,add
	label def countryofcitizenship 7520 "New Zealand" ,add
	label def countryofcitizenship 7524 "Nicaragua" ,add
	label def countryofcitizenship 7528 "Niger" ,add
	label def countryofcitizenship 7532 "Nigeria" ,add
	label def countryofcitizenship 7536 "Niue" ,add
	label def countryofcitizenship 7540 "Norfolk Island" ,add
	label def countryofcitizenship 7544 "Norway" ,add
	label def countryofcitizenship 7548 "Pakistan" ,add
	label def countryofcitizenship 7550 "Palau" ,add
	label def countryofcitizenship 7551 "Palestinian Territory, Occupied" ,add
	label def countryofcitizenship 7552 "Panama" ,add
	label def countryofcitizenship 7554 "Paracel Islands" ,add
	label def countryofcitizenship 7556 "New Guinea (Papua)" ,add
	label def countryofcitizenship 7560 "Paraguay" ,add
	label def countryofcitizenship 7564 "Peru" ,add
	label def countryofcitizenship 7568 "Philippines" ,add
	label def countryofcitizenship 7572 "Pitcairn Island" ,add
	label def countryofcitizenship 7576 "Poland" ,add
	label def countryofcitizenship 7580 "Portugal (Azores)" ,add
	label def countryofcitizenship 7584 "Guinea-Bissau (Portugese Guinea)" ,add
	label def countryofcitizenship 7588 "Qatar" ,add
	label def countryofcitizenship 7592 "Reunion" ,add
	label def countryofcitizenship 7596 "Zimbabwe (Rhodesia)" ,add
	label def countryofcitizenship 7604 "Romania" ,add
	label def countryofcitizenship 7606 "Russian Federation" ,add
	label def countryofcitizenship 7608 "Rwanda" ,add
	label def countryofcitizenship 7610 "Saint Lucia" ,add
	label def countryofcitizenship 7612 "St.Pierre + Miquelon" ,add
	label def countryofcitizenship 7614 "Saint Vincent/Grenadines" ,add
	label def countryofcitizenship 7615 "Samoa" ,add
	label def countryofcitizenship 7616 "San Marino" ,add
	label def countryofcitizenship 7620 "Sao Tome & Principe (Rio De Ouro)" ,add
	label def countryofcitizenship 7622 "Saint Barthelemy" ,add
	label def countryofcitizenship 7624 "Saint Martin" ,add
	label def countryofcitizenship 7628 "Saudi Arabia" ,add
	label def countryofcitizenship 7636 "Senegal" ,add
	label def countryofcitizenship 7638 "Serbia" ,add
	label def countryofcitizenship 7640 "Seychelles" ,add
	label def countryofcitizenship 7644 "Sierra Leone" ,add
	label def countryofcitizenship 7652 "Singapore" ,add
	label def countryofcitizenship 7653 "Slovakia" ,add
	label def countryofcitizenship 7654 "Slovenia" ,add
	label def countryofcitizenship 7656 "Solomon Islands" ,add
	label def countryofcitizenship 7660 "Somalia" ,add
	label def countryofcitizenship 7664 "South Africa" ,add
	label def countryofcitizenship 7668 "Namibia" ,add
	label def countryofcitizenship 7670 "South Georgia & the South Sandwich Islands" ,add
	label def countryofcitizenship 7672 "Spain" ,add
	label def countryofcitizenship 7673 "Spratly Islands" ,add
	label def countryofcitizenship 7676 "St. Helena" ,add
	label def countryofcitizenship 7680 "Sudan" ,add
	label def countryofcitizenship 7684 "Suriname" ,add
	label def countryofcitizenship 7686 "Svalbard And Jan Mayen Islands" ,add
	label def countryofcitizenship 7688 "Swaziland" ,add
	label def countryofcitizenship 7692 "Sweden" ,add
	label def countryofcitizenship 7696 "Switzerland" ,add
	label def countryofcitizenship 7700 "Syria" ,add
	label def countryofcitizenship 7704 "Tajikistan" ,add
	label def countryofcitizenship 7706 "Tanzania" ,add
	label def countryofcitizenship 7708 "Thailand" ,add
	label def countryofcitizenship 7712 "Togo" ,add
	label def countryofcitizenship 7714 "Tokelau" ,add
	label def countryofcitizenship 7716 "Tonga" ,add
	label def countryofcitizenship 7720 "Trinidad + Tobago" ,add
	label def countryofcitizenship 7728 "Tunisia" ,add
	label def countryofcitizenship 7732 "Turkey" ,add
	label def countryofcitizenship 7734 "Turks & Caicos Islands" ,add
	label def countryofcitizenship 7736 "Turkmenistan" ,add
	label def countryofcitizenship 7738 "Tuvalu (Ellice Island)" ,add
	label def countryofcitizenship 7740 "Uganda" ,add
	label def countryofcitizenship 7742 "Ukraine" ,add
	label def countryofcitizenship 7744 "Soviet Union (USSR)" ,add
	label def countryofcitizenship 7748 "Egypt" ,add
	label def countryofcitizenship 7752 "United Kingdom" ,add
	label def countryofcitizenship 7756 "Burkina Faso (Upper Volta)" ,add
	label def countryofcitizenship 7760 "Uraguay" ,add
	label def countryofcitizenship 7762 "Uzbekistan" ,add
	label def countryofcitizenship 7764 "Vatican" ,add
	label def countryofcitizenship 7766 "Venezuela" ,add
	label def countryofcitizenship 7768 "Vietnam" ,add
	label def countryofcitizenship 7772 "Virgin Islands (British)" ,add
	label def countryofcitizenship 7777 "Western Sahara" ,add
	label def countryofcitizenship 7778 "West Bank" ,add
	label def countryofcitizenship 7782 "Wallis & Futuna Islands" ,add
	label def countryofcitizenship 7784 "Western Somoa" ,add
	label def countryofcitizenship 7789 "Oman" ,add
	label def countryofcitizenship 7792 "Yemen Arab Rep" ,add
	label def countryofcitizenship 7794 "United Arab Emirates" ,add
	label def countryofcitizenship 7796 "Yugoslavia" ,add
	label def countryofcitizenship 7798 "Zambia" ,add
	label def countryofcitizenship 7801 "Marshall Islands" ,add
	label def countryofcitizenship 7810 "Micronesia, Fed States of" ,add
	label def countryofcitizenship 7815 "Zaire" ,add
label def countryofcitizenship 7900 "United States" ,add
	label def countryofcitizenship .a "0" ,add
	label def countryofcitizenship .b "9000" ,add
	label def countryofcitizenship .c "9001" ,add
	label def countryofcitizenship .d "9002" ,add
	label def countryofcitizenship .e "9999" ,add
	
label val countryofcitizenship countryofcitizenship
label variable countryofcitizenship "Country Of Citizenship"


*** collegepreparatoryenglish
*    p 123 in 2016 OPSMAN

qui destring collegepreparatoryenglish, replace

*di "`year' `term'"
*tab collegepreparatoryenglish if collegepreparatoryenglish<0 | collegepreparatoryenglish>16
* According to the 2016 OPSMAN the valid range is [0,16]. However ,there are 
* a non trivial number of entries that are >16 (it is a very small percentage,
* but it happens in most years, sometimes as often as a couple hundred.
* Some is likely data entry error (it is unlikely that students have 80
* semesters of college prep english) but could some be correct? I don't know.
* TURNING EVERYTHING OUTSIDE THE VALID RANGE TO MISSING

qui replace collegepreparatoryenglish = . if collegepreparatoryenglish<0 | collegepreparatoryenglish>16

rename collegepreparatoryenglish cprepeng
label var cprepeng "Sem Col Prep Eng"


*** collegepreparatorymathematics
*    p 129 in 2016 OPSMAN

qui destring collegepreparatorymathematics, replace

*di "`year' `term'"
*tab collegepreparatorymathematics if collegepreparatorymathematics<0 | collegepreparatorymathematics>16
* According to the 2016 OPSMAN the valid range is [0,16]. However ,there are 
* a non trivial number of entries that are >16 (it is a very small percentage,
* but it happens in most years, sometimes as often as a couple hundred.
* Some is likely data entry error (it is unlikely that students have 80
* semesters of college prep english) but could some be correct? I don't know.
* TURNING EVERYTHING OUTSIDE THE VALID RANGE TO MISSING

qui replace collegepreparatorymathematics = . if collegepreparatorymathematics<0 | collegepreparatorymathematics>16

rename collegepreparatorymathematics cprepmath
label var cprepmath "Sem Col Prep Math"


*** degreeobjectivecode
*    p 181 in 2016 OPSMAN

qui replace degreeobjectivecode = trim(degreeobjectivecode)
qui replace degreeobjectivecode = "." if degreeobjectivecode =="*"

qui destring degreeobjectivecode, replace

*di "`year' `term'"
*tab degreeobjectivecode if !inlist(degreeobjectivecode, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
* no observations outside the list

label def degreeobjectivecode 0 "None"
label def degreeobjectivecode 1 "2-year undergrad program", add
label def degreeobjectivecode 2 "BA", add
label def degreeobjectivecode 3 "BS",add
label def degreeobjectivecode 4 "Other Bachelor's",add
label def degreeobjectivecode 5 "MA",add
label def degreeobjectivecode 6 "MS",add
label def degreeobjectivecode 7 "Other Master's",add
label def degreeobjectivecode 8 "Doctorate",add
label def degreeobjectivecode 9 "Bach+Masters (4+1 prog)",add
	
label val degreeobjectivecode degreeobjectivecode
label var degreeobjectivecode "Degree Objective Code"
rename degreeobjectivecode degreeobj


*** enrollmentstatus
*    p 217 in 2016 OPSMAN

qui replace enrollmentstatus = trim(enrollmentstatus)
qui replace enrollmentstatus = "." if enrollmentstatus =="*"
qui replace enrollmentstatus = "." if enrollmentstatus =="?"
qui replace enrollmentstatus = "." if enrollmentstatus =="R"
* something is weird in 20084
qui replace enrollmentstatus = "." if inlist(enrollmentstatus, "A", "B", "C", "D", "F", "G", "H", "J", "K")
qui replace enrollmentstatus = "." if inlist(enrollmentstatus, "M", "N", "P", "Q", "S", "T", "V")
qui replace enrollmentstatus = ".a" if enrollmentstatus =="0"
qui replace enrollmentstatus = ".b" if enrollmentstatus =="9"

qui destring enrollmentstatus, replace

*di "`year' `term'"
*tab enrollmentstatus if !inlist(enrollmentstatus, 1, 2, 3, 4, 5, 6, 7, 8)

label def enrollmentstatus 1 "Continuing"
label def enrollmentstatus 2 "Returning", add
label def enrollmentstatus 3 "Returning Transfer", add
label def enrollmentstatus 4 "Transfer",add
label def enrollmentstatus 5 "1st Time Student",add
label def enrollmentstatus 6 "Transitory",add
label def enrollmentstatus 7 "Summer Early Ent Transitory",add
label def enrollmentstatus 8 "Early Start Prog Transitory",add
label def enrollmentstatus .a "0",add
label def enrollmentstatus .b "9",add

label val enrollmentstatus enrollmentstatus
label var enrollmentstatus "Enrollment Status"
rename enrollmentstatus enrollstat


*** ethiccode
*    p 234 in 2016 OPSMAN

qui replace ethniccode = trim(ethniccode)

qui generate ethnicdetail = .
qui replace ethnicdetail = 100 if ethniccode == "1"
qui replace ethnicdetail = 200 if ethniccode == "2"
qui replace ethnicdetail = 301 if ethniccode == "3"
qui replace ethnicdetail = 302 if ethniccode == "A"
qui replace ethnicdetail = 303 if ethniccode == "B"
qui replace ethnicdetail = 304 if ethniccode == "Q"
qui replace ethnicdetail = 305 if ethniccode == "P"
qui replace ethnicdetail = 306 if ethniccode == "4"
qui replace ethnicdetail = 401 if ethniccode == "C"
qui replace ethnicdetail = 402 if ethniccode == "J"
qui replace ethnicdetail = 403 if ethniccode == "K"
qui replace ethnicdetail = 404 if ethniccode == "R"
qui replace ethnicdetail = 405 if ethniccode == "5"
qui replace ethnicdetail = 406 if ethniccode == "L"
qui replace ethnicdetail = 407 if ethniccode == "M"
qui replace ethnicdetail = 408 if ethniccode == "S"
qui replace ethnicdetail = 409 if ethniccode == "T"
qui replace ethnicdetail = 410 if ethniccode == "V"
qui replace ethnicdetail = 501 if ethniccode == "G"
qui replace ethnicdetail = 502 if ethniccode == "H"
qui replace ethnicdetail = 503 if ethniccode == "N"
qui replace ethnicdetail = 504 if ethniccode == "6"
qui replace ethnicdetail = 600 if ethniccode == "F"
qui replace ethnicdetail = 700 if ethniccode == "7"
qui replace ethnicdetail = 800 if ethniccode == "8"
qui replace ethnicdetail = .a if ethniccode =="9"
qui replace ethnicdetail = .b if ethniccode == "D"

qui generate ethnic = .
qui replace ethnic = 100 if ethnicdetail == 100
qui replace ethnic = 200 if ethnicdetail == 200
qui replace ethnic = 300 if inrange(ethnicdetail, 300, 399)
qui replace ethnic = 400 if inrange(ethnicdetail, 400, 499)
qui replace ethnic = 500 if inrange(ethnicdetail, 500, 599)
qui replace ethnic = 600 if ethnicdetail == 600
qui replace ethnic = 700 if ethnicdetail == 700
qui replace ethnic = 800 if ethnicdetail == 800
qui replace ethnic = .a if ethnicdetail == .a
qui replace ethnic = .b if ethnicdetail == .b

*di "`year' `term'"
*tab ethniccode if ethnicdetail ==.
* almost no observations

label define ethnicdetail ///
100 "Am Ind or Al Nat" ///
200 "African American" ///
300 "Latino" ///
301 "Mexican" ///
302 "Central American" ///
303 "South American" ///
304 "Cuban" ///
305 "Puerto Rican" ///
306 "Other Latino" ///
400 "Asian" ///
401 "Chinese" ///
402 "Japanese" ///
403 "Korean" ///
404 "Asian Indian" ///
405 "Other Asian (Not S.E.)" ///
406 "Laotian" ///
407 "Cambodian" ///
408 "Other S.E. Asian" ///
409 "Thai" ///
410 "Vietnamese" ///
500 "Pacific Islander" ///
501 "Guamanian" ///
502 "Hawaiian" ///
503 "Samoan" ///
504 "Other Pac. Is." ///
600 "Filipino" ///
700 "White" ///
800 "Other" ///
.a "No Responce" ///
.b "Decline To State"

label val ethnicdetail ethnicdetail
label val ethnic ethnicdetail

label var ethnicdetail "Ethnicity, detailed"
label var ethnic "Ethnicity, aggregated"

drop ethniccode


*** highschoolgpa
*    p 255 in 2016 OPSMAN

*di "`year' `term'"
qui destring highschoolgpa, replace force
*tab highschoolgpa if !inrange(highschoolgpa, 0, 500)
* a few could be real GPA, but mainly not. It looks like 999 might have been some sort of missing code.
*count if highschoolgpa == 0
* There are a lot of zeros. The codebook says it is an acceptable value, but
* Jake codes it as missing. I'm going to folow his lead.

*** NOPE - Since talked to the CSUs and coding zeros as zeros.

qui replace highschoolgpa = . if !inrange(highschoolgpa, 0, 500)

rename highschoolgpa hsgpa
label var hsgpa "High School GPA"


*** institutionorigincode
*    p 271 in 2016 OPSMAN

* There is a COSAR table with all the institution origion codes, so it is 
* possible to label them. I think this will take time and make the data
* messy, and I don't think that we'll need the info, but if I'm wrong it
* should be doable.

qui generate institutionorigintype = substr(institutionorigincode,3,1)
qui destring institutionorigintype, generate(instorgtype) force
qui replace instorgtype = . if instorgtype == 0
qui replace instorgtype = 3 if instorgtype == 9
qui replace instorgtype = 1 if instorgtype == 4

*di "`year' `term'"
*tab institutionorigintype if instorgtype==., missing
* all the missings are "s" (or blank probably, I didn't type ", missing"
* until after I ran the loop and I'm not running it again for this.

label define instorgtype ///
1 "CA Private HS (1/4)" ///
2 "Other CA Institutions (2)" ///
3 "CA Public HS (3/9)" ///
5 "CA Comm Coll (5)" ///
6 "CSU (6)" ///
7 "UC (7)" ///
8 "CA Independent Coll/U (8)"

label val instorgtype instorgtype
label var instorgtype "Instutution of Origin Type"

drop institutionorigintype

*di "`year' `term'"
qui destring institutionorigincode, replace force
qui replace institutionorigincode = . if !inrange(institutionorigincode, 0, 999999)
rename institutionorigincode institutionorigin
label var institutionorigin "Instutution of Origin Code"


*** majoroptionconcentrationofemphas
*    there isn't a page, but I think this is the same as the "Major Code"
*    p 279 in 2016 OPSMAN (That's the page for Major Codes)

capture rename majoroptionconcentrationor majoroptionconcentrationoremphas

*di "`year' `term'"
qui replace majoroptionconcentrationoremphas = trim(majoroptionconcentrationoremphas)
qui replace majoroptionconcentrationoremphas = "." if majoroptionconcentrationoremphas=="NONE"
qui replace majoroptionconcentrationoremphas = "." if majoroptionconcentrationoremphas=="7RF3T"
qui replace majoroptionconcentrationoremphas = "." if majoroptionconcentrationoremphas=="0329A"

qui generate majorocedd = substr(majoroptionconcentrationoremphas,1,2)
qui destring majorocedd, replace

qui destring majoroptionconcentrationoremphas, replace

	label def majoroptionconcentrationoremphas 0 "Undeclared", add
	label def majoroptionconcentrationoremphas 121 "PRE-NURSING", add
	label def majoroptionconcentrationoremphas 1011 "Agriculture", add
	label def majoroptionconcentrationoremphas 1012 "Agriculture Education", add
	label def majoroptionconcentrationoremphas 1013 "International Agriculture", add
	label def majoroptionconcentrationoremphas 1014 "Agricultural Studies", add
	label def majoroptionconcentrationoremphas 1021 "Agronomy/Crop Science", add
	label def majoroptionconcentrationoremphas 1031 "Soil Science", add
	label def majoroptionconcentrationoremphas 1041 "Animal Science", add
	label def majoroptionconcentrationoremphas 1042 "Pre-Veterinary Studies", add
	label def majoroptionconcentrationoremphas 1043 "Animal Health Science", add
	label def majoroptionconcentrationoremphas 1051 "Dairy Science", add
	label def majoroptionconcentrationoremphas 1061 "Poultry Science", add
	label def majoroptionconcentrationoremphas 1071 "Fisheries", add
	label def majoroptionconcentrationoremphas 1072 "Wildlife Mgmt.", add
	label def majoroptionconcentrationoremphas 1081 "Horticulture/Fruit Science", add
	label def majoroptionconcentrationoremphas 1082 "Viticulture", add
	label def majoroptionconcentrationoremphas 1091 "Ornamental Horticulture", add
	label def majoroptionconcentrationoremphas 1101 "Farm Management", add
	label def majoroptionconcentrationoremphas 1111 "Agri. Economics", add
	label def majoroptionconcentrationoremphas 1120 "Agri. Business", add
	label def majoroptionconcentrationoremphas 1121 "Agricultural Business", add
	label def majoroptionconcentrationoremphas 1122 "Wine Business Strategies", add
	label def majoroptionconcentrationoremphas 1130 "Food Science and Technology", add
	label def majoroptionconcentrationoremphas 1131 "Food Science", add
	label def majoroptionconcentrationoremphas 1132 "Enology", add
	label def majoroptionconcentrationoremphas 1141 "Forestry", add
	label def majoroptionconcentrationoremphas 1151 "Natural Resources", add
	label def majoroptionconcentrationoremphas 1152 "Watershed Management", add
	label def majoroptionconcentrationoremphas 1153 "Natural Resources Planning", add
	label def majoroptionconcentrationoremphas 1154 "Wastewater Utilization", add
	label def majoroptionconcentrationoremphas 1155 "Ecological Economics", add
	label def majoroptionconcentrationoremphas 1161 "Agricultural Mechanics", add
	label def majoroptionconcentrationoremphas 1171 "Rangeland Resource Science", add
	label def majoroptionconcentrationoremphas 1991 "Agricultural Biology/Plant Science", add
	label def majoroptionconcentrationoremphas 1992 "Agricultural Chemistry", add
	label def majoroptionconcentrationoremphas 1993 "Landscape Irrigation Science", add
	label def majoroptionconcentrationoremphas 2011 "Environmental Design", add
	label def majoroptionconcentrationoremphas 2020 "Architecture", add
	label def majoroptionconcentrationoremphas 2021 "Architecture", add
	label def majoroptionconcentrationoremphas 2022 "Interior Architecture", add
	label def majoroptionconcentrationoremphas 2031 "Interior Design", add
	label def majoroptionconcentrationoremphas 2041 "Landscape Architecture", add
	label def majoroptionconcentrationoremphas 2061 "City/Regional Plng.", add
	label def majoroptionconcentrationoremphas 2062 "Rural And Town Planning", add
	label def majoroptionconcentrationoremphas 3011 "Asian Studies", add
	label def majoroptionconcentrationoremphas 3021 "East Asian Studies", add
	label def majoroptionconcentrationoremphas 3031 "India Studies", add
	label def majoroptionconcentrationoremphas 3071 "Russian/Central European Studies", add
	label def majoroptionconcentrationoremphas 3081 "Latin Amer. Studies", add
	label def majoroptionconcentrationoremphas 3085 "CENTRAL AMERICAN STUDIES", add
	label def majoroptionconcentrationoremphas 3101 "European Studies", add
	label def majoroptionconcentrationoremphas 3121 "French Studies", add
	label def majoroptionconcentrationoremphas 3122 "Italian Studies", add
	label def majoroptionconcentrationoremphas 3131 "American Studies", add
	label def majoroptionconcentrationoremphas 3132 "California Studies", add
	label def majoroptionconcentrationoremphas 4011 "Biological Science", add
	label def majoroptionconcentrationoremphas 4012 "Environmental Biology", add
	label def majoroptionconcentrationoremphas 4021 "Botany", add
	label def majoroptionconcentrationoremphas 4031 "Bacteriology", add
	label def majoroptionconcentrationoremphas 4071 "Zoology", add
	label def majoroptionconcentrationoremphas 4101 "Physiology", add
	label def majoroptionconcentrationoremphas 4111 "Microbiology", add
	label def majoroptionconcentrationoremphas 4121 "Anatomy", add
	label def majoroptionconcentrationoremphas 4141 "Biochemistry", add
	label def majoroptionconcentrationoremphas 4151 "Biophysics", add
	label def majoroptionconcentrationoremphas 4152 "Biomedical Physics", add
	label def majoroptionconcentrationoremphas 4153 "Biomedical Science", add
	label def majoroptionconcentrationoremphas 4161 "Molecular Biology", add
	label def majoroptionconcentrationoremphas 4171 "Cell Biology", add
	label def majoroptionconcentrationoremphas 4181 "Marine Biology", add
	label def majoroptionconcentrationoremphas 4191 "Biostatistics and Biometry", add
	label def majoroptionconcentrationoremphas 4201 "Ecology", add
	label def majoroptionconcentrationoremphas 4202 "Conservation Biology", add
	label def majoroptionconcentrationoremphas 4211 "Entomology", add
	label def majoroptionconcentrationoremphas 4221 "Genetics", add
	label def majoroptionconcentrationoremphas 4261 "Toxicology", add
	label def majoroptionconcentrationoremphas 4991 "Biotechnology", add
	label def majoroptionconcentrationoremphas 5011 "Business Administration", add
	label def majoroptionconcentrationoremphas 5012 "Business Education", add
	label def majoroptionconcentrationoremphas 5013 "E-Business", add
	label def majoroptionconcentrationoremphas 5015 "CONCRETE INDUSTRY MANAGEMENT", add
	label def majoroptionconcentrationoremphas 5016 "BUSINESS ADMINISTRATION AND LIFE SCIENCES", add
	label def majoroptionconcentrationoremphas 5017 "CONCRETE INDUSTRY MANAGEMENT", add
	label def majoroptionconcentrationoremphas 5021 "Accountancy", add
	label def majoroptionconcentrationoremphas 5022 "Taxation", add
	label def majoroptionconcentrationoremphas 5023 "INTERNAL AUDIT", add
	label def majoroptionconcentrationoremphas 5041 "Finance", add
	label def majoroptionconcentrationoremphas 5042 "Banking", add
	label def majoroptionconcentrationoremphas 5043 "Financial Services", add
	label def majoroptionconcentrationoremphas 5044 "Corporate Financial Management", add
	label def majoroptionconcentrationoremphas 5061 "Management", add
	label def majoroptionconcentrationoremphas 5062 "Office Systems", add
	label def majoroptionconcentrationoremphas 5063 "Industrial Management", add
	label def majoroptionconcentrationoremphas 5064 "Production and Operations Mgmt", add
	label def majoroptionconcentrationoremphas 5065 "High-Technology Management", add
	label def majoroptionconcentrationoremphas 5066 "Non-Profit Management", add
	label def majoroptionconcentrationoremphas 5067 "Medical Product Development Management", add
	label def majoroptionconcentrationoremphas 5068 "Business and Technology", add
	label def majoroptionconcentrationoremphas 5071 "Quantitative Methods/Analysis", add
	label def majoroptionconcentrationoremphas 5072 "Management Sci/Operations Res", add
	label def majoroptionconcentrationoremphas 5081 "Hotel/Hospitality Management", add
	label def majoroptionconcentrationoremphas 5082 "Travel and Tourism", add
	label def majoroptionconcentrationoremphas 5083 "Entertainment / Tourism Management", add
	label def majoroptionconcentrationoremphas 5084 "Sports Management", add
	label def majoroptionconcentrationoremphas 5091 "Marketing", add
	label def majoroptionconcentrationoremphas 5092 "Retailing", add
	label def majoroptionconcentrationoremphas 5101 "Transportation", add
	label def majoroptionconcentrationoremphas 5105 "Global Supply Chain Management", add
	label def majoroptionconcentrationoremphas 5111 "Real Estate", add
	label def majoroptionconcentrationoremphas 5112 "Urban Land Development", add
	label def majoroptionconcentrationoremphas 5121 "Insurance and Risk Management", add
	label def majoroptionconcentrationoremphas 5131 "INTERNATIONAL BUSINESS", add
	label def majoroptionconcentrationoremphas 5141 "Secretarial Studies", add
	label def majoroptionconcentrationoremphas 5151 "Personnel Management", add
	label def majoroptionconcentrationoremphas 5161 "Industrial Relations", add
	label def majoroptionconcentrationoremphas 5171 "Business Economics", add
	label def majoroptionconcentrationoremphas 5991 "Business Computer Telecomm", add
	label def majoroptionconcentrationoremphas 5992 "Public Relations", add
	label def majoroptionconcentrationoremphas 5993 "Business, Special Interest", add
	label def majoroptionconcentrationoremphas 5995 "Business, Legal", add
	label def majoroptionconcentrationoremphas 5996 "Small Business Management", add
	label def majoroptionconcentrationoremphas 5997 "Entrepreneurship", add
	label def majoroptionconcentrationoremphas 6010 "MASS MEDIA", add
	label def majoroptionconcentrationoremphas 6011 "Communications", add
	label def majoroptionconcentrationoremphas 6012 "Communication Design", add
	label def majoroptionconcentrationoremphas 6021 "Journalism", add
	label def majoroptionconcentrationoremphas 6031 "Radio/TV", add
	label def majoroptionconcentrationoremphas 6032 "MEDIA MGMT", add
	label def majoroptionconcentrationoremphas 6033 "Telecommunications and Film", add
	label def majoroptionconcentrationoremphas 6034 "SCREENWRITING", add
	label def majoroptionconcentrationoremphas 6041 "Advertising", add
	label def majoroptionconcentrationoremphas 6991 "Multimedia", add
	label def majoroptionconcentrationoremphas 6992 "Telecommunications/Multimedia", add
	label def majoroptionconcentrationoremphas 6993 "Digital Publishing", add
	label def majoroptionconcentrationoremphas 7011 "Computer Science", add
	label def majoroptionconcentrationoremphas 7012 "COMPUTER SCIENCE AND INFORMATION TECHNOLOGY", add
	label def majoroptionconcentrationoremphas 7021 "Information Systems", add
	label def majoroptionconcentrationoremphas 7022 "Accounting Information Systems", add
	label def majoroptionconcentrationoremphas 7023 "Management Information Systems", add
	label def majoroptionconcentrationoremphas 7024 "Financial Computer Systems", add
	label def majoroptionconcentrationoremphas 7025 "Production/Operatiuons Information Systems", add
	label def majoroptionconcentrationoremphas 7026 "Computer Systems", add
	label def majoroptionconcentrationoremphas 7027 "Knowledge Management", add
	label def majoroptionconcentrationoremphas 7028 "Infomation Technology", add
	label def majoroptionconcentrationoremphas 7029 "Computer Networks", add
	label def majoroptionconcentrationoremphas 7030 "Information Technology and Communication Design", add
	label def majoroptionconcentrationoremphas 7051 "Cybernetic Systems/Sys Sci", add
	label def majoroptionconcentrationoremphas 7052 "Software Engineering", add
	label def majoroptionconcentrationoremphas 7991 "Telecommunication Systems", add
	label def majoroptionconcentrationoremphas 7992 "Computational Science", add
	label def majoroptionconcentrationoremphas 7993 "Applied Computer Graphics", add
	label def majoroptionconcentrationoremphas 7994 "BIOINFORMATICS", add
	label def majoroptionconcentrationoremphas 8011 "Education", add
	label def majoroptionconcentrationoremphas 8021 "Elementary Educ.", add
	label def majoroptionconcentrationoremphas 8031 "Secondary Educ.", add
	label def majoroptionconcentrationoremphas 8051 "Higher Education", add
	label def majoroptionconcentrationoremphas 8061 "Community College Education", add
	label def majoroptionconcentrationoremphas 8071 "Adult Education", add
	label def majoroptionconcentrationoremphas 8081 "Special Education", add
	label def majoroptionconcentrationoremphas 8091 "Special Educ. - Admin.", add
	label def majoroptionconcentrationoremphas 8101 "Spec.Educ.-Mental.Retard.", add
	label def majoroptionconcentrationoremphas 8111 "Spec.Educ.-Gifted", add
	label def majoroptionconcentrationoremphas 8121 "Spec.Educ.-Deaf", add
	label def majoroptionconcentrationoremphas 8131 "Equity and Social Justice", add
	label def majoroptionconcentrationoremphas 8141 "Spec.Educ.-Vis.Hand.", add
	label def majoroptionconcentrationoremphas 8142 "Spec.Educ.-Orientat/Mobil.", add
	label def majoroptionconcentrationoremphas 8181 "Spec.Educ.-Learn.Disabl.", add
	label def majoroptionconcentrationoremphas 8191 "Spec.Educ.-Ortho.Hand.", add
	label def majoroptionconcentrationoremphas 8201 "Spec.Educ.-Severely Hand.", add
	label def majoroptionconcentrationoremphas 8211 "Educ. Theory", add
	label def majoroptionconcentrationoremphas 8221 "Educational Psychology", add
	label def majoroptionconcentrationoremphas 8225 "English", add
	label def majoroptionconcentrationoremphas 8231 "Child Development/ECE", add
	label def majoroptionconcentrationoremphas 8232 "Early Childhood Studies", add
	label def majoroptionconcentrationoremphas 8241 "Educational Research", add
	label def majoroptionconcentrationoremphas 8261 "Counseling/Guide.", add
	label def majoroptionconcentrationoremphas 8271 "Educ. Administration", add
	label def majoroptionconcentrationoremphas 8272 "Educational Leadership CSU EdD  P-12", add
	label def majoroptionconcentrationoremphas 8273 "Educational Leadership-CSU EdD Community College", add
	label def majoroptionconcentrationoremphas 8281 "Educ. Supervision", add
	label def majoroptionconcentrationoremphas 8291 "Educ.-Curric/Instr.", add
	label def majoroptionconcentrationoremphas 8292 "Teaching", add
	label def majoroptionconcentrationoremphas 8301 "Educ.-Reading", add
	label def majoroptionconcentrationoremphas 8341 "Environmental Education", add
	label def majoroptionconcentrationoremphas 8351 "Kinesiology/Physical Education", add
	label def majoroptionconcentrationoremphas 8352 "Physical Education, Men", add
	label def majoroptionconcentrationoremphas 8353 "Physical Education, Women", add
	label def majoroptionconcentrationoremphas 8355 "Exercise Scncs/Physiology & Movement Studies", add
	label def majoroptionconcentrationoremphas 8356 "Exercise Physiology & Nutritional Science", add
	label def majoroptionconcentrationoremphas 8357 "Excercise Science", add
	label def majoroptionconcentrationoremphas 8371 "Health Educ.", add
	label def majoroptionconcentrationoremphas 8375 "Athletic training", add
	label def majoroptionconcentrationoremphas 8391 "Industrial Design", add
	label def majoroptionconcentrationoremphas 8392 "Graphic Communications", add
	label def majoroptionconcentrationoremphas 8393 "Industrial Arts", add
	label def majoroptionconcentrationoremphas 8394 "Industrial Technology", add
	label def majoroptionconcentrationoremphas 8395 "Career and Technical Studies", add
	label def majoroptionconcentrationoremphas 8396 "Aviation", add
	label def majoroptionconcentrationoremphas 8992 "Instruct. Media", add
	label def majoroptionconcentrationoremphas 8993 "Educ.-Special Int.", add
	label def majoroptionconcentrationoremphas 8994 "Bilingual Educ.", add
	label def majoroptionconcentrationoremphas 8995 "Computer-Based Education", add
	label def majoroptionconcentrationoremphas 8996 "School Librarianship", add
	label def majoroptionconcentrationoremphas 8997 "Science Teacher Education, General", add
	label def majoroptionconcentrationoremphas 8998 "Teaching Internatl Languages", add
	label def majoroptionconcentrationoremphas 9011 "Engineering", add
	label def majoroptionconcentrationoremphas 9012 "Engr Science", add
	label def majoroptionconcentrationoremphas 9013 "Systems Engr", add
	label def majoroptionconcentrationoremphas 9021 "Aerospace Engr", add
	label def majoroptionconcentrationoremphas 9022 "Aeronautical Engineering", add
	label def majoroptionconcentrationoremphas 9023 "Astronautics", add
	label def majoroptionconcentrationoremphas 9031 "Agricult. Engr", add
	label def majoroptionconcentrationoremphas 9041 "Architect. Engr", add
	label def majoroptionconcentrationoremphas 9051 "Biomedical Engr", add
	label def majoroptionconcentrationoremphas 9052 "Biochemical Engineering", add
	label def majoroptionconcentrationoremphas 9061 "Chemical Engr", add
	label def majoroptionconcentrationoremphas 9071 "Petroleum Engr", add
	label def majoroptionconcentrationoremphas 9081 "Civil Engr", add
	label def majoroptionconcentrationoremphas 9082 "Construction Engineering", add
	label def majoroptionconcentrationoremphas 9083 "Transportation Engineering", add
	label def majoroptionconcentrationoremphas 9084 "Structural Engineering", add
	label def majoroptionconcentrationoremphas 9085 "Water Resources Engineering", add
	label def majoroptionconcentrationoremphas 9091 "Electrical Engr", add
	label def majoroptionconcentrationoremphas 9092 "Electronic Engr", add
	label def majoroptionconcentrationoremphas 9093 "Elec/Electr Engr", add
	label def majoroptionconcentrationoremphas 9094 "Computer Engr", add
	label def majoroptionconcentrationoremphas 9095 "Electrical and Computer Engineering", add
	label def majoroptionconcentrationoremphas 9101 "Mechanical Engr", add
	label def majoroptionconcentrationoremphas 9102 "MECHATRONIC ENGR", add
	label def majoroptionconcentrationoremphas 9131 "Industrial Engineering", add
	label def majoroptionconcentrationoremphas 9132 "Industrial Administration", add
	label def majoroptionconcentrationoremphas 9134 "Manufacturing Engr", add
	label def majoroptionconcentrationoremphas 9141 "Metallurgical Engr", add
	label def majoroptionconcentrationoremphas 9151 "Materials Engr", add
	label def majoroptionconcentrationoremphas 9201 "Nuclear Engr", add
	label def majoroptionconcentrationoremphas 9211 "Engineering-Applied Mechanics", add
	label def majoroptionconcentrationoremphas 9221 "Environ.Engr", add
	label def majoroptionconcentrationoremphas 9222 "Environmental Resources Engr", add
	label def majoroptionconcentrationoremphas 9241 "Ocean Engr", add
	label def majoroptionconcentrationoremphas 9251 "Engineering Technology", add
	label def majoroptionconcentrationoremphas 9252 "Surveying/Photogrammetry", add
	label def majoroptionconcentrationoremphas 9253 "Air Condition Technology", add
	label def majoroptionconcentrationoremphas 9254 "Construction Engr Tech/Mgmt", add
	label def majoroptionconcentrationoremphas 9255 "Electronic Technology", add
	label def majoroptionconcentrationoremphas 9256 "Manufacturing Technology", add
	label def majoroptionconcentrationoremphas 9257 "Mechanical Technology", add
	label def majoroptionconcentrationoremphas 9258 "MARINE ENGINEERING TECH", add
	label def majoroptionconcentrationoremphas 9259 "Computer Engineering Technology", add
	label def majoroptionconcentrationoremphas 9261 "Engineering Mathematics", add
	label def majoroptionconcentrationoremphas 9262 "ENVIRON ENGR TECH", add
	label def majoroptionconcentrationoremphas 9263 "Facilities Engineering Technology", add
	label def majoroptionconcentrationoremphas 9992 "Quality Assurance", add
	label def majoroptionconcentrationoremphas 9993 "Civil and Environmental Engr", add
	label def majoroptionconcentrationoremphas 9994 "BIOMEDICAL QUALITY SYSTEMS", add
	label def majoroptionconcentrationoremphas 9995 "CONCRETE INDUSTRY MANAGEMENT", add
	label def majoroptionconcentrationoremphas 10011 "Creative Arts", add
	label def majoroptionconcentrationoremphas 10015 "PERFORMING ARTS", add
	label def majoroptionconcentrationoremphas 10021 "Art", add
	label def majoroptionconcentrationoremphas 10022 "Art, Studio Performance", add
	label def majoroptionconcentrationoremphas 10023 "Design", add
	label def majoroptionconcentrationoremphas 10031 "Art History", add
	label def majoroptionconcentrationoremphas 10041 "Music - Perf", add
	label def majoroptionconcentrationoremphas 10051 "Music - Liberal Arts", add
	label def majoroptionconcentrationoremphas 10052 "Music Education", add
	label def majoroptionconcentrationoremphas 10053 "Music Industry & Technology", add
	label def majoroptionconcentrationoremphas 10070 "THEATRE AND FILM / OTHER", add
	label def majoroptionconcentrationoremphas 10071 "Drama", add
	label def majoroptionconcentrationoremphas 10072 "Theatre Arts (Performance)", add
	label def majoroptionconcentrationoremphas 10073 "Musical Theatre", add
	label def majoroptionconcentrationoremphas 10075 "Concurrent MBA/MFA in Theatre Management", add
	label def majoroptionconcentrationoremphas 10076 "Dramatic Writing", add
	label def majoroptionconcentrationoremphas 10081 "Dance", add
	label def majoroptionconcentrationoremphas 10082 "Dance (perfoemance)", add
	label def majoroptionconcentrationoremphas 10091 "Graphic Art/Design", add
	label def majoroptionconcentrationoremphas 10101 "Cinema/Film", add
	label def majoroptionconcentrationoremphas 10102 "Film Video Making Cinematography & Production", add
	label def majoroptionconcentrationoremphas 10111 "Photography", add
	label def majoroptionconcentrationoremphas 10992 "Arts Administration", add
	label def majoroptionconcentrationoremphas 11011 "Modern Languages & Literature", add
	label def majoroptionconcentrationoremphas 11013 "Translation/Interpretation Studies", add
	label def majoroptionconcentrationoremphas 11021 "French", add
	label def majoroptionconcentrationoremphas 11031 "German", add
	label def majoroptionconcentrationoremphas 11041 "Italian", add
	label def majoroptionconcentrationoremphas 11051 "Spanish", add
	label def majoroptionconcentrationoremphas 11061 "Russian", add
	label def majoroptionconcentrationoremphas 11071 "Chinese", add
	label def majoroptionconcentrationoremphas 11081 "Japanese", add
	label def majoroptionconcentrationoremphas 11121 "Arabic Language", add
	label def majoroptionconcentrationoremphas 12011 "Health Science", add
	label def majoroptionconcentrationoremphas 12012 "Interdisciplinary Health/Rehabilitative Science", add
	label def majoroptionconcentrationoremphas 12021 "Health Care Management", add
	label def majoroptionconcentrationoremphas 12031 "Nursing", add
	label def majoroptionconcentrationoremphas 12032 "Nursing (RN-to-Nursing Degree)", add
	label def majoroptionconcentrationoremphas 12039 "Statewide Nursing", add
	label def majoroptionconcentrationoremphas 12081 "Occupational Therapy", add
	label def majoroptionconcentrationoremphas 12121 "Physical Therapy", add
	label def majoroptionconcentrationoremphas 12141 "Public Health", add
	label def majoroptionconcentrationoremphas 12142 "Environmental/Community Health", add
	label def majoroptionconcentrationoremphas 12171 "Health Professions And Related Sciences, Other", add
	label def majoroptionconcentrationoremphas 12201 "Commuicative Disorders", add
	label def majoroptionconcentrationoremphas 12202 "Audiology", add
	label def majoroptionconcentrationoremphas 12221 "Rehabilitation Counseling", add
	label def majoroptionconcentrationoremphas 12224 "Assistive and Rehabilitative Technology", add
	label def majoroptionconcentrationoremphas 12225 "Assistive Technology Studies", add
	label def majoroptionconcentrationoremphas 12231 "Clinical/Biomed Lab Science", add
	label def majoroptionconcentrationoremphas 12232 "Nuclear Medicine Technologist", add
	label def majoroptionconcentrationoremphas 12234 "Cytotechnology", add
	label def majoroptionconcentrationoremphas 12251 "Radiological Health Physics", add
	label def majoroptionconcentrationoremphas 12991 "Public Health and Social Work", add
	label def majoroptionconcentrationoremphas 12992 "NURSING AND MPUBLIC HEALTH", add
	label def majoroptionconcentrationoremphas 12993 "Nursing & Health Care Administration", add
	label def majoroptionconcentrationoremphas 13011 "Home Economics", add
	label def majoroptionconcentrationoremphas 13031 "APPAREL MERCHANDISING", add
	label def majoroptionconcentrationoremphas 13051 "Marriage and Family Therapy", add
	label def majoroptionconcentrationoremphas 13052 "Child and Family Development", add
	label def majoroptionconcentrationoremphas 13061 "Dietetics/Food Admin/Nutrition", add
	label def majoroptionconcentrationoremphas 13991 "Apparel and Interior Design", add
	label def majoroptionconcentrationoremphas 14202 "Ecological Conservation", add
	label def majoroptionconcentrationoremphas 15011 "English", add
	label def majoroptionconcentrationoremphas 15012 "Language Studies", add
	label def majoroptionconcentrationoremphas 15013 "English Composition", add
	label def majoroptionconcentrationoremphas 15021 "English Literature", add
	label def majoroptionconcentrationoremphas 15031 "Comparative Lit.", add
	label def majoroptionconcentrationoremphas 15041 "Classics", add
	label def majoroptionconcentrationoremphas 15051 "Linguistics", add
	label def majoroptionconcentrationoremphas 15052 "Bilingual/Bicultural Studies", add
	label def majoroptionconcentrationoremphas 15061 "Speech Communication", add
	label def majoroptionconcentrationoremphas 15071 "Creative Writing", add
	label def majoroptionconcentrationoremphas 15081 "English/Second Lang", add
	label def majoroptionconcentrationoremphas 15091 "Philosophy", add
	label def majoroptionconcentrationoremphas 15101 "Religious Studies", add
	label def majoroptionconcentrationoremphas 15102 "Modern Jewish Studies", add
	label def majoroptionconcentrationoremphas 15991 "Humanities", add
	label def majoroptionconcentrationoremphas 15992 "Philos / Religion", add
	label def majoroptionconcentrationoremphas 15996 "Liberal Arts", add
	label def majoroptionconcentrationoremphas 15997 "Technical And Professional Writing", add
	label def majoroptionconcentrationoremphas 15999 "Humanities", add
	label def majoroptionconcentrationoremphas 16011 "Library Science", add
	label def majoroptionconcentrationoremphas 17011 "Mathematics", add
	label def majoroptionconcentrationoremphas 17012 "Mathematics Education", add
	label def majoroptionconcentrationoremphas 17021 "Statistics", add
	label def majoroptionconcentrationoremphas 17022 "Applied Statistics", add
	label def majoroptionconcentrationoremphas 17023 "Geographic Information Science", add
	label def majoroptionconcentrationoremphas 17031 "Applied Math", add
	label def majoroptionconcentrationoremphas 19011 "Physical Science", add
	label def majoroptionconcentrationoremphas 19021 "Physics", add
	label def majoroptionconcentrationoremphas 19025 "Applied Physics", add
	label def majoroptionconcentrationoremphas 19051 "Chemistry", add
	label def majoroptionconcentrationoremphas 19052 "Polymers and Coating Science", add
	label def majoroptionconcentrationoremphas 19081 "Chemical Physics", add
	label def majoroptionconcentrationoremphas 19111 "Astronomy", add
	label def majoroptionconcentrationoremphas 19131 "Meteorology", add
	label def majoroptionconcentrationoremphas 19141 "Geology", add
	label def majoroptionconcentrationoremphas 19151 "Geochemistry", add
	label def majoroptionconcentrationoremphas 19160 "Geophysics", add
	label def majoroptionconcentrationoremphas 19171 "Earth Sciences", add
	label def majoroptionconcentrationoremphas 19172 "Geosciences", add
	label def majoroptionconcentrationoremphas 19173 "Atmospheric and Oceanic Science", add
	label def majoroptionconcentrationoremphas 19191 "Oceanography", add
	label def majoroptionconcentrationoremphas 19991 "Criminalistics/Forensic Sci", add
	label def majoroptionconcentrationoremphas 19992 "FORENSIC AND BEHAVIORAL SCIENCES", add
	label def majoroptionconcentrationoremphas 20011 "Psychology", add
	label def majoroptionconcentrationoremphas 20012 "Psych, College Teach.", add
	label def majoroptionconcentrationoremphas 20013 "School Psychology", add
	label def majoroptionconcentrationoremphas 20031 "Comm/Clinical Psych", add
	label def majoroptionconcentrationoremphas 20041 "Counseling (psych)", add
	label def majoroptionconcentrationoremphas 20051 "Social Psychology", add
	label def majoroptionconcentrationoremphas 20081 "Industrial Psych", add
	label def majoroptionconcentrationoremphas 20091 "Developmental Psych", add
	label def majoroptionconcentrationoremphas 20095 "Forensic Psychology", add
	label def majoroptionconcentrationoremphas 20101 "Physiological Psych", add
	label def majoroptionconcentrationoremphas 20991 "Behavioral Science", add
	label def majoroptionconcentrationoremphas 20992 "Psych - Research", add
	label def majoroptionconcentrationoremphas 20993 "Human Development", add
	label def majoroptionconcentrationoremphas 20994 "Human Factors", add
	label def majoroptionconcentrationoremphas 21011 "Community Service", add
	label def majoroptionconcentrationoremphas 21021 "Public Administration", add
	label def majoroptionconcentrationoremphas 21022 "Public Policy Analysis", add
	label def majoroptionconcentrationoremphas 21024 "Hospitality and Tourism", add
	label def majoroptionconcentrationoremphas 21025 "Recreation Management", add
	label def majoroptionconcentrationoremphas 21031 "Recreation Admin", add
	label def majoroptionconcentrationoremphas 21032 "Park Administration", add
	label def majoroptionconcentrationoremphas 21041 "Social Work", add
	label def majoroptionconcentrationoremphas 21042 "Human Services, Collaborative", add
	label def majoroptionconcentrationoremphas 21043 "Gerontology", add
	label def majoroptionconcentrationoremphas 21044 "Deaf Studies", add
	label def majoroptionconcentrationoremphas 21045 "Social Work/Legal", add
	label def majoroptionconcentrationoremphas 21050 "CRIMINOLOGY AND CRIMINAL JUSTICE STUDIES", add
	label def majoroptionconcentrationoremphas 21051 "Criminal Justice", add
	label def majoroptionconcentrationoremphas 21052 "Corrections", add
	label def majoroptionconcentrationoremphas 21053 "Crim Just-Security", add
	label def majoroptionconcentrationoremphas 21991 "Fire Protection Admin", add
	label def majoroptionconcentrationoremphas 21992 "Emergency Services Administration", add
	label def majoroptionconcentrationoremphas 22011 "Social Science", add
	label def majoroptionconcentrationoremphas 22021 "Anthropology", add
	label def majoroptionconcentrationoremphas 22041 "Economics", add
	label def majoroptionconcentrationoremphas 22051 "History", add
	label def majoroptionconcentrationoremphas 22059 "Public/Applied History and Archival Administration", add
	label def majoroptionconcentrationoremphas 22061 "Geography", add
	label def majoroptionconcentrationoremphas 22071 "Political Science", add
	label def majoroptionconcentrationoremphas 22081 "Sociology", add
	label def majoroptionconcentrationoremphas 22091 "Criminology", add
	label def majoroptionconcentrationoremphas 22101 "Internatl Relations", add
	label def majoroptionconcentrationoremphas 22102 "National Security Studies", add
	label def majoroptionconcentrationoremphas 22103 "INTERNAT SECURITY & CONFLICT RESOLVE", add
	label def majoroptionconcentrationoremphas 22111 "African American Studies", add
	label def majoroptionconcentrationoremphas 22121 "Native American Studies", add
	label def majoroptionconcentrationoremphas 22131 "Mexican-American Studies", add
	label def majoroptionconcentrationoremphas 22141 "Urban Studies", add
	label def majoroptionconcentrationoremphas 22990 "Gender Studies", add
	label def majoroptionconcentrationoremphas 22991 "Ethnic Studies", add
	label def majoroptionconcentrationoremphas 22992 "Anthro/Geography", add
	label def majoroptionconcentrationoremphas 22993 "Labor Studies", add
	label def majoroptionconcentrationoremphas 22994 "Cultural Resources Management", add
	label def majoroptionconcentrationoremphas 22995 "Public History/Preservation", add
	label def majoroptionconcentrationoremphas 22996 "Asian American Studies", add
	label def majoroptionconcentrationoremphas 22997 "International/Global Studies", add
	label def majoroptionconcentrationoremphas 22999 "Asian/Asian-American Studies", add
	label def majoroptionconcentrationoremphas 29990 "Women and Gender Studies", add
	label def majoroptionconcentrationoremphas 49009 "LIBERAL ARTS AND ENGINEERING STUDIES", add
	label def majoroptionconcentrationoremphas 49010 "Environmental Science - Joint Program (UCR)", add
	label def majoroptionconcentrationoremphas 49011 "Environmental Studies", add
	label def majoroptionconcentrationoremphas 49012 "Liberal Studies", add
	label def majoroptionconcentrationoremphas 49015 "Hutchins School", add
	label def majoroptionconcentrationoremphas 49016 "Cognitive Science / Cognitive Studies", add
	label def majoroptionconcentrationoremphas 49017 "Liberal Arts", add
	label def majoroptionconcentrationoremphas 49019 "Human Sexuality Studies", add
	label def majoroptionconcentrationoremphas 49020 "Science, Technology and Society", add
	label def majoroptionconcentrationoremphas 49021 "Natural Science", add
	label def majoroptionconcentrationoremphas 49022 "Marine Science", add
	label def majoroptionconcentrationoremphas 49023 "Science", add
	label def majoroptionconcentrationoremphas 49024 "Regenerative Studies", add
	label def majoroptionconcentrationoremphas 49031 "Humanities/Arts/Social Science", add
	label def majoroptionconcentrationoremphas 49032 "Philosophy - Psychology", add
	label def majoroptionconcentrationoremphas 49033 "Govt - Journalism", add
	label def majoroptionconcentrationoremphas 49034 "Humanities/Social Sciences", add
	label def majoroptionconcentrationoremphas 49036 "Museum Studies", add
	label def majoroptionconcentrationoremphas 49038 "Jewish Studies", add
	label def majoroptionconcentrationoremphas 49039 "Conflict Resolution", add
	label def majoroptionconcentrationoremphas 49041 "Environmental Systems", add
	label def majoroptionconcentrationoremphas 49042 "Engineering Management", add
	label def majoroptionconcentrationoremphas 49043 "Transportation Planning", add
	label def majoroptionconcentrationoremphas 49044 "MARINE TRANSPORTATION", add
	label def majoroptionconcentrationoremphas 49045 "Regulatory Affairs", add
	label def majoroptionconcentrationoremphas 49051 "Environmental Resource Management", add
	label def majoroptionconcentrationoremphas 49052 "Coastal and Watershed Science and Policy", add
	label def majoroptionconcentrationoremphas 49061 "Latin-American Stds/Bus Admin", add
	label def majoroptionconcentrationoremphas 49081 "Diversified Studies/Education", add
	label def majoroptionconcentrationoremphas 49101 "ENVIRONMENTAL SCIENCES", add
	label def majoroptionconcentrationoremphas 49102 "ENERGY, ENVIRONMENT, AND SOCIETY", add
	label def majoroptionconcentrationoremphas 49991 "Women's Studies", add
	label def majoroptionconcentrationoremphas 49993 "Special Major", add
	label def majoroptionconcentrationoremphas 49994 "Petroleum Land Studies", add
	label def majoroptionconcentrationoremphas 49995 "Interdisciplinary Management", add
	label def majoroptionconcentrationoremphas 49996 "Biology - Math", add
	label def majoroptionconcentrationoremphas 49997 "New College", add
	label def majoroptionconcentrationoremphas 49998 "Small College", add
	label def majoroptionconcentrationoremphas 51050 "Criminal Justice Studies", add

label define majorocedd ///
1 "Agriculture and Natural Resources" ///
2 "Architecture and Environmental Design" ///
3 "Area Studies" ///
4 "Biological Science" ///
5 "Business and Management" ///
6 "Communications" ///
7 "Computer and Information Sciences" ///
8 "Education" ///
9 "Engineering" ///
10 "Fine and Applied Arts" ///
11 "Foreign Languages" ///
12 "Heath Professions" ///
13 "Home Economics" ///
15 "Letters" ///
16 "Library Science" ///
17 "Mathematics" ///
18 "Military Science" ///
19 "Physical Science" ///
20 "Psychology" ///
21 "Public Affairs and Services" ///
22 "Social Sciences" ///
23 "Interdisiplinary Studies (23)" ///
49 "Interdisiplinary Studies (49)"


label val majoroptionconcentrationoremphas majoroptionconcentrationoremphas
label var majoroptionconcentrationoremphas "Major Option Concentation Or Emphasis"

label val majorocedd majorocedd
label var majorocedd "Discipline Division of Major O.C.or E."

rename majoroptionconcentrationoremphas majoroce


*** residencecode
*    p 310 in 2016 OPSMAN

qui destring residencecode, replace force

qui replace residencecode =.a if residencecode==0
qui replace residencecode =.b if residencecode==9000
qui replace residencecode =.c if residencecode==9001
qui replace residencecode =.d if residencecode==9002
qui replace residencecode =.e if residencecode==9999

label val residencecode countryofcitizenship
label variable residencecode "Permanent Residence at time of App."

rename residencecode residence


*** residence status
*     p 316 in 2016 OPSMAN

qui gen residencestatus2 =.
qui replace residencestatus2 = 1 if residencestatus=="D"
qui replace residencestatus2 = 2 if residencestatus=="R"
qui replace residencestatus2 = 3 if residencestatus=="M"
qui replace residencestatus2 = 4 if residencestatus=="S"
qui replace residencestatus2 = 5 if residencestatus=="T"
qui replace residencestatus2 = 6 if residencestatus=="O"
qui replace residencestatus2 = 7 if residencestatus=="X"
qui replace residencestatus2 = 8 if residencestatus=="W"
qui replace residencestatus2 = 9 if residencestatus=="N"
qui replace residencestatus2 = 10 if residencestatus=="F"

*di "`year' `term'"
*tab residencestatus if residencestatus2 == . ,missing
* mainly blanks or things that look like typos. P and Z pop up a non trivial 
* amount. I'm going to treat them like typos and not give them their own
* missing catagories.

label define residencestatus ///
1 "CA HS Grad" ///
2 "CA Resident" ///
3 "Military" ///
4 "Faculty, Staff" ///
5 "Teachers" ///
6 "Other qualification" ///
7 "Undetermined" ///
8 "Western UG Exchange" ///
9 "Not exempt (US outside CA)" ///
10 "Not exempt (Foreign)"

qui drop residencestatus
rename residencestatus2 residencestatus

label val residencestatus residencestatus
label variable residencestatus "Student's Residence Status For Fee Purposes"


*** sexcode
*    p 323 in 2016 OPSMAN

qui replace sexcode = trim(sexcode)

qui generate female = .
qui replace female = 1 if sexcode == "F"
qui replace female = 0 if sexcode == "M"

*di "`year' `term'"
*tab sexcode if female == ., missing

qui drop sexcode


*** studentlevelcode
*    p 340 in 2016 OPSMAN

*di "`year' `term'"

qui replace studentlevelcode = trim(studentlevelcode)
qui replace studentlevelcode = "." if studentlevelcode=="*"
qui replace studentlevelcode = "." if studentlevelcode=="F"
qui replace studentlevelcode = "." if studentlevelcode=="8"
qui replace studentlevelcode = "." if studentlevelcode=="S"
qui replace studentlevelcode = "." if studentlevelcode=="O"
qui replace studentlevelcode = "." if studentlevelcode=="N"
qui replace studentlevelcode = "." if studentlevelcode=="T"

qui destring studentlevelcode, replace
*tab studentlevelcode, missing

qui replace studentlevelcode = .a if studentlevelcode==0

label def studentlevelcode ///
1 "Freshman" ///
2 "Sophomore" ///
3 "Junior" ///
4 "Senior" ///
5 "Postbacc" ///
.a "(0)

label val studentlevelcode studentlevelcode
label var studentlevelcode "Current Student Academic Level"

rename studentlevelcode level


*** entrylevelmathematicsproficiency
*    p 226 in 2016 OPSMAN

capture rename entrylevelmathematicsproficie entrylevelmathematicsproficiency

qui gen entrylevelmathematicsproficienc2 =.
qui replace entrylevelmathematicsproficienc2 = 1 if entrylevelmathematicsproficiency=="A"
qui replace entrylevelmathematicsproficienc2 = 2 if entrylevelmathematicsproficiency=="T"
qui replace entrylevelmathematicsproficienc2 = 3 if entrylevelmathematicsproficiency=="Z"
qui replace entrylevelmathematicsproficienc2 = 4 if entrylevelmathematicsproficiency=="Y"
qui replace entrylevelmathematicsproficienc2 = 5 if entrylevelmathematicsproficiency=="M"
qui replace entrylevelmathematicsproficienc2 = 6 if entrylevelmathematicsproficiency=="S" | entrylevelmathematicsproficiency=="C"
qui replace entrylevelmathematicsproficienc2 = 7 if entrylevelmathematicsproficiency=="W" | entrylevelmathematicsproficiency=="G"
qui replace entrylevelmathematicsproficienc2 = 8 if entrylevelmathematicsproficiency=="E"
qui replace entrylevelmathematicsproficienc2 = 9 if entrylevelmathematicsproficiency=="P"
qui replace entrylevelmathematicsproficienc2 = 10 if entrylevelmathematicsproficiency=="R"

qui replace entrylevelmathematicsproficienc2 = 11 if entrylevelmathematicsproficiency=="X"
qui replace entrylevelmathematicsproficienc2 = 12 if entrylevelmathematicsproficiency=="V"
qui replace entrylevelmathematicsproficienc2 = 13 if entrylevelmathematicsproficiency=="H"

qui replace entrylevelmathematicsproficienc2 = 14 if entrylevelmathematicsproficiency=="1"
qui replace entrylevelmathematicsproficienc2 = 15 if entrylevelmathematicsproficiency=="2"
qui replace entrylevelmathematicsproficienc2 = 16 if entrylevelmathematicsproficiency=="3"
qui replace entrylevelmathematicsproficienc2 = 17 if entrylevelmathematicsproficiency=="O"
qui replace entrylevelmathematicsproficienc2 = 18 if entrylevelmathematicsproficiency=="U"
qui replace entrylevelmathematicsproficienc2 = 19 if entrylevelmathematicsproficiency=="F"
	
qui replace entrylevelmathematicsproficienc2 = 20 if entrylevelmathematicsproficiency=="N"

qui replace entrylevelmathematicsproficienc2 = .a if entrylevelmathematicsproficiency=="0"
qui replace entrylevelmathematicsproficienc2 = .b if entrylevelmathematicsproficiency=="!"
qui replace entrylevelmathematicsproficienc2 = .c if entrylevelmathematicsproficiency=="#"
qui replace entrylevelmathematicsproficienc2 = .d if entrylevelmathematicsproficiency=="D"

	
label def entrylevelmathematicsproficiency 1 "Exempt-AP(A)"
label def entrylevelmathematicsproficiency 2 "Exempt-GE Breadth/Quant Reason(T)", add
label def entrylevelmathematicsproficiency 3 "Exempt-EAP(Z)", add
label def entrylevelmathematicsproficiency 4 "Exempt-EAP & Senior Exp(Y)", add
label def entrylevelmathematicsproficiency 5 "Exempt-SAT Math Subj Test(M)", add
label def entrylevelmathematicsproficiency 6 "Exempt-SAT/ACT Math Sec(S/C)", add
label def entrylevelmathematicsproficiency 7 "Exempt-SAT/ACT Math & Senior Exp(W/G)", add
label def entrylevelmathematicsproficiency 8 "Exempt - ESM (E)", add
label def entrylevelmathematicsproficiency 9 "Exempt-ELM(P)", add
label def entrylevelmathematicsproficiency 10 "Exempt-rem req but proficiency shown(R)", add

label def entrylevelmathematicsproficiency 11 "Conditional Exempt-EAP(X)", add
label def entrylevelmathematicsproficiency 12 "Conditional Exempt-SAT pending SE(V)", add
label def entrylevelmathematicsproficiency 13 "Conditional Exempt-ACT pending SE(H)", add

label def entrylevelmathematicsproficiency 14 "Not Exempt-ELM Low-1 sem remed(1)", add
label def entrylevelmathematicsproficiency 15 "Not Exempt-ELM Low-2 sem remed(2)", add
label def entrylevelmathematicsproficiency 16 "Not Exempt-ELM Low-3 sem remed(3)", add
label def entrylevelmathematicsproficiency 17 "Not Exempt-ELM Low-Other(O)", add
label def entrylevelmathematicsproficiency 18 "Not Exempt-ELM not taken(U)", add
label def entrylevelmathematicsproficiency 19 "Not Exempt-ELM Low-remed req(F)", add
	
label def entrylevelmathematicsproficiency 20 "Not required - transit/grad(N)", add

label def entrylevelmathematicsproficiency .a "Missing (0)", add
label def entrylevelmathematicsproficiency .b "Missing (!)", add
label def entrylevelmathematicsproficiency .c "Missing (#)", add
label def entrylevelmathematicsproficiency .d "Missing (D)", add

qui replace entrylevelmathematicsproficienc2 = .a if entrylevelmathematicsproficiency=="0"
qui replace entrylevelmathematicsproficienc2 = .b if entrylevelmathematicsproficiency=="!"
qui replace entrylevelmathematicsproficienc2 = .c if entrylevelmathematicsproficiency=="#"
qui replace entrylevelmathematicsproficienc2 = .d if entrylevelmathematicsproficiency=="D"

*di "`year' `term'"
*tab entrylevelmathematicsproficiency if entrylevelmathematicsproficienc2 ==., missing

drop entrylevelmathematicsproficiency

rename entrylevelmathematicsproficienc2 mathprof
	
label val mathprof entrylevelmathematicsproficiency
label var mathprof "Entry Level Mathematics Proficiency Status"

qui generate mathprofsum = .
qui replace mathprofsum = 1 if inrange(mathprof, 1, 10)
qui replace mathprofsum = 2 if inrange(mathprof, 11, 13)
qui replace mathprofsum = 3 if inrange(mathprof, 14, 19)
qui replace mathprofsum = 4 if mathprof == 20

label def mathprofsum ///
1 "Exempt" ///
2 "Conditionally Exempt" ///
3 "Not Exempt" ///
4 "Not required (transit/grad)"

label val mathprofsum mathprofsum
label var mathprofsum "Entry Level Math Proficiency Stat, Summary"

*tab mathprof if mathprofsum == ., missing


*** englishproficiencystatus
*    p 211 in 2016 OPSMAN
        
qui gen englishproficiencystatus2 =.
qui replace englishproficiencystatus2 = 1 if englishproficiencystatus=="A"
qui replace englishproficiencystatus2 = 2 if englishproficiencystatus=="T"
qui replace englishproficiencystatus2 = 3 if englishproficiencystatus=="Z"
qui replace englishproficiencystatus2 = 4 if englishproficiencystatus=="Y"
qui replace englishproficiencystatus2 = 5 if englishproficiencystatus=="M"
qui replace englishproficiencystatus2 = 6 if englishproficiencystatus=="S" | englishproficiencystatus=="C"
qui replace englishproficiencystatus2 = 7 if englishproficiencystatus=="W" | englishproficiencystatus=="G"
qui replace englishproficiencystatus2 = 8 if englishproficiencystatus=="E"
qui replace englishproficiencystatus2 = 9 if englishproficiencystatus=="P"
qui replace englishproficiencystatus2 = 10 if englishproficiencystatus=="R"

qui replace englishproficiencystatus2 = 11 if englishproficiencystatus=="X"
qui replace englishproficiencystatus2 = 12 if englishproficiencystatus=="V"
qui replace englishproficiencystatus2 = 13 if englishproficiencystatus=="H"

qui replace englishproficiencystatus2 = 14 if englishproficiencystatus=="1"
qui replace englishproficiencystatus2 = 15 if englishproficiencystatus=="2"
qui replace englishproficiencystatus2 = 16 if englishproficiencystatus=="3"
qui replace englishproficiencystatus2 = 17 if englishproficiencystatus=="O"
qui replace englishproficiencystatus2 = 18 if englishproficiencystatus=="U"
qui replace englishproficiencystatus2 = 19 if englishproficiencystatus=="F"
	
qui replace englishproficiencystatus2 = 20 if englishproficiencystatus=="N"

qui replace englishproficiencystatus2 = .a if englishproficiencystatus=="0"
qui replace englishproficiencystatus2 = .b if englishproficiencystatus=="!"
qui replace englishproficiencystatus2 = .c if englishproficiencystatus=="4"
qui replace englishproficiencystatus2 = .d if englishproficiencystatus=="D"
qui replace englishproficiencystatus2 = .e if englishproficiencystatus=="*"

	
label def englishproficiencystatus 1 "Exempt-AP(A)"
label def englishproficiencystatus 2 "Exempt-GE Breadth Eng Comp(T)", add
label def englishproficiencystatus 3 "Exempt-EAP(Z)", add
label def englishproficiencystatus 4 "Exempt-EAP & Senior Exp(Y)", add
label def englishproficiencystatus 5 "Exempt-SAT Writting Subj Test(M)", add
label def englishproficiencystatus 6 "Exempt-SAT/ACT CR/Eng Sec(S/C)", add
label def englishproficiencystatus 7 "Exempt-SAT/ACT Read/Eng & Senior Exp(W/G)", add
label def englishproficiencystatus 8 "Exempt - ESE (E)", add
label def englishproficiencystatus 9 "Exempt-EPT(P)", add
label def englishproficiencystatus 10 "Exempt-rem req but proficiency shown(R)", add

label def englishproficiencystatus 11 "Conditional Exempt-EAP(X)", add
label def englishproficiencystatus 12 "Conditional Exempt-SAT pending SE(V)", add
label def englishproficiencystatus 13 "Conditional Exempt-ACT pending SE(H)", add

label def englishproficiencystatus 14 "Not Exempt-EPT Low-1 sem remed(1)", add
label def englishproficiencystatus 15 "Not Exempt-EPT Low-2 sem remed(2)", add
label def englishproficiencystatus 16 "Not Exempt-EPT Low-3 sem remed(3)", add
label def englishproficiencystatus 17 "Not Exempt-EPT Low-Other(O)", add
label def englishproficiencystatus 18 "Not Exempt-EPT not taken(U)", add
label def englishproficiencystatus 19 "Not Exempt-EPT Low-remed req(F)", add
	
label def englishproficiencystatus 20 "Not required - transit/grad(N)", add

label def englishproficiencystatus .a "Missing (0)", add
label def englishproficiencystatus .b "Missing (!)", add
label def englishproficiencystatus .c "Missing (4)", add
label def englishproficiencystatus .d "Missing (D)", add
label def englishproficiencystatus .e "Missing (*)", add

*di "`year' `term'"
*tab englishproficiencystatus if englishproficiencystatus2 ==., missing

drop englishproficiencystatus

rename englishproficiencystatus2 engprof
	
label val engprof englishproficiencystatus
label var engprof "Entry Level English Proficiency Status"

qui generate engprofsum = .
qui replace engprofsum = 1 if inrange(engprof, 1, 10)
qui replace engprofsum = 2 if inrange(engprof, 11, 13)
qui replace engprofsum = 3 if inrange(engprof, 14, 19)
qui replace engprofsum = 4 if engprof == 20

label def engprofsum ///
1 "Exempt" ///
2 "Conditionally Exempt" ///
3 "Not Exempt" ///
4 "Not required (transit/grad)"

label val engprofsum engprofsum
label var engprofsum "Entry Level Math Proficiency Stat, Summary"

*tab engprof if engprofsum == ., missing


*** actenglishscore
*** actmathematicsscore
*** actreadingscore 
*** actsciencereasoningscore 
*** actcompositescore 
*    p 369 in 2016 OPSMAN

* VALID ACT scores are are contained in the set of integers ranging from
* 1 to 36 (inclusive)

foreach type in english mathematics reading sciencereasoning composite {

if "`type'" == "english" {
	local newvar "acteng"
	local varlab "ACT English Score"
}
else if "`type'" == "mathematics" {
	local newvar "actmath"
	local varlab "ACT Mth Score"
}
else if "`type'" == "reading" {
	local newvar "actread"
	local varlab "ACT Reading Score"
}
else if "`type'" == "sciencereasoning" {
	local newvar "actsci"
	local varlab "ACT Science Reas Score"
}
else if "`type'" == "composite" {
	local newvar "actcomp"
	local varlab "ACT Composite Score"
}
else {
	di "error message: my cat sleeps on my keyboard"
}

*di "`year' `term' `type'"

qui destring act`type'score, generate(`newvar') force
*tab act`type'score if `newvar'==., missing
* almost all blanks (one or two ".")
*tab `newvar' if `newvar'<1 | `newvar'>36, missing
* the vast majority of these are zeros. There are also an non trivial number
* of 99s. And then there are a small number of what look like random typos.
qui replace `newvar'=. if  `newvar'<1 |`newvar'>36
label var `newvar' "`varlab'"
drop act`type'score

}


*** elmadministrationdate
*    p224 in 2016 OPSMAN as Entry Level Mathematics Administration Date

qui replace elmadministrationdate = trim(elmadministrationdate)

qui generate elmadmindate = date(elmadministrationdate, "YMD")
format elmadmindate %td

*di "`year' `term'"
*tab elmadministrationdate if elmadmindate == ., missing
* either blank, zero, or in one case something that looks like an SSN

drop elmadministrationdate
label var elmadmindate "ELM Administration Date"


*** elmtotalscore
*    p 232 in 2016 OPSMAN as Entry Level Mathematics Total Score

* Valid Values:
* 10 to 70, if ELM Administration Date before March 23, 2002
* 00 to 80, if ELM Administration Date on or after March 23, 2002

qui replace elmtotalscore = trim(elmtotalscore)
qui destring elmtotalscore, generate(elmtot) force

*di "`year' `term'"
*tab elmtotalscore if elmtot == . , missing
* all blanks

*tab elmtot if ((elmtot<10 | elmtot>70) & elmadmindate<td(23mar2002)) | (elmtot<0 | elmtot>80) & elmadmindate>=td(23mar2002)

qui replace elmtot = . if (elmtot<10 | elmtot>70) & elmadmindate<td(23mar2002)
qui replace elmtot = . if (elmtot<0 | elmtot>80) & elmadmindate>=td(23mar2002)

*count if elmtot<0 | (elmtot>99 & elmtot<.)
* always zero

drop elmtotalscore
label var elmtot "ELM Total Score"


*** eptessayscore
*    NOT IN OPSMAN

* According to <https://www.ets.org/csu/scores/results/>
* Scores on the test taken before March 15, 2008 ranged [1, 12]
* Scores on the test taken on or after March 15, 2008 ranged [0, 6]

* The problem is that I don't have the EPT Test Date, so I can't set scores
* outside the valid range to missing.

qui replace eptessayscore = trim(eptessayscore)
qui destring eptessayscore, generate(eptessay) force

*di "`year' `term'"
*tab eptessayscore if eptessay == . , missing
* all blanks
*tab eptessay, missing
* all zero until 2000.3
* There are a lot of zeros before the 2008 files (which mean that the student
* had to have taken the test before March 15, 2008 when zero was not a valid
* score.)
* There are some scores that are larger than 12 so they can't be valid. I'm
* not going to change them to missing because I can't change other scores that
* aren't valid to missing since I don't have a test date.

drop eptessayscore
label variable eptessay "EPT Essay Score - Check for nonvalid scores."


*** eptreadingscore
*** eptcompositionscore
*** epttotalscore
* NOT IN OPSMAN 2016

* According to: <https://www.ets.org/csu/scores/results/>
* All three scores range from [120, 180] and there is no indication that this
* changed over time.

*di "`year' `term'"

foreach var in eptreadingscore eptcompositionscore epttotalscore {

if "`var'" == "eptreadingscore" {
	local newvar "eptread"
	local varlab "EPT Reading Score"
}
else if "`var'" == "eptcompositionscore" {
	local newvar "eptcomp"
	local varlab "EPT Composition Score"
}
else if "`var'" == "epttotalscore" {
	local newvar "epttot"
	local varlab "EPT Total Score"
}
else {
	di "error message: I am tired"
}

qui replace `var' = trim(`var')
qui destring `var', generate(`newvar') force

*di "`newvar'"
*tab `var' if `newvar'==.
*tab `newvar' if !inrange(`newvar', 120, 180)
* Lots of zeros. Smaller clusters around 200, 880, 950, 990.
* The rest of the out of ranges look basically random on a visual scan.

qui replace `newvar' = .a if `newvar'==0
qui replace `newvar' = .b if `newvar'==200
qui replace `newvar' = .c if `newvar'==880
qui replace `newvar' = .d if `newvar'==950
qui replace `newvar' = .e if `newvar'==990

qui replace `newvar' = . if !inrange(`newvar', 120, 180) & !inlist(`newvar', .a, .b, .c, .d, .e)

label def `newvar' ///
.a "0" ///
.b "200" ///
.c "880" ///
.d "950" ///
.e "990"

label val `newvar' "`newvar'"
label var `newvar' "`varlab'"
drop `var'

}


*** sativerbalscore
*** satimathematicsscore
* NOT IN OPSMAN 2016

qui destring sativerbalscore, generate(satverb)
qui destring satimathematicsscore, generate(satmath)

*di "`year' `term'"
*tab sativerbalscore if satverb==. | satverb<200 | satverb>800, missing
*tab satimathematicsscore if satmath==. | satmath<200 | satmath>800, missing
* There are a lot of "0" and "000" and blanks, and a small number of what
* are almost certainly typos.

qui replace satverb = . if satverb<200 | satverb>800
qui replace satmath = . if satmath<200 | satmath>800

label var satverb "SAT Verbal Score"
label var satmath "SAT Math Score"

drop sativerbalscore satimathematicsscore


*** saticompositescore
* NOT IN OPSMAN 2016

qui destring saticompositescore, generate(sattot) force

*di "`year' `term'"
*tab saticompositescore if sattot==. | sattot<400 | sattot>1600, missing
* lots of "0" "0000" and blanks, a small amount of what are almost certainly typos

qui replace sattot = . if sattot<400 | sattot>1600

label var sattot "SAT Composite Score"

drop saticompositescore


*** testscoresfortoefl
*    p 389 in 2016 OPSMAN

/*
There are almost no missing values or blanks. However, there are way more 
zeros than are credible. I'm not turning them to missing because  once they 
started giving computer based tests in 1998 zero became a valid score. But most
zeros are probably actually missing.
*/

qui destring testscoresfortoefl, generate(toefl) force

*di "`year' `term'"
*tab testscoresfortoefl if toefl==. | toefl<0 | toefl>677, missing

qui replace toefl=. if toefl<0 | toefl>677

label var toefl "TOEFL Score: Be careful with 0"

drop testscoresfortoefl


*** dependentincomecode
*    p 188 in 2016 OPSMAN

qui destring dependentincomecode, generate(depinc) force

*di "`year' `term'"
*tab dependentincomecode if depinc==. | !inlist(depinc, 1, 2, 3, 4, 5, 6, 7, 8)

qui replace depinc = .a if depinc == 0
qui replace depinc = .b if depinc == 7
qui replace depinc = .c if depinc == 8
qui replace depinc = . if !inlist(depinc, 1, 2, 3, 4, 5, 6, 7, 8) & depinc<.

label def depinc 1 "<24K"
label def depinc 2 "24K-<36K", add
label def depinc 3 "36K-<48K", add
label def depinc 4 "48K-<60K", add
label def depinc 5 "60K-<72K", add
label def depinc 6 ">72K", add
label def depinc .a "Coded as 0 (not a valid entry)", add
label def depinc .b "Cannot Estimate", add
label def depinc .c "No response", add

label val depinc depinc
label var depinc "Dependent Income Code"

drop dependentincomecode


*** dependentfamilysize
*    p 186 in 2016 OPSMAN

qui destring dependentfamilysize, generate(depfam) force

qui replace depfam = . if !inrange(depfam, 1, 99)
qui replace depfam = .a if depfam==99

*di "`year' `term'"
*tab dependentfamilysize if depfam==.
* almost all zeros or blanks

label def depfam ///
.a "No Responce (99)"

label val depfam depfam
label var depfam "Dependent Family Size"

drop dependentfamilysize


*** independentincomecode
*    p 269 in 2016 OPSMAN

qui destring independentincomecode, generate(indinc) force

*di "`year' `term'"
*tab independentincomecode if indinc==. | !inlist(indinc, 1, 2, 3, 4, 5, 6, 7, 8, 9)
* almost all blanks and zeros. A very small number of "N"s.

qui replace indinc = .a if indinc == 0
qui replace indinc = .b if indinc == 8
qui replace indinc = .c if indinc == 9
qui replace indinc = . if !inlist(indinc, 1, 2, 3, 4, 5, 6, 7, 8, 9) & indinc<.

label def indinc 1 "<6K"
label def indinc 2 "6K-<12K", add
label def indinc 3 "12K-<24K", add
label def indinc 4 "24K-<36K", add
label def indinc 5 "36K-<48K", add
label def indinc 6 "48K-<60K", add
label def indinc 7 ">60K", add
label def indinc .a "Coded as 0 (not a valid entry)", add
label def indinc .b "Cannot Estimate", add
label def indinc .c "No response", add

label val indinc indinc
label var indinc "Independent Income Code"

drop independentincomecode


*** independentfamilysize
*    p 267 in 2016 OPSMAN

qui destring independentfamilysize, generate(indfam) force

qui replace indfam = . if !inrange(indfam, 1, 99)
qui replace indfam = .a if indfam==99

*di "`year' `term'"
*tab independentfamilysize if indfam==.
* almost all zeros or blanks

label def indfam ///
.a "No Responce (99)"

label val indfam indfam
label var indfam "Independent Family Size"

drop independentfamilysize


*** mothereducation 
*    p 286 in 2016 OPSMAN

capture rename motherseducation mothereducation

qui destring mothereducation, generate(edumom) force

qui replace edumom = . if !inlist(edumom, 1, 2, 3, 4, 5, 6, 7, 8)
qui replace edumom = .a if edumom==8

*di "`year' `term'"
*tab mothereducation if edumom==., missing
* Mainly zeros and blanks. A small amount of typos.

label def edumom 1 "No High School"
label def edumom 2 "Some High School", add
label def edumom 3 "High School Grad", add
label def edumom 4 "Some College", add
label def edumom 5 "2-Year Coll Grad", add
label def edumom 6 "4-Year Coll Grad", add
label def edumom 7 "Postgraduate", add
label def edumom .a "No Responce", add

label val edumom edumom
label var edumom "Mother/Parent1's Edu Code"

drop mothereducation


*** fathereducation
*    p 241 in 2016 OPSMAN

capture rename fatherseducation fathereducation

qui destring fathereducation, generate(edudad) force

qui replace edudad = . if !inlist(edudad, 1, 2, 3, 4, 5, 6, 7, 8)
qui replace edudad = .a if edudad==8

*di "`year' `term'"
*tab fathereducation if edudad==., missing
* Mainly zeros and blanks. A small amount of typos.

label val edudad edumom
label var edudad "Father/Parent2's Edu Code"

drop fathereducation


*** cipcode
*    p119 in 2016 OPSMAN

* There is a COSAR table (Table 35?  My Excel sheet is titled 
* "COSAR2010-07-14(17).xls") That provides a crosswalk between CIP Codes 
* (Which from googling around I think may be national) to Hegis Codes and
* major names. I'm going to leave them as is for the moment. That's what 
* Jake did. I can label them or do something with them later if it makes sense.

rename cipcode cip
label var cip "CIP Code"


*** testscoresforenglishlanguageprof
*    p 377 in 2016 OPSMAN

capture rename testscoresforenglishlanguage testscoresforenglishlanguageprof

qui destring testscoresforenglishlanguageprof, generate(elpt) force

qui replace elpt = . if !inrange(elpt, 900, 999)

*di "`year' `term'"
*tab testscoresforenglishlanguageprof if elpt ==., missing
* Almost all zeros

label var elpt "Eng. Lang. Placement Test"

drop testscoresforenglishlanguageprof


order ///
	idunique ///
	year ///
	term ///
	dob ///
	female ///
	ethnic ///
	ethnicdetail ///
	edumom ///
	edudad ///
	depinc ///
	depfam ///
	indinc ///
	indfam ///
	citizenship ///
	countryofcitizenship ///
	residence ///
	residencestatus ///
	admissionbasis ///
	admissionbasis2 ///
	exceptionadmission ///
	admissionstatus ///
	enrollstat ///
	level ///
	degreeobj ///
	majoroce ///
	majorocedd ///
	cip ///
	institutionorigin ///
	instorgtype ///
	hsgpa ///
	cprepeng ///
	cprepmath ///
	acteng ///
	actmath ///
	actread ///
	actsci ///
	actcomp ///
	satverb ///
	satmath ///
	sattot ///
	mathprof ///
	mathprofsum ///
	engprof ///
	engprofsum ///
	elmadmindate ///
	elmtot ///
	eptessay ///
	eptread ///
	eptcomp ///
	epttot ///
	toefl ///
	elpt


qui compress
qui save "clean/csu actually clean/era/era`year'`term'.dta", replace

}

}


*** Cleaning the variables that are in all the files except the really old ones.

forvalues year = 1997 / 2017 {

forvalues term = 1/4 {

if `year' == 1997 & `term' == 1 | ///
   `year' == 1997 & `term' == 2 | ///
   `year' == 1997 & `term' == 3 | ///
   `year' == 1998 & `term' == 1 | ///
   `year' == 1998 & `term' == 3 | ///
   `year' == 1999 & `term' == 1 | ///
   `year' == 1999 & `term' == 3 | ///
   `year' == 2000 & `term' == 1 | ///
   `year' == 2001 & `term' == 1 | ///
   `year' == 2002 & `term' == 1 {
    
	display "No file exists for `year'`term' (2)"
	continue

   }
 
else if `year' == 1997 & `term' == 4 | ///
        `year' == 1998 & `term' == 2 | ///
        `year' == 1998 & `term' == 4 | ///
        `year' == 1999 & `term' == 2 | ///
        `year' == 1999 & `term' == 4 | ///
        `year' == 2000 & `term' == 2 | ///
        `year' == 2000 & `term' == 3 | ///
        `year' == 2000 & `term' == 4 | ///
        `year' == 2001 & `term' == 2 | ///
        `year' == 2001 & `term' == 3 | ///
        `year' == 2001 & `term' == 4 | ///
        `year' == 2002 & `term' == 2 {

	display "Variable set not in type a file `year'`term' (1)"
	continue

  }  
  
else if `year' == 2004 & `term' == 3 | ///
        `year' == 2004 & `term' == 4 | ///
        `year' == 2005 | ///
        `year' == 2006 | ///
        `year' == 2007 | ///
        `year' == 2008 | ///
        `year' == 2009 & `term' == 1 | ///
        `year' == 2009 & `term' == 2 | ///
        `year' == 2009 & `term' == 3 {

	local filepath "2001or02to2009"
	local era "era"

  }   
  
else if `year' == 2002 & `term' == 3 | ///
        `year' == 2002 & `term' == 4 | ///
        `year' == 2003 | ///
        `year' == 2004 & `term' == 1 | ///
        `year' == 2004 & `term' == 2 {

	local filepath "csu update 11-15-10"
	local era "era"

  } 
  
else if `year' == 2009 & `term' == 4 | ///
        `year' == 2010 | ///
        `year' == 2011 | ///
        `year' == 2012 | ///
        `year' == 2013 & `term' == 1 | ///
        `year' == 2013 & `term' == 2 | ///
        `year' == 2013 & `term' == 3 {

	local filepath "CSU Data Update Jake"
	local era "era"

  }  

else if `year' == 2013 & `term' == 4 | ///
        `year' == 2014 & `term' == 1 | ///
        `year' == 2014 & `term' == 2 | ///
        `year' == 2014 & `term' == 3 {

	local filepath "CSU Update 7-15-2015"
	local era "era"

  } 
  
else if `year' == 2014 & `term' == 4 | ///
        `year' == 2015 | ///
        `year' == 2016 & `term' == 1 | ///
        `year' == 2016 & `term' == 2 {

	local filepath "CSU update 10-6-16"
	local era "era"

  }
  
else if `year' == 2016 & `term' == 3 | /// 
	`year' == 2016 & `term' == 4 | ///
	`year' == 2017 & `term' == 1 | ///
	`year' == 2017 & `term' == 2 {

	local filepath "CSU Update 10-23-17"
	local era "era"

  }
  
else if `year' == 2017 & `term' == 3 | ///
	`year' == 2017 & `term' == 4 {

	local filepath "CSU Update 11.29.17"
	local era "era"

  } 
   
else {

	display "unhelpful error message 159265359"

 }

use "clean/csu actually clean/era/era`year'`term'.dta", clear

di "2 `year' `term'"

*** campuscode
*    p 110 in 2016 OPSMAN

qui destring campuscode, generate(campus) force
qui replace campus = . if !inlist(campus, 5, 6, 7, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 63, 65, 68, 70, 73, 75, 80, 85, 90, 93, 96, 97)

*di "`year' `term'"
*tab campuscode if campus ==., missing

label def campus ///
	5 "East Bay" ///
	6 "Monterey Bay" ///
	7 "Maritime Academy" ///
	10 "Pomona" ///
	15 "San Luis Obispo" ///
	20 "Chico" ///	
	25 "Fresno" ///	
	30 "Humboldt" ///	
	35 "Bakersfield" ///
	40 "Long Beach" ///
	45 "Los Angeles" ///
	50 "Fullerton" ///
	55 "Dominguez Hills" ///	
	60 "Sacramento" ///
	63 "San Bernardino" ///
	65 "San Diego" ///
	68 "San Marcos" ///
	70 "Northridge" ///
	73 "Channel Islands" ///
	75 "San Francisco" ///
	80 "San Jose" ///
	85 "Sonoma" ///
	90 "Stanislaus" ///
	93 "Summer Arts" ///
	96 "CalStateTEACH (CO only)" ///
	97 "International Programs (CO Only)"

label val campus campus
label var campus "CSU Campus Code"
drop campuscode


*** accommodationstatus
*    p 79 in 2016 OPSMAN

qui gen accommodationstatus2=.
qui replace accommodationstatus2 = 1 if accommodationstatus=="A"
qui replace accommodationstatus2 = 2 if accommodationstatus=="B"
qui replace accommodationstatus2 = 3 if accommodationstatus=="R"
qui replace accommodationstatus2 = 4 if accommodationstatus=="M"
qui replace accommodationstatus2 = 5 if accommodationstatus=="U"
qui replace accommodationstatus2 = 6 if accommodationstatus=="Z"

*di "`year' `term'"
*tab accommodationstatus if accommodationstatus2 ==., missing

label def accommodationstatus 1 "Accommodated(A)"
label def accommodationstatus 2 "Accommodated: Receive app frm oth CSU(B)", add
label def accommodationstatus 3 "Accommodated: Sent app to other CSU(R)",add
label def accommodationstatus 4 "Unaccommodated: Redirect to other CSU(M)", add
label def accommodationstatus 5 "Unaccommodated(U)",add
label def accommodationstatus 6 "Unaccommodated-Returned application(Z)",add
	
drop accommodationstatus
rename accommodationstatus2 accommodationstatus
label val accommodationstatus accommodationstatus
label var accommodationstatus "Accommodation Status"


*** accommodationstatusdate
*    p 81 in 2016 OPSMAN

qui replace accommodationstatusdate = trim(accommodationstatusdate)

qui generate accommodationdate = date(accommodationstatusdate, "YMD")
format accommodationdate %td

*di "`year' `term'"
*tab accommodationstatusdate if accommodationdate==., missing 
* All zeros or missing

label variable accommodationdate "Date Acc. Status Entered or Changed"
drop accommodationstatusdate


*** admissionstatusdate
*    p 94 in 2016 OPSMAN

qui replace admissionstatusdate = trim(admissionstatusdate)

qui generate admissiondate = date(admissionstatusdate, "YMD")
format admissiondate %td

*di "`year' `term'"
*tab admissionstatusdate if admissiondate==., missing 
* All zeros or missing

label variable admissiondate "Date Admit Status Entered or Changed"
drop admissionstatusdate


*** applicationfeestatus
* NOT IN OPSMAN 2016
* According to the record layout for the ERA files (p19 OPSMAN 2016), the 
* variable went out of use at some point.

qui replace applicationfeestatus = trim(applicationfeestatus)

* di "`year' `term'"
* tab applicationfeestatus, missing 
* blank in 20091 and 20093 on. Otherwise lots of letters.

rename applicationfeestatus appfee
label variable appfee "Application Fee Status"


*** applicationreceiptdate
*    p 96 in 2016 OPSMAN

qui replace applicationreceiptdate = trim(applicationreceiptdate)

qui generate appdate = date(applicationreceiptdate, "YMD")
format appdate %td

*di "`year' `term'"
*tab applicationreceiptdate if appdate==., missing 
* All zeros or missing

label variable appdate "Date Application Received"
drop applicationreceiptdate


*** campusassignedstudentid
*    p 107 in 2016 OPSMAN

*qui destring campusassignedstudentid, generate(x) force
*qui replace x=. if !inrange(csid, 1, 999999998)

*di "`year' `term'"
*tab campusassignedstudentid if x==., missing 
* From 2002 to 2004 there are a bunch of ids that start with an "@" (and for
* one term a "S"). There are not a lot of these (less than a hundered a term)
* but the fact that it is a consistent pattern makes me think that they're not
* typos. There are also a very small number of typos.

rename campusassignedstudentid csid
label variable csid "Campus Assigned Stu. ID"
*drop x


*** eeetestindicator
* NOT IN OPSMAN 2016
* According to the record layout for the ERA files (p19 OPSMAN 2016), the 
* variable went out of use at some point.

qui replace eeetestindicator = trim(eeetestindicator)

*di "`year' `term'"
*tab eeetestindicator, missing
* after 2009 all blank

label variable eeetestindicator "Not in OPSMAN 2016"


*** elmalgebrasubscore 
*** elmgeometrysubscore 
*** elmfirsttotalscore
* NOT IN OPSMAN 2016

qui destring elmalgebrasubscore, generate(elmalg) force
qui destring elmgeometrysubscore, generate(elmgeo) force
qui destring elmfirsttotalscore, generate(elm1sttot) force

*di "`year' `term'"
*tab elmalgebrasubscore if elmalg == . , missing
*tab elmgeometrysubscore if elmgeo == . , missing
*tab elmfirsttotalscore if elm1sttot == . , missing
* all blanks

drop elmalgebrasubscore elmgeometrysubscore elmfirsttotalscore

label var elmalg "ELM Algabra Subscore Score"
label var elmgeo "ELM Geometry Subscore Score"
label var elm1sttot "ELM 1st Total Score"


*** specialprograms
*    p 328 in 2016 OPSMAN

qui gen specpro =.
qui replace specpro = 1 if specialprograms=="A"
qui replace specpro = 2 if specialprograms=="I"
qui replace specpro = 3 if specialprograms=="T"

*di "`year' `term'"
*tab specialprograms if specpro == ., missing
* all blank or zeros
	
label def specpro 1 "Summer Arts"
label def specpro 2 "International Prog", add
label def specpro 3 "CalStateTEACH", add
	
drop specialprograms
	
label val specpro specpro
label var specpro "Special Programs"


*** satscoretype 
*    p 318 in 2016 OPSMAN

qui replace satscoretype = trim(satscoretype)

qui gen satcenter =.
qui replace satcenter = 1 if satscoretype=="O"
qui replace satcenter = 2 if satscoretype=="N"
qui replace satcenter = 3 if satscoretype=="A"
qui replace satcenter = .a if satscoretype=="0"
qui replace satcenter = .b if inlist(satscoretype, "1", "2", "3", "4", "5", "6")

*di "`year' `term'"
*tab satscoretype if satcenter == ., missing
* all blank


label def satcenter 1 "Not Recentered(O)"
label def satcenter 2 ">=1995 No Recentering(N)", add
label def satcenter 3 "Pre-1995 Recentered(A)", add
label def satcenter .a "(0)", add
label def satcenter .b "(1, 2, 3, 4, 5, 6)", add
	
drop satscoretype 
	
label val satcenter satcenter
label var satcenter "SAT Score Type"


*** actwriting
*    p 373 in 2016 OPSMAN (I think)

qui destring actwriting, generate(actwrit) force

qui replace actwrit = . if !inlist(actwrit, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36)

*di "`year' `term'"
*tab actwriting if actwrit == ., missing
* virtually all blanks or zeros except for 20044, 20051, 20052 where it looks 
* like percentiles were entered.

qui replace actwrit = real(actwriting) if year==2004 & term==4
qui replace actwrit = real(actwriting) if year==2005 & term==1
qui replace actwrit = real(actwriting) if year==2005 & term==2

drop actwriting

label var actwrit "ACT Writing Score (Provisional) 20044, 20051, 20052 are percentiles"



*** credentialemphasis
*    p 149 in 2016 OPSMAN

qui replace credentialemphasis = trim(credentialemphasis)
qui replace credentialemphasis = "1" if credentialemphasis=="01"
qui replace credentialemphasis = "2" if credentialemphasis=="02"
qui replace credentialemphasis = "3" if credentialemphasis=="03"

qui gen teachcredemp =.
qui replace teachcredemp = 1 if credentialemphasis=="1"
qui replace teachcredemp = 2 if credentialemphasis=="2"
qui replace teachcredemp = 3 if credentialemphasis=="3"
qui replace teachcredemp = 4 if credentialemphasis=="4"
qui replace teachcredemp = 5 if credentialemphasis=="13"
qui replace teachcredemp = 6 if credentialemphasis=="23"

qui replace teachcredemp = 10 if credentialemphasis=="4A"
qui replace teachcredemp = 11 if credentialemphasis=="4B"
qui replace teachcredemp = 12 if credentialemphasis=="4C"
qui replace teachcredemp = 13 if credentialemphasis=="4D"
qui replace teachcredemp = 14 if credentialemphasis=="4E"
qui replace teachcredemp = 15 if credentialemphasis=="4F"
qui replace teachcredemp = 16 if credentialemphasis=="4H"
qui replace teachcredemp = 17 if credentialemphasis=="4J"
qui replace teachcredemp = 18 if credentialemphasis=="4K"
qui replace teachcredemp = 19 if credentialemphasis=="4L"
qui replace teachcredemp = 20 if credentialemphasis=="4M"
qui replace teachcredemp = 21 if credentialemphasis=="4N"
qui replace teachcredemp = 22 if credentialemphasis=="4P"
qui replace teachcredemp = 23 if credentialemphasis=="4R"
qui replace teachcredemp = 24 if credentialemphasis=="4S"
qui replace teachcredemp = 25 if credentialemphasis=="4Y"
qui replace teachcredemp = 26 if credentialemphasis=="4V"
	
qui replace teachcredemp = 30 if credentialemphasis=="1A"
qui replace teachcredemp = 31 if credentialemphasis=="1B"
qui replace teachcredemp = 32 if credentialemphasis=="1C"
qui replace teachcredemp = 33 if credentialemphasis=="1D"
qui replace teachcredemp = 34 if credentialemphasis=="1E"
qui replace teachcredemp = 35 if credentialemphasis=="1F"
qui replace teachcredemp = 36 if credentialemphasis=="1H"
qui replace teachcredemp = 37 if credentialemphasis=="1J"
qui replace teachcredemp = 38 if credentialemphasis=="1K"
qui replace teachcredemp = 39 if credentialemphasis=="1L"
qui replace teachcredemp = 40 if credentialemphasis=="1M"
qui replace teachcredemp = 41 if credentialemphasis=="1N"
qui replace teachcredemp = 42 if credentialemphasis=="1P"
qui replace teachcredemp = 43 if credentialemphasis=="1R"
qui replace teachcredemp = 44 if credentialemphasis=="1S"
qui replace teachcredemp = 45 if credentialemphasis=="1Y"
qui replace teachcredemp = 46 if credentialemphasis=="1V"
	
qui replace teachcredemp = 50 if credentialemphasis=="2A"
qui replace teachcredemp = 51 if credentialemphasis=="2B"
qui replace teachcredemp = 52 if credentialemphasis=="2C"
qui replace teachcredemp = 53 if credentialemphasis=="2D"
qui replace teachcredemp = 54 if credentialemphasis=="2E"
qui replace teachcredemp = 55 if credentialemphasis=="2F"
qui replace teachcredemp = 56 if credentialemphasis=="2H"
qui replace teachcredemp = 57 if credentialemphasis=="2J"
qui replace teachcredemp = 58 if credentialemphasis=="2K"
qui replace teachcredemp = 59 if credentialemphasis=="2L"
qui replace teachcredemp = 60 if credentialemphasis=="2M"
qui replace teachcredemp = 61 if credentialemphasis=="2N"
qui replace teachcredemp = 62 if credentialemphasis=="2P"
qui replace teachcredemp = 63 if credentialemphasis=="2R"
qui replace teachcredemp = 64 if credentialemphasis=="2S"
qui replace teachcredemp = 65 if credentialemphasis=="2Y"
qui replace teachcredemp = 66 if credentialemphasis=="2V"

*di "`year' `term'"
*tab credentialemphasis if teachcredemp == ., missing

label def teachcredemp 1 "Only Early Childhood(ECE)(1)"
label def teachcredemp 2 "Only Middle School(MS)(2)", add
label def teachcredemp 3 "Only Cross Cult Lang & Acc Dev (CLAD)(3)", add
label def teachcredemp 4 "Only Bilingual/CLAD (BCLAD)(4)", add
label def teachcredemp 5 "ECE/CLAD(13)", add
label def teachcredemp 6 "MS/CLAD(23)", add
	
label def teachcredemp 10 "Only BCLAD-Armenian(4A)", add
label def teachcredemp 11 "Only BCLAD-African Amer(4B)", add
label def teachcredemp 12 "Only BCLAD-Chinese(4C)", add
label def teachcredemp 13 "Only BCLAD-Cantonese(4D)", add
label def teachcredemp 14 "Only BCLAD-Cambodian(4E)", add
label def teachcredemp 15 "Only BCLAD-Filipino(4F)", add
label def teachcredemp 16 "Only BCLAD-Hmong(4H)", add
label def teachcredemp 17 "Only BCLAD-Japanese(4J)", add
label def teachcredemp 18 "Only BCLAD-Korean(4K)", add
label def teachcredemp 19 "Only BCLAD-Laotian(4L)", add
label def teachcredemp 20 "Only BCLAD-Mandarin(4M)", add
label def teachcredemp 21 "Only BCLAD-Native American(4N)", add
label def teachcredemp 22 "Only BCLAD-Portuguese(4P)", add
label def teachcredemp 23 "Only BCLAD-Pan-Asian(4R)", add
label def teachcredemp 24 "Only BCLAD-Spanish(4S)", add
label def teachcredemp 25 "Only BCLAD-Yurok/Tolowa/Kurak/Hup(4Y)", add
label def teachcredemp 26 "Only BCLAD-Vietnamese(4V)", add
	
label def teachcredemp 30 "ECE/BCLAD-Armenian(1A)", add
label def teachcredemp 31 "ECE/BCLAD-African Amer(1B)", add
label def teachcredemp 32 "ECE/BCLAD-Chinese(1C)", add
label def teachcredemp 33 "ECE/BCLAD-Cantonese(1D)", add
label def teachcredemp 34 "ECE/BCLAD-Cambodian(1E)", add
label def teachcredemp 35 "ECE/BCLAD-Filipino(1F)", add
label def teachcredemp 36 "ECE/BCLAD-Hmong(1H)", add
label def teachcredemp 37 "ECE/BCLAD-Japanese(1J)", add
label def teachcredemp 38 "ECE/BCLAD-Korean(1K)", add
label def teachcredemp 39 "ECE/BCLAD-Laotian(1L)", add
label def teachcredemp 40 "ECE/BCLAD-Mandarin(1M)", add
label def teachcredemp 41 "ECE/BCLAD-Native American(1N)", add
label def teachcredemp 42 "ECE/BCLAD-Portuguese(1P)", add
label def teachcredemp 43 "ECE/BCLAD-Pan-Asian(1R)", add
label def teachcredemp 44 "ECE/BCLAD-Spanish(1S)", add
label def teachcredemp 45 "ECE/BCLAD-Yurok/Hup(1Y)", add
label def teachcredemp 46 "ECE/BCLAD-Vietnamese(1V)", add
	
label def teachcredemp 50 "MS/BCLAD-Armenian(2A)", add
label def teachcredemp 51 "MS/BCLAD-African Amer(2B)", add
label def teachcredemp 52 "MS/BCLAD-Chinese(2C)", add
label def teachcredemp 53 "MS/BCLAD-Cantonese(2D)", add
label def teachcredemp 54 "MS/BCLAD-Cambodian(2E)", add
label def teachcredemp 55 "MS/BCLAD-Filipino(2F)", add
label def teachcredemp 56 "MS/BCLAD-Hmong(2H)", add
label def teachcredemp 57 "MS/BCLAD-Japanese(2J)", add
label def teachcredemp 58 "MS/BCLAD-Korean(2K)", add
label def teachcredemp 59 "MS/BCLAD-Laotian(2L)", add
label def teachcredemp 60 "MS/BCLAD-Mandarin(2M)", add
label def teachcredemp 61 "MS/BCLAD-Native American(2N)", add
label def teachcredemp 62 "MS/BCLAD-Portuguese(2P)", add
label def teachcredemp 63 "MS/BCLAD-Pan-Asian(2R)", add
label def teachcredemp 64 "MS/BCLAD-Spanish(2S)", add
label def teachcredemp 65 "MS/BCLAD-Yurok/Hup(2Y)", add
label def teachcredemp 66 "MS/BCLAD-Vietnamese(2V)", add

drop credentialemphasis

label val teachcredemp teachcredemp
label var teachcredemp "(Teacher) Credential Emphasis"


*** registerednurse
*    p 308 in 2016 OPSMAN

qui replace registerednurse = trim(registerednurse)

qui generate rn = .
qui replace rn = 0 if registerednurse=="N"
qui replace rn = 1 if registerednurse=="Y"

*di "`year' `term'"
*tab registerednurse if rn == ., missing
* mainly blank, sometimes zero, every once in a while 1, 20064 some 2-8

label var rn "Registered Nurse @ Matriculation"

drop registerednurse


*** satiwriting
* NOT IN OPSMAN 2016, p 276 OPSMAN 2007

qui destring satiwriting, generate(satwrit) force

*di "`year' `term'"
*sum satwrit
*tab satiwriting if satwrit == ., missing

*from 20032 to 20063 the SAT scores ranged from 0-9
* In 20064 they moved to an 800 point scale, though that term there were also
* a bunch of scores between zero and 200.

drop satiwriting

label var satwrit "SAT I Writing Score: weird, examine values"


*** unassigned
* NOT IN OPSMAN 2016

*di "`year' `term'"
*tab unassigned, missing
* mainly blank, sometimes zero

/*
20064: 

 Unassigned |      Freq.     Percent        Cum.
------------+-----------------------------------
            |    558,909       97.66       97.66
          2 |          1        0.00       97.66
         0  |     12,900        2.25       99.91
         1  |         81        0.01       99.93
         2  |         58        0.01       99.94
         3  |         63        0.01       99.95
         4  |         57        0.01       99.96
         5  |         39        0.01       99.96
         6  |         52        0.01       99.97
         7  |         37        0.01       99.98
         8  |         72        0.01       99.99
         9  |         48        0.01      100.00
------------+-----------------------------------
      Total |    572,317      100.00
*/
drop unassigned


*** collegepreparatoryworldhistcultu 
*** collegepreparatoryushistgovernme 
*** collegepreparatorylaboratoryscie 
*** collegepreparatoryforeignlanguag 
*** collegepreparatoryvisualperformi 
*** collegepreparatoryelectives
*    p 121 - 136 in 2016 OPSMAN

* Valid values are the set of integers [0, 16]

* According to the 2016 OPSMAN the valid range is [0,16]. However ,there are 
* a non trivial number of entries that are >16 (it is a very small percentage,
* but it happens in most years, sometimes as often as a couple hundred.
* Some is likely data entry error (it is unlikely that students have 80
* semesters of college prep english) but could some be correct? I don't know.
* TURNING EVERYTHING OUTSIDE THE VALID RANGE TO MISSING

*di "`year' `term'"

foreach var in ///
	collegepreparatoryworldhistcultu ///
	collegepreparatoryushistgovernme ///
	collegepreparatorylaboratoryscie ///
	collegepreparatoryforeignlanguag ///
	collegepreparatoryvisualperformi ///
	collegepreparatoryelectives {

if "`var'" == "collegepreparatoryworldhistcultu" {
	local newvar "cprepwhc"
	local label "Sem Col Prep WorldHist&Cult"
}
else if "`var'" == "collegepreparatoryushistgovernme" {
	local newvar "cprepgov"
	local label "Sem Col Prep US Hist&Gov"
}
else if "`var'" == "collegepreparatorylaboratoryscie" {
	local newvar "cprepsci"
	local label "Sem Col Prep Lab Sci."
}
else if "`var'" == "collegepreparatoryforeignlanguag" {
	local newvar "cprepflg"
	local label "Sem Col Prep For. Lang."
}
else if "`var'" == "collegepreparatoryvisualperformi" {
	local newvar "cprepvsp"
	local label "Sem Col Prep Visual&Perf Arts"
}
else if "`var'" == "collegepreparatoryelectives" {
	local newvar "cprepele"
	local label "Sem Col Prep Electives"
}

qui destring `var', generate(`newvar') force
qui replace `newvar' = . if !inlist(`newvar', 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16)

*tab `var' if `newvar'==., missing

drop `var'
label var `newvar' "`label'"

}


*** highschooltranscriptstatus
*    p 259 in 2016 OPSMAN

qui replace highschooltranscriptstatus = trim(highschooltranscriptstatus)

qui gen hstranscript =.
qui replace hstranscript = 1 if highschooltranscriptstatus=="F"
qui replace hstranscript = 2 if highschooltranscriptstatus=="G"
qui replace hstranscript = 3 if highschooltranscriptstatus=="I"
qui replace hstranscript = 4 if highschooltranscriptstatus=="M"
qui replace hstranscript = 5 if highschooltranscriptstatus=="N"
qui replace hstranscript = 6 if highschooltranscriptstatus=="P"
qui replace hstranscript = 7 if highschooltranscriptstatus=="R"
qui replace hstranscript = 8 if highschooltranscriptstatus=="U"
qui replace hstranscript = 9 if highschooltranscriptstatus=="-"
	
*di "`year' `term'"
*tab highschooltranscriptstatus if hstranscript==., missing
* mainly blank. A small amount of random stuff that looks like typos
	
label def hstranscript 1 "Final Transcript(F)"
label def hstranscript 2 "Rec. 1 Trans, 1 more req.(G)", add
label def hstranscript 3 "Incomplete Transcript(I)", add
label def hstranscript 4 "Missing Transcript(M)", add
label def hstranscript 5 "Transcript Not Required(N)", add
label def hstranscript 6 "Partial Transcript(P)", add
label def hstranscript 7 "Transcript Rec. in Office(R)", add
label def hstranscript 8 "Unofficial Transcript(U)", add
label def hstranscript 9 "No Transcript Rec.(-)", add
	
drop highschooltranscriptstatus
label val hstranscript hstranscript
label var hstranscript "High School Transcript Status"


*** credentialstatus
*    p 154 in 2016 OPSMAN

qui gen credstat =.
qui replace credstat = 1 if credentialstatus=="4"
qui replace credstat = 2 if credentialstatus=="5"
qui replace credstat = 3 if credentialstatus=="6"
qui replace credstat = 4 if credentialstatus=="V"
qui replace credstat = 5 if credentialstatus=="8"
qui replace credstat = 6 if credentialstatus=="9"
qui replace credstat = 7 if credentialstatus=="3"
qui replace credstat = 8 if credentialstatus=="7"
qui replace credstat = 9 if credentialstatus=="1"
qui replace credstat = 10 if credentialstatus=="2"
qui replace credstat = 11 if credentialstatus=="X"
qui replace credstat = 12 if credentialstatus=="Y"
qui replace credstat = 13 if credentialstatus=="N"
	
*di "`year' `term'"
*tab credentialstatus if credstat==., missing
* there's some crap, but the only thing in any sort of substancial numbers are zeros
	
label def credstat 1 "Regular Credential Prog(4)"
label def credstat 2 "Regular Credential Prog(5)", add
label def credstat 3 "Regular Credential Prog(6)", add
label def credstat 4 "Regular Credential Prog(V)", add
label def credstat 5 "Internship Prog to Cred(8)", add
label def credstat 6 "Pipeline to Credential(9)", add
label def credstat 7 "Emergency/Supplement/Maintain(3)", add
label def credstat 8 "Emergency/Supplement/Maintain(7)", add
label def credstat 9 "Emergency/Supplement/Maintain(1)", add
label def credstat 10 "Emergency/Supplement/Maintain(2)", add
label def credstat 11 "Express Interest in Cred. Prog(X)", add
label def credstat 12 "Express Interest in Cred. Prog(Y)", add
label def credstat 13 "Not seeking Credential(N)", add
	
drop credentialstatus

label val credstat credstat
label var credstat "Credential Status"


*** credentialandsubjectmatterwaiver
*    p 159 in 2016 OPSMAN
*    also refer to COSAR table 26

qui destring credentialandsubjectmatterwaiver, generate(credwvobj) force
qui replace credwvobj = . if !inrange(credwvobj, 100, 998)

*di "`year' `term'"
*tab credentialandsubjectmatterwaiver if credwvobj==., missing
* mainly blanks and triple zeros but some numbers (mainly <100).
* I don't know if they are typos or actual values.

label def credwvobj 100 "SINGLE SUBJECT"
label def credwvobj 105 "AGRICULTURE",add
label def credwvobj 110 "ART",add
label def credwvobj 115 "BUSINESS",add
label def credwvobj 120 "ENGLISH",add
label def credwvobj 125 "GOVERNMENT",add
label def credwvobj 130 "HEALTH SCIENCES",add
label def credwvobj 135 "HISTORY",add
label def credwvobj 140 "HOME ECONOMICS",add
label def credwvobj 144 "ARABIC",add
label def credwvobj 145 "INDUSTRIAL TECHNOLOGY",add
label def credwvobj 146 "ARMENIAN",add
label def credwvobj 147 "CANTONESE",add
label def credwvobj 148 "FARSI",add
label def credwvobj 149 "HINDI",add
label def credwvobj 150 "KHMER",add
label def credwvobj 151 "CHINESE",add
label def credwvobj 152 "FRENCH",add
label def credwvobj 153 "GERMAN",add
label def credwvobj 154 "ITALIAN",add
label def credwvobj 155 "JAPANESE",add
label def credwvobj 156 "LATIN",add
label def credwvobj 157 "RUSSIAN",add
label def credwvobj 158 "SPANISH",add
label def credwvobj 159 "KOREAN",add
label def credwvobj 160 "LIFE SCIENCES",add
label def credwvobj 161 "HMONG",add
label def credwvobj 162 "MANDARIN",add
label def credwvobj 163 "VIETNAMESE",add
label def credwvobj 164 "PUNJABI",add
label def credwvobj 165 "MATHEMATICS",add
label def credwvobj 166 "FOUNDATION LEVEL MATHEMATICS",add
label def credwvobj 167 "FOUNDATION LEVEL GENERAL SCIENCE",add
label def credwvobj 170 "MUSIC",add
label def credwvobj 171 "CHEMISTRY (SPECIALIZED)",add
label def credwvobj 172 "GEO SCIENCES (SPECIALIZED)",add
label def credwvobj 173 "PHYSICS (SPECIALIZED)",add
label def credwvobj 174 "BIOLOGICAL SCIENCES (SPECIALIZED)",add
label def credwvobj 175 "PHYSICAL EDUCATION",add
label def credwvobj 180 "PHYSICAL SCIENCE",add
label def credwvobj 181 "SCIENCE: CHEMISTRY",add
label def credwvobj 182 "SCIENCE: GEO SCIENCE",add
label def credwvobj 183 "SCIENCE: PHYSICS",add
label def credwvobj 184 "SCIENCE: BIOLOGICAL SCIENCE",add
label def credwvobj 185 "SOCIAL SCIENCE",add
label def credwvobj 186 "PORTUGUESE",add
label def credwvobj 187 "HEBREW",add
label def credwvobj 190 "AMERICAN SIGN LANGUAGE",add
label def credwvobj 195 "ENG LANG DEVELOPMENT",add
label def credwvobj 199 "UPGRADE TO CLEAR",add
label def credwvobj 200 "MULTIPLE SUBJECT INSTRUCTION",add
label def credwvobj 299 "UPGRADE TO CLEAR",add
label def credwvobj 300 "DESIGNATED SUBJECTS",add
label def credwvobj 305 "REGULAR FULL-TIME ADULT",add
label def credwvobj 310 "REGULAR PART-TIME ADULT",add
label def credwvobj 315 "VOCATIONAL FULL-TIME",add
label def credwvobj 320 "VOCATIONAL PART-TIME",add
label def credwvobj 325 "SPECIAL SUBJECTS",add
label def credwvobj 330 "SUPERVISION AND COORDINATION",add
label def credwvobj 335 "CAREER TECHNICAL EDU FULL-TIME",add
label def credwvobj 336 "CAREER TECHNICAL EDU PART-TIME",add
label def credwvobj 337 "CAREER TECHNICAL EDU",add
label def credwvobj 399 "DESIGNATED SUBJECT OTHER",add
label def credwvobj 410 "READING LANGUAGE ARTS SPECIALIST",add
label def credwvobj 415 "READING CERTIFICATE",add
label def credwvobj 420 "MATHEMATICS SPECIALIST",add
label def credwvobj 430 "EARLY CHILDHOOD EDUCATION",add
label def credwvobj 435 "EARLY CHILDHOOD SPECIAL EDUCATION",add
label def credwvobj 436 "EARLY CHILDHOOD SPECIAL EDUCATION (2010)",add
label def credwvobj 440 "BILINGUAL / CROSS CULTURAL",add
label def credwvobj 441 "SPECIAL ED: AFRO-AMERICAN",add
label def credwvobj 442 "SPECIAL ED: CANTONESE",add
label def credwvobj 443 "SPECIAL ED: CANTONESE/MANDARIN",add
label def credwvobj 444 "SPECIAL ED: JAPANESE",add
label def credwvobj 445 "SPECIAL ED: SPANISH (MEXICAN/AMERICAN)",add
label def credwvobj 446 "SPECIAL ED: TAGALOG",add
label def credwvobj 447 "SPECIAL ED: CTEL(CALIFORNIA TEACHER OF ENGLISH LEARNERS) CLAD CERTIFICATE",add
label def credwvobj 450 "SPECIAL ED: HEALTH SCIENCE TEACHING",add
label def credwvobj 460 "DEAF AND HARD OF HEARING",add
label def credwvobj 461 "SPECIAL ED, INCLUDING COMMUNICATION HANDICAPPED",add
label def credwvobj 462 "PHYSICALLY HANDICAPPED",add
label def credwvobj 463 "LEARNING HANDICAPPED",add
label def credwvobj 464 "SEVERELY HANDICAPPED",add
label def credwvobj 465 "GIFTED",add
label def credwvobj 466 "VISUALLY HANDICAPPED",add
label def credwvobj 467 "SPECIAL EDUCATION RESOURCE SPECIALIST",add
label def credwvobj 468 "MILD/MODERATE DISABILITIES (NO BASIC CRED REQUIRED)",add
label def credwvobj 469 "MODERATE/SEVERE DISABILITIES (NO BASIC CRED REQUIRED)",add
label def credwvobj 470 "SPECIAL ED: AGRICULTURE SPECIALIST",add
label def credwvobj 471 "VISUAL IMPAIRMENTS (NO BASIC CRED REQUIRED)",add
label def credwvobj 472 "PHYSICAL AND HEALTH IMPAIRMENTS (NO BASIC CRED REQUIRED)",add
label def credwvobj 473 "SEVERELY EMOTIONALLY DISTURBED",add
label def credwvobj 480 "LANGUAGE DEVELOPMENT SPECIALIST",add
label def credwvobj 481 "MILD/MODERATE DISABILITIES (2010)",add
label def credwvobj 482 "MODERATE/SEVERE DISABILITIES (2010)",add
label def credwvobj 483 "VISUAL IMPAIRMENTS (2010)",add
label def credwvobj 484 "PHYSICAL AND HEALTH IMPAIRMENTS (2010)",add
label def credwvobj 485 "DEAF AND HARD OF HEARING (2010)",add
label def credwvobj 490 "ADAPTED PHYSICAL EDUCATION",add
label def credwvobj 491 "EARLY CHILDHOOD EDUCATION SPECIALIST",add
label def credwvobj 492 "MILD/MODERATE DISABILITIES(W/ELEM. EMPHASIS)",add
label def credwvobj 493 "MODERATE/SEVERE DISABILITIES(W/ELEM. EMPHASIS)",add
label def credwvobj 494 "MILD/MODERATE DISABILITIES(W/SECOND. EMPHASIS)",add
label def credwvobj 495 "MODERATE/SEVERE DISABILITIES(W/SECOND. EMPHASIS)",add
label def credwvobj 496 "PHYSICAL & HEALTH DISABILITIES(W/ELEM. EMPHASIS)",add
label def credwvobj 497 "PHYSICAL & HEALTH DISABILITIES(W/SECOND. EMPHASIS)",add
label def credwvobj 498 "VISUAL IMPAIRMENTS & BLINDNESS(W/ELEM. EMPHASIS)",add
label def credwvobj 499 "VISUAL IMPAIRMENTS & BLINDNESS(W/SECOND. EMPHASIS)",add
label def credwvobj 500 "ADMINISTRATIVE SERVICES CREDENTIAL",add
label def credwvobj 501 "ADMINISTRATIVE SERVICES, PRELIMINARY",add
label def credwvobj 502 "ADMINISTRATIVE SERVICES, PROFESSIONAL",add
label def credwvobj 503 "ADMINISTRATIVE SERVICES INTERNSHIP",add
label def credwvobj 600 "HEALTH SERVICES/SCHOOL NURSE",add
label def credwvobj 700 "LIBRARIANSHIP/MEDIA",add
label def credwvobj 800 "PUPIL PERSONNEL SERVICES",add
label def credwvobj 801 "PUPIL PERSONNEL SERVICES-CHILD WELFARE & ATTENDANCE",add
label def credwvobj 802 "PUPIL PERSONNEL SERVICES-COUNSELING",add
label def credwvobj 803 "PUPIL PERSONNEL SERVICES-SOCIAL WORK",add
label def credwvobj 804 "PUPIL PERSONNEL SERVICES-SCHOOL PSYCHOLOGY",add
label def credwvobj 805 "PUPIL PERSONNEL SERVICES-CHILD WELFARE AND ATTENDANCE",add
label def credwvobj 810 "PUPIL PERSONNEL SERVICES COUNSELING",add
label def credwvobj 820 "PSYCOLOGICAL SERVICES",add
label def credwvobj 840 "SCHOOL SOCIAL WORK",add
label def credwvobj 900 "CLINICAL REHABILITATIVE",add
label def credwvobj 901 "LANGUAGE SPEECH HEARING",add
label def credwvobj 902 "LANGUAGE SPEECH HEARING/AUDIOLOGY",add
label def credwvobj 903 "AUDIOLOGY",add
label def credwvobj 904 "ORIENTATION MOBILITY",add
label def credwvobj 905 "SPECIAL CLASS AUTHORIZATION",add
label def credwvobj 910 "LANG, SPEECH AND HEARING, INCLUDING SPECIAL CLASS AUTH",add
label def credwvobj 911 "LANG, SPEECH AND HEARING, ADDING SPECIAL CLASS AUTH",add
label def credwvobj 912 "SPEECH LANGUAGE PATHOLOGY",add
label def credwvobj 950 "SCHOOL PSYCHOLOGIST",add
label def credwvobj 952 "LANGUAGE, SPEECH, AND HEARING AUDIOLOGY",add
label def credwvobj 953 "LANGUAGE, SPEECH, AND HEARING INCLUDING SPECIAL CLASS AUTHORIZATION",add
label def credwvobj 954 "LANGUAGE, SPEECH, HEARING AND AUDIOLOGY INCLUDING SPECIAL CLASS AUTHORIZA",add
label def credwvobj 980 "ADAPTED PHYSICAL EDUCATION",add
label def credwvobj 998 "NONTEACHING POSTBACCALAUREATE CERTIFICATE",add

drop credentialandsubjectmatterwaiver
	
label val credwvobj credwvobj
label var credwvobj "Credential & Subj Matter Waiver Obj"


*** disabilitystatus
* NOT IN OPSMAN 2016
* no longer in use

*di "`year' `term'"
*tab disabilitystatus, missing

rename disabilitystatus disability
label var disability "Disability Status (not in OPSMAN2016)"


*** gebreadthcriticalthinking 
*** gebreadthenglishcomposition 
*** gebreadthmathematicsquantitative 
*** gebreadthoralcommunications
*    p 247 - 258 in 2016 OPSMAN

*di "`year' `term'"

label def ge 0 "Not Completed"
label def ge 1 "In Progress during app review", add
label def ge 2 "Completed", add
label def ge .a "Not a valid entry (X)", add
label def ge .b "Not a valid entry (S)", add



foreach var in ///
	gebreadthcriticalthinking ///
	gebreadthenglishcomposition ///
	gebreadthmathematicsquantitative ///
	gebreadthoralcommunications {

if "`var'" == "gebreadthcriticalthinking" {
	local newvar "gecrit"
	local label "GE-Breadth Critical Thinking Completion Status"
}
else if "`var'" == "gebreadthenglishcomposition" {
	local newvar "geeng"
	local label "GE-Breadth English Comp Completion Status"
}
else if "`var'" == "gebreadthmathematicsquantitative" {
	local newvar "gemath"
	local label "GE-Breadth Math/Quant Reasoning Completion Status"
}
else if "`var'" == "gebreadthoralcommunications" {
	local newvar "gecom"
	local label "GE-Breadth Oral Communications Completion Status"
}
else {
	di "Dirty Data Girl CXLED. Boo."
}

qui gen `newvar' = .

qui replace `newvar' = 0 if `var'=="N"
qui replace `newvar' = 2 if `var'=="Y"
qui replace `newvar' = 1 if `var'=="I"
qui replace `newvar' = .a if `var'=="X"
qui replace `newvar' = .b if `var'=="S"

*tab `var' if `newvar' ==., missing

drop `var'

label val `newvar' ge

label var `newvar' "`label'"
}


*** studentname
*    p 344 in 2016 OPSMAN

rename studentname name
qui replace name = trim(name)

*di "`year' `term'"
*count if name == ""
*count
* stops being used in 20114

label var name "Student Name"


*** transfergpa
*    p 396 in 2016 OPSMAN
*    valid range [0, 400]

rename transfergpa x

qui destring x, generate(transfergpa) force
qui replace transfergpa = . if !inrange(transfergpa, 0, 400)

*di "`year' `term'"
*tab x if transfergpa ==., missing
* mainly 000s and blanks, but some greater than 400. Could be real, could be typos.

drop x

label var transfergpa "Transfer GPA"


*** transferunitsearned
*    p 401 in 2016 OPSMAN

qui destring transferunitsearned, generate(transferunits) force
qui replace transferunits = . if !inrange(transferunits, 0, 9999)
qui replace transferunits = transferunits/10

*di "`year' `term'"
*tab transferunitsearned if transferunits==., missing
* only two missings for all files.

drop transferunitsearned

label var transferunits "Transfer Units Earned"


*** immigrationyear
*    p 265 in 2016 OPSMAN

qui destring immigrationyear, generate(immigrationyr) force
qui replace immigrationyr = . if !inrange(immigrationyr, 1900, 2050)

*di "`year' `term'"
*tab immigrationyear if immigrationyr == ., missing

drop immigrationyear

label var immigrationyr "Immigration Year"


*** startdatecalstateteach
*    p 100 in 2016 OPSMAN

qui replace startdatecalstateteach = trim(startdatecalstateteach)

qui generate caltchdate = date(startdatecalstateteach, "YMD")
format caltchdate %td

*di "`year' `term'"
*tab startdatecalstateteach if caltchdate == ., missing
* almost all zeros or blanks

drop startdatecalstateteach

label var caltchdate "CalStateTEACH Start Date"


*** usmilitarystatus
*    p 407 in 2016 OPSMAN

qui replace usmilitarystatus = trim(usmilitarystatus)
qui gen military =.
qui replace military = 1 if usmilitarystatus=="1"
qui replace military = 2 if usmilitarystatus=="2"
qui replace military = 3 if usmilitarystatus=="3"
qui replace military = 4 if usmilitarystatus=="4"
qui replace military = .a if usmilitarystatus=="X"
qui replace military = .b if usmilitarystatus=="Y"
qui replace military = .c if usmilitarystatus=="#"

	
*di "`year' `term'"
*tab usmilitarystatus if military==., missing
*tab usmilitarystatus, missing
	
label def military 1 "Yes, have been active not dependt"
label def military 2 "Yes, have been active and dependt", add
label def military 3 "Yes, dependent of", add
label def military 4 "No, never active or dependt", add
label def military .a "Not valid entry (X)", add
label def military .b "Not valid entry (Y)", add
label def military .c "Not valid entry (#)", add

drop usmilitarystatus

label val military military
label var military "U.S. Military Status"


order ///
	idunique ///
	name ///
	year ///
	term ///
	campus ///
	csid ///
	dob ///
	female ///
	ethnic ///
	ethnicdetail ///
	edumom ///
	edudad ///
	depinc ///
	depfam ///
	indinc ///
	indfam ///
	citizenship ///
	countryofcitizenship ///
	immigrationyr ///
	residence ///
	residencestatus ///
	accommodationstatus ///
	accommodationdate ///
	disability ///
	appdate ///
	appfee ///
	admissionbasis ///
	admissionbasis2 ///
	exceptionadmission ///
	admissionstatus ///
	admissiondate ///
	enrollstat ///
	specpro ///
	teachcredemp ///
	credstat ///
	credwvobj ///
	caltchdate ///
	rn ///
	level ///
	degreeobj ///
	majoroce ///
	majorocedd ///
	cip ///
	institutionorigin ///
	instorgtype ///
	hstranscript ///
	hsgpa ///
	cprepeng ///
	cprepmath ///
	cprepwhc ///
	cprepgov ///
	cprepsci ///
	cprepflg ///
	cprepvsp ///
	cprepele ///
	acteng ///
	actmath ///
	actread ///
	actsci ///
	actcomp ///
	actwrit ///
	satcenter ///
	satverb ///
	satwrit ///
	satmath ///
	sattot ///
	mathprof ///
	mathprofsum ///
	engprof ///
	engprofsum ///
	elmadmindate ///
	elmalg ///
	elmgeo ///
	elm1sttot ///
	elmtot ///
	eptessay ///
	eptread ///
	eptcomp ///
	epttot ///
	toefl ///
	elpt ///
	gecrit ///
	geeng ///
	gemath ///
	gecom ///
	transfergpa ///
	transferunits ///
	military
		
qui compress
qui save "clean/csu actually clean/era/era`year'`term'.dta", replace

}

}


*** Cleaning the variables that are in all the fixed width files.

forvalues year = 1997 / 2017 {

forvalues term = 1/4 {

if `year' == 1997 & `term' == 1 | ///
   `year' == 1997 & `term' == 2 | ///
   `year' == 1997 & `term' == 3 | ///
   `year' == 1998 & `term' == 1 | ///
   `year' == 1998 & `term' == 3 | ///
   `year' == 1999 & `term' == 1 | ///
   `year' == 1999 & `term' == 3 | ///
   `year' == 2000 & `term' == 1 | ///
   `year' == 2001 & `term' == 1 | ///
   `year' == 2002 & `term' == 1 {
    
	display "No file exists for `year'`term' (3)"
	continue

   }
 
else if `year' == 1997 & `term' == 4 | ///
        `year' == 1998 & `term' == 2 | ///
        `year' == 1998 & `term' == 4 | ///
        `year' == 1999 & `term' == 2 | ///
        `year' == 1999 & `term' == 4 | ///
        `year' == 2000 & `term' == 2 | ///
        `year' == 2000 & `term' == 3 | ///
        `year' == 2000 & `term' == 4 | ///
        `year' == 2001 & `term' == 2 | ///
        `year' == 2001 & `term' == 3 | ///
        `year' == 2001 & `term' == 4 | ///
        `year' == 2002 & `term' == 2 {

	display "Variable set not in type a file `year'`term' (2)"
	continue

  }  
  
else if `year' == 2004 & `term' == 3 | ///
        `year' == 2004 & `term' == 4 | ///
        `year' == 2005 | ///
        `year' == 2006 | ///
        `year' == 2007 | ///
        `year' == 2008 | ///
        `year' == 2009 & `term' == 1 | ///
        `year' == 2009 & `term' == 2 | ///
        `year' == 2009 & `term' == 3 {

	display "Variable set not in type a file `year'`term' (2)"
	continue

  }   
  
else if `year' == 2002 & `term' == 3 | ///
        `year' == 2002 & `term' == 4 | ///
        `year' == 2003 | ///
        `year' == 2004 & `term' == 1 | ///
        `year' == 2004 & `term' == 2 {

	local filepath "csu update 11-15-10"
	local era "era"

  } 
  
else if `year' == 2009 & `term' == 4 | ///
        `year' == 2010 | ///
        `year' == 2011 | ///
        `year' == 2012 | ///
        `year' == 2013 & `term' == 1 | ///
        `year' == 2013 & `term' == 2 | ///
        `year' == 2013 & `term' == 3 {

	local filepath "CSU Data Update Jake"
	local era "era"

  }  

else if `year' == 2013 & `term' == 4 | ///
        `year' == 2014 & `term' == 1 | ///
        `year' == 2014 & `term' == 2 | ///
        `year' == 2014 & `term' == 3 {

	local filepath "CSU Update 7-15-2015"
	local era "era"

  } 
  
else if `year' == 2014 & `term' == 4 | ///
        `year' == 2015 | ///
        `year' == 2016 & `term' == 1 | ///
        `year' == 2016 & `term' == 2 {

	local filepath "CSU update 10-6-16"
	local era "era"

  }
  
else if `year' == 2016 & `term' == 3 | /// 
	`year' == 2016 & `term' == 4 | ///
	`year' == 2017 & `term' == 1 | ///
	`year' == 2017 & `term' == 2  {

	local filepath "CSU Update 10-23-17"
	local era "era"

  }
  
else if `year' == 2017 & `term' == 3 | ///
	`year' == 2017 & `term' == 4 {

	local filepath "CSU Update 11.29.17"
	local era "era"

  }
  
else {

	display "unhelpful error message 159265359"

 }

use "clean/csu actually clean/era/era`year'`term'.dta", clear

di "3 `year' `term'"

*** collegeprepsocialsciences
*    p 131 in 2016 OPSMAN

* Valid values are the set of integers [0, 16]

* According to the 2016 OPSMAN the valid range is [0,16]. However ,there are 
* a non trivial number of entries that are >16 (it is a very small percentage,
* but it happens in most years, sometimes as often as a couple hundred.
* Some is likely data entry error (it is unlikely that students have 80
* semesters of college prep english) but could some be correct? I don't know.
* TURNING EVERYTHING OUTSIDE THE VALID RANGE TO MISSING

qui destring collegeprepsocialsciences, generate(cprepssc) force
qui replace cprepssc = . if !inlist(cprepssc, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16)

*di "`year' `term'"
*tab collegeprepsocialsciences if cprepssc==., missing
*count
* all blank

drop collegeprepsocialsciences

label var cprepssc "Sem Col Prep Soc Sci."


*** hispaniclatinostatus
*    p 263 in 2016 OPSMAN

qui replace hispaniclatinostatus=trim(hispaniclatinostatus)

qui generate hisplatin = .
qui replace hisplatin = 1 if hispaniclatinostatus=="Y"
qui replace hisplatin = 0 if hispaniclatinostatus=="N"
qui replace hisplatin = .a if hispaniclatinostatus=="D"

*di "`year' `term'"
*tab hispaniclatinostatus if hisplatin==., missing
*count

label def hisplatin ///
	0 "No" ///
	1 "Yes" ///
	.a "Decline to State"

drop hispaniclatinostatus

label val hisplatin hisplatin
label var hisplatin "Hispanic/Latino Status"


*** hispaniclatinoethniccategory
*    p 261 in 2016 OPSMAN

qui destring hispaniclatinoethniccategory, generate(hisplatincat) force
qui replace hisplatincat = . if !inlist(hisplatincat, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23)

*di "`year' `term'"
*tab hispaniclatinoethniccategory if hisplatincat==., missing
*count
* virtually all blanks

label def hisplatincat ///
	1 "Mexican" ///	
	2 "Puerto Rican" ///
	3 "Cuban" ///
	4 "Dominican (Dominican Rep.)" ///
	5 "Costa Rican" ///
	6 "Guatemalan" ///
	7 "Honduran" ///
	8 "Nicaraguan" ///
	9 "Panamanian"	///
	10 "Salvadoran" ///
	11 "Other Central American" ///
	12 "Argentinean" ///
	13 "Bolivian" ///
	14 "Chilean" ///
	15 "Colombian" ///
	16 "Ecuadorian" ///
	17 "Paraguayan" ///
	18 "Peruvian" ///
	19 "Uruguayan" ///
	20 "Venezuelan" ///
	21 "Other South American" ///
	22 "Spaniard" ///
	23 "Other Hispanic or Latino"
	
drop hispaniclatinoethniccategory

label val hisplatincat hisplatincat
label var hisplatincat "Hisp/Latino Ethnic Catagory"


*** multipleracecategory
*    p 290 in 2016 OPSMAN

qui destring multipleracecategory, generate(multrace) force
qui replace multrace = . if !inlist(multrace, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31)
qui replace multrace = .a if multipleracecategory == "00"

*di "`year' `term'"
*tab multipleracecategory if multrace==., missing
*count
* all blanks

label def multrace ///
	1 "White Only (White)" ///
	2 "Black or African American Only (Black)" ///
	3 "American Indian or Alaskan Native Only (American Indian)" ///
	4 "Asian Only (Asian)" ///
	5 "Native Hawaiian or Other Pacific Islander Only (Pacific Islander)" ///
	6 "White and Black" ///
	7 "White and American Indian" ///
	8 "White and Asian" ///
	9 "White and Pacific Islander" ///
	10 "Black and American Indian" ///
	11 "Black and Asian" ///
	12 "Black and Pacific Islander" ///
	13 "American Indian and Asian" ///
	14 "American Indian and Pacific Islander" ///
	15 "Asian and Pacific Islander" ///
	16 "White, Black and American Indian" ///
	17 "White, Black and Asian" ///
	18 "White, Black and Pacific Islander" ///
	19 "White, American Indian and Asian" ///
	20 "White, American Indian and Pacific Islander" ///
	21 "White, Asian, Pacific Islander" ///
	22 "Black, American Indian and Asian" ///
	23 "Black, American Indian and Pacific Islander" ///
	24 "Black, Asian, and Pacific Islander" ///
	25 "American Indian, Asian and Pacific Islander" ///
	26 "White, Black, American Indian and Asian" ///
	27 "White, Black, American Indian and Pacific Islander" ///
	28 "White, Black, Asian and Pacific Islander" ///
	29 "White, American Indian, Asian and Pacific Islander" ///
	30 "Black, American Indian, Asian and Pacific Islander" ///
	31 "White, Black, American Indian, Asian and Pacific Islander" ///
	.a "Decline to State"

drop multipleracecategory

label val multrace multrace
label var multrace "Multiple Race Category"


*** ipedsraceethnicityreportingcat
*    p 274 in 2016 OPSMAN

qui destring ipedsraceethnicityreportingcat, generate(ipedsrace) force

qui replace ipedsrace = . if !inlist(ipedsrace, 1, 2, 3, 4, 5, 6, 7, 8)
qui replace ipedsrace = .a if ipedsrace == 8

*di "`year' `term'"
*tab ipedsraceethnicityreportingcat if ipedsrace==., missing
*count
* all blanks

label def ipedsrace ///
	1 "White-NonHisp" ///
	2 "Black/AA-NonHisp" ///
	3 "Am Ind or Alaska Nat-NonHisp" ///
	4 "Asian-NonHisp" ///
	5 "Nat HI or Pac Is-NonHisp" ///
	6 "2 or More Races-NonHisp" ///
	7 "Hispanic/Latino" ///
	.a "Unknown"

drop ipedsraceethnicityreportingcat

label val ipedsrace ipedsrace
label var ipedsrace "IPEDS Race/Eth Reporting Cat."


*** csuraceethnicityreportingcat
*    p 166 in 2016 OPSMAN

qui destring csuraceethnicityreportingcat, generate(csuraceeth) force

qui replace csuraceeth = . if !inlist(csuraceeth, 1, 2, 3, 4, 5, 6, 7, 8)
qui replace csuraceeth = .a if csuraceeth == 8

*di "`year' `term'"
*tab csuraceethnicityreportingcat if csuraceeth==., missing
*count
* all blanks


label def csuraceeth ///
	1 "White" ///
	2 "Black or Af. Am." ///
	3 "Am Ind or Alaska Nat" ///
	4 "Asian" ///
	5 "Nat HI or Pac Is" ///
	6 "2 or More Races/Eth" ///
	7 "Hispanic or Latino" ///
	.a "Decline to State"

drop csuraceethnicityreportingcat

label val csuraceeth csuraceeth
label var csuraceeth "CSU Race/Eth Reporting Cat."


*** studentlastname
*    p 338 in 2016 OPSMAN

rename studentlastname namelast
qui replace namelast = trim(namelast)

*di "`year' `term'"
*count if namelast == ""
*count
* first use 20113

label var namelast "Student Last Name"


*** studentfirstname
*    p 336 in 2016 OPSMAN

rename studentfirstname namefirst
qui replace namefirst = trim(namefirst)

*di "`year' `term'"
*count if namefirst == ""
*count
* first use 20113

label var namefirst "Student First Name"


*** studentnamesuffix
*    p 336 in 2016 OPSMAN

rename studentnamesuffix namesuffix
qui replace namesuffix = trim(namesuffix)

*di "`year' `term'"
*count if namesuffix == ""
*count
* first use 20113

label var namesuffix "Student Name Suffix"


*** studentmiddlename
*    p 336 in 2016 OPSMAN

rename studentmiddlename namemiddle
qui replace namemiddle = trim(namemiddle)

*di "`year' `term'"
*count if namemiddle == ""
*count
* first use 20113

label var namemiddle "Student Middle Name"


*** earlystartenglish 
*** earlystartmathematics
*    p 202-205 in 2016 OPSMAN

qui destring earlystartenglish, generate(eseng) force
qui destring earlystartmathematics, generate(esmath) force

qui replace eseng = . if !inlist(eseng, 1, 2, 3, 4, 5, 6, 7)
qui replace esmath = . if !inlist(esmath, 1, 2, 3, 4, 5, 6, 7)

*di "`year' `term'"
*tab earlystartenglish if eseng==., missing
*tab earlystartmathematics if esmath==., missing
*count
* blanks and zeros

drop earlystartenglish earlystartmathematics

label def es ///
	1 "Participated" ///
	2 "Didn't Part., excempt by test scores, coll cred, or AP" ///
	3 "Didn't Part., excempt by summer prog." ///
	4 "Didn't Part., excempt by non res status" ///
	5 "Didn't Part., excempt by International status" ///
	6 "Didn't Part., excempt by local campus decision" ///
	7 "Didn't Part., non-excempt"
	
label val eseng es
label val esmath es

label var eseng "Early Start English"
label var esmath "Early Start Mathematics"


*** optionsuffixcode
*    p 294 in 2016 OPSMAN

qui destring optionsuffixcode, generate(optionsuffix) force
qui replace optionsuffix = . if !inrange(optionsuffix, 0, 99)

*di "`year' `term'"
*tab optionsuffixcode if optionsuffix==., missing
*count

drop optionsuffixcode

label var optionsuffix "Option Suffix Code"


*** eapenglishlanguageartsstatus 
*** eapmathematicsstatus
*    p 196 & 200 in 2016 OPSMAN

label def eapstat ///
	1 "Exempt, based on EAP (1,6)" ///
	2 "Conditional, considered ready at time of assessment (2,7)" ///
	3 "Non-exempt (3,8)" ///
	4 "Non-exempt, EAP incomplete (4,9)" ///
	5 "Student did not take EAP (5)"

*di "`year' `term'"	

foreach var in eapenglishlanguageartsstatus eapmathematicsstatus {

qui replace `var' = trim(`var')

qui generate `var'2 = .
qui replace `var'2 = 1 if inlist(`var', "1", "6")
qui replace `var'2 = 2 if inlist(`var', "2", "7")
qui replace `var'2 = 3 if inlist(`var', "3", "8")
qui replace `var'2 = 4 if inlist(`var', "4", "9")
qui replace `var'2 = 5 if inlist(`var', "5")

*tab `var' if `var'2==., missing
* all blanks
*tab `var', missing

drop `var'

label val `var'2 eapstat

}

rename eapenglishlanguageartsstatus2 eapelastat
rename eapmathematicsstatus2 eapmathstat

label var eapelastat "EAP ELA Status"
label var eapmathstat "EAP Math Status"


*** employeeidentificationnumber
*    p 208  in 2016 OPSMAN

qui destring employeeidentificationnumber, generate(x) force
qui replace x = . if x<1 | x>999999999999998

*di "`year' `term'"
*sum x
*tab employeeidentificationnumber if x==., missing
drop x
rename employeeidentificationnumber empid

label var empid "Employee Identification Number"

qui replace empid = trim(empid)
qui replace empid = "Not Valid 000000000000000" if empid =="000000000000000"


*** uscurrentmilitarystatus
*    p 403  in 2016 OPSMAN

qui destring uscurrentmilitarystatus, generate(militarynow) force
qui replace militarynow = . if !inlist(militarynow, 1, 2, 3, 4, 5)

*di "`year' `term'"
*sum militarynow
*tab uscurrentmilitarystatus if militarynow==., missing
* all blanks

drop uscurrentmilitarystatus

label def militarynow ///
	1 "Student is Active Duty (1)" ///
	2 "Student is National Guard (2)" ///
	3 "Student is Reserve (3)" ///
	4 "Student is Veteran (4)" ///
	5 "Not US military (5)"

label val militarynow militarynow
label var militarynow "US Current Military Status"


*** usmilitarydependentstatus
*    p 405  in 2016 OPSMAN

qui destring usmilitarydependentstatus, generate(militarydep) force
qui replace militarydep = . if !inlist(militarydep, 1, 2, 3, 4, 5)

*di "`year' `term'"
*sum militarydep
*tab usmilitarydependentstatus if militarydep==., missing
* all blanks

drop usmilitarydependentstatus

label def militarydep ///
	1 "Student a dependent of Active Duty member (1)" ///
	2 "Student a dependent of National Guard member (2)" ///
	3 "Student a dependent of Reserve member (3)" ///
	4 "Student a dependent of Veteran member (4)" ///
	5 "Not a dependent of US military member (5)"

label val militarydep militarydep
label var militarydep "US Military Dependent Status"


*** degreeheldcode
*    p 176 in 2016 OPSMAN

qui replace degreeheldcode = trim(degreeheldcode)
qui generate degreeheld = .
qui replace degreeheld=0 if degreeheldcode=="0"
qui replace degreeheld=1 if degreeheldcode=="1"
qui replace degreeheld=2 if degreeheldcode=="3"
qui replace degreeheld=3 if degreeheldcode=="4"
qui replace degreeheld=4 if degreeheldcode=="6"
qui replace degreeheld=5 if degreeheldcode=="2"
qui replace degreeheld=6 if degreeheldcode=="5"
qui replace degreeheld=7 if degreeheldcode=="8"

*di "`year' `term'"
*sum degreeheld
*tab degreeheldcode if degreeheld ==., missing
* all blanks

drop degreeheldcode

label def degreeheld ///
	0 "No degree (0)" ///
	1 "Associate of Arts (AA) (1) " ///
	2 "Associate of Science (AS) (3)" ///
	3 "Transfer Associate of Arts (TAA) (4)" ///
	4 "Transfer Associate of Science (TAA) (6)" ///
	5 "Bachelor's (2)" ///
	6 "Master's (5)" ///
	7 "Doctor's Degree (8)"

label val degreeheld degreeheld
label var degreeheld "Degree Held Code"	


*** cacommunitycollegecontrolnum
*    p 104 in 2016 OPSMAN

qui destring cacommunitycollegecontrolnum, generate(x) force
qui replace x = . if !inrange(x, 0, 99999)

*di "`year' `term'"
*sum x
*tab cacommunitycollegecontrolnum if x==., missing

drop x

rename cacommunitycollegecontrolnum ccccontroln
label var ccccontroln "CA Com. Col. Control Num."


*** redesignedsatevidencebasereadw 
*** redesignedsatmathematics 
*** redesignedsaticompositescore
*    p 320 in 2016 OPSMAN

qui destring redesignedsatevidencebasereadw, generate(satredrwr) force
qui destring redesignedsatmathematics, generate(satredmat) force
qui destring redesignedsaticompositescore, generate(satredtot) force

qui replace satredrwr = . if !inrange(satredrwr, 200, 800)
qui replace satredmat = . if !inrange(satredmat, 200, 800)
qui replace satredtot = . if !inrange(satredtot, 400, 1600)

*di "`year' `term'"
*sum satred*
*tab redesignedsatevidencebasereadw if satredrwr==., missing
*tab redesignedsatmathematics if satredmat==., missing
*tab redesignedsaticompositescore if satredtot==., missing
* Mainly "000" but a few scores less than 100 with leading zeros. And two 350 for the composite score.

drop redesignedsatevidencebasereadw redesignedsatmathematics redesignedsaticompositescore

label var satredrwr "Redesigned Ev. Based Reading & Writing Score"
label var satredmat "Redesigned Math Score"
label var satredtot "Redesigned Composite Score"


*** testscoreforenhancedactwriting
*    p 375 in 2016 OPSMAN

qui destring testscoreforenhancedactwriting, generate(actenhwrt)
qui replace actenhwrt = . if !inlist(actenhwrt, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36)

*di "`year' `term'"
*sum actenhwrt
*tab testscoreforenhancedactwriting if actenhwrt==., missing
* all "00"

drop testscoreforenhancedactwriting

label var actenhwrt "ACT Enhanced Writing"


*** eapenglishlanguageartsscore 
*** eapmathematicsscore
*    p 195, 198 in 2016 OPSMAN

qui destring eapenglishlanguageartsscore, generate(eapelasco) force
qui destring eapmathematicsscore, generate(eapmathsco) force

qui replace eapelasco = . if !inrange(eapelasco, 0, 3000)
qui replace eapmathsco = . if !inrange(eapmathsco, 0, 3000)

*di "`year' `term'"
*sum eapelasco eapmathsco
*tab eapenglishlanguageartsscore if eapelasco==., missing
*tab eapmathematicsscore if eapmathsco==., missing

drop eapenglishlanguageartsscore eapmathematicsscore

label var eapelasco "EAP ELA Score"
label var eapmathsco "EAP Math Score"


*** adtcompletionverificationstatu
*    p 98 in 2016 OPSMAN

qui destring adtcompletionverificationstatu, generate(adtstatus) force
qui replace adtstatus = . if !inlist(adtstatus, 0, 1)

*di "`year' `term'"
*sum adtstatus
*tab adtcompletionverificationstatu if adtstatus==., missing
* all blank

drop adtcompletionverificationstatu

label def adtstatus ///
	0 "Not Completed (0)" ///
	1 "Completed (1)"

label val adtstatus adtstatus
label var adtstatus "ADT Completion Varification Status"


*** degreeprogramdeliverytype
*    p 184 in 2016 OPSMAN

qui destring degreeprogramdeliverytype, generate(delivery) force
qui replace delivery = . if !inlist(delivery, 11, 12, 13)

*di "`year' `term'"
*sum delivery
*tab degreeprogramdeliverytype if delivery==., missing
* all blanks

drop degreeprogramdeliverytype

label def delivery ///
	11 "Fully Online (11)" ///
	12 "Hybrid (12)" ///
	13 "Fully Face to Face (13)"
	
label val delivery delivery
label var delivery "Degree Program Delivery Type"


*** majorcode
*    p 279 in 2016 OPSMAN

qui replace majorcode = trim(majorcode)
qui generate majorcodeshort = substr(majorcode,1,2)

qui destring majorcode, generate(major) force
qui destring majorcodeshort, generate(majordd) force
qui replace majordd = . if !inlist(majordd, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 49)

*di "`year' `term'"
*sum major majordd
*tab majorcode if major==., missing
*tab majorcodeshort if majordd==., missing
* all blanks or 00s which correspond to undeclareds

drop majorcode majorcodeshort

label val major majoroptionconcentrationoremphas
label val majordd majorocedd

label var major "Major Code"
label var majordd "Discipline Division of Major Code"


*** redesignedsatreading 
*** redesignedsatmath 
*** redesignedsatwritandlang
*    p 381 in 2016 OPSMAN

label var redesignedsatreading "p381 OPSMAN16"
label var redesignedsatmath "p381 OPSMAN16"
label var redesignedsatwritandlang "p381 OPSMAN16"


*** transfermodelcurriculumnumber
*    p 398 in 2016 OPSMAN

qui destring transfermodelcurriculumnumber, generate(tmcnum) force
qui replace tmcnum = . if !inrange(tmcnum, 0, 9999)

*di "`year' `term'"
*sum tmcnum
*tab transfermodelcurriculumnumber if tmcnum==., missing

qui replace tmcnum = tmcnum/10

drop transfermodelcurriculumnumber

label var tmcnum "TMC Number"


*** sexualorientationcode 
*** genderidentitycode 
*** genderexpressioncode

* Not introduced until Fall 2017 so not in 2016 OPSMAN so can't clean yet.



order ///
	idunique ///
	empid ///
	name ///
	namesuffix ///
	namelast ///
	namefirst ///
	namemiddle ///
	year ///
	term ///
	campus ///
	csid ///
	dob ///
	female ///
	ethnic ///
	ethnicdetail ///
	hisplatin ///
	hisplatincat ///
	multrace ///
	ipedsrace ///
	csuraceeth ///
	edumom ///
	edudad ///
	depinc ///
	depfam ///
	indinc ///
	indfam ///
	citizenship ///
	countryofcitizenship ///
	immigrationyr ///
	residence ///
	residencestatus ///
	accommodationstatus ///
	accommodationdate ///
	disability ///
	appdate ///
	appfee ///
	admissionbasis ///
	admissionbasis2 ///
	exceptionadmission ///
	admissionstatus ///
	admissiondate ///
	enrollstat ///
	specpro ///
	teachcredemp ///
	credstat ///
	adtstatus ///
	credwvobj ///
	caltchdate ///
	rn ///
	delivery ///
	level ///
	degreeheld ///
	ccccontroln ///
	tmcnum ///
	degreeobj ///
	majoroce ///
	majorocedd ///
	major ///
	majordd ///
	cip ///
	optionsuffix ///
	institutionorigin ///
	instorgtype ///
	hstranscript ///
	hsgpa ///
	cprepeng ///
	cprepmath ///
	cprepwhc ///
	cprepssc ///
	cprepgov ///
	cprepsci ///
	cprepflg ///
	cprepvsp ///
	cprepele ///
	acteng ///
	actmath ///
	actread ///
	actsci ///
	actcomp ///
	actwrit ///
	actenhwrt ///
	satcenter ///
	satverb ///
	satwrit ///
	satmath ///
	sattot ///
	satredrwr ///
	satredmat ///
	satredtot ///
	mathprof ///
	mathprofsum ///
	engprof ///
	engprofsum ///
	elmadmindate ///
	elmalg ///
	elmgeo ///
	elm1sttot ///
	elmtot ///
	eptessay ///
	eptread ///
	eptcomp ///
	epttot ///
	eseng ///
	esmath ///
	eapelastat ///
	eapmathstat ///
	eapelasco ///
	eapmathsco ///
	toefl ///
	elpt ///
	gecrit ///
	geeng ///
	gemath ///
	gecom ///
	transfergpa ///
	transferunits ///
	military ///
	militarynow ///
	militarydep ///
	redesignedsatreading ///
	redesignedsatmath ///
	redesignedsatwritandlang
		
qui compress
qui save "clean/csu actually clean/era/era`year'`term'.dta", replace

}

}


*** Cleaning the variables added in the 2017 OPSMAN.

forvalues year = 2016 / 2017 {

forvalues term = 1/4 {

if `year' == 2016 & `term' == 1 | ///
   `year' == 2016 & `term' == 2 {
    
	display "ERG BLA"
	continue

   }
  
else if `year' == 2016 & `term' == 3 | /// 
	`year' == 2016 & `term' == 4 | ///
	`year' == 2017 & `term' == 1 | ///
	`year' == 2017 & `term' == 2  {

	local filepath "CSU Update 10-23-17"
	local era "era"

  }
  
else if `year' == 2017 & `term' == 3 | ///
	`year' == 2017 & `term' == 4 {

	local filepath "CSU Update 11.29.17"
	local era "era"

  }
  
else {

	display "unhelpful error message IN YOUR EAR"

 }

use "clean/csu actually clean/era/era`year'`term'.dta", clear

di "4 `year' `term'"

*** sexualorientationcode 
*    p 333 in 2017 OPSMAN


qui destring sexualorientationcode, generate(gayisgood) force
qui replace gayisgood = . if !inlist(gayisgood, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19)

*di "`year' `term'"
*sum gayisgood
*tab sexualorientationcode if gayisgood==., missing
* all blanks

drop sexualorientationcode

label def gayisgood ///
	10 "Straight/Heterosexual (10)" ///
	11 "Gay (11)" ///
	12 "Lesbian (12)" ///
	13 "Bisexual (13)" ///
	14 "Queer (14)" ///
	15 "Pansexual (15)" ///
	16 "Asexual (16)" ///
	17 "Not sure (17)" ///
	18 "Decline to State (18)" ///
	19 "Another Orientation (19)"
	
label val gayisgood gayisgood
label var gayisgood "Sexual Orientation Code"


*** genderidentitycode 
*    p 261 in 2017 OPSMAN

qui destring genderidentitycode, generate(genderid) force
qui replace genderid = . if !inlist(genderid, 10, 11, 12, 13, 14, 15, 16, 17)

*di "`year' `term'"
*sum genderid
*tab genderidentitycode if genderid==., missing
* all blanks

drop genderidentitycode

label def genderid ///
	10 "Man (10)" ///
	11 "Woman (11)" ///
	12 "Trans Man (12)" ///
	13 "Trans Woman (13)" ///
	14 "Genderqueer/Gender Non-conforming (14)" ///
	15 "Not Sure (15)" ///
	16 "Decline to State (16)" ///
	17 "Another Identity (17)"
	
label val genderid genderid
label var genderid "Gender Identity Code"


*** genderexpressioncode 
*    p 259 in 2017 OPSMAN

qui destring genderexpressioncode, generate(genderexp) force
qui replace genderexp = . if !inlist(genderexp, 10, 11, 12, 13, 14, 15, 16, 17)

*di "`year' `term'"
*sum genderexp
*tab genderexpressioncode if genderexp==., missing
* all blanks

drop genderexpressioncode

label def genderexp ///
	10 "Gender conforming (10)" ///
	11 "Gender non-conforming (11)" ///
	12 "Both (12)" ///
	13 "Not Sure (13)" ///
	14 "Decline to State (14)" ///
	15 "Not listed above (15)"
	
label val genderexp genderexp
label var genderexp "Gender Expression Code"


*** admissionbasiscode2 
*    p 83 in 2017 OPSMAN

qui replace admissionbasiscode2 = trim(admissionbasiscode2)

qui generate admissionbasis3=.
qui replace admissionbasis3 = 1 if admissionbasiscode2=="A" | admissionbasiscode2=="B" | admissionbasiscode2=="C"
qui replace admissionbasis3 = 2 if admissionbasiscode2=="H" | admissionbasiscode2=="I"
qui replace admissionbasis3 = 3 if admissionbasiscode2=="D" | admissionbasiscode2=="E" | admissionbasiscode2=="F"
qui replace admissionbasis3 = 4 if admissionbasiscode2=="O" | admissionbasiscode2=="X"
qui replace admissionbasis3 = 5 if admissionbasiscode2=="T" | admissionbasiscode2=="U"
qui replace admissionbasis3 = 6 if admissionbasiscode2=="Q" | admissionbasiscode2=="R" | admissionbasiscode2=="W" | admissionbasiscode2=="Y"
qui replace admissionbasis3 = 7 if admissionbasiscode2=="N" | admissionbasiscode2=="P"
qui replace admissionbasis3 = 8 if admissionbasiscode2=="S" | admissionbasiscode2=="Y" | admissionbasiscode2=="Z" | admissionbasiscode2=="10"
qui replace admissionbasis3 = 9 if admissionbasiscode2=="K"
qui replace admissionbasis3 = 10 if admissionbasiscode2=="G" | admissionbasiscode2=="J"
qui replace admissionbasis3 = 11 if admissionbasiscode2=="1" | admissionbasiscode2=="2" | admissionbasiscode2=="3" | admissionbasiscode2=="4" | admissionbasiscode2=="5" 

*di "`year' `term'"
*sum admissionbasis3
*tab admissionbasiscode2 if admissionbasis3==., missing


label def admissionbasis3 1 "1st time Fresh, Reg"
label def admissionbasis3 2 "1st time Fresh, Exceptional", add
label def admissionbasis3 3 "1st time Fresh, Other", add
label def admissionbasis3 4 "Low Div Transf, Reg",add
label def admissionbasis3 5 "Low Div Transf, Exceptional",add
label def admissionbasis3 6 "Low Div Transf, Other",add
label def admissionbasis3 7 "Up Div Transf, Reg",add
label def admissionbasis3 8 "Up Div Transf, Other",add
label def admissionbasis3 9 "Transitory Student",add
label def admissionbasis3 10 "Summer Early Entry Transitory",add
label def admissionbasis3 11 "Postbac/Grad",add

label val admissionbasis3 admissionbasis3

rename admissionbasiscode2 admissionbasis4
label var admissionbasis4 "Admission Basis Code"
label var admissionbasis3 "Admission Basis Recode"


*** addedauthorization 

* Cannot clean cause variable does not exist until Fall 2018


*** californiapromiseprogramstatus
*    p 108 in 2017 OPSMAN

qui destring californiapromiseprogramstatus, generate(capromise) force
qui replace capromise = . if !inlist(capromise, 0, 1, 2, 3)

*di "`year' `term'"
*sum capromise
*tab californiapromiseprogramstatus if capromise==., missing
* all blanks

drop californiapromiseprogramstatus

label def capromise ///
	0 "Not Interested (0)" ///
	1 "Interested  (1)" ///
	2 "Participating (2)" ///
	3 "No Longer Participating (3)"
	
label val capromise capromise
label var capromise "California Promise Program Status"



order ///
	idunique ///
	empid ///
	name ///
	namesuffix ///
	namelast ///
	namefirst ///
	namemiddle ///
	year ///
	term ///
	campus ///
	csid ///
	dob ///
	female ///
	genderid ///
	genderexp ///
	gayisgood ///
	ethnic ///
	ethnicdetail ///
	hisplatin ///
	hisplatincat ///
	multrace ///
	ipedsrace ///
	csuraceeth ///
	edumom ///
	edudad ///
	depinc ///
	depfam ///
	indinc ///
	indfam ///
	citizenship ///
	countryofcitizenship ///
	immigrationyr ///
	residence ///
	residencestatus ///
	accommodationstatus ///
	accommodationdate ///
	disability ///
	appdate ///
	appfee ///
	admissionbasis ///
	admissionbasis2 ///
	admissionbasis3 ///
	admissionbasis4 ///
	exceptionadmission ///
	admissionstatus ///
	admissiondate ///
	enrollstat ///
	specpro ///
	teachcredemp ///
	credstat ///
	adtstatus ///
	credwvobj ///
	caltchdate ///
	rn ///
	capromise ///
	delivery ///
	level ///
	degreeheld ///
	ccccontroln ///
	tmcnum ///
	degreeobj ///
	majoroce ///
	majorocedd ///
	major ///
	majordd ///
	cip ///
	optionsuffix ///
	institutionorigin ///
	instorgtype ///
	hstranscript ///
	hsgpa ///
	cprepeng ///
	cprepmath ///
	cprepwhc ///
	cprepssc ///
	cprepgov ///
	cprepsci ///
	cprepflg ///
	cprepvsp ///
	cprepele ///
	acteng ///
	actmath ///
	actread ///
	actsci ///
	actcomp ///
	actwrit ///
	actenhwrt ///
	satcenter ///
	satverb ///
	satwrit ///
	satmath ///
	sattot ///
	satredrwr ///
	satredmat ///
	satredtot ///
	mathprof ///
	mathprofsum ///
	engprof ///
	engprofsum ///
	elmadmindate ///
	elmalg ///
	elmgeo ///
	elm1sttot ///
	elmtot ///
	eptessay ///
	eptread ///
	eptcomp ///
	epttot ///
	eseng ///
	esmath ///
	eapelastat ///
	eapmathstat ///
	eapelasco ///
	eapmathsco ///
	toefl ///
	elpt ///
	gecrit ///
	geeng ///
	gemath ///
	gecom ///
	transfergpa ///
	transferunits ///
	military ///
	militarynow ///
	militarydep ///
	redesignedsatreading ///
	redesignedsatmath ///
	redesignedsatwritandlang
		
qui compress
qui save "clean/csu actually clean/era/era`year'`term'.dta", replace

}

}

*** Droping variables

forvalues year = 1997 / 2017 {

forvalues term = 1/4 {

if `year' == 1997 & `term' == 1 | ///
   `year' == 1997 & `term' == 2 | ///
   `year' == 1997 & `term' == 3 | ///
   `year' == 1998 & `term' == 1 | ///
   `year' == 1998 & `term' == 3 | ///
   `year' == 1999 & `term' == 1 | ///
   `year' == 1999 & `term' == 3 | ///
   `year' == 2000 & `term' == 1 | ///
   `year' == 2001 & `term' == 1 | ///
   `year' == 2002 & `term' == 1 {
   
	display "No file exists for `year'`term' (1)"
	continue

   }
 
else if `year' == 1997 & `term' == 4 | ///
        `year' == 1998 & `term' == 2 | ///
        `year' == 1998 & `term' == 4 | ///
        `year' == 1999 & `term' == 2 | ///
        `year' == 1999 & `term' == 4 | ///
        `year' == 2000 & `term' == 2 | ///
        `year' == 2000 & `term' == 3 | ///
        `year' == 2000 & `term' == 4 | ///
        `year' == 2001 & `term' == 2 | ///
        `year' == 2001 & `term' == 3 | ///
        `year' == 2001 & `term' == 4 | ///
        `year' == 2002 & `term' == 2 {

	local filepath "1993or97to2007"
	local era "ERA"

  }  
  
else if `year' == 2004 & `term' == 3 | ///
        `year' == 2004 & `term' == 4 | ///
        `year' == 2005 | ///
        `year' == 2006 | ///
        `year' == 2007 | ///
        `year' == 2008 | ///
        `year' == 2009 & `term' == 1 | ///
        `year' == 2009 & `term' == 2 | ///
        `year' == 2009 & `term' == 3 {

	local filepath "2001or02to2009"
	local era "era"

  }   
  
else if `year' == 2002 & `term' == 3 | ///
        `year' == 2002 & `term' == 4 | ///
        `year' == 2003 | ///
        `year' == 2004 & `term' == 1 | ///
        `year' == 2004 & `term' == 2 {

	local filepath "csu update 11-15-10"
	local era "era"

  } 
  
else if `year' == 2009 & `term' == 4 | ///
        `year' == 2010 | ///
        `year' == 2011 | ///
        `year' == 2012 | ///
        `year' == 2013 & `term' == 1 | ///
        `year' == 2013 & `term' == 2 | ///
        `year' == 2013 & `term' == 3 {

	local filepath "CSU Data Update Jake"
	local era "era"

  }  

else if `year' == 2013 & `term' == 4 | ///
        `year' == 2014 & `term' == 1 | ///
        `year' == 2014 & `term' == 2 | ///
        `year' == 2014 & `term' == 3 {

	local filepath "CSU Update 7-15-2015"
	local era "era"

  } 
  
else if `year' == 2014 & `term' == 4 | ///
        `year' == 2015 | ///
        `year' == 2016 & `term' == 1 | ///
        `year' == 2016 & `term' == 2 {

	local filepath "CSU update 10-6-16"
	local era "era"

  }
  
else if `year' == 2016 & `term' == 3 | /// 
	`year' == 2016 & `term' == 4 | ///
	`year' == 2017 & `term' == 1 | ///
	`year' == 2017 & `term' == 2  {

	local filepath "CSU Update 10-23-17"
	local era "era"

  }
  
else if `year' == 2017 & `term' == 3 | ///
	`year' == 2017 & `term' == 4  {

	local filepath "CSU Update 11.29.17"
	local era "era"

  }
  
else {

	display "unhelpful error message 6 finger discount"

 }

use "clean/csu actually clean/era/era`year'`term'.dta", clear

di "`year'`t'"
describe, short

foreach var of varlist * {

qui count if mi(`var')

if r(N)!=_N {

	continue

}
else if r(N)==_N {

	drop `var'

}
else {

	display "fudge `year'`t'"

}

}
describe, short

qui save "clean/csu actually clean/era/era`year'`term'.dta", replace

}

}

/* From Jake's .do file
/* Do cip and hs labels because they can't fit here */
	do "C:\Users\MKStudent\Desktop\CSU Project\Cleaning\do files\cip and hs labels.do"
*/
log close

di "huh"


