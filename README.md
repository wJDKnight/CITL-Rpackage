# Introduction 
CITL is running in [R](https://www.r-project.org/), a free software environment for statistical computing. R support a wide variety of UNIX platforms, Windows and MacOS, which means that CITL could run on many platforms. The instruction of installing R is at [here](https://cran.r-project.org/doc/manuals/r-release/R-admin.html).

# CITL-Rpackage
Here is the R package of CITL. If you are working with R only, this version is what you need. However, if you are working across different programming environments, the command-line tool of CITL is more convenient to use. The command-line tool is at https://github.com/wJDKnight/CITL/ . Both the R package and the command-line tool can run independently.
# Requirements
  R packages: bnlearn; snow  
# Installation 
  Use R package: devtools to install CITL.
    
    devtools::install_github("wJDKnight/CITL-Rpackage")
  
 # [Tutorial](https://wjdknight.github.io/CITL-Rpackage/package_tutorial.html)


# Reference
Wei et al.(2021), Inferring time-lagged causality using the derivative of single-cell expression
