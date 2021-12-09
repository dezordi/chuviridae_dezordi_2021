library(ggplot2)
library(dplyr)
library(webr)

setwd('.')

#chuviridar host plot

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

#pEVEs host plots

blast_tax <- read.csv('./files/glyco_chu_eves/blastp.tax.csv', header = TRUE)
blast_tax$Taxonomy <- gsub(" ","/",paste(blast_tax$Phylum,blast_tax$Class,blast_tax$Order))

PD_blast <- blast_tax %>%
  group_by(Taxonomy, Family) %>% 
  summarise(freq=n())

PieDonut(PD_blast, aes(Taxonomy, Family, count=freq), 
         title = "Host Taxonomy", 
         ratioByGroup = FALSE, 
         showRatioThreshold=FALSE,
         r0 = 0.5, r1 = 0.9)

PD2_blast <- blast_tax %>%
  group_by(Phylum, Class) %>% 
  summarise(freq=n())

PieDonut(PD2_blast, aes(Phylum, Class, count=freq), 
         title = "Host Taxonomy", 
         ratioByGroup = FALSE, 
         showRatioThreshold=FALSE)

pEVE_tax <- read.csv('./files/glyco_chu_eves/glyco_phylogeny.tax.csv', header = TRUE)
pEVE_tax$Taxonomy <- gsub(" ","/",paste(pEVE_tax$Phylum,pEVE_tax$Class,pEVE_tax$Order))

PD_blast <- pEVE_tax %>%
  group_by(Taxonomy, Family) %>% 
  summarise(freq=n())

PieDonut(PD_blast, aes(Taxonomy, Family, count=freq), 
         title = "Host Taxonomy", 
         ratioByGroup = FALSE, 
         showRatioThreshold=FALSE,
         r0 = 0.5, r1 = 0.9)

PD2_blast <- pEVE_tax %>%
  group_by(Phylum, Class) %>% 
  summarise(freq=n())

PieDonut(PD2_blast, aes(Phylum, Class, count=freq), 
         title = "Host Taxonomy", 
         ratioByGroup = FALSE, 
         showRatioThreshold=FALSE)
