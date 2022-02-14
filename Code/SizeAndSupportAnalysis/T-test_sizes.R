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

p1 <- ggboxplot(a, "Support", "AbsSize",
          color = "black", fill = "gray") +
          scale_y_log10()+ 
          ylab('Structural Variant absolute log10(size)') +
          xlab('Number of individuals supporting a structural variant')
ggsave(filename = paste0(args[2], 'Boxplot_size_by_support.pdf'), plot = p1, device = 'pdf', width = 16, height = 9, dpi = 300)

b <- a
b[b$Support>1, 'Support'] <- 2
p2 <- ggboxplot(b, "Support", "AbsSize",
          color = "black", fill = "gray") +
          scale_y_log10()+ 
          ylab('Structural Variant absolute log10(size)') +
          xlab('Number of individuals supporting a structural variant')
ggsave(filename = paste0(args[2], '/Boxplot_size_by_support_twoGroups.pdf'), plot = p2, device = 'pdf', width = 16, height = 9, dpi = 300)

supp1 <- pull(a[a$Support==1,'AbsSize'])
supp2 <- pull(a[a$Support>1,'AbsSize'])


ttest <- t.test(supp1, supp2, alternative = 'greater')
wtest <- wilcox.test(supp1, supp2, alternative = 'greater')
ttest
wtest
