CleaningData
============

Cleaning data artifacts
This repository supports a scrit - run_analysis.R that will download a set for files from the accelerometers from the Samsung Galaxy S smartphone
The run_analysis.R script downloads a zip files containing a set of files describing the experiment and the type of measurements, that are actually contained in a test sub-directory.
The script runs in a directory where it will download all the files

As for the script it is pretty straigtforward and only requires an active connection to be able to download the file.

It will first combine training and test data for all subjects then it will merge the data to assign the specific features and activities to specific subjects.  

A number of variables were measured for the various signals, but this script will only deal with mean and standard deviation, so it will subset these two variables from the full set, and use them to create a tidy dataset.

The tidy dataset will calculate the mean for the various activities performed by the 30 subjects.





