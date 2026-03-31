#PCA
rm(list=ls()) 
library(tidyverse)
library(ggfocus)
library(RColorBrewer)
library(ggforce)
# read in data
pca <- read_table("gr_tcas.eigenvec", col_names = FALSE)
eigenval <- scan("gr_tcas.eigenval")

# sort out the pca data
# remove nuisance column
pca <- pca[,-1]
# set names
names(pca)[1] <- "ind"
names(pca)[2:ncol(pca)] <- paste0("PC", 1:(ncol(pca)-1))

# sort out the individual population origins and rescue
#Origin
Origin<- rep(NA, length(pca$ind))
Origin[grep("KSS", pca$ind)] <- "Outbred Stock"
Origin[grep("01ISO", pca$ind)] <- "Iso01"
Origin[grep("03ISO", pca$ind)] <- "Iso03"
Origin[grep("05ISO", pca$ind)] <- "Iso05"
Origin[grep("08ISO", pca$ind)] <- "Iso08"
Origin[grep("12ISO", pca$ind)] <- "Iso12"
Origin[grep("13ISO", pca$ind)] <- "Iso13"
Origin[grep("14ISO", pca$ind)] <- "Iso14"
Origin[grep("15ISO", pca$ind)] <- "Iso15"
Origin[grep("16ISO", pca$ind)] <- "Iso16"
Origin[grep("20ISO", pca$ind)] <- "Iso20"
Origin[grep("21ISO", pca$ind)] <- "Iso21"
Origin[grep("23ISO", pca$ind)] <- "Iso23"
Origin[grep("16C", pca$ind)] <- "Iso01"
Origin[grep("18C", pca$ind)] <- "Iso03"
Origin[grep("23C", pca$ind)] <- "Iso05"
Origin[grep("34C", pca$ind)] <- "Iso08"
Origin[grep("46C", pca$ind)] <- "Iso12"
Origin[grep("15C", pca$ind)] <- "Iso13"
Origin[grep("48C", pca$ind)] <- "Iso14"
Origin[grep("27C", pca$ind)] <- "Iso15"
Origin[grep("26C", pca$ind)] <- "Iso16"
Origin[grep("24C", pca$ind)] <- "Iso20"
Origin[grep("01C", pca$ind)] <- "Iso21"
Origin[grep("39C", pca$ind)] <- "Iso23"
Origin[grep("05O", pca$ind)] <- "Iso01"
Origin[grep("10O", pca$ind)] <- "Iso03"
Origin[grep("13O", pca$ind)] <- "Iso05"
Origin[grep("06O", pca$ind)] <- "Iso08"
Origin[grep("04O", pca$ind)] <- "Iso12"
Origin[grep("37O", pca$ind)] <- "Iso13"
Origin[grep("14O", pca$ind)] <- "Iso14"
Origin[grep("47O", pca$ind)] <- "Iso15"
Origin[grep("32O", pca$ind)] <- "Iso16"
Origin[grep("44O", pca$ind)] <- "Iso20"
Origin[grep("03O", pca$ind)] <- "Iso21"
Origin[grep("36O", pca$ind)] <- "Iso23"
Origin[grep("02H", pca$ind)] <- "Iso01"
Origin[grep("43H", pca$ind)] <- "Iso03"
Origin[grep("09H", pca$ind)] <- "Iso05"
Origin[grep("29H", pca$ind)] <- "Iso08"
Origin[grep("25H", pca$ind)] <- "Iso12"
Origin[grep("08H", pca$ind)] <- "Iso13"
Origin[grep("41H", pca$ind)] <- "Iso14"
Origin[grep("31H", pca$ind)] <- "Iso15"
Origin[grep("45H", pca$ind)] <- "Iso16"
Origin[grep("21H", pca$ind)] <- "Iso20"
Origin[grep("35H", pca$ind)] <- "Iso21"
Origin[grep("11H", pca$ind)] <- "Iso23"
Origin[grep("12L", pca$ind)] <- "Iso01"
Origin[grep("19L", pca$ind)] <- "Iso03"
Origin[grep("38L", pca$ind)] <- "Iso05"
Origin[grep("30L", pca$ind)] <- "Iso08"
Origin[grep("33L", pca$ind)] <- "Iso12"
Origin[grep("22L", pca$ind)] <- "Iso13"
Origin[grep("40L", pca$ind)] <- "Iso14"
Origin[grep("07L", pca$ind)] <- "Iso15"
Origin[grep("42L", pca$ind)] <- "Iso16"
Origin[grep("20L", pca$ind)] <- "Iso20"
Origin[grep("17L", pca$ind)] <- "Iso21"
Origin[grep("28L", pca$ind)] <- "Iso23"
#Rescue
Rescue<- rep(NA, length(pca$ind))
Rescue[grep("KSS", pca$ind)] <- "Outbred Stock"
Rescue[grep("01ISO", pca$ind)] <- "Iso01"
Rescue[grep("03ISO", pca$ind)] <- "Iso03"
Rescue[grep("05ISO", pca$ind)] <- "Iso05"
Rescue[grep("08ISO", pca$ind)] <- "Iso08"
Rescue[grep("12ISO", pca$ind)] <- "Iso12"
Rescue[grep("13ISO", pca$ind)] <- "Iso13"
Rescue[grep("14ISO", pca$ind)] <- "Iso14"
Rescue[grep("15ISO", pca$ind)] <- "Iso15"
Rescue[grep("16ISO", pca$ind)] <- "Iso16"
Rescue[grep("20ISO", pca$ind)] <- "Iso20"
Rescue[grep("21ISO", pca$ind)] <- "Iso21"
Rescue[grep("23ISO", pca$ind)] <- "Iso23"
Rescue[grep("16C", pca$ind)] <- "Iso01"
Rescue[grep("18C", pca$ind)] <- "Iso03"
Rescue[grep("23C", pca$ind)] <- "Iso05"
Rescue[grep("34C", pca$ind)] <- "Iso08"
Rescue[grep("46C", pca$ind)] <- "Iso12"
Rescue[grep("15C", pca$ind)] <- "Iso13"
Rescue[grep("48C", pca$ind)] <- "Iso14"
Rescue[grep("27C", pca$ind)] <- "Iso15"
Rescue[grep("26C", pca$ind)] <- "Iso16"
Rescue[grep("24C", pca$ind)] <- "Iso20"
Rescue[grep("01C", pca$ind)] <- "Iso21"
Rescue[grep("39C", pca$ind)] <- "Iso23"
Rescue[grep("05O", pca$ind)] <- "Outbred Stock"
Rescue[grep("10O", pca$ind)] <- "Outbred Stock"
Rescue[grep("13O", pca$ind)] <- "Outbred Stock"
Rescue[grep("06O", pca$ind)] <- "Outbred Stock"
Rescue[grep("04O", pca$ind)] <- "Outbred Stock"
Rescue[grep("37O", pca$ind)] <- "Outbred Stock"
Rescue[grep("14O", pca$ind)] <- "Outbred Stock"
Rescue[grep("47O", pca$ind)] <- "Outbred Stock"
Rescue[grep("32O", pca$ind)] <- "Outbred Stock"
Rescue[grep("44O", pca$ind)] <- "Outbred Stock"
Rescue[grep("03O", pca$ind)] <- "Outbred Stock"
Rescue[grep("36O", pca$ind)] <- "Outbred Stock"
Rescue[grep("02H", pca$ind)] <- "Iso23"
Rescue[grep("43H", pca$ind)] <- "Iso12"
Rescue[grep("09H", pca$ind)] <- "Iso23"
Rescue[grep("29H", pca$ind)] <- "Iso12"
Rescue[grep("25H", pca$ind)] <- "Iso23"
Rescue[grep("08H", pca$ind)] <- "Iso23"
Rescue[grep("41H", pca$ind)] <- "Iso12"
Rescue[grep("31H", pca$ind)] <- "Iso14"
Rescue[grep("45H", pca$ind)] <- "Iso14"
Rescue[grep("21H", pca$ind)] <- "Iso14"
Rescue[grep("35H", pca$ind)] <- "Iso12"
Rescue[grep("11H", pca$ind)] <- "Iso14"
Rescue[grep("12L", pca$ind)] <- "Iso21"
Rescue[grep("19L", pca$ind)] <- "Iso13"
Rescue[grep("38L", pca$ind)] <- "Iso21"
Rescue[grep("30L", pca$ind)] <- "Iso13"
Rescue[grep("33L", pca$ind)] <- "Iso13"
Rescue[grep("22L", pca$ind)] <- "Iso21"
Rescue[grep("40L", pca$ind)] <- "Iso21"
Rescue[grep("07L", pca$ind)] <- "Iso20"
Rescue[grep("42L", pca$ind)] <- "Iso20"
Rescue[grep("20L", pca$ind)] <- "Iso13"
Rescue[grep("17L", pca$ind)] <- "Iso20"
Rescue[grep("28L", pca$ind)] <- "Iso20"
# combine - if you want to plot each in different colours
Origin_Rescue <- paste0(Origin, "_", Rescue)
# remake data.frame
pca <- as_tibble(data.frame(pca,Origin,Rescue,Origin_Rescue))
pca$Run<-ifelse(grepl("_",pca$ind),1,2)
str(pca)
pca$Run<-as.factor(pca$Run)
#first convert to percentage variance explained
pve <- data.frame(PC = 1:20, pve = eigenval/sum(eigenval)*100)
a <- ggplot(pve, aes(PC, pve)) + geom_bar(stat = "identity")
a + ylab("Percentage variance explained") + theme_light()
# calculate the cumulative sum of the percentage variance explained
cumsum(pve$pve)
#make palette
c16 <- c("dodgerblue2", "#E31A1C", "green4", "#6A3D9A", "#FF7F00", "black", "gold1", "skyblue2", "palegreen2", "#FDBF6F", "gray70", "maroon", "orchid1", "darkturquoise", "darkorange4", "brown") 

