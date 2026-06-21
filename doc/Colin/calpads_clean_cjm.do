*** do file calpads_clean_cjm.do for Stata
*** file version 1.2
*** updated: 2020-08-02
*** written by Colin Merritt

/*
Purpose:
1. Make variables conform to lab conventions (names, labels)
2. Compress datasets
3. Construct grade point
4. Construct grade point average (in progress)

*/

clear all
cap log close
set more off
*cd "/home/research/ca_ed_lab/colin/gsr/CALPADS" // cjm Directory
cd /home/research/ca_ed_lab/data/restricted_access/clean/calpads/
*log using "do and log/calpads_clean_cjm.txt", text replace	// permissions denied
log using "calpads_clean_cjm.txt", text replace			// temp solution


********************************************************************************
*** START FILE
********************************************************************************

local rawdsets /home/research/ca_ed_lab/data/restricted_access/raw/calpads/coursecomp/crscomp17_18.dta ///
	/home/research/ca_ed_lab/data/restricted_access/raw/calpads/coursecomp/crscomp16_17.dta ///
	/home/research/ca_ed_lab/data/restricted_access/raw/calpads/coursecomp/crscomp15_16.dta ///
	/home/research/ca_ed_lab/data/restricted_access/raw/calpads/coursecomp/crscomp14_15.dta ///
	/home/research/ca_ed_lab/data/restricted_access/raw/calpads/coursecomp/crscomp13_14.dta

	
foreach dset of local rawdsets {
	use `dset', clear
	local filename = "c(filename)"
	local fname = substr(`filename',strlen(`filename')-15,12) // ie: crscompxx_xx
	local suffix = "_clean_cjm.dta"
	local lclyear = substr(`filename',strlen(`filename')-5,2)

	*** Make Dataset Variable Names Equivalent 
	/* first two years of data did not have Stata user friendly conventions
	this section attempts to make the variable names equivalent across years for 
	single cleaning file compatibility.
	
	Note: Stukey is not equivalent to ssid. They are not the same length IDs.
	*/

	// Academic Year and Term variables misspelled in 13-15
	cap rename Acadamic_Year academic_year
	cap rename Acadamic_Term academic_term
	cap rename A_G_Course_Reg_Name a_g_course_req_name

	// This loop makes early dataset variables equivalent to later years (cap sensitivity issue solved)
	cap rename Stukey CALPADSSnpshtKey EOY1 County_District School_ID 	///
		Local_Course_Number Local_Course_Name State_Course_Code ///
		State_Course_Name Credit_Attempted Credit_Earned 	///
		Final_Grade UC_CSUApproved_Course Independent_Study 	///
		Distance_Learning CTE_Tech_Prep A_G_Course_Req_code, lower

	*** Trim All String Variables
	// this loop removes all leading, trailing, and internal multiple blanks for all string variables
	foreach x of var * {
		local lcltype = substr("`: type `x''", 1, 3)
	*	disp "`x' is a `lcltype'"			// used to debug loop
		if "`lcltype'" == "str" {
			replace `x' = trim(itrim(`x'))
	*		disp "`x' is a trimmed `lcltype'"	// used to debug loop
		}
	}

	*** Label Student ID
	cap label variable ssid "State Student ID"

	*** Clean Academic Year
	rename academic_year year
	replace year = substr(year, -2, 2)
	label variable year "Academic Year as defined by Spring Term"

	*destring year, replace 				// if numerically coding


	*** Clean Academic Term
	rename academic_term term 
	label variable term "Academic Term"

	/* 
	Observation: Academic term system varies across schools.
	This can have implications for credits earned/attempted.
	This can be recoded numerically by spliting strings by the internal space.
	First half
	 First, Second, Third, Fourth -> 1,2,3,4
	Second half
	 Semester, Trimester, Quarter -> 2,3,4
	*/

	*** Clean County District
	rename county_district cdcode
	label variable cdcode "County District Code"

	*** Clean School ID
	rename school_id cdscode7
	label variable cdscode7 "School CDS Code (Last 7 Digits)"

	*** Make County District School Code
	gen cdscode = cdcode + cdscode7
	label variable cdscode "School CDS Code (Full 14 Digits)"

	*** Clean Local Course Number
	rename local_course_number lcrsnum
	label variable lcrsnum "Local Course Number"

	*** Clean Local Course Name
	rename local_course_name lcrsname
	label variable lcrsname "Local Course Name"

	*** Clean State Course Number
	rename state_course_code scrsnum
	label variable scrsnum "State Course Code"

	*** Clean State Course Names
	rename state_course_name scrsname
	label variable scrsname "State Course Name"

	*** Clean Credit Attempted
	rename credit_attempted credatt
	label variable credatt "Credit Attempted"

	*** Clean Credit Earned
	rename credit_earned credearn
	label variable credearn "Credit Earned"

	*** Clean Final Grade
	rename final_grade fgrade
	label variable fgrade "Final Grade"

	*** Make UC/CSU Approved Course Dummy
	gen byte uccsuapp = .
	replace uccsuapp = 0 if uc_csuapproved_course == "N"
	replace uccsuapp = 1 if uc_csuapproved_course == "Y"
	drop uc_csuapproved_course

	label variable uccsuapp "UC/CSU Approved Course"

	*** Make Independent Study Dummy
	gen byte indstudy =.
	replace indstudy = 0 if independent_study == "N"
	replace indstudy = 1 if independent_study == "Y"
	drop independent_study

	label variable indstudy "Independent Study"

	*** Make Distance Learning Dummy
	gen byte distlearn =.
	replace distlearn = 0 if distance_learning == "N"
	replace distlearn = 1 if distance_learning == "Y"
	drop distance_learning

	label variable distlearn "Distance Learning"

	*** Make CTE Tech Prep Dummy
	gen byte cte =.
	replace cte = 0 if cte_tech_prep == "N"
	replace cte = 1 if cte_tech_prep == "Y"
	drop cte_tech_prep

	label variable cte "Career Technical Education Prep Course"

	*** Make UC Honors Dummy (not available for 14-16)
	gen byte uchonors =.
	if year == "18" {
		replace uchonors = 0 if uc_honors == "N"
		replace uchonors = 1 if uc_honors == "Y"
		drop uc_honors
	}
	if year == "17" {
		replace uchonors = 0 if honors == "N"
		replace uchonors = 1 if honors == "Y"
	drop honors
	}

	label variable uchonors "UC Honors"

	*** Clean A-G Course Req Code
	rename a_g_course_req_code agcode
	label variable agcode "A-G Course Req Code"

	*** Clean A-G Course Req Names
	rename a_g_course_req_name agname
	label variable agname "A-G Course Req Name"

	*** Label Dummy Values
	label define yndummy ///
		0 "No" ///
		1 "Yes" 
		
	label values uccsuapp indstudy distlearn cte uchonors yndummy

	*** Create Final Grade Point
	*do "do and log/calpads_fgradept.do"		// permissions denied
	do calpads_fgradept.do				// temp solution
	
	*** Create Year GPA
	/* 
	Formula used: (Grade Point * Credits)/Credits
	Observation: Credit Earned or attempted varies greatly across data but does not matter for GPA formula.
	Question: Why is credit_earned not always equal to credits_attempted?
		Answer:
	Question: Which credit should be used in the formula (or both)? 
		Answer: starting with credit_earned in num and deno
	Problem: If student fails class credit_earned = 0 which can lead to dividing by 0.
		Potential solution: recode 0 gpa if credit attempted more than 0?
	Problem: Some schools coding 0 credit attempted and earned
		Potential solution: can recode as 1 credit if assumed the class is actually worth credit

	*/
	
	if `lclyear' == 14 | `lclyear' == 15 {
		sort stukey
		by stukey: egen credtot = sum(credearn)
		by stukey: egen crednum = sum(fgradept * credearn)
		by stukey: gen yeargpa = crednum / credtot
		drop credtot crednum
		label variable yeargpa "Grade Point Average for Academic Year"
	} 
	else {	
		sort ssid
		by ssid: egen credtot = sum(credearn)
		by ssid: egen crednum = sum(fgradept * credearn)
		by ssid: gen yeargpa = crednum / credtot
		drop credtot crednum
		label variable yeargpa "Grade Point Average for Academic Year"
	}
	
	compress
	save "dta/`fname'`suffix'", replace
}
cap log close

