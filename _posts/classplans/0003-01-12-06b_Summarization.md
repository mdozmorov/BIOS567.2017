---
categories:
 - weekly
title: "12 - Expression summarization"
slides: ""
tags:
 - assets
visible: 1
---

[Slides: Expression summarization]({{site.baseurl}}/presentations/06b_Summarization/06b_Summarization.pdf)   
[Lecture notes: Expression summarization]({{site.baseurl}}/presentations/06b_Summarization/Tukey_MAS5_NOTES.pdf)   
[Li & Wong summarization example]({{site.baseurl}}/presentations/06b_Summarization/Li_and_Wong_expression_summary.pdf)   
[Median polish example]({{site.baseurl}}/presentations/06b_Summarization/Median_Polish.pdf)   
[RMA example 1]({{site.baseurl}}/presentations/06b_Summarization/RMA_example_1.pdf)   
[RMA example 2]({{site.baseurl}}/presentations/06b_Summarization/RMA_example_2.pdf)   
[Exercises and data](https://github.com/mdozmorov/BIOS567.2017/tree/gh-pages/assets/06b_Summarization)  
- `lab/Tukey_MAS5.R` - normalization example. Uses data from `05b_Quality/lab/data_affy/`
- `lab/median_polish.R` - median polish example. Uses data from `05b_Quality/lab/data_affy/`

## References

- `sadd_whitepaper.pdf` - Statistical Algorithms Description Document. Summarization, noise, background correction, ideal mismatch. P/A calls (wilcoxon). [http://tools.thermofisher.com/content/sfs/brochures/sadd_whitepaper.pdf](http://tools.thermofisher.com/content/sfs/brochures/sadd_whitepaper.pdf)

- Li, C., and W. Hung Wong. “Model-Based Analysis of Oligonucleotide Arrays: Model Validation, Design Issues and Standard Error Application.” Genome Biology 2, no. 8 (2001): RESEARCH0032. [http://www.pnas.org/content/98/1/31.long](http://www.pnas.org/content/98/1/31.long)

- Irizarry, Rafael A., Bridget Hobbs, Francois Collin, Yasmin D. Beazer-Barclay, Kristen J. Antonellis, Uwe Scherf, and Terence P. Speed. “Exploration, Normalization, and Summaries of High Density Oligonucleotide Array Probe Level Data.” Biostatistics (Oxford, England) 4, no. 2 (April 2003): 249–64. doi:10.1093/biostatistics/4.2.249. [https://academic.oup.com/biostatistics/article/4/2/249/245074/Exploration-normalization-and-summaries-of-high](https://academic.oup.com/biostatistics/article/4/2/249/245074/Exploration-normalization-and-summaries-of-high)

