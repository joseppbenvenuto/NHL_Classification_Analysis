/************************************************************************************************************************************/
/*Check distinct values macro*/
/************************************************************************************************************************************/
%macro distinct (data, col);
/*Keep the chosen column*/
data &col.;
set &data.;
keep &col.;
run;

/*find all unique values*/
proc sort data = &col. nodupkey;
by &col.;
run;
%mend;

/************************************************************************************************************************************/
/*Frequencies macro*/
/************************************************************************************************************************************/
%macro freq(data, col);
/*Create frequency table*/
proc sql;
CREATE TABLE freq_&data. AS
SELECT &col., COUNT(&col.) as Frequency, ROUND((COUNT(&col.)/(SELECT COUNT(&col.) FROM &data.))*100, 0.01) AS Percent
FROM &data.
GROUP BY &col.
ORDER BY Frequency DESC;
quit;

/*Print frequency tables*/
proc print data = freq_&data.;
run;

/*Create frequency bar chart*/
ods graphics / reset width = 10in height = 8in imagemap;
proc sgplot data = freq_&data.;
hbar &col. / datalabel fillattrs =(transparency = 0.75) response = Percent categoryorder = respdesc;
title height = 10pt "Frequencies";
xaxis label = "Percent";
yaxis label = "&col.";
run;
ods graphics on / reset = all;
%mend;

/************************************************************************************************************************************/
/*Continuous variable bivariate for classification macro*/
/************************************************************************************************************************************/
%macro BivariateCont(data, iv, dv);
/*Create table for averages across dependant variable*/
proc sql;
Create TABLE &iv._tab AS
SELECT &dv., round(avg(&iv.), 0.01) AS Avg_&iv.
FROM &data.
GROUP BY &dv.;
quit;

/*Print table*/
proc print data = &iv._tab;
run;

/*Create averages bar chart*/
proc sgplot data = &iv._tab;
vbar &dv. / datalabel fillattrs =(transparency = 0.75) response = Avg_&iv. stat = mean;
title "Avg &iv Across &dv.";
yaxis label ="Avg_&iv.";
run;
%mend;

/************************************************************************************************************************************/
/*Categorical variable bivariate for classification macro*/
/************************************************************************************************************************************/
%macro BivariateCateg(data, iv, dv);
/*Part 1 - create table to calculate rate of dependant variable*/
proc sql;
CREATE TABLE &iv._tab AS 
SELECT &iv, count(*) as freq, sum(&dv.) AS sum
FROM &data.
GROUP BY &iv.;
quit;

/*Part 2 - create table to calculate rate of dependant variable*/
data &iv._tab;
set &iv._tab;
rate = round(sum/freq, 0.01);
run;

/*Print rates of dependant variable by independant variable*/
proc print data = &iv._tab;
run;

/*Creat bar chart of independant variable by dependant variable rates*/
ods graphics / reset width = 10in height = 8in imagemap;
proc sgplot data = &iv._tab;
hbar &iv. / datalabel fillattrs = (transparency = 0.75) response = rate stat = mean;
title "Rate of &iv. Per &iv.";
xaxis label = "Rate";
yaxis label ="&iv.";
run;
%mend;

/************************************************************************************************************************************/
/*Multicollinearity test using VIF macro*/
/************************************************************************************************************************************/
%macro vif(data, iv_list, dv);
/*Calculate VIF scores*/
ods graphics off;
ods exclude all;
proc reg data = &data.;
model &dv. = &iv_list. / vif tol collin;
ods output ParameterEstimates = params tableout;
run;
ods exclude none;

/*Create table of VIF scores*/
data params;
set params;
keep Variable Estimate Probt VarianceInflation;
run;

/*Round VIF scores to two decimal places*/
data params;
set params;
VarianceInflation_new = round(VarianceInflation, 0.01);
drop VarianceInflation;
rename VarianceInflation_new = VarianceInflation;
run;

/*Sort VIF scores in descending order*/
proc sort data = params;
by descending VarianceInflation;

/*Print VIF scores tables*/
proc print data = params;
run;

/*Horizontal bar chart of VIF scores in descending order*/
proc sgplot data = params;
hbar Variable / datalabel fillattrs =(transparency = 0.75) response = VarianceInflation stat = mean categoryorder = respdesc;
title "Variable Inflation Factor Scores";
xaxis label = "Variance Inflation";
run;
%mend;

/************************************************************************************************************************************/
/*Classification results metrics macro*/
/************************************************************************************************************************************/
%macro class_metrics(data, col1, col2, metrics_name);
/*Create confussion matrix*/
proc freq data = &data.;
table &col1. * &col2. / out = ConfusionMatrix nocol norow nopercent sparse;
run;

