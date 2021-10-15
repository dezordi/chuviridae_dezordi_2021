library(ggplot2)
library(dplyr)
library(webr)
setwd('.')
host_table <- read.table('./files/total_host.tsv', header = TRUE)
host_table$Taxonomy <- gsub(" ","/",paste(host_table$host_phylum,host_table$host_class,host_table$host_order))
head(host_table)
PD <- host_table %>%
  group_by(Taxonomy, host_family) %>% 
  summarise(freq=n())

PieDonut(PD, aes(Taxonomy, host_family, count=freq), 
         title = "Host Taxonomy", 
         ratioByGroup = FALSE, 
         showRatioThreshold=FALSE,
         r0 = 0.5, r1 = 0.9)

PD2 <- host_table %>%
  group_by(host_phylum, host_class) %>% 
  summarise(freq=n())

PieDonut(PD2, aes(host_phylum, host_class, count=freq), 
         title = "Host Taxonomy", 
         ratioByGroup = FALSE, 
         showRatioThreshold=FALSE)
