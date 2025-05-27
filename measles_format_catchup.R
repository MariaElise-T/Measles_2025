library(readr)
library(dplyr)
library(lubridate)
library(stringr)
library(tidyr)

# Read the original CSV
df <- read_csv("C:/Users/met48/Desktop/Measles_2025/Measles 2025_Manual extraction_TX counties (1).csv")

# Clean column names for consistency
names(df) <- c("County", "Cases", "LastUpdated", "Note", "Source")

# Convert "LastUpdated" to Date format
df <- df %>%
  fill(LastUpdated) %>%  # Fill down the date to all rows
  mutate(
    LastUpdated = mdy(LastUpdated)  # Convert to Date
  )

df <- df %>% filter(!is.na(County))

# Now write one CSV per unique date
for (d in unique(df$LastUpdated)) {
  d_parsed <- as.Date(d)
  
  day_df <- df %>%
    filter(LastUpdated == d_parsed) %>%
    select(County, Cases)
  file_name <- sprintf("C:/Users/met48/Desktop/Measles_2025/Case_Counts-OB/TX_measles_counts_ob_%d_%d_%d.csv",
                       month(d_parsed), day(d_parsed), year(d_parsed))
  
  write_csv(day_df, file_name)
}