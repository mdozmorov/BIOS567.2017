---
categories:
 - weekly
title: "11 - Normalization"
slides: ""
tags:
 - assets
visible: 1
---

[Slides: Normalization]({{site.baseurl}}/presentations/06a_Normalization/06a_Normalization.pdf)  
[Lecture notes, normalization]({{site.baseurl}}/presentations/06a_Normalization/Lowess_and_affynormalization_NOTES.pdf)  
[Quantile normalization example]({{site.baseurl}}/presentations/06a_Normalization/Quantile_normalization_example.pdf)  
[Exercises and data](https://github.com/mdozmorov/BIOS567.2017/tree/gh-pages/assets/06a_Normalization)  
- `lab/01_lowess_curve_fit_demo.R` - Non-linear curve fitting exercise
- `lab/02_lowess_by_hand_demo.R` - Manually fitting Loess curves on `wine` dataset
- `lab/03_lowess_2color.R` - Loess on two-color arrays. MA diagnostic plots, global and print-tip loess normalization. Uses `data_spotted` files from `05b_Quality`.

<!--
- `lab/04_normalization_affy.R` - quantile normalization of one-color array. Uses `data_affy` files from `05b_Quality`.
- `lab/05_quantile_demo.R` - QQplot manual demo, affy quantile normalization. Uses `data_affy` files from `05b_Quality`.
-->

## References

- Bolstad, B. M., R. A. Irizarry, M. Astrand, and T. P. Speed. “A Comparison of Normalization Methods for High Density Oligonucleotide Array Data Based on Variance and Bias.” Bioinformatics (Oxford, England) 19, no. 2 (January 22, 2003): 185–93. - Normalization methods description.

- Cleveland, William S, and Susan J Devlin. “Locally Weighted Regression: An Approach to Regression Analysis by Local Fitting.” Journal of the American Statistical Association 83, no. 403 (1988): 596–610. - Loess regression. Concept, statistics.

- Fan, Jianqing, and Yi Ren. “Statistical Analysis of DNA Microarray Data in Cancer Research.” Clinical Cancer Research: An Official Journal of the American Association for Cancer Research 12, no. 15 (August 1, 2006): 4469–73. doi:10.1158/1078-0432.CCR-06-1033. - Steps in microarray data analysis, from preprocessing to differential expression and time course. Brief.

- Carvalho, Benilton S., and Rafael A. Irizarry. “A Framework for Oligonucleotide Microarray Preprocessing.” Bioinformatics (Oxford, England) 26, no. 19 (October 1, 2010): 2363–67. doi:10.1093/bioinformatics/btq431. - Preprocessing for different microarray types - Affy, Illumina, Nimblegen - , and platforms - SNP, Exon, Expression, Tiling. Probe affinity effect figure

- Huber, Wolfgang, Anja von Heydebreck, Holger Sültmann, Annemarie Poustka, and Martin Vingron. “Variance Stabilization Applied to Microarray Data Calibration and to the Quantification of Differential Expression.” Bioinformatics (Oxford, England) 18 Suppl 1 (2002): S96-104. - VSN paper. aka VST. arsinh: https://www.geogebra.org/m/f5gdhrmT

- On non-linear curve fitting and goodness-of-fit: “Technical note: Curve fitting with the R Environment for Statistical Computing”, PDF, http://www.css.cornell.edu/faculty/dgr2/teach/R/R_CurveFit.pdf

- `qsmooth` R package - Smooth quantile normalization (qsmooth) is a generalization of quantile normalization, which is an average of the two types of assumptions about the data generation process: quantile normalization and quantile normalization between groups. https://github.com/stephaniehicks/qsmooth. Paper: Hicks, Stephanie C, Kwame Okrah, Joseph N Paulson, John Quackenbush, Rafael A Irizarry, and Hector Corrada Bravo. “Smooth Quantile Normalization,” November 2, 2016. http://biorxiv.org/lookup/doi/10.1101/085175. - Per-group quantile normalization accounting for the differences in variation among groups

- Ballman, Karla V., Diane E. Grill, Ann L. Oberg, and Terry M. Therneau. “Faster Cyclic Loess: Normalizing RNA Arrays via Linear Models.” Bioinformatics (Oxford, England) 20, no. 16 (November 1, 2004): 2778–86. doi:10.1093/bioinformatics/bth327. - loess how-to. Method description. cyclic loess. Parallel implementation. Quantile normalization as another non-parametric normalization.

- Hurvich, Clifford M., Jeffrey S. Simonoff, and Chih-Ling Tsai. “Smoothing Parameter Selection in Nonparametric Regression Using an Improved Akaike Information Criterion.” Journal of the Royal Statistical Society. Series B (Statistical Methodology) 60, no. 2 (1998): 271–93. http://www.jstor.org/stable/2985940.

- Heider, Andreas, and Rüdiger Alt. “VirtualArray: A R/Bioconductor Package to Merge Raw Data from Different Microarray Platforms.” BMC Bioinformatics 14 (2013): 75. doi:10.1186/1471-2105-14-75. - Meta-analysis of multiple microarrays in GEO. Techniques for normalization and batch effect removal

- "Automated parameter selection for LOESS regression." http://blog.eighty20.co.za//technique%20review/2016/02/11/loess-Allan/ 

