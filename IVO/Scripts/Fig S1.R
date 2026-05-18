# ==============================================================================
# SECTION 1: ENVIRONMENT SETUP & LIBRARY LOADING
# ==============================================================================

# Clear the global R environment
rm(list=ls()) 

# Load packages for data manipulation and advanced aesthetic mapping
library(tidyverse)   # Core tidy data processing & ggplot2 
library(ggfocus)     # Useful for highlighting specific factors in crowded plots
library(RColorBrewer) # Color scheme presets
library(ggforce)     # Provides advanced layout mechanics (shapes/hulls)

# ==============================================================================
# SECTION 2: DATA IMPORT & STRUCTURE PREPARATION
# ==============================================================================

# Load individual eigenvector coordinates (PC scores per sample)
pca <- read_table("gr_tcas.eigenvec", col_names = FALSE)

# Load raw eigenvalue data (represents the magnitude of variance per PC axis)
eigenval <- scan("gr_tcas.eigenval")

# Strip out the first redundant index/family ID column common in PLINK outputs
pca <- pca[, -1]

# Assign human-readable column headers
names(pca)[1] <- "ind" # Name first column 'ind' (Individual sample ID)
names(pca)[2:ncol(pca)] <- paste0("PC", 1:(ncol(pca)-1)) # Label remaining columns PC1, PC2, etc.

# ==============================================================================
# SECTION 3: COMPLEX STRING MAPPING (ORIGIN & RESCUE CONTEXTS)
# ==============================================================================

# Parse individual sample codes using regex to identify the Inbred Population
Origin <- rep(NA, length(pca$ind))
Origin[grep("KSS", pca$ind)]    <- "Outbred Stock"
Origin[grep("01ISO", pca$ind)]  <- "Iso01"
Origin[grep("03ISO", pca$ind)]  <- "Iso03"
Origin[grep("05ISO", pca$ind)]  <- "Iso05"
Origin[grep("08ISO", pca$ind)]  <- "Iso08"
Origin[grep("12ISO", pca$ind)]  <- "Iso12"
Origin[grep("13ISO", pca$ind)]  <- "Iso13"
Origin[grep("14ISO", pca$ind)]  <- "Iso14"
Origin[grep("15ISO", pca$ind)]  <- "Iso15"
Origin[grep("16ISO", pca$ind)]  <- "Iso16"
Origin[grep("20ISO", pca$ind)]  <- "Iso20"
Origin[grep("21ISO", pca$ind)]  <- "Iso21"
Origin[grep("23ISO", pca$ind)]  <- "Iso23"
Origin[grep("16C", pca$ind)]    <- "Iso01"
Origin[grep("18C", pca$ind)]    <- "Iso03"
Origin[grep("23C", pca$ind)]    <- "Iso05"
Origin[grep("34C", pca$ind)]    <- "Iso08"
Origin[grep("46C", pca$ind)]    <- "Iso12"
Origin[grep("15C", pca$ind)]    <- "Iso13"
Origin[grep("48C", pca$ind)]    <- "Iso14"
Origin[grep("27C", pca$ind)]    <- "Iso15"
Origin[grep("26C", pca$ind)]    <- "Iso16"
Origin[grep("24C", pca$ind)]    <- "Iso20"
Origin[grep("01C", pca$ind)]    <- "Iso21"
Origin[grep("39C", pca$ind)]    <- "Iso23"
Origin[grep("05O", pca$ind)]    <- "Iso01"
Origin[grep("10O", pca$ind)]    <- "Iso03"
Origin[grep("13O", pca$ind)]    <- "Iso05"
Origin[grep("06O", pca$ind)]    <- "Iso08"
Origin[grep("04O", pca$ind)]    <- "Iso12"
Origin[grep("37O", pca$ind)]    <- "Iso13"
Origin[grep("14O", pca$ind)]    <- "Iso14"
Origin[grep("47O", pca$ind)]    <- "Iso15"
Origin[grep("32O", pca$ind)]    <- "Iso16"
Origin[grep("44O", pca$ind)]    <- "Iso20"
Origin[grep("03O", pca$ind)]    <- "Iso21"
Origin[grep("36O", pca$ind)]    <- "Iso23"
Origin[grep("02H", pca$ind)]    <- "Iso01"
Origin[grep("43H", pca$ind)]    <- "Iso03"
Origin[grep("09H", pca$ind)]    <- "Iso05"
Origin[grep("29H", pca$ind)]    <- "Iso08"
Origin[grep("25H", pca$ind)]    <- "Iso12"
Origin[grep("08H", pca$ind)]    <- "Iso13"
Origin[grep("41H", pca$ind)]    <- "Iso14"
Origin[grep("31H", pca$ind)]    <- "Iso15"
Origin[grep("45H", pca$ind)]    <- "Iso16"
Origin[grep("21H", pca$ind)]    <- "Iso20"
Origin[grep("35H", pca$ind)]    <- "Iso21"
Origin[grep("11H", pca$ind)]    <- "Iso23"
Origin[grep("12L", pca$ind)]    <- "Iso01"
Origin[grep("19L", pca$ind)]    <- "Iso03"
Origin[grep("38L", pca$ind)]    <- "Iso05"
Origin[grep("30L", pca$ind)]    <- "Iso08"
Origin[grep("33L", pca$ind)]    <- "Iso12"
Origin[grep("22L", pca$ind)]    <- "Iso13"
Origin[grep("40L", pca$ind)]    <- "Iso14"
Origin[grep("07L", pca$ind)]    <- "Iso15"
Origin[grep("42L", pca$ind)]    <- "Iso16"
Origin[grep("20L", pca$ind)]    <- "Iso20"
Origin[grep("17L", pca$ind)]    <- "Iso21"
Origin[grep("28L", pca$ind)]    <- "Iso23"

