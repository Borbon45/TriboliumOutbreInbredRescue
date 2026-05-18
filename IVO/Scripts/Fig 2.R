# ==============================================================================
# SECTION 1: ENVIRONMENT SETUP & LIBRARY LOADING
# ==============================================================================

# Clear the global environment
rm(list=ls()) 

# Load necessary packages for visualization, stats, and data handling
library(tidyverse)     # For data manipulation (dplyr, stringr, forcats) and plotting
library(cowplot)       # ggplot2 companion for publication-ready themes
library(RColorBrewer)  # Color palettes
library(ggfocus)       # For highlighting specific areas in ggplot
library(lme4)          # For running Linear Mixed-Effects Models (lmer)
library(nlme)          # Alternative package for linear/nonlinear mixed effects
library(multcomp)      # For simultaneous inference / multiple comparisons
library(Rmisc)         # For general data summary tools
library(googlesheets4) # For interacting with Google Sheets data (not actively used below)
library(ggsignif)      # To easily add significance brackets/bars to ggplots
library(gridExtra)     # To arrange multiple grid-based plots
library(emmeans)       # For calculating Estimated Marginal Means and post-hoc tests

# ==============================================================================
# SECTION 2: DATA IMPORT & CLEANING
# ==============================================================================

# Read VCFtools heterozygosity summary file (.het)
grhet <- read.table("bcftools_Tribolium_castaneum.Tcas5.2.dna_sm.toplevel__genetic_rescue__20230926.SNPs_vcftools.het")

# Set the first row as column headers, then remove that row from the dataset
colnames(grhet) <- grhet[1, ]
grhet <- grhet[-1, ] 

# Parse individual IDs (INDV) to assign 'Treatment' categories using regex matching
Treatment <- rep(NA, length(grhet$INDV))
Treatment[grep("O", grhet$INDV)]   <- "Outbred"
Treatment[grep("ISO", grhet$INDV)] <- "ISO"
Treatment[grep("L", grhet$INDV)]   <- "Inbred"
Treatment[grep("H", grhet$INDV)]   <- "Inbred"
Treatment[grep("C", grhet$INDV)]   <- "Control"
Treatment[grep("KSS", grhet$INDV)] <- "KSS"

# Add Treatment to the dataframe, factorize it, and check its data structure
grhet$treatment <- Treatment
grhet$treatment <- as.factor(grhet$treatment)
str(grhet)

# Manually reorder factor levels for downstream plotting/analysis
grhet <- grhet %>%
  mutate(treatment = fct_relevel(treatment, "KSS", "ISO", "Control", "Inbred", "Outbred"))

# Double-check the sample sizes across different treatment levels
count(grhet$treatment)

# Remove specific outlier/low-quality individuals based on low sequence coverage
grhet <- grhet[-46, ] 
grhet <- grhet[-52, ]

# Convert the Inbreeding Coefficient (F) column from character to numeric
grhet$F <- as.numeric(grhet$F)

# Filter out males 
grhet <- grhet %>%
  filter(!grepl("m", INDV))

# ==============================================================================
# SECTION 3: ASSIGNING POPULATIONS (FOR RANDOM EFFECTS)
# ==============================================================================

# Create a 'population' tracker vector based on character matches in INDV
# This links individuals to their biological background population origin
population <- rep(NA, length(grhet$INDV))
population[grep("01C", grhet$INDV)]   <- "01"
population[grep("02H", grhet$INDV)]   <- "02"
population[grep("03O", grhet$INDV)]   <- "03"
population[grep("04", grhet$INDV)]    <- "04"
population[grep("05", grhet$INDV)]    <- "05"
population[grep("06", grhet$INDV)]    <- "06"
population[grep("07", grhet$INDV)]    <- "07"
population[grep("08", grhet$INDV)]    <- "08"
population[grep("09", grhet$INDV)]    <- "09"
population[grep("10", grhet$INDV)]    <- "10"
population[grep("11", grhet$INDV)]    <- "11"
population[grep("12", grhet$INDV)]    <- "12"
population[grep("13", grhet$INDV)]    <- "13"
population[grep("14", grhet$INDV)]    <- "14"
population[grep("15", grhet$INDV)]    <- "15"
population[grep("16", grhet$INDV)]    <- "16"
population[grep("17", grhet$INDV)]    <- "17"
population[grep("18", grhet$INDV)]    <- "18"
population[grep("19", grhet$INDV)]    <- "19"
population[grep("20", grhet$INDV)]    <- "20"
population[grep("21", grhet$INDV)]    <- "21"
population[grep("22", grhet$INDV)]    <- "22"
population[grep("23", grhet$INDV)]    <- "23"
population[grep("24", grhet$INDV)]    <- "24"
population[grep("25", grhet$INDV)]    <- "25"
population[grep("26", grhet$INDV)]    <- "26"
population[grep("27", grhet$INDV)]    <- "27"
population[grep("28", grhet$INDV)]    <- "28"
population[grep("29", grhet$INDV)]    <- "29"
population[grep("30", grhet$INDV)]    <- "30"
population[grep("31", grhet$INDV)]    <- "31"
population[grep("32", grhet$INDV)]    <- "32"
population[grep("33", grhet$INDV)]    <- "33"
population[grep("34", grhet$INDV)]    <- "34"
population[grep("35", grhet$INDV)]    <- "35"
population[grep("36", grhet$INDV)]    <- "36"
population[grep("37", grhet$INDV)]    <- "37"
population[grep("38", grhet$INDV)]    <- "38"
population[grep("39", grhet$INDV)]    <- "39"
population[grep("40", grhet$INDV)]    <- "40"
population[grep("41", grhet$INDV)]    <- "41"
population[grep("42", grhet$INDV)]    <- "42"
population[grep("43", grhet$INDV)]    <- "43"
population[grep("44", grhet$INDV)]    <- "44"
population[grep("45", grhet$INDV)]    <- "45"
population[grep("46", grhet$INDV)]    <- "46"
population[grep("47", grhet$INDV)]    <- "47"
population[grep("48", grhet$INDV)]    <- "48"
population[grep("KSS", grhet$INDV)]   <- "KSS"
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

