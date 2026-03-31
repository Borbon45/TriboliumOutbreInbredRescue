rm(list=ls()) 
library(ggpubr)
library(tidyverse)
library(DHARMa)
library(googlesheets4)
library(Rmisc)
library(multcomp)
library(emmeans)
library(glmmTMB)
library(patchwork)

allsnp<-read.table("psc_snps_stats.txt")
siftsnp<-read.table("psc_output_confident.txt")

merged_snps <- allsnp %>%
  inner_join(siftsnp, by = "V3")

merged_snps<-merged_snps%>%dplyr::select(-1,-2,-15,-16)

merged_snps<-merged_snps%>%dplyr::rename(Sample = V3)
merged_snps<-merged_snps%>%dplyr::rename(allRefHom = V4.x)
merged_snps<-merged_snps%>%dplyr::rename(allAltHom = V5.x)
merged_snps<-merged_snps%>%dplyr::rename(allHet = V6.x)
merged_snps<-merged_snps%>%dplyr::rename(allTransitions = V7.x)
merged_snps<-merged_snps%>%dplyr::rename(allTransversions = V8.x)
merged_snps<-merged_snps%>%dplyr::rename(allIndels = V9.x)
merged_snps<-merged_snps%>%dplyr::rename(allAverageDepth = V10.x)
merged_snps<-merged_snps%>%dplyr::rename(allSingletons = V11.x)
merged_snps<-merged_snps%>%dplyr::rename(allHapref = V12.x)
merged_snps<-merged_snps%>%dplyr::rename(allHapalt = V13.x)
merged_snps<-merged_snps%>%dplyr::rename(allMissing = V14.x)
merged_snps<-merged_snps%>%dplyr::rename(delRefHom = V4.y)
merged_snps<-merged_snps%>%dplyr::rename(delAltHom = V5.y)
merged_snps<-merged_snps%>%dplyr::rename(delHet = V6.y)
merged_snps<-merged_snps%>%dplyr::rename(delTransitions = V7.y)
merged_snps<-merged_snps%>%dplyr::rename(delTransversions = V8.y)
merged_snps<-merged_snps%>%dplyr::rename(delIndels = V9.y)
merged_snps<-merged_snps%>%dplyr::rename(delAverageDepth = V10.y)
merged_snps<-merged_snps%>%dplyr::rename(delSingletons = V11.y)
merged_snps<-merged_snps%>%dplyr::rename(delHapref = V12.y)
merged_snps<-merged_snps%>%dplyr::rename(delHapalt = V13.y)
merged_snps<-merged_snps%>%dplyr::rename(delMissing = V14.y)

Treatment<- rep(NA, length(merged_snps$Sample))
Treatment[grep("O", merged_snps$Sample)] <- "Outbred"
Treatment[grep("ISO", merged_snps$Sample)] <- "ISO"
Treatment[grep("L", merged_snps$Sample)] <- "Inbred"
Treatment[grep("H", merged_snps$Sample)] <- "Inbred"
Treatment[grep("C", merged_snps$Sample)] <- "Control"
Treatment[grep("KSS", merged_snps$Sample)] <- "KSS"
merged_snps$Treatment<-Treatment

