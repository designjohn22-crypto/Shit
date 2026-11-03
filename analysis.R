# Student Academic Performance — exploratory analysis
# Dataset: student_academic_performance.csv (synthetic teaching dataset)
# Run this script from the project folder in Posit Cloud.

# 1. Import data
student_data <- read.csv("student_academic_performance.csv",
                         stringsAsFactors = FALSE)

# 2. Inspect and clean
str(student_data)
summary(student_data)

student_data$grade_level <- factor(
  student_data$grade_level,
  levels = c("Grade 9", "Grade 10", "Grade 11", "Grade 12")
)
student_data$performance_band <- factor(
  student_data$performance_band,
  levels = c("Needs Support", "Moderate", "High")
)

# Remove incomplete rows in the variables used for this analysis.
analysis_data <- student_data[
  complete.cases(student_data[, c(
    "grade_level", "study_hours_per_day", "attendance_rate_pct",
    "assignment_completion_pct", "exam_score", "performance_band"
  )]), ]

# 3. Overall summary objects (visible in the Environment pane)
overall_summary <- data.frame(
  number_of_students = nrow(analysis_data),
  average_exam_score = round(mean(analysis_data$exam_score), 1),
  median_exam_score = round(median(analysis_data$exam_score), 1),
  average_study_hours = round(mean(analysis_data$study_hours_per_day), 1),
  average_attendance_pct = round(mean(analysis_data$attendance_rate_pct), 1),
  average_assignment_completion_pct =
    round(mean(analysis_data$assignment_completion_pct), 1)
)
print(overall_summary)

# 4. Compare average scores by grade level
grade_summary <- aggregate(
  exam_score ~ grade_level,
  data = analysis_data,
  FUN = function(x) round(mean(x), 1)
)
names(grade_summary)[2] <- "average_exam_score"
print(grade_summary)

# 5. Compare average scores by parental support
support_summary <- aggregate(
  exam_score ~ parental_support,
  data = analysis_data,
  FUN = function(x) round(mean(x), 1)
)
names(support_summary)[2] <- "average_exam_score"
print(support_summary)

# 6. Examine the relationship between study time and exam score
study_score_correlation <- round(
  cor(analysis_data$study_hours_per_day,
      analysis_data$exam_score,
      use = "complete.obs"),
  2
)
print(study_score_correlation)

# 7. Simple visualizations
barplot(grade_summary$average_exam_score,
        names.arg = grade_summary$grade_level,
        ylim = c(0, 100),
        main = "Average exam score by grade level",
        xlab = "Grade level", ylab = "Average exam score")

plot(analysis_data$study_hours_per_day, analysis_data$exam_score,
     pch = 19,
     xlab = "Study hours per day",
     ylab = "Exam score",
     main = "Study time and exam score")
abline(lm(exam_score ~ study_hours_per_day, data = analysis_data),
       lwd = 2)

# Interpretation reminder:
# These are simulated records, not real student results. Associations in
# this dataset do not establish cause and effect.
