cd "C:\Users\prani\Dropbox (MIT)\2020-2021\14.33\Paper\14.33_final_project"

*Original dataset from Jetter and Walker(2017), includes many variables not used in eventual analysis
use "dta\Jeopdatafull.dta", clear

*don't include final jeopardy clues
drop if finaljeopardyround

*dummies for special tournaments/events not considered in original dataset
gen teacher = 0
replace teacher = 1 if strpos(lower(showdescription), "teacher")

gen celeb = 0
replace celeb = 1 if strpos(lower(showdescription), "celebrity") | strpos(lower(showdescription), "power")

gen decades = 0
replace decades = 1 if strpos(lower(showdescription), "decades")

replace kids = 1 if strpos(lower(showdescription), "back to school")

gen masters = 0
replace masters = 1 if strpos(lower(showdescription), "masters")

gen ibm = 0
replace ibm = 1 if strpos(lower(showdescription), "ibm")

*labels for special event dummies
lab var kids "=1 kids week game"
lab var teen "=1 teen tournament game"
lab var college "=1 college championship game"
lab var senior "=1 senior week/tournament game"
lab var champions "=1 tournament of champions game"
lab var teacher "=1 teacher's tournament game"
lab var celeb "=1 celebrity/power players game"
lab var decades "=1 battle of the decades game"
lab var masters "=1 million dollar masters game"
lab var ibm "=1 ibm challenge game"

*dummies for adult/regular games
gen adults=1
replace adults=0 if kids==1 | teen==1 | college==1 | senior==1
lab var adults "=1 game with contestants from adult contestant pool"

gen regular=1
replace regular=0 if adults == 0 | champions==1 | teacher==1 | celeb==1 | decades==1 | masters==1 | ibm == 1
lab var regular "=1 for regular play game (subset of adult games)"

* November 26, 2001 = edate 15305 (clue values doubled)
gen old=0
replace old=1 if edate<15305
lab var old "=1 if before Nov 26,2001 (doubling of $)"

*order clues sequentially by player by game, grouped by category
*Note: each clue has one observation per player, regardless of if they answer
sort player showid doublejeopardyround questioncat questionnumber 

gen dummy = 1

*prior clues and outcomes in category 
by player showid doublejeopardyround questioncat: gen shownthiscat=sum(dummy) 
replace shownthiscat=shownthiscat-1 if shownthiscat>0 
label variable shownthiscat "# of clues shown in this category"

by player showid doublejeopardyround questioncat: gen answerthiscat=sum(answer) 
replace answerthiscat=answerthiscat-1 if answerthiscat>0 & answer==1
label variable answerthiscat "# of clues answered in this category by reference player"

by player showid doublejeopardyround questioncat: gen correctthiscat=sum(correct) 
replace correctthiscat=correctthiscat-1 if correctthiscat>0 & correct == 1
label variable correctthiscat "# of clues correct in this category by reference player"

*order clues answered by player sequentially by player by game
sort player showid answer doublejeopardyround questionnumber

*prior daily doubles for player in game
*Note: Inaccurate for observations where player did not answer, but these will be removed anyway
by player showid answer: gen dds=sum(dailydouble)
replace dds=dds-1 if dds>0 & dailydouble == 1
label variable dds "# of previous Daily Doubles by reference player in that show"

*order all clues sequentially by player by game
sort player showid doublejeopardyround questionnumber

*prior daily doubles for anyone in game
by player showid: gen ddshown = sum(dailydouble)
replace ddshown=ddshown-1 if ddshown>0 & dailydouble == 1
label variable ddshown "# of previous Daily Doubles by anyone in that show"

*order all clues sequentially by player by game
sort player showid doublejeopardyround questionnumber

*preceding clue category
by player showid: gen catlag = questioncat[_n-1]
label variable catlag "category of preceding clue"

gen samecatprev = 0
replace samecatprev = 1 if questioncat == catlag
label variable samecatprev "=1 if preceding clue was in same category as current clue"

*maximum possible wager, defined as maximum of player's initial score (ie scorelag) and maximum clue value on board
gen maxwager = max(scorelag, 500*(1+doublejeopardyround)*(2-old)) 
lab var maxwager "maximum possible daily double wager for reference player at start of clue"

*measure reference player's score relative to opponents, previous scores
gen scoreleadopplag = max(scoreopp1lag, scoreopp2lag)
gen scorelowopplag = min(scoreopp1lag, scoreopp2lag)
gen scoreleaddifflag = scorelag - scoreleadopplag 
gen scorelowdifflag = scorelag - scorelowopplag
gen prevscorechange = scorelag-scorelag2
gen poschange = prevscorechange > 0

*interaction terms
// gen feminter = female * prevscorechange
// gen adultinter= adults * prevscorechange
// gen regularinter= regular * prevscorechange
// gen kidsinter = kids * prevscorechange
// gen teeninter = teen * prevscorechange
// gen collegeinter = college * prevscorechange
// gen championsinter = champions * prevscorechange



*label several variables
// lab var feminter "female*prevscorechange"
// lab var adultinter "adult*prevscorechange"
// lab var regularinter "regular*prevscorechange"
// lab var kidsinter "kids*prevscorechange"
// lab var teeninter "teen*prevscorechange"
// lab var collegeinter "college*prevscorechange"
// lab var championsinter "champions*prevscorechange"


lab var prevscorechange "change in score ($$ won or lost) on precedng clue"
lab var prevscorechange "prevscorechange > 0"
lab var scoreleadopplag "highest score of any opponent at start of clue"
lab var scorelowopplag "lowest score of any opponent at start of clue"
lab var scoreleaddifflag "difference between player's and highest opponent's score at start of clue"
lab var scorelowdifflag "difference between player's and lowest opponent's score at start of clue"

foreach cat of varlist cats*{
	lab var `cat' "=1 if nth most common category"
// 	tab questioncategory if `cat' == 1
}

lab var id "# of question seen by player in lifetime so far (including FJ)"
lab var shows "# of lifetime shows for this player (including future)"

lab var scorelag "score of reference player at end of preceding clue"
lab var scorelag2 "scorelag for preceding clue"
lab var scoreopp1lag "score of opponent 1 at end of preceding clue"
lab var scoreopp2lag "score of opponent 2 at end of preceding clue"

lab var answer "=1 if reference player gives answer to clue"
lab var correct "=1 if reference player answers clue correctly" 


keep if dailydouble == 1 & answer == 1

gen relwager = wager/maxwager

save "dta\daily_double.dta", replace
