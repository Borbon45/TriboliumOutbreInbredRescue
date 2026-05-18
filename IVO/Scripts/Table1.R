# ==============================================================================
# SECTION 1: ENVIRONMENT SETUP & DATA PACKAGES
# ==============================================================================

# Clear the global environment
rm(list=ls())

# Load libraries for modeling, diagnostics, and marginal effects predictions
library(tidyverse)   # Data manipulation and visualization
library(DHARMa)      # CRITICAL: Simulated quantile residuals for GLMM diagnostics
library(ggeffects)   # For calculating and pulling marginal model predictions (predict_response)
library(glmmTMB)     # Fitting flexible Mixed Models (Negative Binomial, Beta, etc.)
library(performance) # Multicollinerity testing and model check tools
library(MuMIn)       # Calculating pseudo-R2 values for mixed models
library(emmeans)     # Post-hoc pairwise comparisons

# Load the raw experimental dataset
IvO <- read.csv("IvO.csv")
str(IvO)

# ==============================================================================
# SECTION 2: DATA CLEANING & RE-FACTORING
# ==============================================================================

# Drop any rows containing missing data (NAs)
IvO1 <- na.omit(IvO)

# Systematically convert categorical variables to structural factors
IvO1$Treatment <- as.factor(IvO1$Treatment)
levels(IvO1$Treatment)

IvO1$Rescue <- as.factor(IvO1$Rescue)
levels(IvO1$Rescue)

IvO1$Rescuer <- as.factor(IvO1$Rescuer)
levels(IvO1$Rescuer)

IvO1$ID <- as.factor(IvO1$ID)
levels(IvO1$ID)

IvO1$Isoline <- as.factor(IvO1$Isoline)
levels(IvO1$Isoline)

# ==============================================================================
# SECTION 3: AUTOMATED PLOTTING FUNCTION
# ==============================================================================

# Define a custom reusable plotting function for model fit visualization
# Arguments: 'model' (ggeffects dataframe object), 'data' (raw empirical data)
plotmodelfunc <- function(model, data) {
  ggplot2::ggplot(model) + 
    # Draw predicted regression lines across generations per treatment group
    ggplot2::geom_line(aes(x = x, y = predicted, colour = group)) +          
    # Overlay a 95% confidence interval ribbon beneath the lines
    ggplot2::geom_ribbon(aes(x = x, ymin = conf.low, ymax = conf.high, colour = group), 
                         fill = "lightgrey", alpha = 0.5) + 
    # Overlay the underlying raw data points for visual fit evaluation
    ggplot2::geom_point(data = data, aes(x = Generation, y = Productivity, colour = Treatment)) + 
    # Canvas configuration, theme details, timeline intercept lines, and static annotations
    ggplot2::labs(x = "Generation", y = "Productivity", 
                  title = "Sex Specific Genetic Rescue") + 
    ggplot2::theme_classic() +
    ggplot2::geom_vline(xintercept = 0.5, linetype = "dashed", color = "black", lwd = 2) +
    ggplot2::annotate(geom = "text", x = 0.9, y = 750, label = "Rescue", color = "black") +
    ggplot2::scale_x_continuous(breaks = c(0,1,2,3,4,5,6,7,8,9,10))
}

# ==============================================================================
# SECTION 4: GLMM REGRESSION MODELING & STATS
# ==============================================================================

# Inspect the target response variable distribution (checks for non-normality)
hist(IvO1$Productivity)

# Fit a Negative Binomial Type 1 GLMM
# Fixed Effects: Treatment, Generation, their Interaction (*), and a quadratic component.
# Note: I(Generation^2) allows the model to capture curved/parabolic trends over time.
# Random Effects: (1|Isoline/ID) represents ID nested inside Isoline, 
# accounting for repeated measures of families/lines.
# Subset: data is filtered to focus exclusively on generations post-baseline (Generation > 0).
M5 <- glmmTMB(Productivity ~ Treatment * Generation + I(Generation^2) + (1 | Isoline/ID),
              family = nbinom1, data = IvO1 %>% filter(Generation > "0"))

# Display the summary output (Log-likelihood estimate coefficients, p-values, random effect variance)
summary(M5)

# ==============================================================================
# SECTION 5: MODEL DIAGNOSTICS & POST-HOC TESTING
# ==============================================================================

# DHARMa Residual Diagnostics (simulates standard uniformly distributed residuals)
# Checks model structural validity for overdispersion, zero-inflation, and deviations
fitM5 <- simulateResiduals(fittedModel = M5, plot = TRUE)
plot(fitM5, asFactor = TRUE)

# Extract predicted marginal responses spanning all generation increments across treatments
plotM5 <- predict_response(M5, terms = c("Generation[all]", "Treatment[all]"))

# Execute the custom automated function to plot the model predictions over the raw data
plotmodelfunc(plotM5, IvO1)

# Multicollinearity check (Calculates Variance Inflation Factors [VIF])
# Checks if fixed predictor components are problematically redundant/correlated
multicollinearity(M5)

# Calculate Marginal (fixed effects only) and Conditional (fixed + random effects) R-squared values
r.squaredGLMM(M5)

# Generate Estimated Marginal Means across the interaction grid
emmeans_results <- emmeans(M5, ~ Treatment * Generation)

# Run a pairwise post-hoc test with a Tukey p-value adjustment for multiple comparisons
tukey_results <- pairs(emmeans_results, adjust = "tukey")

# Output final pairwise post-hoc statistical results table
summary(tukey_results)
