## Accelerometer data from the Samsung Galaxy S smartphone
This repository contains a script `run_analysis.R` that downloads accelerometer data from
the UCI Machine Learning Repository. The data is downloaded into a data/ directory and unziped there.
The script then merges several of the files in the downloaded data and extracts the mean values for the
different subjects and the measured activities.activities. The script creates a file called `data/tidyData.txt`.
That contains this merged data with descriptive variable names.

## Dependencies

The script depends on R version 3.1.1 or later and the dplyr package.

## Usage

Run `run_analysis.R` through R and the `data/tidyData.txt` file will be created. The created file can be loaded
and viewed in R with:
```R
> data <- read.table("./data/tidyData.txt", header = TRUE)
> View(data)
```
