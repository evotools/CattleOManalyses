library(tidyverse)
library(ggpubr)
args <- commandArgs(T)

a <- read_table(args[1], 
                col_names = c('Chromosome', 'Position', 'Variant ID', 'Support', 'Size'),
                col_types = list(Chromosome = "c", 
                                 Position = "n", 
                                 `Variant ID` = "c", 
                                 Support = 'n', 
                                 Size = 'n') ) %>%
  mutate(AbsSize=abs(Size))

b <- a
b$Support = as.character(b$Support)
b[b$Support != '1', 'Support'] = '>1'
b$Support = factor(b$Support, levels = c('1', '>1'))

p <- ggdensity(b, x="AbsSize", add = "mean", rug = TRUE, fill = "Support", color = "Support", palette = c("#00AFBB", "#E7B800")) + 
          scale_x_log10()+ 
          xlab('Structural Variant absolute log10(size)') 
ggsave(filename = paste0(args[2], '/SupplementaryFigure1.pdf'), plot = p, device = 'pdf', width = 16, height = 9, dpi = 300)

supp1 <- pull(a[a$Support==1,'AbsSize'])
supp2 <- pull(a[a$Support>1,'AbsSize'])


ttest <- t.test(supp1, supp2, alternative = 'greater')
wtest <- wilcox.test(supp1, supp2, alternative = 'greater')
ttest
wtest
