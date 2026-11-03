# Student Academic Performance Explorer

## Files
- `student_academic_performance.csv` — 150 simulated student-level records.
- `analysis.R` — import, cleaning, summaries, comparisons, correlation, and plots.
- `app.R` — interactive Shiny application.
- `video_presentation_script.txt` — demonstration script.

## Run in Posit Cloud
1. Create a new RStudio project in Posit Cloud.
2. Upload all four files to the project folder using the Files pane.
3. Open `analysis.R` and run it from top to bottom. The CSV and script must be
   in the same project folder.
4. Install Shiny if needed in the Console: `install.packages("shiny")`.
5. Open `app.R` and click **Run App**.
6. Test all three controls: grade, parental support, and exam-score range.
7. Publish using the hosting service approved by your teacher. For shinyapps.io,
   create/sign in to an account and follow its current Posit publishing setup
   instructions. Save the resulting app URL.

## Dataset note
All records are synthetic and were generated for demonstration. The dataset
does not represent real students, a real school, or an external data source.
The simulated relationships are not causal evidence.
