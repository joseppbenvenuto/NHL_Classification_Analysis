/*
*************************************************************************************************************************************
NHL Bivariate Analysis

Project Description: 

The following analysis seeks to explore the features in the data set and remove any with an inflation factor score greater than 2.5.

Once the final set of features are selected, playoff outcomes will be predicted using logistic regression.
*/
/************************************************************************************************************************************/
/*Set model environment*/
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

/*Variable list 1*/
%let varlist1 = goalsPerGame
goalsAgainstPerGame
powerPlayPercentage
penaltyKillPercentage
shotsPerGame 
shotsAllowed 
shootingPctg
winScoreFirst
winOppScoreFirst
winLeadFirstPer
winLeadSecondPer
winOutshootOpp
winOutshotByOpp
D1
D2;

/************************************************************************************************************************************/
/*Bootstrap model*/
/************************************************************************************************************************************/
/*bootstrap model*/
/*The 70/30 train and test split delivers the best training results (F1 0.87), so going forward the data will be split 
70/30 train and test.*/
%logi_bootstrap(110, nhl, failed_playoff_flag, &varlist1.);

/*Choose 70 - 30 split*/
data train test;
set nhl;
if ranuni(110) <= 00.70 then output train;
else output test;
run;

/************************************************************************************************************************************/
/*Train model*/
/************************************************************************************************************************************/
ods pdf 
file = '/folders/myshortcuts/SAS_Work/Project_Josepp/NHL_Train_Model.pdf'
style = dove;
/*Multicollinearity VIF test - Variables goalsAgainstPerGame, winScoreFirst, winOppScoreFirst, winOutshootOpp are removed because their 
VIF scores are above 2.5*/
/*Variable list 2*/
%let varlist2 = goalsPerGame
/*goalsAgainstPerGame*/
powerPlayPercentage
penaltyKillPercentage
shotsPerGame 
shotsAllowed 
/*winScoreFirst*/
/*winOppScoreFirst*/
winLeadFirstPer
winLeadSecondPer
/*winOutshootOpp*/
winOutshotByOpp
D1
D2;

%vif(train, &varlist2., failed_playoff_flag);

/*The results appear to be acceptable with an F1 of 0.83*/
/*KS of 42% at the 50th percentile*/
proc logistic data = train descending outest = betas covout outmodel = glm1;
model failed_playoff_flag = &varlist2. / 
selection = stepwise /* forward, backward, or stepwise */
slentry = 0.05
slstay = 0.05
details
lackfit;
output out = pred_train p = phat lower = lcl upper = ucl
predprobs = (individual crossvalidate);
run;

/*Classification metrics*/
%class_metrics(pred_train, _FROM_, _INTO_, performance);

/*Lift Chart*/
%cap_lift(pred_train, failed_playoff_flag, phat);
ods pdf close;

/************************************************************************************************************************************/
/*Test model*/
/************************************************************************************************************************************/
/*The results appear to be acceptable with an F1 of 0.84*/
/*KS of 48% at the 40th percentile*/
ods pdf 
file = '/folders/myshortcuts/SAS_Work/Project_Josepp/NHL_Test_Model.pdf'
style = dove;
proc logistic inmodel = glm1;
score data = test out = pred_test;
run;

/*Classification metrics*/
%class_metrics(pred_test, F_failed_playoff_flag, I_failed_playoff_flag, performance);

/*Lift Chart*/
%cap_lift(pred_test, failed_playoff_flag, P_1);
ods pdf close;






