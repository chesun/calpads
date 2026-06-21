********************************************************************************
*********determine the a to g eligibility of students***************************
********************************************************************************



/* IMPORTANT: needs to know SAT/ACT/AP/IB test scores. The UC system allows for SAT/ACT etc
test scores to be used to satisfy A-G requirements. See
https://admission.universityofcalifornia.edu/admission-requirements/freshman-requirements/subject-requirement-a-g.html
Here I assume the dataset consists of full 4 years of high school course records for a cohort
of high school students. Code may need adjustment depending on the final form of the dataset
that will be used */

 /* here I create an algorithm that calculates A-G eligbility based on high school
 courses. If SAT/ACT/IB/AP test scores are acquired, update the code accordingly  */


/* convention used: 2.0 fgradept = C letter grade  */

/* A-G requirement from UC website:
courses need to have grade C or better
A. History
  2 years of history
B. English
  4 years of college-preparatory English
C. Mathematics
  3 years of college preparatory Mathematics
D. Science
  2 years
E. language other than English
  2 years
F. Visual and performing arts
  1 year
G. college-preparatory elective
  1 year in addition to A-F chosen from the above subject areas  */



/*
for each ssid,
generate new var
fullyearA = total number of courses with agcode == "A" & term == "Full Year" & fgradept >= 2.0
semesterA = total number of courses with agcode == "A" & term == "First Semester" & fgradept >= 2.0
          + total number of courses with agcode == "A" & term == "Second Semester" & fgradept >= 2.0
trimesterA = total number of courses with agcode == "A" & term == "First Trimester" & fgradept >= 2.0
          + total number of courses with agcode == "A" & term == "Second Trimester" & fgradept >= 2.0
          + total number of courses with agcode == "A" & term == "Third Trimester" & fgradept >= 2.0
quarterA = total number of courses with agcode == "A" & term == "First Quarter" & fgradept >= 2.0
          + total number of courses with agcode == "A" & term == "Second Quarter" & fgradept >= 2.0
          + total number of courses with agcode == "A" & term == "Third Quarter" & fgradept >= 2.0
          + total number of courses with agcode == "A" & term == "Fourth Quarter" & fgradept >= 2.0
hexmesterA = total number of courses with agcode == "A" & term == "First Hexmester" & fgradept >= 2.0
          + total number of courses with agcode == "A" & term == "Second Hexmester" & fgradept >= 2.0
          + total number of courses with agcode == "A" & term == "Third Hexmester" & fgradept >= 2.0
          + total number of courses with agcode == "A" & term == "Fourth Hexmester" & fgradept >= 2.0
          + total number of courses with agcode == "A" & term == "Fifth Hexmester" & fgradept >= 2.0
          + total number of courses with agcode == "A" & term == "Sixth Hexmester" & fgradept >= 2.0
gen satisfyA = 0
replace satisfyA = 1 if fullyearA == 2 | semesterA == 4 | trimesterA == 6 | quarterA == 8 | hexmesterA = 12
 */


**** calculating number of courses that satisfy each A-G requirement ****


sort ssid

