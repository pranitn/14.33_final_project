cd "C:\Users\prani\Dropbox (MIT)\2020-2021\14.33\Paper\14.33_final_project"

*cleaned daily double dataset, output of jdata_cleaning.do
use "dta\daily_double.dta", clear

*gets some summary stats mentioned in paper
by playername, sort: gen nvals = _n == 1
by playername, sort: gen nvals2 = _n == 2
*number of players in sample
count if nvals
*number of players who appear multiple times in sample
count if nvals2
drop nvals nvals2


*Summary Stats (Table 1)
eststo drop *

estpost summarize wager prevscorechange scorelag maxwager initialdollarvalue scoreleaddifflag doublejeopardyround questionnumber dds shownthiscat answerthiscat correctthiscat samecatprev id female year stem adults, det

esttab using "tex\t1.tex", wide cells("mean(label(Mean) fmt(a3)) sd(label(Std. Dev.)) min(label(Min) fmt(0)) p25(label(25th)) p50(label(Median)) p75(label(75th)) max(label(Max))") title("Summary Statistics") coeflabels(wager "Wager (\\$)" prevscorechange "Prev. Clue Score Change (\\$)" scorelag "Init. Score (\\$)" maxwager "Maximum Wager (\\$)" initialdollarvalue "Init. Clue Value (\\$)" scoreleaddifflag "Dist. to Lead Opponent (\\$)" doublejeopardyround "Double Jeopardy Round" questionnumber "\# of Clue in Round" dds "\# of Prior DDs in Game" shownthiscat "\# of Clues Shown in Cat." answerthiscat "\# of Clues Answered in Cat." correctthiscat "\# of Clues Correct in Cat." samecatprev "Curr. and Prev. Clues in Same Cat." id "Lifetime Clue \# for Player" female "Female" year "Year Aired" stem "STEM Category" adults "Adult Game") nomtitle noobs nonum replace

*Main Results (Table 2)
eststo drop *

*base bivariate regression
eststo: regress wager prevscorechange

*game state controls
eststo: regress wager prevscorechange scorelag maxwager initialdollarvalue scoreleaddifflag doublejeopardyround questionnumber

*player/game history
eststo: regress wager prevscorechange scorelag maxwager initialdollarvalue scoreleaddifflag doublejeopardyround questionnumber dds shownthiscat answerthiscat correctthiscat id

*contestant/date controls
eststo: regress wager prevscorechange scorelag maxwager initialdollarvalue scoreleaddifflag doublejeopardyround questionnumber dds shownthiscat answerthiscat correctthiscat id female edate

*category/game type controls
eststo: regress wager prevscorechange scorelag maxwager initialdollarvalue scoreleaddifflag doublejeopardyround questionnumber dds shownthiscat answerthiscat correctthiscat id female edate stem cats*  kids teen college

