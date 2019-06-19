/*Replace missing values with a blank*/
OPTIONS MISSING='';

/*Read in the cleaned csv file of energy consumption data.*/
PROC IMPORT DATAFILE= '/folders/myfolders/SASData/Annual_Energy_Consumption_Data_2017.csv'
OUT=WORK.TORONTOENERGY
DBMS=CSV;
GETNAMES=YES
;
RUN;

/*Histogram of AvgHrsperWeek of energy consumption.
Give vertical scale in counts instead of percent*/
TITLE =  'Average Hours per Week of Energy Consumption';
PROC UNIVARIATE DATA=WORK.TORONTOENERGY;
   VAR AvgHrsperWeek;
   HISTOGRAM AvgHrsperWeek / MIDPOINTS = 70 80 90 100 110 120 130 140 150 160 170
   VSCALE = COUNT;
   LABEL AvgHrsperWeek='Average Hours of Energy Consumption per Week'; 
RUN;

/*Redo Histogram with only three bins, set the values that
actually exist.  Since the variable is numeric, the ticks
will show up in their proper place on the x axis.*/
ODS GRAPHICS ON;
PROC SGPLOT DATA=WORK.TORONTOENERGY;
HISTOGRAM AvgHrsperWeek  / NBINS=4 SCALE=COUNT;
XAXIS GRID VALUES=(70 100 168) VALUESHINT;
LABEL AvgHrsperWeek= 'Average Hours per Week of Energy Consumed';
RUN;


/*Create a new table where AvgHrsperWeek is a character variable instead*/
DATA WORK.TORONTOENERGY2;
	SET WORK.TORONTOENERGY;
	AvgHrsperWeek_char = PUT(AvgHrsperWeek, 6.);
RUN;

/*Create a table of counts for the different AvgHrsperWeek values*/	
PROC FREQ DATA=WORK.TORONTOENERGY2;
TABLES AvgHrsperWeek_char;
RUN;
	
/*Redo histogram of AvgHrsperWeek of energy consumption.
Use the Hrs per Week as a character/factor variable instead.
Give vertical scale in counts instead of percent*/
PROC SGPLOT DATA=WORK.TORONTOENERGY2;
VBAR AvgHrsperWeek_char;
XAXIS LABEL = 'Average Hours of Energy Consumption per Week';
YAXIS LABEL = 'Counts';
RUN;
ODS GRAPHICS OFF;