population<-rep(NA, length(merged_snps$Sample))
population[grep("01C", merged_snps$Sample)] <- "01"
population[grep("02H", merged_snps$Sample)] <- "02"
population[grep("03O", merged_snps$Sample)] <- "03"
population[grep("04", merged_snps$Sample)] <- "04"
population[grep("05", merged_snps$Sample)] <- "05"
population[grep("06", merged_snps$Sample)] <- "06"
population[grep("07", merged_snps$Sample)] <- "07"
population[grep("08", merged_snps$Sample)] <- "08"
population[grep("09", merged_snps$Sample)] <- "09"
population[grep("10", merged_snps$Sample)] <- "10"
population[grep("11", merged_snps$Sample)] <- "11"
population[grep("12", merged_snps$Sample)] <- "12"
population[grep("13", merged_snps$Sample)] <- "13"
population[grep("14", merged_snps$Sample)] <- "14"
population[grep("15", merged_snps$Sample)] <- "15"
population[grep("16", merged_snps$Sample)] <- "16"
population[grep("17", merged_snps$Sample)] <- "17"
population[grep("18", merged_snps$Sample)] <- "18"
population[grep("19", merged_snps$Sample)] <- "19"
population[grep("20", merged_snps$Sample)] <- "20"
population[grep("21", merged_snps$Sample)] <- "21"
population[grep("22", merged_snps$Sample)] <- "22"
population[grep("23", merged_snps$Sample)] <- "23"
population[grep("24", merged_snps$Sample)] <- "24"
population[grep("25", merged_snps$Sample)] <- "25"
population[grep("26", merged_snps$Sample)] <- "26"
population[grep("27", merged_snps$Sample)] <- "27"
population[grep("28", merged_snps$Sample)] <- "28"
population[grep("29", merged_snps$Sample)] <- "29"
population[grep("30", merged_snps$Sample)] <- "30"
population[grep("31", merged_snps$Sample)] <- "31"
population[grep("32", merged_snps$Sample)] <- "32"
population[grep("33", merged_snps$Sample)] <- "33"
population[grep("34", merged_snps$Sample)] <- "34"
population[grep("35", merged_snps$Sample)] <- "35"
population[grep("36", merged_snps$Sample)] <- "36"
population[grep("37", merged_snps$Sample)] <- "37"
population[grep("38", merged_snps$Sample)] <- "38"
population[grep("39", merged_snps$Sample)] <- "39"
population[grep("40", merged_snps$Sample)] <- "40"
population[grep("41", merged_snps$Sample)] <- "41"
population[grep("42", merged_snps$Sample)] <- "42"
population[grep("43", merged_snps$Sample)] <- "43"
population[grep("44", merged_snps$Sample)] <- "44"
population[grep("45", merged_snps$Sample)] <- "45"
population[grep("46", merged_snps$Sample)] <- "46"
population[grep("47", merged_snps$Sample)] <- "47"
population[grep("48", merged_snps$Sample)] <- "48"
population[grep("KSS", merged_snps$Sample)] <- "KSS"
population[grep("01ISO", merged_snps$Sample)] <- "01ISO"
population[grep("03ISO", merged_snps$Sample)] <- "03ISO"
population[grep("05ISO", merged_snps$Sample)] <- "05ISO"
population[grep("08ISO", merged_snps$Sample)] <- "08ISO"
population[grep("12ISO", merged_snps$Sample)] <- "12ISO"
population[grep("13ISO", merged_snps$Sample)] <- "13ISO"
population[grep("14ISO", merged_snps$Sample)] <- "14ISO"
population[grep("15ISO", merged_snps$Sample)] <- "15ISO"
population[grep("16ISO", merged_snps$Sample)] <- "16ISO"
population[grep("20ISO", merged_snps$Sample)] <- "20ISO"
population[grep("21ISO", merged_snps$Sample)] <- "21ISO"
population[grep("23ISO", merged_snps$Sample)] <- "23ISO"
merged_snps$population<-population

merged_snps<-merged_snps%>%
  filter(!(Sample%in%c("10O03","11H02")))
merged_snps<-merged_snps%>%
  mutate(Sample=str_remove(Sample,"_.*"))
#remove males
merged_snps <- merged_snps %>%
  filter(!grepl("m", Sample))

coverage<-read.table("genetic_rescue_samplenames_bam_files.depth.av.sort")
coverage<-coverage%>%dplyr::rename(Sample = V1)
coverage<-coverage%>%dplyr::rename(indvcover = V2)
coverage<-coverage%>%
  filter(!(Sample%in%c("10O03","11H02")))
coverage <- coverage %>%
  filter(!grepl("m", Sample))

merged_snps <- merged_snps %>%
  inner_join(coverage, by = "Sample")

