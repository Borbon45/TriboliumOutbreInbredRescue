# --- Environment Setup ---
rm(list=ls())          # Clear the global environment (deletes all existing variables)

library(tidyverse)     # Load suite for data manipulation and ggplot2
library(Rmisc)         # Load for the summarySE function (calculates SE and CI)

# --- Data Import & Cleaning ---
IvO <- read.csv("IvO.csv")  # Load the raw dataset
str(IvO)                    # Inspect the structure of the data

# 1. Handle Missing Values
IvO1 <- na.omit(IvO)        # Remove any rows containing NA values

# 2. Factor Conversion (Categorical Data)
# Converting strings/integers to factors ensures R treats them as groups for analysis
IvO1$Treatment <- as.factor(IvO1$Treatment)
IvO1$Rescue    <- as.factor(IvO1$Rescue)
IvO1$Rescuer   <- as.factor(IvO1$Rescuer)
IvO1$ID        <- as.factor(IvO1$ID)
IvO1$Isoline   <- as.factor(IvO1$Isoline)

# 3. Numeric Conversion
IvO1$Eclosion  <- as.numeric(IvO1$Eclosion)

# --- Data Summarization ---
# Calculates Mean, SD, SE, and CI for 'Productivity' 
# grouped by Treatment and Generation
IvO2b <- summarySE(IvO1, measurevar = "Productivity", 
                   groupvars = c("Treatment", "Generation"))

# --- Visualization ---

# Define a colorblind-friendly palette
selected_colours1 <- c("#E69F00", "#0072B2", "#000000")

FIGURE1 <- IvO2b %>%
  # Reorder factors so the legend/plot follows a specific logic (O then I then C)
  mutate(Treatment = fct_relevel(Treatment, c("O", "I", "C"))) %>%
  
  # Initialize plot: x-axis is Generation, y-axis is Productivity Mean
  ggplot(aes(x = Generation, y = Productivity, col = Treatment)) +
  theme_classic() + # Clean white background, no gridlines
  
  # Add lines connecting the means (dodge prevents overlapping points/lines)
  geom_line(position = position_dodge(0.3), linewidth = 1.5) +
  
  # Add Standard Error bars
  geom_errorbar(aes(ymin = Productivity - se, ymax = Productivity + se),
                width = 0.5, linewidth = 1.5, position = position_dodge(0.3)) +
  
  # Add points for the means
  geom_point(size = 3, stroke = 1.5, position = position_dodge(width = 0.3)) +
  
  # Formatting Axes and Labels
  coord_cartesian(ylim = c(500, 850)) + # Focus on specific Y range
  scale_x_continuous(breaks = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10)) +
  scale_y_continuous(position = "right") + # Move Y-axis labels to the right side
  ylab("Number of Adult Offspring \n(7 Days Ovipostion)") +
  
  # Visual Styling (High contrast/large text for publication)
  theme(
    axis.text = element_text(size = 25),
    axis.title = element_text(size = 30, face = "bold"),
    legend.title = element_text(size = 25),
    legend.text = element_text(size = 20),
    legend.box = "horizontal",
    legend.direction = "horizontal",
    legend.background = element_rect(colour = "black"),
    legend.position = c(0.55, 0.08)) + # Position legend inside the plot area
  
  # Manual color mapping and custom labels for the legend
  scale_color_manual(labels = c("Outbred Rescue", "Inbred Rescue", "No Rescue"),
                     values = selected_colours1) +
  
  # Add a vertical dashed line to indicate an event (likely when Rescue occurred)
  geom_vline(xintercept = 0.5, linetype = "dashed", color = ("black"), lwd = 2) +
  
  # Add text annotation on the plot
  ggplot2::annotate(geom = "text", x = 1.2, y = 800, label = "Rescue", 
                    color = "black", size = 10, fontface = "bold") +
  
  # Fine-tune legend appearance
  guides(color = guide_legend(order = 1, override.aes = list(size = 10)), 
         linetype = guide_legend(order = 2, override.aes = list(linewidth = 1)))
