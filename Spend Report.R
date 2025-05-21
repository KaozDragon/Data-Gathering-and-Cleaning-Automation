library(tidyverse)
library(readxl)
library(xlsx)
library(lubridate)

setwd("C:/Users/ivan.yuen/Documents/R/")

#Spend report automation: filter data based on customer account number
#The client file should already have tab named PORTFOLIO REPORT which
#includes the iRIS customer ID

##For rare use of loading 2021 data, commented out code block
# spend2021_part1 <- data.frame(
#   read_excel('C:/Users/ivan.yuen/Documents/R/Input files/2021 Spend.xlsx',
#              1))
# spend2021_part2 <- data.frame(
#   read_excel('C:/Users/ivan.yuen/Documents/R/Input files/2021 spend.xlsx',
#              2))


#Read in files, unless spend reports already have been loaded.
if (!exists("spend2024_part3", mode = "any", where = globalenv()))
  {
      #  spend2022_part1 <- data.frame(
      #    read_excel('C:/Users/ivan.yuen/Documents/R/Input files/2022 Spend.xlsx',
      #             1))
      # 
      # spend2022_part2 <- data.frame(
      #   read_excel('C:/Users/ivan.yuen/Documents/R/Input files/2022 Spend.xlsx',
      #             2))
      # 
      # spend2023_part1 <- data.frame(
      #   read_excel('C:/Users/ivan.yuen/Documents/R/Input files/2023 Spend.xlsx',
      #             1))
      # spend2023_part2 <- data.frame(
      #   read_excel('C:/Users/ivan.yuen/Documents/R/Input files/2023 Spend.xlsx',
      #              2))
      # 
      spend2024_part1 <- data.frame(
        read_excel('C:/Users/ivan.yuen/Documents/R/Input files/2024 Spend.xlsx',
                   1))
      spend2024_part2 <- data.frame(
        read_excel('C:/Users/ivan.yuen/Documents/R/Input files/2024 Spend.xlsx',
                   2))
      spend2024_part3 <- data.frame(
        read_excel('C:/Users/ivan.yuen/Documents/R/Input files/2024 Spend.xlsx',
                   3))
      spend2025_part1 <- data.frame(
        read_excel('C:/Users/ivan.yuen/Documents/R/Input files/2025 Spend.xlsx',
                   1))
  }
client_file <- choose.files(
  default = "C:/Users/ivan.yuen/Documents/R/Input files",
  caption = "Choose client file"
)

#The client file should have the tab portfolio data already 
report <- data.frame(
  read_excel(client_file, sheet = "PORTFOLIO DATA"))


#Get customer ID from client
iris_number <- distinct(select(report, "CUST.ID"))


# Get the current date in the EST time zone
current_date_est <- with_tz(Sys.Date(), tzone = "EST")

# Calculate the end_date (last day of last month)
end_date <- ceiling_date(current_date_est - months(1), unit = "month") - days(1)

# Calculate the start_date (beginning of the month 12 months ago)
start_date <- ceiling_date(current_date_est - months(13), unit = "month")


# Convert the start and end dates to the YY.MM format
start_date_YYMM <- as.numeric(format(start_date, "%Y%m"))
end_date_YYMM <- as.numeric(format(end_date, "%Y%m"))

# # # #Temp dates
start_date_YYMM <- 202404
end_date_YYMM <- 202503

##For the rare use of previous data, use commented out code block
# iris2021_part2 <- spend2021_part2 %>%
#   filter(spend2021_part2$CUST.ID. %in% iris_number$CUST.ID &
#            YY.MM >= start_date_YYMM & YY.MM <= end_date_YYMM)
# 
# iris2021_part1 <- spend2021_part1 %>%
#   filter(spend2021_part1$CUST.ID. %in% iris_number$CUST.ID &
#            YY.MM >= start_date_YYMM & YY.MM <= end_date_YYMM)
# 
# iris2022_part2 <- spend2022_part2 %>%
#   filter(spend2022_part2$CUST.ID. %in% iris_number$CUST.ID &
#            YY.MM >= start_date_YYMM & YY.MM <= end_date_YYMM)
# 
# iris2022_part1 <- spend2022_part1 %>%
#   filter(spend2022_part1$CUST.ID. %in% iris_number$CUST.ID &
#            YY.MM >= start_date_YYMM & YY.MM <= end_date_YYMM)
# 
# iris2023_part1 <- spend2023_part1 %>%
#   filter(spend2023_part1$CUST.ID. %in% iris_number$CUST.ID &
#            YY.MM >= start_date_YYMM & YY.MM <= end_date_YYMM)
# 
# iris2023_part2 <- spend2023_part2 %>%
#   filter(spend2023_part2$CUST.ID. %in% iris_number$CUST.ID &
#            YY.MM >= start_date_YYMM & YY.MM <= end_date_YYMM)
# 
iris2024_part1 <- spend2024_part1 %>%
  filter(spend2024_part1$CUST.ID. %in% iris_number$CUST.ID &
           YY.MM >= start_date_YYMM & YY.MM <= end_date_YYMM)

iris2024_part2 <- spend2024_part2 %>%
  filter(spend2024_part2$CUST.ID. %in% iris_number$CUST.ID &
           YY.MM >= start_date_YYMM & YY.MM <= end_date_YYMM)

iris2024_part3 <- spend2024_part3 %>%
  filter(spend2024_part3$CUST.ID. %in% iris_number$CUST.ID &
           YY.MM >= start_date_YYMM & YY.MM <= end_date_YYMM)

iris2025_part1 <- spend2025_part1 %>%
  filter(spend2025_part1$CUST.ID. %in% iris_number$CUST.ID &
           YY.MM >= start_date_YYMM & YY.MM <= end_date_YYMM)

#iris2022_part1, iris2022_part2, iris2023_part1, iris2023_part2, iris2025_part1
combined_spend <- rbind(iris2024_part1,iris2024_part2,iris2024_part3,iris2025_part1)


write.csv(combined_spend, file = "Filtered Spend.csv", row.names = FALSE)
