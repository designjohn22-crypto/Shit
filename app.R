# Student Academic Performance — Shiny app
# Keep this file beside student_academic_performance.csv.
# Required package: shiny

library(shiny)

student_data <- read.csv("student_academic_performance.csv",
                         stringsAsFactors = FALSE)

grade_choices <- c("All grades", sort(unique(student_data$grade_level)))
support_choices <- c("All levels", "High", "Medium", "Low")

ui <- fluidPage(
  titlePanel("Student Academic Performance Explorer"),
  p("Explore a simulated teaching dataset. These are not real student records."),
  sidebarLayout(
    sidebarPanel(
      selectInput("grade", "Grade level", choices = grade_choices,
                  selected = "All grades"),
      selectInput("support", "Parental support", choices = support_choices,
                  selected = "All levels"),
      sliderInput("score_range", "Exam score range",
                  min = 0, max = 100, value = c(0, 100), step = 1),
      helpText("Change the filters to update the summary, chart, and table.")
    ),
    mainPanel(
      h3("Filtered overview"),
      fluidRow(
        column(4, wellPanel(h4("Students"), textOutput("student_count"))),
        column(4, wellPanel(h4("Average exam score"), textOutput("mean_score"))),
        column(4, wellPanel(h4("Average attendance"), textOutput("mean_attendance")))
      ),
      h3("Average exam score by grade"),
      plotOutput("grade_plot", height = "300px"),
      h3("Filtered student records"),
      tableOutput("student_table")
    )
  )
)

server <- function(input, output, session) {
  filtered_data <- reactive({
    d <- student_data
    if (input$grade != "All grades") {
      d <- d[d$grade_level == input$grade, , drop = FALSE]
    }
    if (input$support != "All levels") {
      d <- d[d$parental_support == input$support, , drop = FALSE]
    }
    d <- d[d$exam_score >= input$score_range[1] &
             d$exam_score <= input$score_range[2], , drop = FALSE]
    d
  })

  output$student_count <- renderText({
    nrow(filtered_data())
  })

  output$mean_score <- renderText({
    d <- filtered_data()
    if (nrow(d) == 0) "No matching records"
    else paste0(round(mean(d$exam_score), 1), " / 100")
  })

  output$mean_attendance <- renderText({
    d <- filtered_data()
    if (nrow(d) == 0) "No matching records"
    else paste0(round(mean(d$attendance_rate_pct), 1), "%")
  })

  output$grade_plot <- renderPlot({
    d <- filtered_data()
    validate(need(nrow(d) > 0, "No records match these filters."))
    averages <- aggregate(exam_score ~ grade_level, data = d, FUN = mean)
    barplot(averages$exam_score,
            names.arg = averages$grade_level,
            ylim = c(0, 100),
            col = "steelblue",
            main = "Average exam score by grade",
            xlab = "Grade level", ylab = "Average exam score")
  })

  output$student_table <- renderTable({
    d <- filtered_data()
    d <- d[order(d$exam_score, decreasing = TRUE), ]
    head(d[, c("student_id", "grade_level", "study_hours_per_day",
               "attendance_rate_pct", "exam_score", "performance_band")], 20)
  }, striped = TRUE, bordered = TRUE, spacing = "s")
}

shinyApp(ui = ui, server = server)