local ag `" "A" "B" "C" "D" "E" "F" "GA" "GB" "GC" "GD" "GE" "GF" "' // macro that contains categories of A-G code

foreach i of local ag {

  gen byte fyr`i' = 0 // a binary variable that equals 1 if the course is a full year course, has A-G designation i, and has grade >= 2.0
  replace fyr`i' = 1 if term == "Full Year" & fgradept >= 2 & agcode == "`i'"
  by ssid: egen numfyr`i' = total(fyr`i') // number of full year courses that satisfy the A-G designation i requirement

  gen byte sem`i' = 0 // a binary variable that equals 1 if the course ils a semester course, has A-G designation i, and has grade >= 2.0
  replace sem`i' = 1 if ( term == "First Semester" | term == "Second Semester" ) & fgradept >= 2 & agcode == "`i'"
  by ssid: egen numsem`i' = total(sem`i') //number of semester courses that satisfy the A-G designation i requirement

  gen byte tri`i' = 0 // a binary variable that equals 1 if the course is trimester course and satisfy the A-G designation i requirement
  replace tri`i' = 1 if ( term == "First Trimester" | term == "Second Trimester" | term == "Third Trimester" ) & fgradept >= 2 & agcode == "`i'"
  by ssid: egen numtri`i' = total(tri`i') //number of trimester courses that satisfy the A-G designation i requirement

  gen byte qtr`i' = 0 // a binary variable that equals 1 if the coures is quarter course and satisfies the A-G designation i requirement
  replace qtr`i' = 1 if ( term == "First Quarter" | term == "Second Quarter" | term == "Third Quarter" | term == "Fourth Quarter" ) & fgradept >= 2 & agcode == "`i'"
  by ssid: egen numqtr`i' = total(qtr`i') //number of quarter courses that satisfy the A-G designation i requirement

  gen byte hex`i' = 0 // a bianry var that equals 1 if the course is hexmester and satisfies the A-G designation i requirement
  replace hex`i' = 1 if ( term == "First Hexmester" | term == "Second Hexmester" term == "Third Hexmester" | term == "Fourth Hexmester" | term == "Fifth Hexmester" | term == "Sixth Hexmester" ) & fgradept >= 2 & agcode == "`i'"
  by ssid: egen numhex`i' = total(hex`i') // number of hexmester coureses that satisfy the A-G designation i requirement

  }

by ssid: gen satisfyA = 0 // dummy var that equals 1 if the student satisfies the A requirement
replace satisfyA = 1 if numfyrA >= 2 | numsemA >= 4 | numtriA >= 6 | numqtrA >= 8 | numhexA >= 12

by ssid: gen satisfyB = 0 // dummy var that equals 1 if the student satisfies the B requirement
replace satisfyA = 1 if numfyrB >= 4 | numsemB >= 8 | numtriB >= 12 | numqtrB >= 16 | numhexB >= 24

by ssid: gen satisfyC = 0 // dummy var that equals 1 if the student satisfies the C requirement
replace satisfyC = 1 if numfyrC >= 3 | numsemC >= 6 | numtriC >= 9 | numqtrC >= 12 | numhexC >= 18

by ssid: gen satisfyD = 0 // dummy var that equals 1 if the student satisfies the D requirement
replace satisfyD = 1 if numfyrD >= 2 | numsemD >= 4 | numtriD >= 6 | numqtrD >= 8 | numhexD >= 12

by ssid: gen satisfyE = 0 // dummy var that equals 1 if the student satisfies the E requirement
replace satisfyE = 1 if numfyrE >= 2 | numsemE >= 4 | numtriE >= 6 | numqtrE >= 8 | numhexE >= 12

by ssid: gen satisfyF = 0 // dummy var that equals 1 if the student satisfies the D requirement
replace satisfyF = 1 if numfyrF >= 1 | numsemF >= 2 | numtriF >= 3 | numqtrF >= 4 | numhexF >= 6

local g `" "GA" "GB" "GC" "GD" "GE" "GF" "' // macro that contains the categories of the codes of the G requirement

foreach j of local g {
  by ssid: gen satisfy`j' = 0 // dummy var that equals 1 if the student satisfies the j requirement
  replace satisfy`j' = 1 if numfyr`j' >= 1 | numsem`j' >= 2 | numtri`j' >= 3 | numqtr`j' >= 4 | numhex`j' >= 6
}

gen byte satisfyag = 0 // dummy that equals 1 if satisfies A-G requirement
replace satisfyag = 1 if satisfyA == 1 & satisfyB == 1 & satisfyC == 1 & satisfyD == 1 & satisfyE == 1 & satisfyF == 1 & ( satisfyGA == 1 | satisfyGB == 1 | satisfyGC == 1 | satisfyGD == 1 | satisfyGE == 1 | satisfyGF == 1 )