exit

***appendix
*notes

*scratch work
gen year = .
replace year = 18 if academic_year == "2017-2018"
replace year = 17 if academic_year == "2016-2017"
replace year = 16 if academic_year == "2015-2016"
replace year = 15 if academic_year == "2014-2015"

/*
gen year = .
replace year = "18" if academic_year == "2017-2018"
replace year = "17" if academic_year == "2016-2017"
replace year = "16" if academic_year == "2015-2016"
replace year = "15" if academic_year == "2014-2015"

*/


/*
Instructions from Kramer:
* Keep years separate (datasets are not merged in clean folder)
* ID numbers stay strings 
*trim(itrim()) strings
*compress before save

*ssid = state student id
*acadamic year -> new variable "year" "Spring term of accademic year"
*accademic term -> term
*conty district -> cdcode
*school id -> cdscode7
*make cdscode = cdcode + cdscode7
*local_course_number-> lcrsnum
*local_course_name->lcrsname
*state_course_code-> scrsnum
*state_course_name-> scrsname
*credit_attempted -> credatt
*credit_earned-> credearn
*final_grade-> fgrade
*uc_csuapproved_course-> uccsuapp.  Make into dummy
*independent_study-> indstudy Make into dummy
*distance_learning -> distlearn Make into dummy
*cte_tech_prep -> cte Make into dummy
*a_g_course_req_code -> agcode
*a_g_course_reg_name -> agname

should local course number be an actual number or stay a string?
	Answer: the local course numbers aren't strictly numerical, so should stay strings. Convention Varies.
make a "final grade point" -> fgradept
	IN PROGRESS
What is EOY1? 
	^ Che's Assignment?
Is there number storage consistency between years 
	^ What does this mean??????


TODO:
Make fgradept

*/