# Append the vector into the dataset
grhet$population <- population

# ==============================================================================
# SECTION 4: STATISTICAL MODELING
# ==============================================================================

# Fit a Linear Mixed-Effects Model (LMM)
# Fixed Effect: treatment
# Random Effect: (1|population) to account for variation shared among same-source groups
modelIvO <- lmer(F ~ treatment + (1|population), data = grhet)

# Print the model summary (coefficients, residuals, random effect variance)
summary(modelIvO)

# Calculate Estimated Marginal Means (predicted group means adjusted for random effect)
emmeans(modelIvO, ~ treatment)
emm_group <- emmeans(modelIvO, ~ treatment)

# Pairwise post-hoc comparisons between treatments using Tukey's P-value adjustments
pairs(emm_group, adjust = "tukey")

# ==============================================================================
# SECTION 5: DATA VISUALIZATION
# ==============================================================================

# Define a 5-color manual hex code palette 
selected_colours1 <- c("#1B9E77FF", "#D95F02FF", "#000000", "#0072B2", "#E69F00")

# Construct the base boxplot
F_Inbred_sig <- grhet %>%
  ggplot(aes(x = treatment, y = F, fill = treatment)) +
  
  # Configure legend layout to split items over 2 rows
  guides(fill = guide_legend(nrow = 2)) +
  
  # Standard boxplot layout (hiding default outlier symbols to avoid double-plotting with jitter)
  geom_boxplot(alpha = 0.8, outlier.shape = NA) +
  
  # Map internal factor level names to clean labels on the X-axis
  scale_x_discrete(labels = c("KSS" = "Outbred Stock", "ISO" = "Inbred Stock", "Control" = "No Rescue",
                              "Inbred" = "Inbred Rescue", "Outbred" = "Outbred Rescue")) +
  
  # Spread individual data points out across the boxes to show data distribution density
  geom_jitter(width = 0.1, alpha = 0.6) +
  
  # Add the custom color fills and update the legend labels
  scale_fill_manual(values = selected_colours1,
                    labels = c("Outbred Stock", "Inbred Stock", "No Rescue", "Inbred Rescue", "Outbred Rescue")) +
  
  # Create a distinct physical separation line between base stock groups and experimental groups
  geom_vline(xintercept = 2.5, linetype = "dashed") +
  
  # Axis labels
  labs(x = "Population Treatment",
       y = "Genomic Inbreeding Coefficient (F)",
       fill = "Population Treatment") +
  
  # Use a standard black-and-white panel theme
  theme_bw() +
  
  # Fine-tune typographic styling and position the legend at the bottom
  theme(
    plot.title = ggtext::element_markdown(face = "bold", size = 25), 
    axis.title.x = element_text(face = "bold", size = 20),
    axis.title.y = element_text(face = "bold", size = 20),            
    axis.text.x = element_text(face = "bold", size = 16),
    axis.text.y = element_text(face = "bold", size = 20),
    legend.title = element_text(face = "bold", size = 20),
    legend.text = element_text(face = "bold", size = 20),
    legend.key.size = unit(1, "cm"),
    legend.position = "bottom"
  ) +
  
  # Append static contextual labels identifying the broader sections of the graph
  ggplot2::annotate(geom = "text", x = 1.5, y = 0.65, label = "Stock", color = "black", size = 8) +
  ggplot2::annotate(geom = "text", x = 4, y = 0.65, label = "Experimental", color = "black", size = 8)

# Add custom significance comparison bars directly to the existing plot
plot1 <- F_Inbred_sig + geom_signif(
  comparisons = list(c("KSS", "ISO"), c("Control", "Inbred"), c("Outbred", "Inbred"), c("Outbred", "Control")), 
  annotations = c("p < 0.001", "N.S", "p < 0.001", "p < 0.001"),    # Hardcoded text strings representing your pairwise results
  y_position = c(-0.1, 0.1, 0, -0.1),                               # Vertical heights where bars sit on the Y axis
  tip_length = -0.03,                                               # Downward-pointing bracket ticks
  textsize = 6,
  vjust = 0.5)