/*Set confussion matrix results to variables*/
proc sql noprint;
SELECT count INTO : tp FROM ConfusionMatrix WHERE &col1. = '1' AND &col2. = '1';
SELECT count INTO : fp FROM ConfusionMatrix WHERE &col1. = '0' AND &col2. = '1';
SELECT count INTO : tn FROM ConfusionMatrix WHERE &col1. = '0' AND &col2. = '0';
SELECT count INTO : fn FROM ConfusionMatrix WHERE &col1. = '1' AND &col2. = '0';
quit;

/*Calculate classification result metrics*/
data &metrics_name.;
Model = "&metrics_name.";
Accuracy = (&tp. + &tn.) /(&tp. + &tn. + &fp. + &fn.);
Precision = &tp. / (&tp. + &fp.);
Recall = &tp. / (&tp. + &fn.);
F1 = (2 * Precision * Recall) / (Precision + Recall);
run;

/*print metrics*/
proc print data = &metrics_name.;
run;
%mend;

/************************************************************************************************************************************/
/*Classification CAP / LIFT chart macro*/
/************************************************************************************************************************************/
%macro cap_lift(data1, target, order);
/*Sort data in descending order*/
proc sort data = &data1.;
by descending &order.;
run;

proc sql noprint;
SELECT COUNT(*) INTO : row_num FROM &data1.;
quit;

/*Split data into 10 deciles*/
%Let NoOfRecords = &row_num.;
%Let NoOfBins = 10;
data binned;
set &data1.;
retain Cumulative_Count;
Count = 1;
Cumulative_Count = sum(Cumulative_Count, Count);
Bin = ceil(Cumulative_Count / round((&NoOfRecords/&NoOfBins),1));
if Bin > &NoOfBins then Bin = &NoOfBins;
run;

/*Group by deciles*/
proc sql;
CREATE TABLE Gains_v1 AS 
SELECT Bin AS Group, count(*) AS CountOfRows, 
sum(&target.) AS CountOftarget
FROM binned
GROUP BY Bin;
quit;

/*Set total target to variable*/
proc sql noprint;
SELECT count(1) INTO : totalTarget
FROM binned
WHERE &target. = 1;
quit;

/*Calculate model target rates and KS*/
data Gains_v1;
set Gains_v1;
ModelPerc = (CountOftarget / &totalTarget) * 100;
RandomPerc = 10;
retain ModelCummPerc RandomCummPerc;
ModelCummPerc = sum(ModelCummPerc, ModelPerc);
RandomCummPerc = sum(RandomCummPerc, RandomPerc);
KS = ModelCummPerc - RandomCummPerc;
run;

/*Create a zero only row*/
proc sql;
insert into Gains_v1
set  CountOfRows = 0, CountOftarget = 0, Group = 0, 
KS = 0, ModelCummPerc = 0, ModelPerc = 0, 
RandomCummPerc = 0, RandomPerc = 0;
quit;

/*Sort data by group in descending order*/
proc sort data = Gains_v1;
by Group;
run;

/*Print lift results table*/
proc print data = Gains_v1;
run;

/*Plot lift curve*/
proc sgplot data = Gains_v1;
series x = Group y = ModelCummPerc;
series x = Group y = RandomCummPerc;
title "Lift Curve";
run;
%mend;

/************************************************************************************************************************************/
/*Logistic bootstrap macro*/
/************************************************************************************************************************************/
%macro logi_bootstrap(seed, data, target, varlist);
   /*Set parameters*/
   %let start = 1;
   %let split = 0.60;
   %let split1 = 60;
	
   /*Selt loop to loop six times*/ 	
   %do %while (&start. <= 6);
   
	  /*Split data by parameters*/
	  data train_&split1. test;
	  set &data.;
	  if ranuni(&seed.) <= &split. then output train_&split1.;
	  else output test;
	  run;
	  
	  /*Run logistic regression on decided data split and seed*/
	  proc logistic data = train_&split1. descending outest = betas covout outmodel = glm_macro;
	  model &target. = &varlist. / 
	  selection = stepwise
	  slentry = 0.05
	  slstay = 0.05
	  details
	  lackfit;
	  output out = pred_train_&split1. p = phat lower = lcl upper = ucl
	  predprobs = (individual crossvalidate);
	  run;
		
	  /*Calculate performance metrics*/	
	  %class_metrics(pred_train_&split1., _FROM_, _INTO_, performance_&split1.);
	  
	  /*adjust parameters*/
      %let split = %sysevalf(&split. + 0.05);
      %let split1 = %eval(&split1. + 5);
      %let start = %eval(&start. + 1);
      
   %end;
   
   /*Unnion join all metrics*/
   proc sql;
   CREATE TABLE metrics AS
   SELECT * FROM performance_60
   UNION SELECT * FROM performance_65
   UNION SELECT * FROM performance_70
   UNION SELECT * FROM performance_75
   UNION SELECT * FROM performance_80
   UNION SELECT * FROM performance_85
   ORDER BY F1 DESC;
   quit;
   
   proc print data = metrics;
   run;
  
%mend;













