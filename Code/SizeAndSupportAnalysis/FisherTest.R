library(tidyverse)
args <- commandArgs(T)

a <- read_table(args[1], col_names = c('CDS', 'Support', 'Counts')) %>%
  pivot_wider(id_cols = CDS, names_from = Support, values_from = Counts)

vals <- t(matrix(c(pull(a[1,2]), pull(a[2,2]), pull(a[1,3]), pull(a[2,3])),
              nrow = 2,
              dimnames = list(CDS = c("InCDS", "OutCDS"),
                              Support = c("Support = 1", "Support > 1"))))
vals

fisher.test(vals, alternative = "greater")