# Parse sample codes to identify the Rescuer population
Rescue <- rep(NA, length(pca$ind))
Rescue[grep("KSS", pca$ind)]    <- "Outbred Stock"
Rescue[grep("01ISO", pca$ind)]  <- "Iso01"
Rescue[grep("03ISO", pca$ind)]  <- "Iso03"
Rescue[grep("05ISO", pca$ind)]  <- "Iso05"
Rescue[grep("08ISO", pca$ind)]  <- "Iso08"
Rescue[grep("12ISO", pca$ind)]  <- "Iso12"
Rescue[grep("13ISO", pca$ind)]  <- "Iso13"
Rescue[grep("14ISO", pca$ind)]  <- "Iso14"
Rescue[grep("15ISO", pca$ind)]  <- "Iso15"
Rescue[grep("16ISO", pca$ind)]  <- "Iso16"
Rescue[grep("20ISO", pca$ind)]  <- "Iso20"
Rescue[grep("21ISO", pca$ind)]  <- "Iso21"
Rescue[grep("23ISO", pca$ind)]  <- "Iso23"
Rescue[grep("16C", pca$ind)]    <- "Iso01"
Rescue[grep("18C", pca$ind)]    <- "Iso03"
Rescue[grep("23C", pca$ind)]    <- "Iso05"
Rescue[grep("34C", pca$ind)]    <- "Iso08"
Rescue[grep("46C", pca$ind)]    <- "Iso12"
Rescue[grep("15C", pca$ind)]    <- "Iso13"
Rescue[grep("48C", pca$ind)]    <- "Iso14"
Rescue[grep("27C", pca$ind)]    <- "Iso15"
Rescue[grep("26C", pca$ind)]    <- "Iso16"
Rescue[grep("24C", pca$ind)]    <- "Iso20"
Rescue[grep("01C", pca$ind)]    <- "Iso21"
Rescue[grep("39C", pca$ind)]    <- "Iso23"
Rescue[grep("05O", pca$ind)]    <- "Outbred Stock"
Rescue[grep("10O", pca$ind)]    <- "Outbred Stock"
Rescue[grep("13O", pca$ind)]    <- "Outbred Stock"
Rescue[grep("06O", pca$ind)]    <- "Outbred Stock"
Rescue[grep("04O", pca$ind)]    <- "Outbred Stock"
Rescue[grep("37O", pca$ind)]    <- "Outbred Stock"
Rescue[grep("14O", pca$ind)]    <- "Outbred Stock"
Rescue[grep("47O", pca$ind)]    <- "Outbred Stock"
Rescue[grep("32O", pca$ind)]    <- "Outbred Stock"
Rescue[grep("44O", pca$ind)]    <- "Outbred Stock"
Rescue[grep("03O", pca$ind)]    <- "Outbred Stock"
Rescue[grep("36O", pca$ind)]    <- "Outbred Stock"
Rescue[grep("02H", pca$ind)]    <- "Iso23"
Rescue[grep("43H", pca$ind)]    <- "Iso12"
Rescue[grep("09H", pca$ind)]    <- "Iso23"
Rescue[grep("29H", pca$ind)]    <- "Iso12"
Rescue[grep("25H", pca$ind)]    <- "Iso23"
Rescue[grep("08H", pca$ind)]    <- "Iso23"
Rescue[grep("41H", pca$ind)]    <- "Iso12"
Rescue[grep("31H", pca$ind)]    <- "Iso14"
Rescue[grep("45H", pca$ind)]    <- "Iso14"
Rescue[grep("21H", pca$ind)]    <- "Iso14"
Rescue[grep("35H", pca$ind)]    <- "Iso12"
Rescue[grep("11H", pca$ind)]    <- "Iso14"
Rescue[grep("12L", pca$ind)]    <- "Iso21"
Rescue[grep("19L", pca$ind)]    <- "Iso13"
Rescue[grep("38L", pca$ind)]    <- "Iso21"
Rescue[grep("30L", pca$ind)]    <- "Iso13"
Rescue[grep("33L", pca$ind)]    <- "Iso13"
Rescue[grep("22L", pca$ind)]    <- "Iso21"
Rescue[grep("40L", pca$ind)]    <- "Iso21"
Rescue[grep("07L", pca$ind)]    <- "Iso20"
Rescue[grep("42L", pca$ind)]    <- "Iso20"
Rescue[grep("20L", pca$ind)]    <- "Iso13"
Rescue[grep("17L", pca$ind)]    <- "Iso20"
Rescue[grep("28L", pca$ind)]    <- "Iso20"

