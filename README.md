# NHL_Classification_Analysis

## Project Description

The analysis used logistic regression to predict the playoff outcomes of teams that don't make the playoffs. 

By understanding the economics of what holds teams back from making playoffs, teams can gain more transparency and perspective on what does work with strategy and achieving successful campaigns in mind.

Achieving successful campaigns can potentially lead to increased revenue for all stakeholders through ticket sales, salary increases, 
endorsement deals, fair book value of the organization, greater economic activity for the represented city, etc.  

## Methods Used

1) Descriptive Statistics - used for preliminary data exploration.
2) Machine Learning - in the process of predicting season and playoff outcomes, greater transparency around the features were developed for a greater understadning of the statistical economics driving teams into the playoffs.

## Results 

Model Features:

1) **goalsPerGame** - Average goals per game
2) **powerPlayPercentage** - Average goals per power play
3) **penaltyKillPercentage** - Average scoreless penalty kills
4) **shotsPerGame** - Average shots per game
5) **shotsAllowed** - Average shots against
6) **winLeadFirstPer** Percentage of games won when teams scored frist
7) **winLeadSecondPer** Percentage of games won when teams lead the second period
8) **winOutshotByOpp** Percentage of games won when teams was outshot by opponent
9) **D1** -  winOutShootOpp > 0.483 and winOutShotByOpp > 0.421
10) **D2** - winOutShootOpp <= 0.483 and goalsPerGame <= 2.805 and goalsAgainstPerGame > 2.646

Model Target:

1) **failed_playoff_flag** -  Failed Seasons By Not Making Playoffs

Model Results on Test Data:

![](ReadMe_Images/ROC_AUC.png)

* **Concordance:** 0.94
* **AUC:** 0.94

![](ReadMe_Images/CAP_LIFT.png)

* **Accuracy:** 0.86
* **Percision:** 0.91
* **Recall:** 0.87
* **F1:** 0.89
* **Kolmogorov–Smirnov Measure (KS):** 43% at the 4th decile, 1.1 times greater than a random model

Model Feature Coefficients:

Shooting Percentage (shootingPctg): 3.99
Save Percentage (savePctg): 3.92
Shots Per Game (failedShotsPerGame): 1.36
Percentage of Games Won when Team Scores First (winScoreFirstGreater61_low): -1.74
Save Per Game (savesPerGame): -1.40

## Technologies 

1) SAS 
2) Python
3) SAS Studio
4) Jupyter Notebook
5) Anaconda Environment

## Order of Analysis

1) **NHL_1983_2020_Multiple_Linear_Regression_EDA.ipynb**
2) **NHL_1983_2020_Multiple_Linear_Regression.ipynb**
3) **NHL_1983_2020_Logistic_Regression_EDA.ipynb**
4) **NHL_1983_2020_Logistic_Regression.ipynb**
5) **NHL_1983_2020_Feature_A-B_Tests.ipynb**

## Directory Files

1) **NHL_API.ipynb** - NHL data base API.
2) **Preprocessing_Functions.ipynb** - Preprocessing functions.
3) **Regression_Metrics_Function.ipynb** - Regression evaluation functions.
4) **AUC_CAP_Functions.ipynb** - Classification evaluation functions.
5) **Stats_Functions.ipynb** - Descriptive and inferential stats functions.
6) **CHAID_Tree_Plots** - CHAID tree algorithm used to explore data for derived variables.
7) **NHL_1983_2020_Multiple_Linear_Regression_EDA.ipynb** - Multiple linear regression EDA, feature enginearing, and feature selection.
8) **NHL_1983_2020_Multiple_Linear_Regression.ipynb** - Multiple linear regression model building, feature selection, preprocessing, evaluation, and interpretation.
9) **NHL_Season_Wins_Linear_Regression_Model.pkl** - Saved multiple linear regression model.
10) **NHL_1983_2020_Logistic_Regression_EDA.ipynb** - Logistic regression EDA, feature enginearing, and feature selection.
11) **NHL_1983_2020_Logistic_Regression.ipynb** - Logistic regression model building, feature selection, preprocessing, evaluation, and interpretation.
12) **NHL_Playoffs_Logistic_Regression_Model.pkl** - Saved Logistic regression model.
13) **NHL_1983_2020_Feature_A-B_Tests.ipynb** - A/B testing on predictor features between successful and unsuccessful playoff outcomes.

