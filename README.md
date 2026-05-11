# Interpretable Machine Learning for Reddit Mental Health Text Classification

## Project Overview

This project explores whether interpretable machine learning can be used to classify depression-related Reddit posts against an ADHD comparison group.

The purpose of this project is not to provide clinical diagnosis. Instead, it demonstrates how natural language processing, supervised machine learning, and model interpretability can support early-risk triage in sensitive mental health contexts.

This project was developed as part of FIT5145 Assignment 3 and later organised as a portfolio-style data science project.

---

## Research Aim

The main aim of this project is to build and evaluate an interpretable text classification pipeline that can identify depression-related Reddit posts using linguistic features extracted from social media text.

The project focuses on:

- Reddit mental health text preprocessing
- Exploratory data analysis
- Word frequency and TF-IDF analysis
- Document-Term Matrix feature engineering
- Logistic Regression and Naive Bayes classification
- Model evaluation using accuracy, precision, recall, F1-score, ROC, and AUC
- Logistic Regression coefficient interpretation
- Error analysis and responsible reporting

---

## Project Structure

```text
5145-mental-health-detection/
├── data/
│   ├── raw/                  # Raw data, not included in public repository
│   └── processed/            # Processed metadata and safe outputs
├── notebooks/                # R Markdown analysis files
├── report/                   # Final report files
├── results/
│   ├── figures/              # Generated visualisations
│   ├── tables/               # Summary tables and model results
│   └── models/               # Saved model files, not uploaded publicly
├── slides/                   # Presentation materials
├── src/                      # Reusable source scripts
├── README.md
└── .gitignore
```

---

## Methods

The analysis pipeline includes the following steps:

1. Data loading and cleaning
2. Exploratory data analysis
3. Text length analysis
4. Word frequency analysis by class
5. Post-level TF-IDF analysis
6. Document-Term Matrix feature engineering
7. Logistic Regression and Naive Bayes model training
8. Model evaluation and comparison
9. Model interpretability using Logistic Regression coefficients
10. Error analysis and limitation discussion

---

## Key Results

The Logistic Regression model achieved stronger overall performance than Naive Bayes.

| Model | Accuracy | Precision | Recall | F1 | AUC |
|---|---:|---:|---:|---:|---:|
| Logistic Regression | 0.9024 | 0.8714 | 0.8905 | 0.8809 | 0.9577 |
| Naive Bayes | 0.7680 | 0.6534 | 0.9096 | 0.7605 | 0.8248 |

Logistic Regression was selected as the main model because it provides both strong predictive performance and interpretable coefficients.

---

## Model Interpretability

The Logistic Regression coefficients helped identify terms that contributed most strongly to each class.

Depression-related posts were more associated with terms linked to emotional distress, self-harm risk, hopelessness, medication, and hospitalisation.

ADHD comparison posts were more associated with terms related to medication, hyperfocus, diagnosis, attention, and executive function.

These terms should be interpreted as linguistic signals in Reddit text rather than clinical diagnostic indicators.

---

## Error Analysis

The Logistic Regression model correctly classified 6,188 out of 6,857 test posts, representing 90.24% of the test set.

| Prediction Outcome | Count | Percentage |
|---|---:|---:|
| Correct | 6,188 | 90.24% |
| False Negative | 304 | 4.43% |
| False Positive | 365 | 5.32% |

False negatives are particularly important in this project because they represent depression-related posts that the model failed to identify. However, false positives are also important because they may increase the workload for human reviewers in a triage workflow.

---

## Responsible Data Use

This project uses sensitive mental health-related social media text. For privacy and ethical reasons, the raw dataset and full cleaned text dataset are not included in this public repository.

The repository includes:

- R Markdown analysis code
- Aggregate summary tables
- Visualisations
- Model evaluation results
- Privacy-safer processed metadata

The full text data is excluded from GitHub using `.gitignore`.

---

## Tools and Packages

This project was developed in R using the following packages:

- `tidyverse`
- `ggplot2`
- `tidytext`
- `tm`
- `SnowballC`
- `e1071`
- `pROC`
- `knitr`
- `rmarkdown`

---

## How to Run

Open the project `.Rproj` file in RStudio, then open the R Markdown file in the `notebooks/` folder.

Install required packages if needed:

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

Then knit the R Markdown file to reproduce the analysis.

---

## Important Note

This project is for academic and portfolio demonstration purposes only. It is not a clinical tool and should not be used to diagnose depression or ADHD.

Any mental health risk detection system should be used only as decision support under human review and appropriate ethical governance.