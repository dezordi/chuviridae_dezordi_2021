library(ggplot2)
library(dplyr)

host_table <- read.table('./files/total_host.tsv', header = TRUE)
head(host_table)
host_table$count = 1
host_table_class <- host_table %>%
                      group_by(host_class) %>%
                      mutate(Tcount= sum(count))
host_table_class <- select(host_table_class, c(host_class,Tcount))
host_table_class <- host_table_class %>% 
                        group_by(host_class,Tcount) %>%
                        slice(1)
host_table_class$fraction <- host_table_class$Tcount / sum(host_table_class$Tcount)
host_table_class$ymax <- cumsum(host_table_class$fraction)
host_table_class$ymin <- c(0, head(host_table_class$ymax, n=-1))
host_table_class$labelPosition <- (host_table_class$ymax + host_table_class$ymin) / 2
host_table_class$label <- paste0(host_table_class$host_class, " : ", host_table_class$Tcount)

ggplot(host_table_class, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=3, fill=host_class,)) +
  geom_rect() +
  geom_label( x=3.5, aes(y=labelPosition, label=label), size=6) +
  coord_polar(theta="y") +
  xlim(c(2, 4)) +
  theme(legend.position = "none")

host_table_phylum <- host_table %>%
  group_by(host_phylum) %>%
  mutate(Tcount= sum(count))
host_table_phylum <- select(host_table_phylum, c(host_phylum,Tcount))
host_table_phylum <- host_table_phylum %>% 
  group_by(host_phylum,Tcount) %>%
  slice(1)

host_table_phylum$fraction <- host_table_phylum$Tcount / sum(host_table_phylum$Tcount)
host_table_phylum$ymax <- cumsum(host_table_phylum$fraction)
host_table_phylum$ymin <- c(0, head(host_table_phylum$ymax, n=-1))
host_table_phylum$labelPosition <- (host_table_phylum$ymax + host_table_phylum$ymin) / 2
host_table_phylum$label <- paste0(host_table_phylum$host_phylum, " : ", host_table_phylum$Tcount)

ggplot(host_table_phylum, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=3, fill=host_phylum,)) +
  geom_rect() +
  geom_label( x=3.5, aes(y=labelPosition, label=label), size=6) +
  coord_polar(theta="y") +
  xlim(c(2, 4)) +
  theme(legend.position = "none")
