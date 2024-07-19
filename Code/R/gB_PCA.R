# The code below is one of the least efficient pieces of code I've ever written. While it does what it needs to do, a lot of "cleanup" is in order. Alas, i'm a mere virologist and not a computer scientist, and wrote the majority of this code while actively learning R, so some sins can be forgiven. 

#clear environment
rm(list = ls())

#take packages you need out of the library
library(ape)
library(tidyverse)
library(dplyr)
library(ggplot2)
library(ggpubr)
library(factoextra)
library(ggrepel)
library(plotly)

setwd("~/Documents/LIDo_Y4/Code/R")

filename <- "gB_genbank_aligned.fasta"

#read the file in as AABin
data <- read.FASTA(filename,type="AA") 
#create and compute a distance matrix
data_matrix <- as.matrix(data)
distance_matrix <- dist(data_matrix)

#make an empty list for wss values
wss_values <- numeric(10)

# Compute WSS values for different numbers of clusters (2 to 10)
for (i in 2:10) {
  kmeans_model <- kmeans(distance_matrix, centers = i)
  wss_values[i] <- kmeans_model$tot.withinss
}

# Plot WSS values against the number of clusters
plot(2:10, wss_values[2:10], type = "b", 
     xlab = "Number of clusters (k)", ylab = "Within-cluster sum of squares (WSS)",
     main = "Whole gB sequence")
rm(wss_values,kmeans_model,i)

# Looks like k=3 is optimal

# We know the optimal k, time to divvy the sequences up 

k <- 4  # Change this to your chosen number of clusters
kmeans_result <- kmeans(distance_matrix, centers = k)

# Extract the first two principal components
pc <- prcomp(distance_matrix)$x[, 1:2]

# Create a data frame with PC scores and cluster assignments
df <- data.frame(PC1 = pc[, 1], PC2 = pc[, 2], Cluster = as.factor(kmeans_result$cluster))
df$Name <- row.names(df)   

seq_to_AD2 <- read.csv("seq_to_AD2.csv")

df_with_ad2 <- merge(df,seq_to_AD2,by="Name")
df_with_ad2$Cluster_AD2<-as.factor(df_with_ad2$Cluster_AD2)

# Plot clusters
ggplot(df_with_ad2, aes(x = PC1, y = PC2, color = Cluster_AD2)) +
  geom_point(size = 3) +
  geom_text_repel(aes(label = Cluster_AD2), size = 4) +  # Add cluster labels
  theme_pubr() +
  ggtitle("PCA of whole gB sequence variation")

# Now we can use the allele assignment above to carry forward the Ad-2-specific labelling into other plots. 
# A more efficient way would be to build a function for most of this code...
df$Cluster_AD2 <- df$Cluster
seq_to_AD2 <- subset(df, select = -c(`PC1`,`PC2`,`Cluster`) )

#For simplicitys sake lets also save this assignment as a csv

write.csv(x=seq_to_AD2,file='seq_to_AD2.csv', row.names=TRUE)


#lets use the ad2 allele assignent to see whetehr it aligns with just gB clusters+ FCS hotspot clusters


filename <- "gB_genbank_aligned.fasta"
#read the file in as AABin
data <- read.FASTA(filename,type="AA") 
#create and compute a distance matrix
data_matrix <- as.matrix(data)
distance_matrix <- dist(data_matrix)

#make an empty list for wss values
wss_values_2 <- numeric(10)

# Compute WSS values for different numbers of clusters (2 to 10)
for (i in 2:10) {
  kmeans_model <- kmeans(distance_matrix, centers = i)
  wss_values_2[i] <- kmeans_model$tot.withinss
}

# Plot WSS values against the number of clusters
plot(2:10, wss_values_2[2:10], type = "b", 
     xlab = "Number of clusters (k)", ylab = "Within-cluster sum of squares (WSS)",
     main = "Elbow Method to Determine Optimal Number of Clusters")
rm(wss_values_2,kmeans_model,i)

# Looks like k=5 is optimal


# Ackgnowledge gpt3.5 for this 

# We know the optimal k, time to divvy the sequences up 

k <- 3  # Change this to your chosen number of clusters
kmeans_result <- kmeans(distance_matrix, centers = k)

# Extract the first two principal components
pc <- prcomp(distance_matrix)$x[, 1:2]

# Create a data frame with PC scores and cluster assignments
df <- data.frame(PC1 = pc[, 1], PC2 = pc[, 2], Cluster = as.factor(kmeans_result$cluster))

df$Name <- row.names(df)   

df<-merge(df,seq_to_AD2,by=`row.names`,all=TRUE)

# Plot clusters
ggplot(df, aes(x = PC1, y = PC2, color = Cluster_AD2)) +
  geom_point(size = 3) +
  geom_text_repel(aes(label = Cluster), size = 4) +  # Add cluster labels
  theme_pubr() +
  ggtitle("PCA of AD-2 sequence variation")


filename <- "gB_genbank_aligned.fasta"

