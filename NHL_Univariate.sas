/*
*************************************************************************************************************************************
NHL Univariate Analysis

Project Description: 
*************************************************************************************************************************************

The following analysis seeks to explore the features of an NHL data set recording season stats for individual teams from 1983 - 2020.

The overall analysis will use logistic regression to predict the playoff outcomes of teams that don't make the playoffs. 

By understanding the economics of what holds teams back from making playoffs, teams can gain more transparency and perspective on what 
does work with strategy and achieving successful campaigns in mind.

Achieving successful campaigns can potentially lead to increased revenue for all stakeholders through ticket sales, salary increases, 
endorsement deals, fair book value of the organization, greater economic activity for the represented city, etc.  

*/

/************************************************************************************************************************************/
/*Set univariate analysis environment*/
/************************************************************************************************************************************/
/*Import macros*/
%include "/folders/myshortcuts/SAS_Work/Project_Josepp/Macros.sas";

/*Create a directory in sasuser.v94 calles NHL_Data_Directory*/
options dlcreatedir;
libname dd '/folders/myfolders/sasuser.v94/NHL_Data_Dictionary';

/*Import NHL season data from 1983 - 2020*/
proc import datafile = "/folders/myshortcuts/SAS_Work/Project_Josepp/Data/NHL_1983_2020_Data.csv" 
out = dd.nhl
dbms = csv 
replace;
getnames = yes;
guessingrows = 428;
run;

/*Create two derived variables by use of chi-square automatic interaction detector (CHAID) trees*/
data nhl;
set dd.nhl;
if winOutShootOpp > 0.483 and winOutShotByOpp > 0.421 then D1 = 0;
else D1 = 1;
if winOutShootOpp <= 0.483 and goalsPerGame <= 2.805 and goalsAgainstPerGame > 2.646 then D2 = 1;
else D2 = 0;
run;

/*Convert to data type character*/
data nhl;
set nhl;
id_new = put(id, 20.);
year_range_new = put(year_range, 20.);
failed_playoff_flag_new = put(failed_playoff_flag, 20.);
D1_new = put(D1, 20.);
D2_new = put(D2, 20.);
drop id year_range failed_playoff_flag D1 D2;
rename id_new = id year_range_new = year_range 
failed_playoff_flag_new = failed_playoff_flag D1_new = D1 D2_new = D2;
run;

/*Check distinct and missing or null values for each column*/
/*There are no null or out of the ordinary values in the data set*/
%distinct(nhl, gamesPlayed);
%distinct(nhl, wins);
%distinct(nhl, losses);
%distinct(nhl, ot);
%distinct(nhl, pts);
%distinct(nhl, ptPctg);
%distinct(nhl, goalsPerGame);
%distinct(nhl, goalsAgainstPerGame);
%distinct(nhl, PowerPlayPercentage);
%distinct(nhl, powerPlayGoals);
%distinct(nhl, powerPlayOpportunities);
%distinct(nhl, penaltyKillPercentage);
%distinct(nhl, shotsPerGame);
%distinct(nhl, shotsAllowed);
%distinct(nhl, winScoreFirst);
%distinct(nhl, winOppScoreFirst);
%distinct(nhl, winLeadFirstPer);
%distinct(nhl, winLeadSecondPer);
%distinct(nhl, winOutshootOpp);
%distinct(nhl, winOutshotByOpp);
%distinct(nhl, faceOffsTaken);
%distinct(nhl, faceOffsWon);
%distinct(nhl, faceOffsLost);
%distinct(nhl, faceOffWinPercentage);
%distinct(nhl, shootingPctg);
%distinct(nhl, savePctg);
%distinct(nhl, name);
%distinct(nhl, id);
%distinct(nhl, year_range);
%distinct(nhl, D1);
%distinct(nhl, D2);
%distinct(nhl, failed_playoff_flag);

/*Univariate analysis for all numeric columns and saved in project directory as a pdf*/
/* 

* games played - show heavily skewed data due to season strikes and the recent pandemic shortening three identified seasons; 
  1994-1995, 2012-2013, 2019-2020.
* ot - show heavily skewed data due to lack of records in the earlier recorded seasons.
* faceoff data - show heavily skewed data due to lack of records in the earlier recorded seasons.

* The above features will not be included in the predictive analysis going forward.

*/
ods pdf 
file = '/folders/myshortcuts/SAS_Work/Project_Josepp/NHL_Numeric_Univariate.pdf'
style = dove;
proc univariate data = nhl;
histogram _numeric_ / normal (color = blue w = 2.5) barlabel = percent;
var _numeric_;
run;
ods pdf close; 

/*Univariate analysis for all categorical columns and saved in project directory as a pdf*/
/*There is no one feature that is out of the ordinary for the categorical univariate, however, teams names, team id, and dates will not 
be included in the predictive analysis going forward.

*/
ods pdf 
file = '/folders/myshortcuts/SAS_Work/Project_Josepp/NHL_Categorical_Frequencies.pdf'
style = dove;
%freq(nhl, name);
%freq(nhl, id);
%freq(nhl, year_range);
%freq(nhl, D1);
%freq(nhl, D2);
%freq(nhl, failed_playoff_flag);
ods pdf close; 