# plot pca
b <- ggplot(pca, aes(PC1, PC2, col = Rescue,fill=Origin,shape=Run)) + geom_point(size = 3)
b <- b + scale_colour_manual(values = c16)+scale_fill_manual(values = c16)+scale_shape_manual(values=c(21,22))
b <- b + coord_equal() + theme_light()
b + xlab(paste0("PC1 (", signif(pve$pve[1], 3), "%)")) + ylab(paste0("PC2 (", signif(pve$pve[2], 3), "%)"))
c<-b+scale_color_focus(c("Outbred Stock"))

pcaplot2 <- ggplot(pca, aes(PC1, PC2, fill = Origin, color = Rescue)) +
  geom_point(size = 6, alpha = 0.9, stroke = 1.5,shape=21) + # Bigger points and thicker outlines
  scale_fill_manual(values = c16, name = "Population") + # Unified color scale
  scale_color_manual(values = c16, name = "Population") +
  coord_equal() +
  theme_light() +
  xlab(paste0("PC1 (", signif(pve$pve[1], 3), "%)")) +
  ylab(paste0("PC2 (", signif(pve$pve[2], 3), "%)")) +
  stat_ellipse(aes(group = Origin, fill = Origin, color = Origin), 
               geom = "polygon", 
               type = "norm",  
               level = 0.99,  
               alpha = 0.2,   
               linewidth = 0.8,
               show.legend = FALSE)+
  theme(
    legend.position = "right",
    legend.box = "vertical",
    legend.title = element_text(face = "bold", size = 14), # Bigger legend title
    legend.text = element_text(size=14),
    legend.key.size = unit(1, "cm"), # Bigger legend key
    axis.text = element_text(size = 14), # Bigger axis text
    axis.title = element_text(size = 16) # Bigger axis titles
  )

