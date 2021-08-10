library('ggplot2')
library('dplyr')
library('stringr')
library('ggpubr')

setwd('.')

repeat_results <- read.csv('./files/repeatmasker_info.csv', header = TRUE)
#create length column with length of TE
repeat_results$len <- (repeat_results$end - repeat_results$begin) + 1
#create taxonomy column to order rows
repeat_results$taxonomy <- str_c(repeat_results$order,'/',repeat_results$family,'/',repeat_results$specie)
#check
head(repeat_results)

##SPECIE PLOT
#create frequency of each row by specie-element-class/family
repeat_results_specie <- repeat_results %>%
  group_by(specie) %>%
  #group_by(sequence, .add=TRUE) %>% #considering all elements remain a lot of information for heatmap
  mutate(Tlen= sum(len)) %>%
  mutate(freq=paste0(round(len/Tlen,4))) %>%
  mutate(freq=as.numeric(freq))  %>%
  group_by(class.family, .add=TRUE) %>%
  mutate(freq.class= sum(freq)) %>%
  distinct(specie,class.family, .keep_all = TRUE)
#check
head(repeat_results_specie)
#order of DF based on taxonomy
#repeat_results$specie <- factor(repeat_results$taxonomy, levels=unique(repeat_results$taxonomy), order=TRUE)
##made plot
hm_spe <- ggplot(repeat_results_specie, aes(class.family, specie, fill = freq.class)) + geom_tile() + theme(axis.text.x = element_text(
  angle = 90,
  hjust = 1,
  vjust = 0.5)) +
  scale_fill_gradient(low = "#ffbf52", high = "red") +
  ggtitle("TE frequency by Species") + 
  ylab("Species") + 
  xlab("TE Class/Family") +
  labs(fill="Frequency")

##FAMILY PLOT
#create frequency of each row by specie-element-class/family
repeat_results_family <- repeat_results %>%
  group_by(family) %>%
  #group_by(sequence, .add=TRUE) %>% #considering all elements remain a lot of information for heatmap
  mutate(Tlen= sum(len)) %>%
  mutate(freq=paste0(round(len/Tlen,4))) %>%
  mutate(freq=as.numeric(freq))  %>%
  group_by(class.family, .add=TRUE) %>%
  mutate(freq.class= sum(freq)) %>%
  distinct(family,class.family, .keep_all = TRUE)
#check
head(repeat_results_family)
#order of DF based on taxonomy
#repeat_results$specie <- factor(repeat_results$taxonomy, levels=unique(repeat_results$taxonomy), order=TRUE)
##made plot
hm_fam <- ggplot(repeat_results_family, aes(class.family, family, fill = freq.class)) + geom_tile() + theme(axis.text.x = element_text(
  angle = 90,
  hjust = 1,
  vjust = 0.5)) +
  scale_fill_gradient(low = "#ffbf52", high = "red")  +
  ggtitle("TE frequency by Family") + 
  ylab("Family") + 
  xlab("TE Class/Family") +
  labs(fill="Frequency")

##ORDER PLOT
#create frequency of each row by specie-element-class/family
repeat_results_order <- repeat_results %>%
  group_by(order) %>%
  #group_by(sequence, .add=TRUE) %>% #considering all elements remain a lot of information for heatmap
  mutate(Tlen= sum(len)) %>%
  mutate(freq=paste0(round(len/Tlen,4))) %>%
  mutate(freq=as.numeric(freq))  %>%
  group_by(class.family, .add=TRUE) %>%
  mutate(freq.class= sum(freq)) %>%
  distinct(order,class.family, .keep_all = TRUE)
#check
head(repeat_results_order)
#order of DF based on taxonomy
#repeat_results$specie <- factor(repeat_results$taxonomy, levels=unique(repeat_results$taxonomy), order=TRUE)
##made plot
hm_order <- ggplot(repeat_results_order, aes(class.family, order, fill = freq.class)) + geom_tile() + theme(axis.text.x = element_text(
  angle = 90,
  hjust = 1,
  vjust = 0.5)) +
  scale_fill_gradient(low = "#ffbf52", high = "red")  +
  ggtitle("TE frequency by Order") + 
  ylab("Order") + 
  xlab("TE Class/Family") +
  labs(fill="Frequency")

##Creating figure
ggarrange(hm_spe,
          ggarrange(hm_order, hm_fam, ncol = 2, labels = c("B","C"), vjust = 3),
          nrow = 2,
          labels = "A")
