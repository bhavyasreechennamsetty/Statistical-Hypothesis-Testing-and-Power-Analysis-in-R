Overview

This project presents a reproducible, end-to-end statistical analysis pipeline implemented in R, designed for both academic research and industry-level data analysis.
The workflow covers hypothesis testing, effect size estimation, statistical power analysis, and visualization, ensuring results are not only statistically significant but also practically meaningful.

The code is collaboration-ready and can be executed seamlessly in Google Colab or local R environments.

Files :
Analysis.R - R code
Statistical-Hypothesis-Testing-and-Power-Analysis-in-R.ipnyb - R code in google collab 
experimental_data - Dataset used
report.pdf - consolidated report

Key Objectives

Perform two-sample t-tests to compare group means

Conduct one-way ANOVA for multi-group comparisons

Quantify effect sizes (Cohen’s d, Eta Squared)

Perform power analysis for future sample size planning

Visualize results using publication-quality plots

Ensure reproducibility and clarity for collaborative analysis
Dataset Description

The input dataset (experimental_data.csv) is expected to contain:

Column Name	Description
group	Categorical variable for two-sample t-test
treatment	Categorical variable for ANOVA
response	Numeric outcome variable

Tools & Libraries

R

tidyverse – data manipulation & pipelines

ggplot2 – visualization

pwr – statistical power analysis

effectsize – standardized effect size estimation

janitor – data cleaning utilities

All required packages are auto-installed when the notebook is run.

Methodology
1. Exploratory Data Analysis

Summary statistics (mean, SD, sample size)

Group-level comparisons

2. Hypothesis Testing

Two-sample t-test (Welch’s correction)

One-way ANOVA for multi-group analysis

3. Effect Size Estimation

Cohen’s d for t-test

Eta Squared (η²) for ANOVA

4. Power Analysis

Power calculations based on observed effect sizes

Sample size estimation for achieving 80% statistical power

5. Visualization

Boxplots with mean overlays

Violin plots combined with boxplots

Clean, minimal themes suitable for reports and publications

How to Run (Google Colab)

Open Google Colab

Upload Statistical_Analysis_Collab.ipynb

Run all cells

Upload experimental_data.csv when prompted
