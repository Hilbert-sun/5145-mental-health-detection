# Interpretable Machine Learning for Reddit Mental Health Text Classification

This project explores whether interpretable machine learning can identify depression-related Reddit posts against an ADHD comparison group. It was developed for FIT5145 Assignment 3 and then organised as a portfolio-style data science project.

The project is not a clinical diagnosis tool. Its intended use is a cautious, human-in-the-loop triage workflow: score public posts, explain the strongest text signals, and route high-risk or uncertain cases to trained reviewers.

## Project Highlights

- Built a reproducible R Markdown workflow for Reddit mental health text classification.
- Cleaned an initial merged dataset of 61,140 posts down to 34,282 usable posts.
- Compared Logistic Regression with Naive Bayes using Accuracy, Precision, Recall, F1, ROC, and AUC.
- Selected Logistic Regression as the main model because it combines strong performance with coefficient-level interpretability.
- Added error analysis to separate false negatives from false positives in a triage context.
- Added a threshold-based triage view to connect model probabilities with reviewer workload and missed-risk trade-offs.
- Reported privacy and governance limits clearly because the data is sensitive social media text.

## Key Results

| Model | Accuracy | Precision | Recall | F1 | AUC |
|---|---:|---:|---:|---:|---:|
| Logistic Regression | 0.9024 | 0.8714 | 0.8905 | 0.8809 | 0.9577 |
| Naive Bayes | 0.7680 | 0.6534 | 0.9096 | 0.7605 | 0.8248 |

The Logistic Regression model correctly classified 6,188 out of 6,857 test posts, representing 90.24% of the test set.

| Prediction Outcome | Count | Percentage |
|---|---:|---:|
| Correct | 6,188 | 90.24% |
| False Negative | 304 | 4.43% |
| False Positive | 365 | 5.32% |

## Repository Structure

```text
5145-mental-health-detection/
|-- data/
|   |-- processed/          # Privacy-safer processed metadata
|-- notebooks/              # R Markdown analysis and rendered HTML
|-- report/                 # Final report deliverables
|-- results/
|   |-- figures/            # Generated visualisations
|   |-- models/             # Local model files, ignored by Git
|   |-- tables/             # Summary tables and model results
|-- slides/                 # Presentation deliverables
|-- src/                    # Reserved for reusable scripts
|-- README.md
|-- .gitignore
```

## Analysis Workflow

1. Load Reddit depression and ADHD datasets.
2. Combine post title and body into a single text field.
3. Remove deleted, removed, empty, or missing posts.
4. Explore class balance and text length distribution.
5. Analyse word frequency and post-level TF-IDF terms.
6. Build Document-Term Matrix features from the training set vocabulary.
7. Train Logistic Regression and Naive Bayes models.
8. Evaluate metrics, ROC curves, and AUC.
9. Interpret Logistic Regression coefficients.
10. Analyse false negatives, false positives, and threshold trade-offs.

## Responsible Data Use

This project uses sensitive mental health-related social media text. Raw Reddit text is not suitable for public portfolio sharing.

The public repository should include:

- R Markdown analysis code
- Aggregate summary tables
- Generated figures
- Model evaluation results
- Privacy-safer processed metadata
- Final report and presentation deliverables

The public repository should not include:

- Raw Reddit CSV files
- Full cleaned text datasets
- Saved model binaries
- RStudio temporary files
- Personal working-history files

## Limitations

- Subreddit membership is used as a proxy label; it is not a verified clinical diagnosis.
- Reddit language reflects community norms and may not generalise to other platforms.
- Model coefficients are linguistic signals, not psychological theory.
- A single automatic threshold is not appropriate for deployment without reviewer calibration.
- Any real-world use would require consent-aware data sourcing, clinical validation, fairness checks, audit logs, and human oversight.

## How to Run

Open `5145 mental-health-detection.Rproj` in RStudio, then knit `notebooks/analysis.Rmd`.

Install the required R packages if needed:

```r
install.packages(c(
  "tidyverse",
  "ggplot2",
  "tidytext",
  "tm",
  "SnowballC",
  "e1071",
  "pROC",
  "knitr",
  "rmarkdown"
))
```

The analysis writes reproducible outputs to:

- `results/tables/`
- `results/figures/`
- `results/models/` locally only

## Important Note

This project is for academic and portfolio demonstration purposes only. It should not be used to diagnose depression or ADHD. Any mental health risk detection system should be used only as decision support under human review and appropriate ethical governance.
