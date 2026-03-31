
rm(list=ls())

library(tidyverse)
library(Rmisc)

#DATA
IvO<-read.csv("IvO.csv")
str(IvO)
#remove na
IvO1<-na.omit(IvO)
#set treatment as factor
IvO1$Treatment <- as.factor(IvO1$Treatment)
levels(IvO1$Treatment)
#set rescue as factor
IvO1$Rescue <- as.factor(IvO1$Rescue)
levels(IvO1$Rescue)
#set rescuer as factor
IvO1$Rescuer <- as.factor(IvO1$Rescuer)
levels(IvO1$Rescuer)
#ID as factor
IvO1$ID <- as.factor(IvO1$ID)
levels(IvO1$ID)
#set isoline as factor
IvO1$Isoline <- as.factor(IvO1$Isoline)
levels(IvO1$Isoline)
#eclosion as numeric
IvO1$Eclosion <- as.numeric(IvO1$Eclosion)
str(IvO1)
IvO2b<-summarySE(IvO1,measurevar = "Productivity",
                 groupvars = c("Treatment","Generation"))
#COLOURS FOR PLOT
selected_colours1<-c("#E69F00", "#0072B2","#000000")

#PLOT
FIGURE1 <- IvO2b %>%
  mutate(Treatment = fct_relevel(Treatment, c("O", "I", "C"))) %>%
  ggplot(aes(x = Generation, y = Productivity, col = Treatment)) +
  theme_classic() +
  geom_line(position = position_dodge(0.3), linewidth = 1.5) +
  geom_errorbar(aes(ymin = Productivity - se, ymax = Productivity + se),
                width = 0.5, linewidth = 1.5, position = position_dodge(0.3)) +
  geom_point(size = 3, stroke = 1.5, position = position_dodge(width = 0.3)) +
  coord_cartesian(ylim = c(500, 850)) +
  scale_x_continuous(breaks = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10)) +
  scale_y_continuous(position = "right") +
  ylab("Number of Adult Offspring \n(7 Days Ovipostion)") +
  labs(linetype = "Environment") +
  theme(
    axis.text = element_text(size = 25),
    axis.title = element_text(size = 30, face = "bold"),
    legend.title = element_text(size = 25),
    legend.text = element_text(size = 20),
    legend.box = "horizontal",
    legend.direction = "horizontal",
    legend.background = element_rect(colour = "black"),
    legend.position = c(0.55, 0.08)) +
  scale_color_manual(labels = c("Outbred Rescue", "Inbred Rescue", "No Rescue"),
                     values = selected_colours1) +
  geom_vline(xintercept = 0.5, linetype = "dashed", color = ("black"), lwd = 2) +
  ggplot2::annotate(geom = "text", x = 1.2, y = 800, label = "Rescue", color = "black", size = 10, fontface = "bold")+
  guides(color = guide_legend(order = 1, override.aes = list(size = 10)), # Increase color size
         linetype = guide_legend(order = 2, override.aes = list(linewidth = 1)))
