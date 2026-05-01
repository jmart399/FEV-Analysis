install.packages("haven")
library(haven)
library(ggplot2)

df <- read_sas("fev.sas7bdat")

#Checking for NA values
colSums(is.na(df))

#Checking for duplicate IDs
is_unique <- length(unique(df$id)) == nrow(df)
is_unique

#Checking for negative values or unrealistic outliers
summary(df)
str(df)

head(df[order(-df$fev), ], 10)
head(df[order(df$fev), ], 10)

table(df$sex)
table(df$csmoke)

  hist(df$age, main = "Histogram of Age", xlab = "Age")
  summary(df$age)
  hist(df$height, main = "Histogram of Height", xlab = "Height (in)")
  summary(df$height)
  hist(df$fev, main = "Histogram of FEV", xlab = "FEV (L)")
  summary(df$fev)

plot(df$height, df$fev,
     main = "Scatter Plot of Height vs FEV",
     xlab = "Height (in)",
     ylab = "Recorded FEV",
     col = "blue",
     pch = 16)

plot(df$age, df$fev,
     main = "Scatter Plot of Age vs FEV",
     xlab = "Age (years)",
     ylab = "Recorded FEV",
     col = "red",
     pch = 16)

#R won't display these these boxplots in correct sizes, so they're exported as PNGs
png("boxplot_sex.png", width = 800, height = 600, res = 100)
boxplot(fev ~ sex, data = df,
        names = c("Female", "Male"),
        xlab = "Sex", ylab = "FEV (Litres)",
        main = "FEV by Sex",
        col = c("blue", "red"))
dev.off()

png("boxplot_csmoke.png", width = 800, height = 600, res = 100)
boxplot(fev ~ csmoke, data = df,
        names = c("Nonsmoker", "Smoker"),
        xlab = "Smoking Status", ylab = "FEV (Litres)",
        main = "FEV by Smoking Status",
        col = c("blue", "red"))
dev.off()

desc_table <- data.frame(
  Variable = c("Age", "Height", "FEV"),
  Mean = c(mean(df$age, na.rm = TRUE),
           mean(df$height, na.rm = TRUE),
           mean(df$fev, na.rm = TRUE)),
  SD = c(sd(df$age, na.rm = TRUE),
         sd(df$height, na.rm = TRUE),
         sd(df$fev, na.rm = TRUE)),
  Min = c(min(df$age, na.rm = TRUE),
          min(df$height, na.rm = TRUE),
          min(df$fev, na.rm = TRUE)),
  Max = c(max(df$age, na.rm = TRUE),
          max(df$height, na.rm = TRUE),
          max(df$fev, na.rm = TRUE))
)

#FINAL REPORT

#To what extent can age, height, sex, and smoking status predict FEV?

#Continuous variable analysis for MLR

#AGE vs FEV
AbyF_Reg <- lm(df$fev ~ df$age) 
AbyF_Resid <- resid(AbyF_Reg)
summary(AbyF_Reg)

  plot(fitted(AbyF_Reg), AbyF_Resid,
       xlab = "Fitted values", ylab = "Residuals",
       main = "Age Residual",
       pch  = 19, col = "blue")
  abline(h = 0, col = "red", lwd = 2, lty = 2)

  qqnorm(AbyF_Resid, main = "Age Q-Q Plot",
         pch = 19, col = "blue")
  qqline(AbyF_Resid, col = "red", lwd = 2)

#HEIGHT vs FEV
  HbyF_Reg <- lm(df$fev ~ df$height) 
  HbyF_Resid <- resid(HbyF_Reg)
  summary(HbyF_Reg)

  plot(fitted(HbyF_Reg), HbyF_Resid,
       xlab = "Fitted values", ylab = "Residuals",
       main = "Height Residual",
       pch  = 19, col = "blue")
  abline(h = 0, col = "red", lwd = 2, lty = 2)

  qqnorm(HbyF_Resid, main = "Height Q-Q Plot",
         pch = 19, col = "blue")
  qqline(HbyF_Resid, col = "red", lwd = 2)

#Checking for multicolinearity between continuous variables
 tb <- cor(df[, c("age", "height", "fev")])

 #Correlation Matrix visual
 pairs(df[, c("age", "height", "fev")],
       main = "Correlation Matrix",
       pch = 19, col = "blue")

#Categorical variable analysis

#T-tests (sex & csmoke)
  t.test(fev ~ sex, data = df)
  t.test(fev ~ csmoke, data = df)

#Chi squared test between csmoke and sex
Table1 <- table(df$sex, df$csmoke)
chisq.test(Table1)$expected
chisq.test(Table1)


#MULTIPLE LINEAR REGRESSION
mlr <- lm(fev ~ age + height, data = df)

summary(mlr)
#R-squared = .774, p value <.001

#PNG of plot
png("mlr_assumptions.png", width = 1200, height = 1000, res = 120)
par(mfrow = c(2, 2))
plot(mlr)
dev.off()

