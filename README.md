# NHL_Classification_Analysis

## Project Description

The analysis explored NHL team season data from 1983 - 2020 to predict season and playoff outcomes.

The season outcomes were calculated by how many adjusted wins a team won (wins + (ties / 2)) above the mean adjusted wins of any given season. The season outcome was calculated this way due to the varying nature of hockey; in some seasons, teams were closer in regards to games won and some had a greater divide. In addition, some seasons were longer than other seasons and by using the adjusted games a team won **(wins + (ties / 2))** above the mean adjusted wins of any given season metric, all seasons were included in the analysis despite some seasons having less games played (shortened due to strike and pandemic).

The season outcomes calculated in the way mentioned above will help predict and understand playoff outcomes more efficiently.

More than 60% of teams make the playoffs, so the analysis set out to predict teams that did not make the playoffs.

The entirety of the analysis sought to understand the statistical economics of what NHL team organizations can focus on to reach the post-season. 

By understanding the economics of what hold teams back from making playoffs, teams can gain more transparency and perspective on what does work with strategy and achieving successful campaigns in mind.

Achieving successful campaigns can potentially lead to increased revenue for all stakeholders through ticket sales, salary increases, endorsement deals, fair book value of the organization, greater economic activity for the represented city, etc.

## Methods Used

1) Descriptive Statistics - used for preliminary data exploration.
2) Machine Learning - in the process of predicting season and playoff outcomes, greater transparency around the features were developed for a greater understadning of the statistical economics driving teams into the playoffs.
3) Inferential Statistics - used to make quantitative recommendations (confidence intervals and means) regarding the predictor features. 

## Results 

### Multiple Linear Regression to Predict Season Outcomes

Model Features:

1) **Shooting Percentage** (shootingPctg)
2) **Save Percentage** (savePctg)
3) **Shots Per Game** (failedShotsPerGame)
4) **Percentage of Games Won when Team Scores First** (winScoreFirstGreater61_low)
5) **Save Per Game** (savesPerGame) 

Model Target:

1) **Above the Mean Adjusted Wins** (aboveMeanAdjWins)

Model Results on Test Data:

![](ReadMe_Images/r2.png)

* **r2:** 0.90
* **Mean Absolute Error:** 1.79
* **Mean Squared Error:** 5.32
* **Root Mean Squared Error:** 2.31

Model Feature Coefficients:

1) **Shooting Percentage** (shootingPctg): 3.99
2) **Save Percentage** (savePctg): 3.92
3) **Shots Per Game** (failedShotsPerGame): 1.36
4) **Percentage of Games Won when Team Scores First** (winScoreFirstGreater61_low): -1.74
5) **Save Per Game** (savesPerGame): -1.40

Model Feature Importance:

![](ReadMe_Images/Feature_Importance.png)
 
### Logistic Regression Using Predicted Season Outcomes to Predict Playoff Outcomes

Model Feature:

1) **Predicted Above the Mean Adjusted Wins** (predAboveMeanAdjWins)

Model Target:

1) **Failed Seasons By Not Making Playoffs** (failed_playoff_flag)

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

1) Python 
2) R
3) Jupyter Notebook
4) Anaconda Environment

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

