rm(list=ls()) 
library(tidyverse)
library(cowplot)
library(RColorBrewer)
library(ggfocus)
library(lme4)
library(nlme)
library(multcomp)
library(Rmisc)
library(googlesheets4)
library(ggsignif)
library(gridExtra)
library(emmeans)

grhet<-read.table("bcftools_Tribolium_castaneum.Tcas5.2.dna_sm.toplevel__genetic_rescue__20230926.SNPs_vcftools.het")

colnames(grhet) <- grhet[1, ]
grhet <- grhet[-1, ] #column names
Treatment<- rep(NA, length(grhet$INDV))
Treatment[grep("O", grhet$INDV)] <- "Outbred"
Treatment[grep("ISO", grhet$INDV)] <- "ISO"
Treatment[grep("L", grhet$INDV)] <- "Inbred"
Treatment[grep("H", grhet$INDV)] <- "Inbred"
Treatment[grep("C", grhet$INDV)] <- "Control"
Treatment[grep("KSS", grhet$INDV)] <- "KSS"
grhet$treatment<-Treatment
grhet$treatment<-as.factor(grhet$treatment)
str(grhet)
grhet<-grhet %>%
  mutate(treatment=fct_relevel(treatment,"KSS","ISO","Control","Inbred","Outbred"))
count(grhet$treatment)


grhet <- grhet[-46, ] #individuals with low coverage
grhet <- grhet[-52, ]
grhet$F<-as.numeric(grhet$F)
#remove males
grhet <- grhet %>%
  filter(!grepl("m", INDV))

###Stats
population<-rep(NA, length(grhet$INDV))
population[grep("01C", grhet$INDV)] <- "01"
population[grep("02H", grhet$INDV)] <- "02"
population[grep("03O", grhet$INDV)] <- "03"
population[grep("04", grhet$INDV)] <- "04"
population[grep("05", grhet$INDV)] <- "05"
population[grep("06", grhet$INDV)] <- "06"
population[grep("07", grhet$INDV)] <- "07"
population[grep("08", grhet$INDV)] <- "08"
population[grep("09", grhet$INDV)] <- "09"
population[grep("10", grhet$INDV)] <- "10"
population[grep("11", grhet$INDV)] <- "11"
population[grep("12", grhet$INDV)] <- "12"
population[grep("13", grhet$INDV)] <- "13"
population[grep("14", grhet$INDV)] <- "14"
population[grep("15", grhet$INDV)] <- "15"
population[grep("16", grhet$INDV)] <- "16"
population[grep("17", grhet$INDV)] <- "17"
population[grep("18", grhet$INDV)] <- "18"
population[grep("19", grhet$INDV)] <- "19"
population[grep("20", grhet$INDV)] <- "20"
population[grep("21", grhet$INDV)] <- "21"
population[grep("22", grhet$INDV)] <- "22"
population[grep("23", grhet$INDV)] <- "23"
population[grep("24", grhet$INDV)] <- "24"
population[grep("25", grhet$INDV)] <- "25"
population[grep("26", grhet$INDV)] <- "26"
population[grep("27", grhet$INDV)] <- "27"
population[grep("28", grhet$INDV)] <- "28"
population[grep("29", grhet$INDV)] <- "29"
population[grep("30", grhet$INDV)] <- "30"
population[grep("31", grhet$INDV)] <- "31"
population[grep("32", grhet$INDV)] <- "32"
population[grep("33", grhet$INDV)] <- "33"
population[grep("34", grhet$INDV)] <- "34"
population[grep("35", grhet$INDV)] <- "35"
population[grep("36", grhet$INDV)] <- "36"
population[grep("37", grhet$INDV)] <- "37"
population[grep("38", grhet$INDV)] <- "38"
population[grep("39", grhet$INDV)] <- "39"
population[grep("40", grhet$INDV)] <- "40"
population[grep("41", grhet$INDV)] <- "41"
population[grep("42", grhet$INDV)] <- "42"
population[grep("43", grhet$INDV)] <- "43"
population[grep("44", grhet$INDV)] <- "44"
population[grep("45", grhet$INDV)] <- "45"
population[grep("46", grhet$INDV)] <- "46"
population[grep("47", grhet$INDV)] <- "47"
population[grep("48", grhet$INDV)] <- "48"
population[grep("KSS", grhet$INDV)] <- "KSS"
population[grep("01ISO", grhet$INDV)] <- "01ISO"
population[grep("03ISO", grhet$INDV)] <- "03ISO"
population[grep("05ISO", grhet$INDV)] <- "05ISO"
population[grep("08ISO", grhet$INDV)] <- "08ISO"
population[grep("12ISO", grhet$INDV)] <- "12ISO"
population[grep("13ISO", grhet$INDV)] <- "13ISO"
population[grep("14ISO", grhet$INDV)] <- "14ISO"
population[grep("15ISO", grhet$INDV)] <- "15ISO"
population[grep("16ISO", grhet$INDV)] <- "16ISO"
population[grep("20ISO", grhet$INDV)] <- "20ISO"
population[grep("21ISO", grhet$INDV)] <- "21ISO"
population[grep("23ISO", grhet$INDV)] <- "23ISO"
grhet$population<-population


