library(tm)
library(SnowballC)
library(ggplot2)
library(tidyr)

find_project_root <- function(start = getwd()) {
  current <- normalizePath(start, mustWork = TRUE)
  
  repeat {
    required_dirs <- c("data", "notebooks", "results", "src")
    
    if (all(dir.exists(file.path(current, required_dirs)))) {
      return(current)
    }
    
    parent <- dirname(current)
    
    if (identical(parent, current)) {
      stop("Project root could not be found.")
    }
    
    current <- parent
  }
}

clean_corpus <- function(text_vector) {
  corpus <- VCorpus(VectorSource(text_vector))
  corpus <- tm_map(corpus, content_transformer(tolower))
  corpus <- tm_map(corpus, content_transformer(function(x) {
    gsub("[\u2018\u2019\u201c\u201d]", "'", x)
  }))
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, removeNumbers)
  
  modelling_stop_words <- c(
    stopwords("english"),
    "adhd", "depression", "depressed", "depressive"
  )
  
  corpus <- tm_map(corpus, removeWords, modelling_stop_words)
  corpus <- tm_map(corpus, stemDocument)
  corpus <- tm_map(corpus, stripWhitespace)
  
  corpus
}

project_root <- find_project_root()
tables_dir <- file.path(project_root, "results", "tables")
figures_dir <- file.path(project_root, "results", "figures")
models_dir <- file.path(project_root, "results", "models")

depression <- read.csv(file.path(project_root, "data", "depression.csv"), stringsAsFactors = FALSE)
adhd <- read.csv(file.path(project_root, "data", "adhd.csv"), stringsAsFactors = FALSE)

depression$text_raw <- paste(
  ifelse(is.na(depression$title), "", depression$title),
  ifelse(is.na(depression$body), "", depression$body)
)
adhd$text_raw <- paste(
  ifelse(is.na(adhd$title), "", adhd$title),
  ifelse(is.na(adhd$body), "", adhd$body)
)

depression$label <- 1
adhd$label <- 0

data_raw <- rbind(
  depression[, c("text_raw", "label")],
  adhd[, c("text_raw", "label")]
)

removed_or_deleted <- grepl("\\[removed\\]|\\[deleted\\]", data_raw$text_raw, ignore.case = TRUE)
empty_text <- is.na(data_raw$text_raw) | trimws(data_raw$text_raw) == ""
data_clean <- data_raw[!removed_or_deleted & !empty_text, ]

data_clean$class <- ifelse(
  data_clean$label == 1,
  "Depression-related posts",
  "ADHD comparison posts"
)
data_clean$word_count <- sapply(
  strsplit(trimws(data_clean$text_raw), "\\s+"),
  length
)

set.seed(5145)
model_data <- data_clean[, c("text_raw", "label", "class", "word_count")]
train_indices <- unlist(
  tapply(seq_len(nrow(model_data)), model_data$label, function(idx) {
    sample(idx, size = floor(0.8 * length(idx)))
  })
)
test_data <- model_data[-train_indices, ]

dtm_dictionary <- readRDS(file.path(models_dir, "dtm_dictionary.rds"))
logistic_model <- readRDS(file.path(models_dir, "logistic_regression_model.rds"))

test_corpus <- clean_corpus(test_data$text_raw)
test_dtm <- DocumentTermMatrix(
  test_corpus,
  control = list(dictionary = dtm_dictionary)
)
test_matrix <- as.data.frame(as.matrix(test_dtm))
colnames(test_matrix) <- make.names(colnames(test_matrix), unique = TRUE)

test_y <- factor(
  test_data$label,
  levels = c(0, 1),
  labels = c("ADHD", "Depression")
)

logistic_prob <- predict(
  logistic_model,
  newdata = test_matrix,
  type = "response"
)

threshold_values <- c(0.30, 0.40, 0.50, 0.60, 0.70)
threshold_summary <- do.call(
  rbind,
  lapply(threshold_values, function(threshold) {
    predicted <- ifelse(logistic_prob >= threshold, "Depression", "ADHD")
    predicted <- factor(predicted, levels = c("ADHD", "Depression"))
    
    cm <- table(Predicted = predicted, Actual = test_y)
    tp <- cm["Depression", "Depression"]
    fp <- cm["Depression", "ADHD"]
    fn <- cm["ADHD", "Depression"]
    
    precision <- tp / (tp + fp)
    recall <- tp / (tp + fn)
    f1 <- 2 * precision * recall / (precision + recall)
    review_queue <- tp + fp
    
    data.frame(
      Threshold = threshold,
      Review_Queue_Posts = as.integer(review_queue),
      Review_Queue_Percentage = round(review_queue / length(test_y) * 100, 2),
      Precision = round(precision, 4),
      Recall = round(recall, 4),
      F1 = round(f1, 4),
      False_Negatives = as.integer(fn),
      False_Positives = as.integer(fp)
    )
  })
)

write.csv(
  threshold_summary,
  file.path(tables_dir, "threshold_summary.csv"),
  row.names = FALSE
)

threshold_summary_long <- threshold_summary %>%
  pivot_longer(
    cols = c("Precision", "Recall", "F1"),
    names_to = "Metric",
    values_to = "Value"
  )

p_threshold_tradeoff <- ggplot(
  threshold_summary_long,
  aes(x = Threshold, y = Value, colour = Metric)
) +
  geom_line(linewidth = 1) +
  geom_point(size = 2) +
  scale_y_continuous(limits = c(0, 1)) +
  labs(
    title = "Threshold Trade-off for Human Review Triage",
    subtitle = "Lower thresholds improve recall but increase review workload",
    x = "Depression Probability Threshold",
    y = "Metric Score"
  ) +
  theme_minimal()

ggsave(
  filename = file.path(figures_dir, "threshold_tradeoff.png"),
  plot = p_threshold_tradeoff,
  width = 8,
  height = 5,
  dpi = 300
)

threshold_summary
