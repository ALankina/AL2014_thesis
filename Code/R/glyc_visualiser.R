library(ggplot2)
library(ggpubr)


data <- read.delim("./MATV_glyc_results.txt", header=TRUE,sep="\t")

neutr<-data[,2:17]
nonneutr<-data[,18:32]
