####MODELS
rm(list=ls())

#PACKAGES
library(tidyverse)
library(DHARMa)
library(ggeffects)
library(glmmTMB)
library(performance)
library(MuMIn)
library(emmeans)


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

plotmodelfunc <- function(model, data) {
  ggplot2::ggplot(model) + 
    ggplot2::geom_line(aes(x = x, y = predicted, colour = group)) +          
    ggplot2::geom_ribbon(aes(x = x, ymin = conf.low, ymax = conf.high, colour = group), 
                         fill = "lightgrey", alpha = 0.5) + 
    ggplot2::geom_point(data = data, aes(x = Generation, y = Productivity, colour = Treatment)) + 
    ggplot2::labs(x = "Generation", y = "Productivity", 
                  title = "Sex Specific Genetic Rescue") + 
    ggplot2::theme_classic() +
    ggplot2::geom_vline(xintercept = 0.5, linetype = "dashed", color = "black", lwd = 2) +
    ggplot2::annotate(geom = "text", x = 0.9, y = 750, label = "Rescue", color = "black") +
    ggplot2::scale_x_continuous(breaks = c(0,1,2,3,4,5,6,7,8,9,10))
}


##Models
hist(IvO1$Productivity)
#OvI
M5<-glmmTMB(Productivity~Treatment*Generation+I(Generation^2)+(1|Isoline/ID),
            family=nbinom1,data=IvO1%>%filter(Generation>"0"))
summary(M5)
fitM5 <- simulateResiduals(fittedModel = M5, plot = T)
plot(fitM5, asFactor = T)
plotM5<- predict_response(M5, terms = c("Generation[all]","Treatment[all]"))
plotmodelfunc(plotM5,IvO1)
multicollinearity(M5)
r.squaredGLMM(M5)
# Post-hoc Tukey test on interaction
emmeans_results <- emmeans(M5, ~ Treatment * Generation)
# Pairwise comparisons with Tukey adjustment
tukey_results <- pairs(emmeans_results, adjust = "tukey")
# View results
summary(tukey_results)
