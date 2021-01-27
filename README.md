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

### Logistic Regression Using Predicted Season Outcomes to Predict Playoff Outcomes

Model Features:

1) **goalsPerGame** - Average goals per game
2) **powerPlayPercentage** - Average goals per power play
3) **penaltyKillPercentage** - Average scoreless penalty kills
4) **shotsPerGame** - Average shots per game
5) **shotsAllowed** - Average shots against
6) **winLeadFirstPer** Percentage of games won when teams scored frist
7) **winLeadSecondPer** Percentage of games won when teams lead the second period
8) **winOutshotByOpp** Percentage of games won when teams was outshot by opponent
9) **D1** - 
10) **D2** - 

Model Target:

1) **Failed Seasons By Not Making Playoffs** - failed_playoff_flag

![](ReadMe_Images/ROC_AUC.png)

* **Concordance:** 0.94
* **AUC:** 0.94

![](ReadMe_Images/CAP_LIFT.png)

* **Accuracy:** 0.86
* **Percision:** 0.91
* **Recall:** 0.87
* **F1:** 0.89
* **Kolmogorov–Smirnov Measure (KS):** 43% at the 4th decile, 1.1 times greater than a random model

### A/B Testing on Predictor Features

If teams want to make the playoffs they need to increase their aboveMeanAdjWins. To increase their aboveMeanAdjWins, teams should take into consideration the following:

**Note** - all p-values are significant as **p < 0.05**. 

1) **shootingPctg** -                strive to achieve **10.84%** shooting percentage and stay within range **10.3%, 10.48%, 10.67%**.<br>
2) **savePctg**                      strive to achieve a **90.21%** save percentage and stay within range **90.02%, 90.21%, 90.4%**.<br>
3) **savesPerGame**                  strive to achieve **26.12** saves per game and stay within range **25.82, 26.12, 26.42**.<br>
4) **failedShotsPerGame**            strive to achieve **27.17** shots per game and stay within range **26.91, 27.17, 27.43**.<br>
5) **winScoreFirstGreater61_low**    strive to win **82%** of games they score first and stay within range **75%, 82%, 88%**.<br>
6) **aboveMeanAdjWins**              strive to achieve **4.3** shots per game and stay within range **3.62, 4.3, 4.98**.<br>

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