# Generate a compound category tag joining both histories
Origin_Rescue <- paste0(Origin, "_", Rescue)

# Merge back into a consolidated structural tibble object
pca <- as_tibble(data.frame(pca, Origin, Rescue, Origin_Rescue))

# Differentiate sequencing runs: IDs with underscores are Run 1, others are Run 2
pca$Run <- ifelse(grepl("_", pca$ind), 1, 2)
pca$Run <- as.factor(pca$Run)

# Check structural integrity of data types
str(pca)

# ==============================================================================
# SECTION 4: SCREE PLOT DIAGNOSTICS (VARIANCE METRICS)
# ==============================================================================

# Convert absolute values to Percentage Variance Explained (PVE) per component
pve <- data.frame(PC = 1:20, pve = eigenval/sum(eigenval)*100)

# Build descriptive Scree Plot
a <- ggplot(pve, aes(PC, pve)) + geom_bar(stat = "identity")
a + ylab("Percentage variance explained") + theme_light()

# Calculate individual component cumulative steps (tracks overall data captured)
cumsum(pve$pve)

# ==============================================================================
# SECTION 5: PCA VISUALIZATION WITH POPULATION CLUSTERING
# ==============================================================================

# Define a 16-color custom discrete color vector
c16 <- c("dodgerblue2", "#E31A1C", "green4", "#6A3D9A", "#FF7F00", "black", 
         "gold1", "skyblue2", "palegreen2", "#FDBF6F", "gray70", "maroon", 
         "orchid1", "darkturquoise", "darkorange4", "brown") 

# Build comprehensive high-density PCA Cluster chart
pcaplot2 <- ggplot(pca, aes(PC1, PC2, fill = Origin, color = Rescue)) +
  
  # Map points using Shape 21 (allows simultaneous interior 'fill' and border 'color' tracking)
  geom_point(size = 6, alpha = 0.9, stroke = 1.5, shape = 21) + 
  
  # Assign custom color vectors to fill and outline aesthetics
  scale_fill_manual(values = c16, name = "Population") + 
  scale_color_manual(values = c16, name = "Population") +
  
  # Enforce a strict 1:1 aspect ratio to ensure PC distance representations are geometrically accurate
  coord_equal() +
  theme_light() +
  
  # Label axes dynamically using scale calculations from the pve metadata
  xlab(paste0("PC1 (", signif(pve$pve[1], 3), "%)")) +
  ylab(paste0("PC2 (", signif(pve$pve[2], 3), "%)")) +
  
  # Draw data clustering ellipses encompassing approximately 99% of sample spread per Origin
  stat_ellipse(aes(group = Origin, fill = Origin, color = Origin), 
               geom = "polygon", 
               type = "norm",   # Assumes a multivariate normal distribution layout
               level = 0.99,    # Confidence threshold interval width
               alpha = 0.2,     # Semi-transparent polygon interiors
               linewidth = 0.8,
               show.legend = FALSE) +
  
  # Adjust label typographic styles for formal presentation layout
  theme(
    legend.position = "right",
    legend.box = "vertical",
    legend.title = element_text(face = "bold", size = 14), 
    legend.text = element_text(size = 14),
    legend.key.size = unit(1, "cm"), 
    axis.text = element_text(size = 14), 
    axis.title = element_text(size = 16) 
  )

