# ==============================================================================
# SECTION 1: ENVIRONMENT SETUP & LIBRARY LOADING
# ==============================================================================

# Clear the global environment (deletes all existing variables)
rm(list=ls())         

# Load libraries for data manipulation, summary calculations, and graphics
library(tidyverse)   # Core tidy data processing & ggplot2
library(Rmisc)       # Provides summarySE function for descriptive stats (SE and CI)

# ==============================================================================
# SECTION 2: DATA IMPORT & CLEANING
# ==============================================================================

# Load the raw experimental dataset
IvO <- read.csv("IvO.csv") 

# Inspect the underlying structure and variable types of the data
str(IvO)                    

# Drop any rows containing missing data values (NAs)
IvO1 <- na.omit(IvO)        

# Systematically convert categorical text variables to structural factors
IvO1$Treatment <- as.factor(IvO1$Treatment)
IvO1$Rescue    <- as.factor(IvO1$Rescue)
IvO1$Rescuer   <- as.factor(IvO1$Rescuer)
IvO1$ID        <- as.factor(IvO1$ID)
IvO1$Isoline   <- as.factor(IvO1$Isoline)

# Force conversion of eclosion metric to a continuous numeric variable
IvO1$Eclosion  <- as.numeric(IvO1$Eclosion)

# ==============================================================================
# SECTION 3: DATA SUMMARIZATION
# ==============================================================================

# Calculate descriptive summary statistics (Mean, SD, SE, and CI) for Productivity
# Aggregated across discrete Treatment groups and Generation steps
IvO2b <- summarySE(IvO1, measurevar = "Productivity", 
                   groupvars = c("Treatment", "Generation"))

# ==============================================================================
# SECTION 4: VISUALIZATION & PRESENTATION LAYOUT
# ==============================================================================

# Define a colorblind-friendly vector for line and point aesthetics
selected_colours1 <- c("#E69F00", "#0072B2", "#000000")

# Build the publication-ready line graph tracking reproductive trends
FIGURE1 <- IvO2b %>%
  
  # Reorder factors manually to enforce an explicit legend layout sequence (O -> I -> C)
  mutate(Treatment = fct_relevel(Treatment, c("O", "I", "C"))) %>%
  
  # Initialize the canvas mapping Generation trends to descriptive Productivity scores
  ggplot(aes(x = Generation, y = Productivity, col = Treatment)) +
  theme_classic() + 
  
  # Draw line geometries (position_dodge prevents track overlay overlap)
  geom_line(position = position_dodge(0.3), linewidth = 1.5) +
  
  # Add error bars calculated from the summary statistics standard error metric
  geom_errorbar(aes(ymin = Productivity - se, ymax = Productivity + se),
                width = 0.5, linewidth = 1.5, position = position_dodge(0.3)) +
  
  # Plot calculated group means as overlapping focal points
  geom_point(size = 3, stroke = 1.5, position = position_dodge(width = 0.3)) +
  
  # Enforce specific axis windows and placement transformations
  coord_cartesian(ylim = c(500, 850)) + 
  scale_x_continuous(breaks = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10)) +
  scale_y_continuous(position = "right") + 
  
  # Assign detailed labels to axes
  ylab("Number of Adult Offspring \n(7 Days Ovipostion)") +
  labs(linetype = "Environment") +
  
  # Configure typography scaling and embedded legend positioning coordinates
  theme(
    axis.text = element_text(size = 25),
    axis.title = element_text(size = 30, face = "bold"),
    legend.title = element_text(size = 25),
    legend.text = element_text(size = 20),
    legend.box = "horizontal",
    legend.direction = "horizontal",
    legend.background = element_rect(colour = "black"),
    legend.position = c(0.55, 0.08)
  ) + 
    
  # Map custom population designations to hex codes
  scale_color_manual(labels = c("Outbred Rescue", "Inbred Rescue", "No Rescue"),
                     values = selected_colours1) +
                     
  # Draw a bold vertical intercept indicating the generational rescue timeline event
  geom_vline(xintercept = 0.5, linetype = "dashed", color = ("black"), lwd = 2) +
  
  # Add clear text identifying the rescue marker point
  ggplot2::annotate(geom = "text", x = 1.2, y = 800, label = "Rescue", 
                    color = "black", size = 10, fontface = "bold") +
                    
  # Fine-tune aesthetic sizes inside the interactive legend box
  guides(color = guide_legend(order = 1, override.aes = list(size = 10)), 
         linetype = guide_legend(order = 2, override.aes = list(linewidth = 1)))
