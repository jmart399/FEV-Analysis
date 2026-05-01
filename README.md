#README: FEV Analysis

The files associated are in reference to a data analysis study on Forced Expiratory Volume (FEV), including linear regression, multiple linear regression, Chi Squared test of independence, and various descriptive statistics analyses in a population sample of 3-19 year old children. 

 
#Dataset file setup
 
This code relies on an SAS dataset file named `fev.sas7bdat` in the working directory, read using the `haven` package.
 
Expected variables: 'id', 'age', 'height', 'fev', 'sex', 'csmoke'
Expected observations: 654

---
 
#Requirements
 
- R studio, or an IDE with an R console
- Packages: Run the following lines before engaging with statistical analysis code.
install.packages("haven")
install.packages("ggplot2")
library(haven)
library(ggplot2)

---
 
## Usage
 
1. Place `fev.sas7bdat` in your R working directory.
2. Open `FEVAnalysis.R` in an R console.
3. Run blocks of code by highlighting a section and clicking "run", or ctrl+enter.
4. For each block, check the console for analysis outputs and the "plots" tab for graphs. 
 
