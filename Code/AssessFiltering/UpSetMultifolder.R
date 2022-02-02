library(tidyverse)
library(UpSetR)
library(ComplexHeatmap)
library(cowplot)
library(gridExtra)
library(ggpubr)
library(RColorBrewer)

args = commandArgs(T)

multifilters = list.files(path = "./", pattern = ".suppvec", recursive = T)

convert = c("Hereford_1" = "Hereford 1",
            "Hereford_2" = "Hereford 2",
            "HolsteinFriesian_104095" = "Holstein 1",
            "HolsteinFriesian_2" = "Holstein 2",
            "NDama_1_1628" = "N'Dama 1",
            "NDama_NN031" = "N'Dama 2",
            "Ankole_UG833" = "Ankole 1",
            "Ankole_UG869" = "Ankole 2",
            "Angoni_1" = "Angoni 1",
            "Angoni_2" = "Angoni 2",
            "WhiteFulani_NN199" = "White Fulani 1",
            "WhiteFulani_NN233" = "White Fulani 2",
            "Barotse_2" = "Barotse 1",
            "Barotse_3" = "Barotse 2",
            "Boran_1_3218" = "Boran 1",
            "Boran_2_2124" = "Boran 2",
            "Nelore_N4689" = "Nelore 1",
            "Nelore_N2" = "Nelore 2"
)

subgroup = c("Hereford 1" = "European",
             "Hereford 2" = "European",
             "Holstein 1" = "European",
             "Holstein 2" = "European",
             "N'Dama 1" = "African",
             "N'Dama 2" = "African",
             "Ankole 1" = "African",
             "Ankole 2" = "African",
             "Angoni 1" = "African",
             "Angoni 2" = "African",
             "White Fulani 1" = "African",
             "White Fulani 2" = "African",
             "Barotse 1" = "African",
             "Barotse 2" = "African",
             "Boran 1" = "African",
             "Boran 2" = "African",
             "Nelore 1" = "Indian",
             "Nelore 2" = "Indian"
)
subgroup2 = c("Hereford 1" = "Taurine",
              "Hereford 2" = "Taurine",
              "Holstein 1" = "Taurine",
              "Holstein 2" = "Taurine",
              "N'Dama 1" = "Taurine",
              "N'Dama 2" = "Taurine",
              "Barotse 1" = "Taurine",
              "Barotse 2" = "Taurine",
              "Ankole 1" = "Sanga",
              "Ankole 2" = "Sanga",
              "Angoni 1" = "Indicine",
              "Angoni 2" = "Indicine",
              "White Fulani 1" = "Indicine",
              "White Fulani 2" = "Indicine",
              "Boran 1" = "Indicine",
              "Boran 2" = "Indicine",
              "Nelore 1" = "Indicine",
              "Nelore 2" = "Indicine"
)

topN = 40
data = data.frame(files = multifilters) %>% 
  separate(files, c("QUAL", "DIST", "fileName"), sep = "/") %>%
  select(QUAL, DIST)
data$fname = multifilters
data$QUAL = as.numeric(gsub(x = data$QUAL, pattern = "QUAL",replacement = ""))
data$DIST = as.numeric(gsub(x = data$DIST, pattern = "MAXDIST",replacement = ""))
data = data[order(data$QUAL, data$DIST), ]
nrows = length(unique(data$QUAL))
ncols = length(unique(data$DIST))
regCols = structure(brewer.pal(length(unique(subgroup)), "Set2")[0:length(unique(subgroup))],
                    names = unique(subgroup))
specCols = structure(brewer.pal(length(unique(subgroup2)), "Set1")[0:length(unique(subgroup2))],
                     names = unique(subgroup2))

