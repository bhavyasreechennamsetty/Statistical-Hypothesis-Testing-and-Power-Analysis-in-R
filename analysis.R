# ================================
# Package Setup
# ================================

required_pkgs <- c(
  "tidyverse",
  "ggplot2",
  "pwr",
  "effectsize",
  "janitor",
  "rmarkdown"
)

install_if_missing <- function(pkg) {
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg, repos = "https://cloud.r-project.org")
    library(pkg, character.only = TRUE)
  }
}

invisible(lapply(required_pkgs, install_if_missing))

# ================================
# Data Loading & Inspection
# ================================
setwd("C:/Users/bhavy/Downloads")
getwd()

data_path <- "experimental_data.csv"

data <- read_csv(data_path) %>%
  clean_names()

colnames(data)
glimpse(data)

# ================================
# Descriptive Statistics
# ================================

summary_table <- data %>%
  group_by(group) %>%
  summarise(
    mean = mean(response),
    sd = sd(response),
    n = n(),
    .groups = "drop"
  )

summary_table

# ================================
# Two-Sample t-Test
# ================================

data_ttest <- data %>%
  filter(group %in% c("Control", "Treatment_A"))

data_ttest$group <- droplevels(as.factor(data_ttest$group))

t_test <- t.test(response ~ group, data = data_ttest)
t_effect <- cohens_d(response ~ group, data = data_ttest)

list(
  t_test_result = t_test,
  effect_size = t_effect
)

# ================================
# One-Way ANOVA
# ================================

anova_model <- aov(response ~ group, data = data)
anova_summary <- summary(anova_model)
anova_effect <- eta_squared(anova_model)

list(
  anova = anova_summary,
  effect_size = anova_effect
)

# ================================
# Power Analysis
# ================================

# Power for t-test
t_power <- pwr.t.test(
  d = t_effect$Cohens_d,
  sig.level = 0.05,
  power = 0.80,
  type = "two.sample"
)

# Power for ANOVA
anova_power <- pwr.anova.test(
  k = nlevels(as.factor(data$group)),
  f = sqrt(anova_effect$Eta2[1]),
  sig.level = 0.05,
  power = 0.80
)

list(
  t_test_power = t_power,
  anova_power = anova_power
)

# ================================
# Visualization: Distribution Plots
# ================================

ttest_plot <- ggplot(data, aes(group, response, fill = group)) +
  geom_boxplot(alpha = 0.7) +
  stat_summary(fun = mean, geom = "point", size = 3) +
  labs(
    title = "Two-Sample Comparison",
    subtitle = "Mean Overlay with Distribution",
    x = "Group",
    y = "Response"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

anova_plot <- ggplot(data, aes(group, response, fill = group)) +
  geom_violin(trim = FALSE, alpha = 0.6) +
  geom_boxplot(width = 0.15, outlier.shape = NA) +
  labs(
    title = "Response Distribution Across Groups",
    x = "Group",
    y = "Response"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

ttest_plot
anova_plot

# ================================
# Mean Comparison with 95% CI
# ================================

summary_stats <- data %>%
  group_by(group) %>%
  summarise(
    mean = mean(response),
    sd = sd(response),
    n = n(),
    se = sd / sqrt(n),
    ci_lower = mean - qt(0.975, df = n - 1) * se,
    ci_upper = mean + qt(0.975, df = n - 1) * se,
    .groups = "drop"
  )

ggplot(summary_stats, aes(x = group, y = mean)) +
  geom_point(size = 4) +
  geom_errorbar(
    aes(ymin = ci_lower, ymax = ci_upper),
    width = 0.2,
    linewidth = 1
  ) +
  labs(
    title = "Mean Response Comparison with 95% Confidence Intervals",
    x = "Group",
    y = "Mean Response"
  ) +
  theme_minimal(base_size = 13)

# ================================
# Power Curve: Two-Sample t-Test
# ================================

sample_sizes <- seq(2, 40, by = 1)

power_ttest <- data.frame(
  n = sample_sizes,
  power = sapply(sample_sizes, function(n) {
    pwr.t.test(
      n = n,
      d = t_effect$Cohens_d,
      sig.level = 0.05,
      type = "two.sample",
      alternative = "two.sided"
    )$power
  })
)

ggplot(power_ttest, aes(x = n, y = power)) +
  geom_line(linewidth = 1.2) +
  geom_hline(yintercept = 0.8, linetype = "dashed") +
  labs(
    title = "Power Curve for Two-Sample t-Test",
    x = "Sample Size per Group",
    y = "Statistical Power"
  ) +
  theme_minimal(base_size = 13)

# ================================
# Power Curve: One-Way ANOVA
# ================================

eta_sq <- anova_effect$Eta2[1]
f_value <- sqrt(eta_sq / (1 - eta_sq))

power_anova <- data.frame(
  n = sample_sizes,
  power = sapply(sample_sizes, function(n) {
    pwr.anova.test(
      k = nlevels(as.factor(data$group)),
      n = n,
      f = f_value,
      sig.level = 0.05
    )$power
  })
)

ggplot(power_anova, aes(x = n, y = power)) +
  geom_line(linewidth = 1.2) +
  geom_hline(yintercept = 0.8, linetype = "dashed") +
  labs(
    title = "Power Curve for One-Way ANOVA",
    x = "Sample Size per Group",
    y = "Statistical Power"
  ) +
  theme_minimal(base_size = 13)

