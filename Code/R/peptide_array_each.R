library(ggplot2)
library(ggpubr)


data <- read.csv("./Peptide_ind_norm.csv", header=TRUE,sep=",")

neutr<-data[,2:17]
nonneutr<-data[,18:32]

neutr<-t(neutr)
nonneutr<-t(nonneutr)
peptide <- rownames(data)
pval <- vector(length = 225) 
res <- data.frame(peptide,pval)

for (i in 1:224){
  ks<-ks.test(neutr[,i],nonneutr[,i])  
  res$pval[i]<-ks$p.value
}


res<-res[1:224,]

res$corr_p<- p.adjust(res$pval, method="fdr", n=length(res$pval))

res$p_plot= -log10(res$corr_p)

plot(res$p_plot)

ggplot(data=res, aes(x=as.numeric(peptide), y=p_plot))+
  geom_point()+
  geom_hline(
    yintercept = -log10(0.05), color = "grey40",
    linetype = "dashed")+
  geom_hline(
    yintercept = -log10(0.01), color = "red",
    linetype = "dashed")+
  xlab("Peptide")+ylab("-log10(p value)")+
  scale_x_continuous(breaks = seq(0, 224, by = 10))+
  theme_pubr()



  
  