modelIvO<-lmer(F~treatment+(1|population), data = grhet)
summary(modelIvO)
emmeans(modelIvO, ~ treatment)
emm_group <- emmeans(modelIvO, ~ treatment)
pairs(emm_group, adjust = "tukey")

selected_colours1<-c("#1B9E77FF","#D95F02FF","#000000","#0072B2","#E69F00")

F_Inbred_sig <- grhet %>%
  ggplot( aes( x=treatment, y=F,fill = treatment)) +
  guides(fill = guide_legend(nrow = 2))+
  geom_boxplot(alpha=0.8, outlier.shape=NA) +
  scale_x_discrete(labels=c("KSS"="Outbred Stock","ISO"="Inbred Stock","Control"="No Rescue",
                            "Inbred"="Inbred Rescue",
                            "Outbred"="Outbred Rescue"))+
  geom_jitter(width=0.1, alpha=0.6) +
  scale_fill_manual(values=selected_colours1,
                    labels = c("Outbred Stock", "Inbred Stock", "No Rescue",
                               "Inbred Rescue", 
                               "Outbred Rescue"))+
  geom_vline(xintercept = 2.5,linetype="dashed")+
  labs(x="Population Treatment",
       y="Genomic Inbreeding Coefficient (F)",
       fill="Population Treatment")+
  theme_bw()+
  theme(
    plot.title = ggtext::element_markdown(face = "bold", size = 25),  # Apply markdown only to title
    axis.title.x = element_text(face = "bold", size = 20),
    axis.title.y = element_text(face = "bold", size = 20),            # Keep element_text for y-axis title
    axis.text.x = element_text(face="bold",size = 16),
    axis.text.y = element_text(face="bold",size=20),
    legend.title = element_text(face = "bold", size = 20),
    legend.text = element_text(face="bold",size = 20),
    legend.key.size = unit(1,"cm"),
    legend.position = "bottom"
  )+
  ggplot2::annotate(geom = "text",x=1.5,y=0.65,label="Stock",color="black",size=8)+
  ggplot2::annotate(geom = "text",x=4,y=0.65,label="Experimental",color="black",size=8)

plot1<-F_Inbred_sig + geom_signif(
  comparisons = list(c("KSS","ISO"),c("Outbred", "Inbred"),c("Outbred","Control")), # Groups to compare
  annotations = c("p < 0.001","p < 0.001", "p < 0.001"),    # P-values or any text
  y_position = c(-0.1,0.1,0),
  tip_length = -0.03,                           # Length of the little vertical lines
  textsize = 6,
  vjust = 0.5)  

