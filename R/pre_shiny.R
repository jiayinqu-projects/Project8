# R Studio API
library(rstudioapi)
setwd(dirname(getActiveDocumentContext()$path))

# Libraries
library(tidyverse)
library(psych)

# Data Import
for_shiny_tbl <- read_csv("../data/week3.csv") %>%
  mutate(gender = factor(gender, levels= c("M", "F"), labels = c("Male", "Female")), 
         timeEnd = ymd_hms(timeEnd),
         xMean = rowMeans(.[,paste0("q", 1:5)]), 
         yMean = rowMeans(.[,paste0("q", 6:10)]))

saveRDS(for_shiny_tbl, "../shiny/for_shiny.rds")

# Generate prototype
ggplot(for_shiny_tbl, aes(rowMeans(week8_tbl[,paste0("q", 1:5)]), rowMeans(week8_tbl[,paste0("q", 6:10)]))) + 
  geom_point() + 
  labs(x = "mean score of Q1 - Q5", y = "mean score of Q6 - Q10")