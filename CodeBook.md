Variables description

-   subj.tr/subj.te: subject identifiers from training and test sets,
    respectively
-   act.labels: mapping from activity identifiers to activity
    descriptions
-   labels.tr/labels.te: activity identifiers for training and test
    sets, respectively
-   features: feature descriptions
-   set.tr/set.te: features from training and test sets, respectively

In order to create the tidy data set, the following transformations were
applied

1.  Concatenation of training and test datasets from subject\_train.txt
    and subject\_test.txt

2.  Filtered the features, keeping only the mean and standard deviation
    of each feature

3.  Replaced the activity ids in the dataset by the activity names
    loaded from activity\_labels.txt

4.  Append subject identifiers and activiy names to the features dataset

5.  Calculate the mean of each feature in feature dataset grouping by
    subject and by activity. This is done in various steps

5.1. Use mean, tapply and with functions to calculate the mean of a
selected feature for all subjects and all activities

5.2. Transpose the resulting table from previous step to a column wise
format

5.3. Repeat steps 5.1 and 5.2 for all the others features, concatenating
the results in m.by.feature data frame
