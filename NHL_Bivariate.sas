/*
*************************************************************************************************************************************
NHL Bivariate Analysis

Project Description: 

The following analysis seeks to explore the features in relation to the traget variable failed_playoff_flag (flags marking teams who 
didn't make the playoffs for that particular season).
*/
/************************************************************************************************************************************/
/*Set bivariate and multicollinearity analysis environment*/
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

/*Create two derived variables*/
data nhl;
set dd.nhl;
if winOutShootOpp > 0.483 and winOutShotByOpp > 0.421 then D1 = 1;
else D1 = 0;
if winOutShootOpp <= 0.483 and goalsPerGame <= 2.805 and goalsAgainstPerGame > 2.646 then D2 = 1;
else D2 = 0;
run;

/************************************************************************************************************************************/
/*Bivariate analysis*/
/************************************************************************************************************************************/
/*Bivariate for continuous variables not held out due to reasons explained in the univariate analysis and saved as a pdf*/
/*Because of the lack of variance, savePctg will not be included in the predictive analysis.*/
ods pdf 
file = '/folders/myshortcuts/SAS_Work/Project_Josepp/NHL_Numeric_Bivariate.pdf'
style = dove;
%BivariateCont(nhl, goalsPerGame, failed_playoff_flag);
%BivariateCont(nhl, goalsAgainstPerGame, failed_playoff_flag);
%BivariateCont(nhl, powerPlayPercentage, failed_playoff_flag);
%BivariateCont(nhl, powerPlayGoals, failed_playoff_flag);
%BivariateCont(nhl, powerPlayOpportunities, failed_playoff_flag);
%BivariateCont(nhl, penaltyKillPercentage, failed_playoff_flag);
%BivariateCont(nhl, shotsPerGame, failed_playoff_flag);
%BivariateCont(nhl, shotsAllowed, failed_playoff_flag);
%BivariateCont(nhl, shootingPctg, failed_playoff_flag);
%BivariateCont(nhl, savePctg, failed_playoff_flag);
%BivariateCont(nhl, winScoreFirst, failed_playoff_flag);
%BivariateCont(nhl, winOppScoreFirst, failed_playoff_flag);
%BivariateCont(nhl, winLeadFirstPer, failed_playoff_flag);
%BivariateCont(nhl, winLeadSecondPer, failed_playoff_flag);
%BivariateCont(nhl, winOutshootOpp, failed_playoff_flag);
%BivariateCont(nhl, winOutshotByOpp, failed_playoff_flag);
ods pdf close;

/*Bivariate of up for entry categorical variables and saved as a pdf*/
/*There is not out of the ordinary for the categorical variables*/
ods pdf 
file = '/folders/myshortcuts/SAS_Work/Project_Josepp/NHL_Categorical_Bivariate.pdf'
style = dove;
%BivariateCateg(nhl, D1, failed_playoff_flag);
%BivariateCateg(nhl, D2, failed_playoff_flag);
ods pdf close;
