# Complementary and Alternative Medicines
*Medical pluralism in Europe : User profiles, determinants of access and value orientations in the use of complementary and alternative medicine (CAM)*

***

### Why this repository ?

This is my assignment for the *quantitative techniques* course from the first semester. The instructions were to produce a statistical study of our choice on a dataset of our choice using the statistical tools covered in class. Since the final result was an oral presentation, I don't have a well-written analysis report to present, but I still managed to cobble something together with the notes that I have.

The repo is organized as follows :
- In the docs directory, you will find the [methodological roadmap](/docs/methodology.md) that I've followed, as well as a step by step [summary of my results](/docs/summary_results.md).
- In the scripts directory their is all my R code divided by operational steps : [preparation of the data](/scripts/01_data_preparation.R), [descriptive statistics](/scripts/02_descriptive_statistics.R), [cluster analysis](/scripts/03_cluster_analysis.R), [variance analysis](/scripts/04_mancova_analysis.R) and [regression models](/scripts/05_logistic_regression_model.R).
- In the outputs file I've put all the generated plots as well as [tables.md](/outputs/tables/tables.md) in wich you'll find all of my numerical results.
- And finally in the data directory their is instructions on how to get the original dataset (and license stuff) in order to process it with my first script, but there is also the already processed dataset.

#### Main findings :
- CAM use is better explained by difficulties in accessing the conventional health system (Push) rather than by cultural values of openness (Pull).
- High intensity CAM use is linked to poor physical health but is unrelated to poor mental health.
- There is no statistically significant sub-cultures of CAM use (no latent profiles), each type of therapy come with its specific predictors and is, in most cases, combined with conventional medicine.

### Favorite plot of the project :

![](/outputs/figure/5_1_predictors_cam_use.png)