*output Table 2
esttab using "tex\t2.tex", r2 nomtitles nogaps mgroups("Dependent Variable: Wager (\\$)" , pattern(1 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat()) title("Main OLS Regressions of Wager on Score Change from Previous Clue")  coeflabels(prevscorechange "Prev. Clue Score Change (\\$)" scorelag "Init. Score (\\$)" maxwager "Maximum Wager (\\$)" initialdollarvalue "Init. Clue Value (\\$)" scoreleaddifflag "Dist. to Lead Opponent (\\$)" doublejeopardyround "Double Jeopardy Round" questionnumber "\# of Clue in Round" dds "\# of Prior DDs in Game" shownthiscat "\# of Clues Shown in Cat." answerthiscat "\# of Clues Answered in Cat." correctthiscat "\# of Clues Correct in Cat." samecatprev "Curr. and Prev. Clues in Same Cat." id "Lifetime Clue \# for Player" female "Female" year "Year Aired" stem "STEM Category" adults "Adult Game" edate  "Airdate" _cons "Constant") indicate("Category/Adult Dummies = stem cats* kids teen college") replace

*Heterogeneous Effects/Interactions (Table 3)
eststo drop *
*female interaction
eststo: regress wager c.prevscorechange##female scorelag maxwager initialdollarvalue scoreleaddifflag doublejeopardyround questionnumber dds shownthiscat answerthiscat correctthiscat id edate stem cats*  kids teen college

*adult interaction
eststo: regress wager c.prevscorechange##adults scorelag maxwager initialdollarvalue scoreleaddifflag doublejeopardyround questionnumber dds shownthiscat answerthiscat correctthiscat id female edate stem cats*

*champions interaction (vs. regular)
eststo: regress wager c.prevscorechange##champions scorelag maxwager initialdollarvalue scoreleaddifflag doublejeopardyround questionnumber dds shownthiscat answerthiscat correctthiscat id female edate stem cats*  if regular == 1 | champions == 1

*round interaction
eststo: regress wager c.prevscorechange##doublejeopardyround scorelag maxwager initialdollarvalue scoreleaddifflag questionnumber dds shownthiscat answerthiscat correctthiscat id female edate stem cats*  kids teen college

*previous clue in same category as dd interaction
eststo: regress wager c.prevscorechange##samecatprev scorelag maxwager initialdollarvalue scoreleaddifflag doublejeopardyround questionnumber dds shownthiscat answerthiscat correctthiscat id female edate stem cats*  kids teen college

*Output Table 3
esttab  using "tex\t3.tex", r2 nogaps nonumbers mtitles("(6)" "(7)" "(8)" "(9)" "(10)") mgroups("Dependent Variable: Wager (\\$)" , pattern(1 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat()) drop(maxwager initialdollarvalue scoreleaddifflag doublejeopardyround questionnumber dds shownthiscat answerthiscat correctthiscat id female edate stem cats*  kids teen college 0.*) title("OLS Regressions of Wager on Score Change from Previous Clue with Heterogeneous Effects") coeflabels(prevscorechange "Prev. Clue Score Change ($)" 1.female "Female" 1.female#c.prevscorechange "Female * Prev. Clue Score Change" 1.adults "Adult Game" 1.adults#c.prevscorechange "Adult Game * Prev. Clue Score Change" 1.champions "Tournament of Champions" 1.champions#c.prevscorechange "Tournament of Champions * Prev. Clue Score Change" 1.doublejeopardyround "Double Jeopardy" 1.doublejeopardyround#c.prevscorechange "Double Jeopardy * Prev. Clue Score Change" 1.samecatprev "Curr. and Prev. Clues in Same Cat." 1.samecatprev#c.prevscorechange "Curr. and Prev. Clues in Same Cat. * Prev. Clue Score Change" _cons "Constant")  indicate("All Regression (5) Controls= scorelag") replace

*Robustness Checks

*Alternate Specifications (Table 4)
eststo drop *

*relwager
eststo: regress relwager prevscorechange scorelag initialdollarvalue scoreleaddifflag doublejeopardyround questionnumber dds shownthiscat answerthiscat correctthiscat id female edate stem cats*  kids teen college

*tobit 
eststo: tobit wager prevscorechange scorelag maxwager initialdollarvalue scoreleaddifflag doublejeopardyround questionnumber dds shownthiscat answerthiscat correctthiscat id female edate stem cats* kids teen college,  ll(5) ul(maxwager)

*player fixed effects
eststo: xtreg wager prevscorechange scorelag maxwager initialdollarvalue scoreleaddifflag doublejeopardyround questionnumber dds shownthiscat answerthiscat correctthiscat id edate stem cats* kids teen college, fe vce(cluster playername)

*Output Table 4
esttab using "tex\t4.tex" , r2 nogaps nonumbers drop(var(e.wager) ) eqlabels("""""") mgroups ("OLS" "Tobit" "OLS", pattern(1 1 1)) mtitles("\shortstack{(11)\\Wager/Max Wager}" "\shortstack{(12)\\Wager (\\$)}" "\shortstack{(13)\\Wager (\\$)}") title("Robustness Checks - Alternate Specifications") coeflabels(prevscorechange "Prev. Clue Score Change (\\$)" scorelag "Init. Score (\\$)" maxwager "Maximum Wager (\\$)" initialdollarvalue "Init. Clue Value (\\$)" scoreleaddifflag "Dist. to Lead Opponent (\\$)" doublejeopardyround "Double Jeopardy Round" questionnumber "\# of Clue in Round" dds "\# of Prior DDs in Game" shownthiscat "\# of Clues Shown in Cat." answerthiscat "\# of Clues Answered in Cat." correctthiscat "\# of Clues Correct in Cat." samecatprev "Curr. and Prev. Clues in Same Cat." id "Lifetime Clue \# for Player" female "Female" year "Year Aired" stem "STEM Category" adults "Adult Game" edate  "Airdate" _cons "Constant") indicate("Category/Adult Dummies = stem cats* kids teen college") replace

*Subsample Analysis (Table 5)
eststo drop * 
*previous in different category as dd only
eststo: regress wager prevscorechange scorelag maxwager initialdollarvalue scoreleaddifflag doublejeopardyround questionnumber dds shownthiscat answerthiscat correctthiscat id female edate stem cats* kids teen college if samecatprev == 0

*not first clue on board
eststo: regress wager prevscorechange scorelag maxwager initialdollarvalue scoreleaddifflag doublejeopardyround questionnumber dds shownthiscat answerthiscat correctthiscat id female edate stem cats* kids teen college if questionnumber != 1

*only when score is high enough for score to equal maxwager
eststo: regress wager prevscorechange scorelag initialdollarvalue scoreleaddifflag doublejeopardyround questionnumber dds shownthiscat answerthiscat correctthiscat id female edate stem cats* if scorelag == maxwager

*nonzero change in score
eststo: regress wager prevscorechange scorelag maxwager initialdollarvalue scoreleaddifflag doublejeopardyround questionnumber dds shownthiscat answerthiscat correctthiscat id female edate stem cats* kids teen college if prevscorechange != 0

*regular play only
eststo: regress wager prevscorechange scorelag maxwager initialdollarvalue scoreleaddifflag doublejeopardyround questionnumber dds shownthiscat answerthiscat correctthiscat id female edate stem cats* if regular == 1

*after dollar values doubled (happened at end of 2001)
eststo: regress wager prevscorechange scorelag maxwager initialdollarvalue scoreleaddifflag doublejeopardyround questionnumber dds shownthiscat answerthiscat correctthiscat id female edate stem cats* kids teen college if year > 2001

*jeopardy round only
eststo: regress wager prevscorechange scorelag maxwager initialdollarvalue scoreleaddifflag questionnumber shownthiscat answerthiscat correctthiscat id female edate stem cats* kids teen college if doublejeopardyround == 0

*double jeopardy round only
eststo: regress wager prevscorechange scorelag maxwager initialdollarvalue scoreleaddifflag questionnumber dds shownthiscat answerthiscat correctthiscat id female edate stem cats* kids teen college if doublejeopardyround == 1

*Output Table 5
*Note: Regression numbers are edited manually after inclusion in paper
esttab using "tex\t5.tex", r2  mgroups("Dependent Variable: Wager (\\$)" , pattern(1 0 0 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat()) mtitles("\shortstack{\\Prev. Clue\\Diff. Cat}" "\shortstack{Not 1st\\Clue}" "\shortstack{Score=\\Max\\Wager}" "\shortstack{Nonzero\\Score\\Change}" "\shortstack{\\Reg.\\Play}" "\shortstack{\\Post\\2001}" "\shortstack{J\\Round}" "\shortstack{DJ\\Round}") title("Robustness Checks - Subsample Analysis") drop(dds shownthiscat answerthiscat correctthiscat id female edate cats*  kids teen college)coeflabels(prevscorechange "Prev. Clue Score Change (\\$)" scorelag "Init. Score (\\$)" maxwager "Maximum Wager (\\$)" initialdollarvalue "Init. Clue Value (\\$)" scoreleaddifflag "Dist. to Lead Opponent (\\$)" doublejeopardyround "Double Jeopardy Round" questionnumber "\# of Clue in Round" dds "\# of Prior DDs in Game" shownthiscat "\# of Clues Shown in Cat." answerthiscat "\# of Clues Answered in Cat." correctthiscat "\# of Clues Correct in Cat." samecatprev "Curr. and Prev. Clues in Same Cat." id "Lifetime Clue \# for Player" female "Female" year "Year Aired" stem "STEM Category" adults "Adult Game" edate  "Airdate" _cons "Constant") indicate("All Regression (5) Controls= stem")replace



