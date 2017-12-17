SafeTree Documentation

1. DESCRIPTION
This package functions to obtain, structure, and analyze data from the Bureau of Labor Statistics (BLS) on workplace injuries, specifically nonfatal cases involving days away from work. This package produces a Shiny Web Application built in R that visualizes average days away from work due to injury and predicts days away from work using random forest regression. The data necessary for this package is too large to be included. A sample dataset has been included for the application to run. All data files can be downloaded from the BLS's directory here: https://download.bls.gov/pub/time.series/cs/

2. INSTALLATION

2.1 Importing Software
To install and setup the code, it is necessary to have the following programs downloaded to your machine: sqlite, R, RStudio.

sqlite - Follow the link to download the correct version of sqlite for your machine: https://www.sqlite.org/download.html

R - Follow the link to download the correct version of R for your machine: https://cran.r-project.org/

RStudio - Follow the link to download the correct version of RStudio for your machine (Free version is adequate for this package): https://www.rstudio.com/products/rstudio/download/

In RStudio you will need to install the following packages: shiny, dplyr, csvread, randomForest, party and plotly. Install by clicking "Install" in the bottom right navigation bar under "Packages" and copy "shiny, dplyr, csvread, randomForest, party, plotly" into the input box.

2.2 Importing Data

2.2.1
Should you decide to download the flat files from the BLS Web Directory, the full data files the sample data sets are sampled from can be created by running the following code in the shell, assuming the DATA folder is the working directory: 
					$sqlite3 < BLS_IN.txt > BLS_OUT.txt
					Note: This will take over 10 minutes to run.
					
The BLS_IN.txt file will export two CSV files named "data.csv", "data_grouped.csv", "predictors.csv", and "industries.csv". These files will house all the data needed to create the web application.

3. EXECUTION
The instructions provided in 3.1 document how to clean the data from the sqlite output. The instructions provided in 3.2 document the proper file structure after everything has been imported and cleaned. The instructions provided in 3.3 document how to run the application with the toy data sets.

3.1 Data Cleaning and Initial Random Forest Model Experiments

3.1.1 DATA CLEANING
Once you are in the directory where you want to run safeTree, (should be same directory as where Data_Cleaning.R is located), first change the directory name in lines 8,9,10 to lead into your current directory, i.e. "~/CX4242/project_files/database/industries.csv". Then by running Data_Cleaning.R, you will generate a folder Industry with separate folder for each specific industry, each with a .csv file for each predictor ready to be used in the random forest model. This will approximately take 20 minutes (20 industries, 14 predictors about 300 .csv files to generate by manipulating and reshaping the original dataset)

3.1.2 RANDOM FOREST MODEL EXPERIMENTS
To see our baseline model for the dataset as a whole, without adding in a predictive capability, simply run safeTree.R. If the DATA CLEANING steps were completed successfully, then this file should run successfully also. The model will cross check the OOB error and test error rate, you will be able to ouput the raw data used to generate Figure 7 in our report. 


3.2 File Structure
Once all software and data is loaded and cleaned, create a directory folder with the structure as follow:
			BLS_Injury_Viz/
				|---data/
					|---sqlite3.exe
					|---BLS_IN.txt
				|---clean
					|---Data_Cleaning.R
					|---database
						|---safeTree.R
						|---industries.csv
						|---predictors.csv
						|---Industry
							|---Accomodation and Food Services
								|---age_toy.csv
								...
							...
				|---visual
					|---application
						|---app.R
						|---data_grouped.csv
						|---random_forest.R
						|---www
							|---bootstrap.css
					

3.3 Application with Toy Dataset

3.3.1 
Open RStudio and set the working directory using the "More" button to the folder the script lives in.
Load the "app.R" and "random_forest.R" script found at the path "BLS_Injury_Viz/visual/application". 

3.3.2
In the "app.R" script, alter the read.csv() file path that reads "CHANGE FILE PATH" to reflect the destiantion of the "data_grouped.csv" file.
In the "random_forest.R" script alter the string in the function that reads "CHANGE FILE PATH" to reflect the destination of the folder that houses the cleaned, random forest compatible Industry datasets. 

3.3.3
The application is run through the app.R script. To run the application, press "Run App" to start the application.
Upon pressing "Run App", a GUI should appear that houses the visualization and prediction tool. Adjust the parameters and explore the workplace injury data like never before!