merged_snps<-merged_snps %>%
  mutate(Treatment=fct_relevel(Treatment,"KSS","ISO","Control","Inbred","Outbred"))


#all positions
merged_snps<-merged_snps%>%
  mutate(Totalpositions=allAltHom+allHet+allRefHom)
#count total snps 
merged_snps<-merged_snps%>%
  mutate(TotalSNPS=allAltHom+allHet)
#count deleterious SNPs (alt or het)
merged_snps<-merged_snps%>%
  mutate(Total_Del_SNPs=delHet+delAltHom)
#proportion of snps that are deleterious
merged_snps<-merged_snps%>%
  mutate(Propdelsnps=Total_Del_SNPs/TotalSNPS)
#proportion of snps that are hom
merged_snps<-merged_snps%>%
  mutate(Prophomdelsnps=delAltHom/Total_Del_SNPs)
#what proportion of deleterious snps are alt hom
merged_snps<-merged_snps%>%
  mutate(prophomdel=delAltHom/Total_Del_SNPs)

selected_colours1<-c("#1B9E77FF","#D95F02FF","#000000","#0072B2","#E69F00")

Prophom <- merged_snps %>%
  ggplot(aes(y = prophomdel, x = Treatment, fill = Treatment))+
  geom_boxplot(alpha=0.8, outlier.shape=NA) +
  scale_x_discrete(labels=c("KSS"="Outbred Stock","ISO"="Inbred Stock","Control"="No Rescue",
                            "Inbred"="Inbred Rescue",
                            "Outbred"="Outbred Rescue"))+
  geom_jitter(width=0.1, alpha=0.6,show.legend = FALSE) +
  scale_fill_manual(values=selected_colours1,
                    labels = c("Outbred Stock", "Inbred Stock", "No Rescue",
                               "Inbred Rescue", 
                               "Outbred Rescue"))+
  geom_vline(xintercept = 2.5,linetype="dashed")+
  theme_classic()+
  xlab("Treatment")+
  ylab("Proportion of homozygous deleterious SNPs")+
  theme(
    plot.title = ggtext::element_markdown(face = "bold", size = 20),  # Apply markdown only to title
    axis.title.x = element_text(face = "bold", size = 20),
    axis.title.y = element_text(face = "bold", size = 20),            # Keep element_text for y-axis title
    axis.text.x = element_text(face="bold",size = 16),
    axis.text.y = element_text(face="bold",size=20),
    legend.title = element_text(face = "bold", size = 20),
    legend.text = element_text(face ="bold",size = 20),
    legend.key.size = unit(1,"cm"),
    legend.position = "right"
  )+
  ggplot2::annotate(geom = "text",x=1.5,y=0.75,label="Stock",color="black",size=8)+
  ggplot2::annotate(geom = "text",x=4.5,y=0.75,label="Experimental",color="black",size=8)


model_beta2 <- glmmTMB(
  prophomdel ~ Treatment + indvcover + (1 | population),
  data = merged_snps,
  family = beta_family(link = "logit")
)

summary(model_beta2)
fitbeta2 <- simulateResiduals(fittedModel = model_beta2, plot = T)

# Obtain estimated marginal means for Treatment
emm2 <- emmeans(model_beta2, ~ Treatment)

# Perform pairwise comparisons
pairwise_comparisons2 <- pairs(emm2)

# Display the results of pairwise comparisons
summary(pairwise_comparisons2)

Prophom<-Prophom + geom_signif(
  comparisons = list(c("KSS","ISO"),c("Outbred", "Inbred"), c("Outbred", "Control")),
  annotations = c("p < 0.001", "p < 0.001","p < 0.001"),
  y_position = c(0.2, 0.24, 0.2), 
  tip_length = -0.03,
  textsize = 5,
  vjust = 1
) 

Prophom

