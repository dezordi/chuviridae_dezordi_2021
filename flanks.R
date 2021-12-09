library(dplyr)
library(tidyverse)

setwd('.')

ltr_table <- read.csv('./files/flank_regions/all_flanks_ltr.txt.csv',
                      sep = ',',
                      header = TRUE)
domain_table <- read.csv('./files/flank_regions/all_flanks.fasta.getorf.domains.csv',
                         sep = '\t',
                         header = TRUE)
#the sequences were renamed to cdd analysis, to avoid error by invalid ID
names_table <- read.csv('./files/flank_regions/all_flanks.fasta.getorf.rename.tsv',
                        sep = '\t',
                        header = FALSE)

domain_table$Sequence = domain_table$Query
domain_table$Sequence <- gsub(".*>","",domain_table$Sequence)
domain_table$Sequence <- names_table[match(domain_table$Sequence,names_table$V2),1]
domain_table$ORF = domain_table$Sequence
domain_table$ORF <- gsub(".*ORF:","",domain_table$ORF)
domain_table$ORF <- gsub("/REVERSE","",domain_table$ORF)
domain_table$Short.name <- gsub(" superfamily","",domain_table$Short.name)
domain_table$Sequence <- gsub("_[0-9]*/ORF.*$","",domain_table$Sequence)

#create domain vectors
tranposase <- c("DDE_Tnp_1_7","DDE_Tnp_4","DDE_Tnp_IS1595","transpos_IS21","transpos_IS481","transpos_IS630","DUF659","Transposase_21","transpos_IS3","zf-IS66","ZnF_TTF")
rt <- c("RT_like","RT_RNaseH_2","RT_RNaseH","RVT_2","zf-RVT")
rnase <- c("RNase_H_like","RT_RNaseH_2","RT_RNaseH")
integrase <- c("rve","Integrase_H2C2","rve_3")
gag <- c("Retrotrans_gag","DUF1759","DUF4219","Retrotran_gag_2","gag_pre-integrs")
protease <- c("pepsin_retropepsin_like","Peptidase_A17","Peptidase_M14_like")

domain_table <- domain_table %>%
  mutate(pos_transposase = case_when(
    Short.name %in% tranposase ~ ORF
  ),
  pos_rt = case_when(
    Short.name %in% rt ~ ORF
  ),
  pos_rnase = case_when(
    Short.name %in% rnase ~ ORF
  ),
  pos_integrase = case_when(
    Short.name %in% integrase ~ ORF
  ),
  pos_gag = case_when(
    Short.name %in% gag ~ ORF
  ),
  pos_protease = case_when(
    Short.name %in% protease ~ ORF
  )) %>%
  select(Sequence, pos_gag, pos_protease, pos_rnase, pos_rt, pos_integrase, pos_transposase)

data_merged <- reduce(list(ltr_table,domain_table), full_join, by = 'Sequence')
data_merged <- data_merged %>%
  na_if(.,"na") %>%
  select(Sequence,X5.LTR_pos,X3.LTR_pos,TSR,PPT,pos_gag,pos_protease,pos_rnase,pos_rt,pos_integrase,pos_transposase) %>%
  group_by(Sequence) %>%
  summarise(LTR5 = toString(unique(na.omit(X5.LTR_pos))),
            LTR3 = toString(unique(na.omit(X3.LTR_pos))),
            TSR = toString(unique(na.omit(TSR))),
            PPT = toString(unique(na.omit(PPT))),
            pos_gag = toString(unique(na.omit(pos_gag))),
            pos_protease = toString(unique(na.omit(pos_protease))),
            pos_rnase = toString(unique(na.omit(pos_rnase))),
            pos_rt = toString(unique(na.omit(pos_rt))),
            pos_integrase = toString(unique(na.omit(pos_integrase))),
            pos_transposase = toString(unique(na.omit(pos_transposase)))
            ) %>%
  mutate_all(na_if,"")

data_merged <- data_merged [!(is.na(data_merged$LTR5) &
                                is.na(data_merged$LTR3) &
                                is.na(data_merged$TSR) &
                                is.na(data_merged$PPT) &
                                is.na(data_merged$pos_gag) &
                                is.na(data_merged$pos_protease) &
                                is.na(data_merged$pos_rnase) &
                                is.na(data_merged$pos_rt) &
                                is.na(data_merged$pos_integrase) &
                                is.na(data_merged$pos_transposase)),]

data_merged_ignore_transposase <- data_merged %>%
  select(Sequence,LTR5,LTR3,TSR,PPT,pos_gag,pos_protease,pos_rnase,pos_rt,pos_integrase)

data_merged_complete <- na.omit(data_merged_ignore_transposase)

write_tsv(data_merged, './flanks_structures.tsv')
write_tsv(data_merged_complete, './flanks_complete_structures.tsv')
