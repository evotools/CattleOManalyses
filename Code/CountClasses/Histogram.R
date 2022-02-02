library(tidyverse)
library(ggfortify)
library(ggpubr)
library(ggsci)
library(hrbrthemes)

inputF <- read_tsv('SVs_type_len.tsv', col_names = c('CHROM', 'POS', 'ID', 'SV Type', 'SV Length')) %>%
  mutate(`SV Length` = abs(`SV Length`)) %>%
  filter( `SV Type` != "INV" ) %>%
  group_by(`SV Type`)

breaks <- seq(5000, 50000, 5000)
# specify interval/bin labels
tags <- c("5000-9999", "10000-14999)", "15000-19999", "20000-24999", 
          "25000-29999","30000-34999", "35000-39999","40000-44999", "45000-49999")

group_tags <- cut(inputF$`SV Length`, 
                  breaks=breaks, 
                  include.lowest=TRUE, 
                  right=F, 
                  labels=tags)
inputF2 <- inputF
inputF2$`Size group` = as.character(group_tags)
inputF2[is.na(inputF2$`Size group`), "Size group"] = ">=50000"
inputF2$`Size group` <- factor(x = inputF2$`Size group`, levels = c(tags, ">=50000"))

p <- inputF2 %>%
  group_by(`SV Type`, `Size group`) %>%
  summarise(`Number of SVs` = n()) %>%
  ggplot(aes(x = `Size group`, y = `Number of SVs`, fill = `SV Type`)) +
    geom_bar(position = "dodge", stat = 'identity') +
    scale_y_continuous(breaks = seq(0, 6000, 250)) +
    theme_ipsum(base_size=15, axis_title_size = 15) +
    theme(axis.text.x = element_text(angle = 45, vjust = 0.9, hjust=1))

ggsave(device = 'tiff', filename = 'histogramSizes.tiff', plot = p, dpi = 300, height = 9, width = 16)

