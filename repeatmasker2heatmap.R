library('ggplot2')
library('dplyr')
library('stringr')
library('ggpubr')

setwd('.')

tblastn_summary <- read.csv('./files/blast_flank_summary.tsv', header = TRUE, sep = '\t')
repeat_results <- read.csv('./files/repeatmasker_info.csv', header = TRUE)
#create length column with length of TE
repeat_results$len <- (repeat_results$end - repeat_results$begin) + 1
#create taxonomy column to order rows
repeat_results$taxonomy <- str_c(repeat_results$order,'/',repeat_results$family,'/',repeat_results$specie)
#group DNA and LINE elements
repeat_results$class.family <- gsub("DNA.*","DNA_TEs",repeat_results$class.family)
repeat_results$class.family <- gsub("LINE.*","LINE_TEs",repeat_results$class.family)
#check
head(repeat_results)

#create order axis

sp_order <- c("Cephus cinctus","Diachasma alloeum","Trichomalopsis sarcophagae","Nasonia vitripennis",
              "Trichogramma brassicae","Osmia lignaria","Habropoda laboriosa","Eufriesea mexicana",
              "Bombus bifarius","Bombus vancouverensis nearcticus","Vespa mandarinia","Odontomachus brunneus",
              "Ooceraea biroi","Harpegnathos saltator","Lasius niger","Camponotus floridanus","Monomorium pharaonis",
              "Solenopsis invicta","Cyphomyrmex costatus","Acromyrmex echinatior","Trachymyrmex cornetzi",
              "Trachymyrmex zeteki","Trachymyrmex septentrionalis","Photinus pyralis","Leptinotarsa decemlineata",
              "Tribolium castaneum","Anopheles stephensi","Culex pipiens","Bemisia tabaci","Cinara cedri",
              "Acyrthosiphon pisum pisum","Myzus persicae","Rhopalosiphum maidis","Aphis craccivora",
              "Aphis glycine","Aphis gossypii","Hyalella azteca","Heligmosomoides polygyrus")

fm_order <- c("Cephidae","Braconidae","Pteromalidae","Trichogrammatidae","Megachilidae","Apidae","Vespidae",
              "Formicidae","Lampyridae","Chrysomelidae","Tenebrionidae","Culicidae","Aleyrodidae","Aphididae",
              "Hyalellidae","Heligmosomatidae")

od_order <- c("Hymenoptera","Coleoptera","Diptera","Hemiptera","Amphipoda","Strongylida")

te_order <- c("DNA_TEs","LINE_TEs","RC/Helitron","rRNA","Low_complexity","Simple_repeat","LTR/Copia","LTR/Gypsy","LTR/Pao")

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
hm_spe <- ggplot(repeat_results_specie, aes(x = factor(class.family, levels = te_order), 
                                            y = factor(specie, levels = sp_order), fill = freq.class)) + 
  geom_tile() + 
  theme(axis.text.x = element_blank()) +
  scale_fill_gradient(low = "#ffbf52", high = "red") +
  ggtitle("TE frequency by Species") + 
  ylab("Species") + 
  xlab("") +
  labs(fill="Frequency")
hm_spe
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
hm_fam <- ggplot(repeat_results_family, aes(x = factor(class.family, levels = te_order),
                                            y = factor(family, levels = fm_order),
                                            fill = freq.class)) + geom_tile() + 
  theme(axis.text.x = element_text(angle = 90,
                                   hjust = 1,
                                   vjust = 0.5)) +
  scale_fill_gradient(low = "#ffbf52", high = "red")  +
  ggtitle("TE frequency by Family") + 
  ylab("Family") + 
  xlab("TE Class/Family") +
  labs(fill="Frequency")

hm_fam
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
hm_order <- ggplot(repeat_results_order, aes(x = factor(class.family, levels = te_order),
                                             y = factor(order, levels = od_order), 
                                             fill = freq.class)) + 
  geom_tile() + 
  theme(axis.text.x = element_text(angle = 90,
                                   hjust = 1,
                                   vjust = 0.5)) +
  scale_fill_gradient(low = "#ffbf52", high = "red")  +
  ggtitle("TE frequency by Order") + 
  ylab("Order") + 
  xlab("TE Class/Family") +
  labs(fill="Frequency")

##blast summary plot

base_blast <- ggplot(tblastn_summary, aes(x = factor(query, levels = sp_order),
                                             y = pEVE)) +
  geom_bar(stat = "identity", color = '#C0C0C0', fill = '#C0C0C0', alpha = 0.7) +
  geom_text(size = 2, position = position_stack(vjust = 0.5), aes(label = pEVE)) +
  theme(axis.text.x = element_text(angle = 90,
                                   hjust = 1,
                                   vjust = 0.5)) +
  coord_flip()+
  ylab("pEVEs (n)") + 
  xlab("")

base_len <- ggplot(tblastn_summary, aes(x = factor(query, levels = sp_order),
                                          y = Total_len)) +
  geom_bar(stat = "identity", color = '#C0C0C0', fill = '#C0C0C0', alpha = 0.7) +
  geom_text(size = 2, position = position_stack(vjust = 0.5), aes(label = Total_len)) +
  theme(axis.text.x = element_text(angle = 90,
                                   hjust = 1,
                                   vjust = 0.5)) +
  coord_flip()+
  ylab("Length (pb)") + 
  xlab("")

tblastn_summary_pos_neg <- rbind(
  data.frame("query" = tblastn_summary$query, 
             "count" = tblastn_summary$copies_pos,
             "count_freq" = (tblastn_summary$copies_pos/tblastn_summary$copies),
             "len"=tblastn_summary$pos_len,
             "len_freq"=(tblastn_summary$pos_len/tblastn_summary$Total_len), 
             "type"="positive"),
  data.frame("query" = tblastn_summary$query, 
             "count" = tblastn_summary$genome_copies_neg,
             "count_freq" = (tblastn_summary$genome_copies_neg/tblastn_summary$copies),
             "len" = tblastn_summary$neg_len,
             "len_freq"=(tblastn_summary$neg_len/tblastn_summary$Total_len), 
             "type"="negative")
)

blast_copies <- ggplot(tblastn_summary_pos_neg, aes(x = factor(query, levels = sp_order),
                                          y = count_freq,
                                          fill=type)) +
  geom_bar(stat = "identity", alpha = 0.7) +
  geom_text(size = 2, position = position_stack(vjust = 0.5), aes(label = count)) +
  theme(axis.text.x = element_text(angle = 90,
                                   hjust = 1,
                                   vjust = 0.5),
        legend.position = "none") +
  coord_flip()+
  ylab("Hits (%)") + 
  xlab("")

blast_len <- ggplot(tblastn_summary_pos_neg, aes(x = factor(query, levels = sp_order),
                                                    y = len_freq,
                                                    fill=type)) +
  geom_bar(stat = "identity", alpha = 0.7) +
  geom_text(size = 2, position = position_stack(vjust = 0.5), aes(label = len)) +
  theme(axis.text.x = element_text(angle = 90,
                                   hjust = 1,
                                   vjust = 0.5),
        legend.position = "none") +
  coord_flip()+
  ylab("Length (%)") + 
  xlab("")

##Creating figure
ggarrange(hm_spe, hm_spe, hm_order, 
          hm_fam, ncol = 2, nrow = 2, 
          labels = c('A','B','C','D'),  
          align = 'v', heights = c(6,4))


ggarrange(base_blast, blast_copies, blast_len, base_len, ncol = 4, nrow = 1, heights = c(3,3,3,3), align = 'h')