Countdel <- merged_snps %>%
  ggplot(aes(y = Total_Del_SNPs, x = Treatment, fill = Treatment))+
  geom_boxplot(alpha=0.8, outlier.shape=NA) +
  scale_x_discrete(labels=c("KSS"="Outbred Stock","ISO"="Inbred Stock","Control"="No Rescue",
                            "Inbred"="Inbred Rescue",
                            "Outbred"="Outbred Rescue"))+
  geom_jitter(width=0.1, alpha=0.6,show.legend = FALSE) +
  scale_fill_manual(values=selected_colours1,
                    labels = c("Outbred Stock", "Inbred Stock", "No Rescue",
                               "Inbred Rescue", 
                               "Outbred Rescue"))+
  geom_vline(xintercept = 2.5,linetype="dashed")+
  theme_classic()+
  xlab("Treatment")+
  ylab("Count of deleterious SNPs")+
  theme(
    plot.title = ggtext::element_markdown(face = "bold", size = 20),  # Apply markdown only to title
    axis.title.x = element_text(face = "bold", size = 20),
    axis.title.y = element_text(face = "bold", size = 20),            # Keep element_text for y-axis title
    axis.text.x = element_text(face="bold",size = 16),
    axis.text.y = element_text(face="bold",size=20),
    legend.title = element_text(face = "bold", size = 20),
    legend.text = element_text(face ="bold",size = 20),
    legend.key.size = unit(1,"cm"),
    legend.position = "right"
  )+
  ggplot2::annotate(geom = "text",x=1.5,y=2730,label="Stock",color="black",size=8)+
  ggplot2::annotate(geom = "text",x=4.5,y=2730,label="Experimental",color="black",size=8)

model_count<-glmmTMB(Total_Del_SNPs~Treatment+indvcover+(1|population),family=nbinom1, data = merged_snps)
summary(model_count)
fitmodel_count <- simulateResiduals(fittedModel = model_count, plot = T)
testDispersion(fitmodel_count)
# Obtain estimated marginal means for Treatment
emm3 <- emmeans(model_count, ~ Treatment)
# Perform pairwise comparisons
pairwise_comparisons3 <- pairs(emm3)
# Display the results of pairwise comparisons
summary(pairwise_comparisons3)

Countdel<-Countdel + geom_signif(
  comparisons = list(c("KSS", "ISO"),c("Outbred", "Inbred"), c("Outbred", "Control")), 
  annotations = c("p < 0.001", "p < 0.001","p < 0.001"), 
  y_position = c(2750, 2750, 2800), 
  tip_length = 0.03,
  textsize = 5,
  vjust = 0
) 
Countdel

Prophom <- Prophom +
  theme(legend.position = "none")
Prophom <- Prophom + annotate("text", x = -Inf, y = Inf, label = "B", hjust = -0.1, vjust = 1.1, size = 15)
Countdel <- Countdel + annotate("text", x = -Inf, y = Inf, label = "A", hjust = -0.1, vjust = 1.1, size = 15)
combined_plot <- Countdel / Prophom
combined_plot

#using the models to account for coverage

# Generate predicted values (on the log scale)
model_count_predict <- predict(model_count, newdata = merged_snps)
# Exponentiate to get back to the original scale (SNP counts)
model_count_predict <- exp(model_count_predict)
# Add predicted values to data frame
merged_snps_p <- merged_snps %>%
  mutate(Predicted_transformed = model_count_predict)

