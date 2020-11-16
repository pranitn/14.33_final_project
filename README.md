# 14.33_final_project
### Inputs (`/dta/`)
`Jeopdatafull.dta`: Original dataset with one observation per clue per player. Input to `jdata_cleaning.do`. Exceeds file size limit for GitHub\
`daily_double.dta`: Cleaned data sample consisting of only Daily Doubles. Output of `jdata_cleaning.do` and input to `jdata_analysis.do`

### Code (`/do/`)
`jdata_cleaning.do`: Given `Jeopdatafull.dta`, creates and labels variables used in eventual analysis, isolates Daily Double observations and produces `daily_double.dta`\
`jdata_analysis.do`: Runs and outputs series of regressions using `daily_double.dta`

### Outputs (`/tex/`)
`t1.tex`: Table 1:  Summary Statistics\
`t2.tex`: Table 2:  Main OLS Regressions of Wager on Score Change from Previous Clue\
`t3.tex`: Table 3:  OLS Regressions of Wager on Score Change from Previous Clue with Heterogeneous Effects\
`t4.tex`: Table 4:  Robustness Checks - Alternate Specifications\
`t5.tex`: Table 5:  Robustness Checks - Subsample Analysis

### Miscellaneous
`.gitignore`: Ignores `Jeopdatafull.dta`, which is used locally but cannot be uploaded to GitHub due to file size limit 
