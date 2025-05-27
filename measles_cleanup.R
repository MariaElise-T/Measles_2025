library(dplyr)
library(tidyr)
library(stringr)
library(readr)
library(purrr)

# Set your directories
ob_dir <- "C:/Users/met48/Desktop/Measles_2025/Case_Counts-OB"
nonob_dir <- "C:/Users/met48/Desktop/Measles_2025/Case_Counts-nonOB"

# List files
ob_files <- list.files(ob_dir, pattern = "TX_measles_counts_ob_.*\\.csv", full.names = TRUE)
nonob_files <- list.files(nonob_dir, pattern = "TX_measles_counts_nonOB_.*\\.csv", full.names = TRUE)

# Extract dates from filenames
get_date_from_filename <- function(path, prefix) {
  basename(path) %>%
    str_remove(paste0("TX_measles_counts_", prefix, "_")) %>%
    str_remove("\\.csv$") %>%
    as.Date(format = "%m_%d_%Y")
}

ob_dates <- tibble(ob_file = ob_files, date = get_date_from_filename(ob_files, "ob"))
nonob_dates <- tibble(nonob_file = nonob_files, date = get_date_from_filename(nonob_files, "nonOB"))

# Join only matching dates
matched_files <- inner_join(ob_dates, nonob_dates, by = "date")

# Function to process a matched pair of files
process_file_pair <- function(ob_file, nonob_file, date) {
  df_ob <- read_csv(ob_file, col_types = cols(.default = col_double(), County = col_character())) %>%
    rowwise() %>%
    mutate(Value = sum(c_across(where(is.numeric)), na.rm = TRUE)) %>%
    select(County, Value) %>%
    mutate(Type = "ob", Date = date)
  
  df_nonob <- read_csv(nonob_file, col_types = cols(.default = col_double(), County = col_character())) %>%
    rowwise() %>%
    mutate(Value = sum(c_across(where(is.numeric)), na.rm = TRUE)) %>%
    select(County, Value) %>%
    mutate(Type = "non-ob", Date = date)
  
  df_sum <- full_join(df_ob, df_nonob, by = c("County", "Date"), suffix = c("_ob", "_nonob")) %>%
    mutate(Value = coalesce(Value_ob, 0) + coalesce(Value_nonob, 0), Type = "sum") %>%
    select(County, Value, Type, Date)
  
  bind_rows(df_ob, df_nonob, df_sum)
}

# Use pmap with named columns
all_data <- pmap_dfr(
  list(
    ob_file = matched_files$ob_file,
    nonob_file = matched_files$nonob_file,
    date = matched_files$date
  ),
  process_file_pair
)

# Pivot into wide format (Tableau-friendly)
final_data <- all_data %>%
  mutate(Date = format(Date, "%Y-%m-%d")) %>%
  pivot_wider(names_from = Date, values_from = Value) %>%
  arrange(County, Type)

final_data <- final_data %>% 
  mutate(across(everything(), ~ replace(., . == "NULL", 0)))


final_data_df <- as.data.frame(final_data)
final_data_df[is.na(final_data_df)] <- 0

# Write to CSV
write.csv(final_data_df, "C:/Users/met48/Desktop/Measles_2025/combined_measles_data_filtered.csv")
