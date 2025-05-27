library(janitor)
TX_measles_counts_2_24_25 <- read.csv("C:/Users/met48/Desktop/Measles_2025/Case_counts/TX_measles_counts_2_24_25.csv")
colnames(TX_measles_counts_2_24_25) <- c("County", "2-24-25")

TX_measles_counts_2_25_25 <- read.csv("C:/Users/met48/Desktop/Measles_2025/Case_counts/TX_measles_counts_2_25_25.csv")
colnames(TX_measles_counts_2_25_25) <- c("County", "2-25-25")

TX_measles_counts_2_28_25 <- read.csv("C:/Users/met48/Desktop/Measles_2025/Case_counts/TX_measles_counts_2_28_25.csv")
colnames(TX_measles_counts_2_28_25) <- c("County", "2-28-25")

TX_measles_counts_3_4_25 <- read.csv("C:/Users/met48/Desktop/Measles_2025/Case_counts/TX_measles_counts_3_4_25.csv")
colnames(TX_measles_counts_3_4_25) <- c("County", "3-4-25")

TX_measles_counts_3_7_25 <- read.csv("C:/Users/met48/Desktop/Measles_2025/Case_counts/TX_measles_counts_3_7_25.csv")
colnames(TX_measles_counts_3_7_25) <- c("County", "3-7-25")

TX_measles_counts_3_11_25 <- read.csv("C:/Users/met48/Desktop/Measles_2025/Case_counts/TX_measles_counts_3_11_25.csv")
colnames(TX_measles_counts_3_11_25) <- c("County", "3-11-25")

TX_measles_counts_3_14_25 <- read.csv("C:/Users/met48/Desktop/Measles_2025/Case_counts/TX_measles_counts_3_14_25.csv")
colnames(TX_measles_counts_3_14_25) <- c("County", "3-14-25")

TX_measles_counts_3_18_25 <- read.csv("C:/Users/met48/Desktop/Measles_2025/Case_counts/TX_measles_counts_3_18_25.csv")
colnames(TX_measles_counts_3_18_25) <- c("County", "3-18-25")

TX_measles_counts_3_21_25 <- read.csv("C:/Users/met48/Desktop/Measles_2025/Case_counts/TX_measles_counts_3_21_25.csv")
colnames(TX_measles_counts_3_21_25) <- c("County", "3-21-25")

TX_measles_counts_3_25_25 <- read.csv("C:/Users/met48/Desktop/Measles_2025/Case_counts/TX_measles_counts_3_25_25.csv")
colnames(TX_measles_counts_3_25_25) <- c("County", "3-25-25")

TX_measles_counts_3_28_25 <- read.csv("C:/Users/met48/Desktop/Measles_2025/Case_counts/TX_measles_counts_3_28_25.csv")
colnames(TX_measles_counts_3_28_25) <- c("County", "3-28-25")

TX_measles_counts <- merge(TX_measles_counts_2_24_25, TX_measles_counts_2_25_25, by='County', all=T)
TX_measles_counts <- merge(TX_measles_counts, TX_measles_counts_2_28_25, by='County', all=T)
TX_measles_counts <- merge(TX_measles_counts, TX_measles_counts_3_4_25, by='County', all=T)
TX_measles_counts <- merge(TX_measles_counts, TX_measles_counts_3_7_25, by='County', all=T)
TX_measles_counts <- merge(TX_measles_counts, TX_measles_counts_3_11_25, by='County', all=T)
TX_measles_counts <- merge(TX_measles_counts, TX_measles_counts_3_14_25, by='County', all=T)
TX_measles_counts <- merge(TX_measles_counts, TX_measles_counts_3_18_25, by='County', all=T)
TX_measles_counts <- merge(TX_measles_counts, TX_measles_counts_3_21_25, by='County', all=T)
TX_measles_counts <- merge(TX_measles_counts, TX_measles_counts_3_25_25, by='County', all=T)
TX_measles_counts <- merge(TX_measles_counts, TX_measles_counts_3_28_25, by='County', all=T)

TX_measles_counts = TX_measles_counts %>%
  adorn_totals("row")

write.csv(TX_measles_counts, 'C:/Users/met48/Desktop/Measles_2025/Case_counts/TX_measles_counts.csv', row.names=F, na="")

TX_measles_counts_diff <- TX_measles_counts
TX_measles_counts_diff[is.na(TX_measles_counts_diff)] <- 0

# Identify the columns that need differences (excluding the 'County' column)
count_columns <- colnames(TX_measles_counts)[-1]  # Excluding the 'County' column
TX_measles_counts_diff['2-24-25_diff'] = TX_measles_counts_diff['2-24-25']
# Loop through each column and calculate the differences
for (i in 2:length(count_columns)) {
  diff_column_name <- paste0(count_columns[i], "_diff")
  TX_measles_counts_diff[[diff_column_name]] <- TX_measles_counts_diff[[count_columns[i]]] - TX_measles_counts_diff[[count_columns[i - 1]]]
}

TX_measles_counts_diff <- TX_measles_counts_diff[, c("County", grep("_diff$", colnames(TX_measles_counts_diff), value = TRUE))]  
colnames(TX_measles_counts_diff) <- gsub("_diff$", "", colnames(TX_measles_counts_diff))
write.csv(TX_measles_counts_diff, 'C:/Users/met48/Desktop/Measles_2025/Case_counts/TX_measles_counts_diff.csv', row.names=F, na="")