myplot <- list()
for (i in c(1:length(multifilters))){
  nplot = i
  flt = data[i, 3]
  smp = gsub(pattern = ".suppvec", replacement = ".samples", x = flt)
  plotName = paste("Minimum QUAL =", data[i, 1], ", break points distance =", data[i, 2], sep = " ")
  cat("Doing ",plotName, "\n")
  sample_names = as.character(read.table(smp)[,1])
  snames = c()
  for (s in sample_names){
    snames = c(snames, as.vector(convert[s]))
  }
  sample_names = snames
  
  sv = read.table(flt, colClasses = c("character", "numeric","character", "character")) %>% 
    distinct(V3, .keep_all = T) %>% 
    separate(V5, sample_names, sep = c(1:(length(sample_names))) )
  
  convergence = sv[,c(5:ncol(sv))]
  rownames(convergence) = sv$V3
  sv[,"V4"] = as.numeric(sv$V4)
  
  if (length(sample_names) != ncol(convergence)){
    print("Sample names vector and support vector lengths do not match.")
    break()
  }
  
  for (k in c(1:ncol(convergence))){convergence[,k] = as.numeric(convergence[,k])}
  m = make_comb_mat(as.matrix(convergence))
  csizes = min(sort(comb_size(m), decreasing = T)[1:topN])
  m = m[comb_size(m) >= csizes]
  comb_sets = lapply(comb_name(m), function(nm) extract_comb(m, nm))
  comb_sets = lapply(comb_sets, function(gr) {
    # we just randomly generate dist_to_tss and mean_meth
    gr$svsizes = abs( sv[sv$V3 %in% unlist(gr), "V4"] )
    gr
  })
  name_sets = list()
  for (j in set_name(m)){
    tmp = sv[, c("V3","V4",j)] 
    name_sets[[j]][['svsizes']] = abs(tmp[tmp[,3] == 1, 2]) 
  }
  
  p = UpSet(m, comb_order = order(comb_size(m)),
            left_annotation = rowAnnotation( continent = subgroup[set_name(m)], 
                                            subsp = subgroup2[set_name(m)], 
                                            show_annotation_name = F, 
                                            col=list(continent=regCols, subsp=specCols)
                                            ),
            bottom_annotation = HeatmapAnnotation(
              SVsize = anno_boxplot(lapply(comb_sets, function(gr) gr$svsizes), outline = FALSE),
              annotation_name_side = "left"),
            column_title = plotName,
            row_names_gp = gpar(fontsize = 18),
            #right_annotation = rowAnnotation(SVcount = upset_right_annotation(m), SVlength = anno_boxplot(lapply(name_sets, function(gr) gr$svsizes), outline = FALSE))
  )
  vp <- grid.grabExpr(draw(p))
  myplot[[nplot]] <- vp
  rm(vp)
} 

p4 = ggarrange(plotlist=myplot) %>% ggexport(filename = "multiUpsets.pdf",  res=300, width = (12 * ncols), height = (8 * nrows))

# 
# # Make targeted upset plot
# flt = data[data$QUAL==20 & data$DIST==1000, 3]
# smp = gsub(pattern = ".suppvec", replacement = ".samples", x = flt)
# plotName = "Minimum QUAL = 20, break points distance = 1000"
# cat("Doing ",plotName, "\n")
# sample_names = as.character(read.table(smp)[,1])
# snames = c()
# for (s in sample_names){
#   snames = c(snames, as.vector(convert[s]))
# }
# sample_names = snames
# 
# sv = read.table(flt, colClasses = c("character", "numeric","character", "character")) %>% 
#   distinct(V3, .keep_all = T) %>% 
#   separate(V5, sample_names, sep = c(1:(length(sample_names) - 1)) )
# 
# convergence = sv[,c(5:ncol(sv))]
# rownames(convergence) = sv$V3
# sv[,"V4"] = as.numeric(sv$V4)
# 
# if (length(sample_names) != ncol(convergence)){
#   print("Sample names vector and support vector lengths do not match.")
#   break()
# }
# 
# for (k in c(1:ncol(convergence))){convergence[,k] = as.numeric(convergence[,k])}
# m = make_comb_mat(as.matrix(convergence))
# csizes = min(sort(comb_size(m), decreasing = T)[1:topN])
# m = m[comb_size(m) >= csizes]
# comb_sets = lapply(comb_name(m), function(nm) extract_comb(m, nm))
# comb_sets = lapply(comb_sets, function(gr) {
#   # we just randomly generate dist_to_tss and mean_meth
#   gr$svsizes = abs( sv[sv$V3 %in% unlist(gr), "V4"] )
#   gr
# })
# name_sets = list()
# for (j in set_name(m)){
#   tmp = sv[, c("V3","V4",j)] 
#   name_sets[[j]][['svsizes']] = abs(tmp[tmp[,3] == 1, 2]) 
# }
# 
# pdf("UpsetPlot_QUAL20_DIST1000.pdf", height = 9, width = 15)
# p = UpSet(m, comb_order = order(comb_size(m)),
#           left_annotation = rowAnnotation( continent = subgroup[set_name(m)], 
#                                            subsp = subgroup2[set_name(m)], 
#                                            show_annotation_name = F, 
#                                            col=list(continent=regCols, subsp=specCols)
#           ),
#           bottom_annotation = HeatmapAnnotation(
#             SVsize = anno_boxplot(lapply(comb_sets, function(gr) gr$svsizes), outline = FALSE),
#             annotation_name_side = "left"),
#           column_title = plotName,
#           row_names_gp = gpar(fontsize = 18),
#           #right_annotation = rowAnnotation(SVcount = upset_right_annotation(m), SVlength = anno_boxplot(lapply(name_sets, function(gr) gr$svsizes), outline = FALSE))
# )
# p
# dev.off()