Countdel_p <- merged_snps_p %>%
  ggplot(aes(y = Predicted_transformed, x = Treatment, fill = Treatment))+
  geom_boxplot(alpha=0.8, outlier.shape=NA) +
  scale_x_discrete(labels=c("KSS"="Outbred Stock","ISO"="Inbred Stock","Control"="No Rescue",
                            "Inbred"="Inbred Rescue",
                            "Outbred"="Outbred Rescue"))+
  geom_jitter(width=0.1, alpha=0.6,show.legend = FALSE) +
  scale_fill_manual(values=selected_colours1,
                    labels = c("Outbred Stock", "Inbred Stock", "No Rescue",
                               "Inbred Rescue", 
                               "Outbred Rescue"))+
  geom_vline(xintercept = 2.5,linetype="dashed")+
  theme_classic()+
  xlab("Treatment")+
  ylab("Count of deleterious SNPs")+
  theme(
    plot.title = ggtext::element_markdown(face = "bold", size = 20),  # Apply markdown only to title
    axis.title.x = element_text(face = "bold", size = 20),
    axis.title.y = element_text(face = "bold", size = 20),            # Keep element_text for y-axis title
    axis.text.x = element_text(face="bold",size = 16),
    axis.text.y = element_text(face="bold",size=20),
    legend.title = element_text(face = "bold", size = 20),
    legend.text = element_text(face ="bold",size = 20),
    legend.key.size = unit(1,"cm"),
    legend.position = "right"
  )+
  ggplot2::annotate(geom = "text",x=1.5,y=2730,label="Stock",color="black",size=8)+
  ggplot2::annotate(geom = "text",x=4.5,y=2730,label="Experimental",color="black",size=8)

Countdel_p<-Countdel_p + geom_signif(
  comparisons = list(c("KSS", "ISO"),c("Outbred", "Inbred"), c("Outbred", "Control")), 
  annotations = c("p < 0.001", "p < 0.001","p < 0.001"), 
  y_position = c(2750, 2750, 2800), 
  tip_length = 0.03,
  textsize = 5,
  vjust = 0
) 

merged_snps_p <- merged_snps_p %>%
  mutate(adj_prop = predict(model_beta2, type = "response"))

Prophom_p <- merged_snps_p %>%
  ggplot(aes(y = adj_prop, x = Treatment, fill = Treatment))+
  geom_boxplot(alpha=0.8, outlier.shape=NA) +
  scale_x_discrete(labels=c("KSS"="Outbred Stock","ISO"="Inbred Stock","Control"="No Rescue",
                            "Inbred"="Inbred Rescue",
                            "Outbred"="Outbred Rescue"))+
  geom_jitter(width=0.1, alpha=0.6,show.legend = FALSE) +
  scale_fill_manual(values=selected_colours1,
                    labels = c("Outbred Stock", "Inbred Stock", "No Rescue",
                               "Inbred Rescue", 
                               "Outbred Rescue"))+
  geom_vline(xintercept = 2.5,linetype="dashed")+
  theme_classic()+
  xlab("Treatment")+
  ylab("Proportion of homozygous deleterious SNPs")+
  theme(
    plot.title = ggtext::element_markdown(face = "bold", size = 20),  # Apply markdown only to title
    axis.title.x = element_text(face = "bold", size = 20),
    axis.title.y = element_text(face = "bold", size = 20),            # Keep element_text for y-axis title
    axis.text.x = element_text(face="bold",size = 16),
    axis.text.y = element_text(face="bold",size=20),
    legend.title = element_text(face = "bold", size = 20),
    legend.text = element_text(face ="bold",size = 20),
    legend.key.size = unit(1,"cm"),
    legend.position = "right"
  )+
  ggplot2::annotate(geom = "text",x=1.5,y=0.75,label="Stock",color="black",size=8)+
  ggplot2::annotate(geom = "text",x=4.5,y=0.75,label="Experimental",color="black",size=8)

Prophom_p<-Prophom_p + geom_signif(
  comparisons = list(c("KSS","ISO"),c("Outbred", "Inbred"), c("Outbred", "Control")),
  annotations = c("p < 0.001", "p < 0.001","p < 0.001"),
  y_position = c(0.2, 0.24, 0.2), 
  tip_length = -0.03,
  textsize = 5,
  vjust = 1
) 

Prophom_p <- Prophom_p +
  theme(legend.position = "none")
Prophom_p <- Prophom_p + annotate("text", x = -Inf, y = Inf, label = "B", hjust = -0.1, vjust = 1.1, size = 15)
Countdel_p <- Countdel_p + annotate("text", x = -Inf, y = Inf, label = "A", hjust = -0.1, vjust = 1.1, size = 15)
combined_plot_p <- Countdel_p / Prophom_p
combined_plot_p
