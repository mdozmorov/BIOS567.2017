---
layout: default
title: BIOS 567, Final project
---

**General description**: The purpose of the final project is for you to gain familiarity with the full spectrum of methods presented in class, applied to the real life data. Additionally, the project should help solidify your statistical and practical understanding of such methods.

For your project, you are required to perform an analysis of a microarray dataset. Your project should be a complete and thorough analysis of your data, and must include application of methods related to data retrieval from GEO, quality control, normalization, expression summaries, batch effect removal, unsupervised (clustering), differential expression analysis, and functional enrichment analysis methods learned in this course.

You must select a microarray dataset to analyze. Prerequisites for a dataset: 

- at least two experimental conditions;
- at least five samples per condition;
- human data, but model organism data are also acceptable;
- any of the following: gene expression, methylation, miRNA expression;
- your own data permitted;

See the [data page]({{site.baseurl}}/presentations/02_data/index.html) for the list of microarray databases and selected datasets. Tips for selecting a dataset:

1. Choose experimental condition of interest (e.g., a particular cancer type, environmental exposure, immunologic or neurologic disease);
2. Explore the NCBI Gene Expression Omnibus (GEO) database, <http://www.ncbi.nlm.nih.gov/geo/> for the presence of such datasets - chances are you will find a microarray dataset for your condition of interest;
3. Read the paper accompanying the dataset, and aim to re-create the described results.

Your project report should be written in R/Markdown format, and compiled as an HTML document. Follow the IMRaD format, <http://sokogskriv.no/en/writing/structure/the-imrad-format/>, when describing your project and results. The text content should be limited to no more than 3,000 words, references and results output not counted towards word limit. Address the following points:

1. A simple and clear description of the dataset you will be using and the research question you are addressing. This should be written in the form of an **Introduction/Background** section(s).

2. A **Methods** section that includes the following:

    - A detailed description of quality assessment measures examined and a results section detailing the results of the quality evaluation;
    - A detailed description of the normalization methods used to process your raw microarray data.
    - A detailed description of expression summaries applied to your dataset.
    - Batch effect correction methods. Describe and apply both `ComBat` (if batch is known) and `sva` (assuming batches are unknown) methods.  
        - Display the data using Principal Components Analysis before-after batch correction.  
        - Use different hierarchical clustering methods to cluster top 10% of the most highly variable genes before-after batch correction, describe your observations
    - Additional methods and results for the unsupervised and supervised learning methods applied to your dataset. Be sure to include a complete description of all methods used in your paper.  
        - Report differentially expressed genes between at least two conditions. Make sure to include all relevant covariates. 
        - Describe filtering steps, multiple testing correction methods, and their appropriatedness for the current study
        - Display boxplots of top 10 differentially expressed genes between the conditions
        - Compare the results with those reported in the original study, if relevant
        - Perform functional enrichment analysis using GSEA and overrepresentation analysis. Use three domains of gene ontologies, and KEGG pathways.
        
3. A **Results** section providing a thorough description of your results. Tables and figures should be numbered and captioned.
4. A **Discussion/Conclusion** section. Either your Introduction or Discussion section should describe how your analysis of the dataset differs from what the authors reported in their published paper.
5. **References**.
6. **Computational component**: code chunks  as well as any data that can't be recreated with the code must be provided to the instructor so it can be tested. Make sure your code is readable (use `formatR::tidy_app()`) and commented.

### Final grading

Review grading policies at [https://mdozmorov.github.io/BIOS567.2017/policies/](https://mdozmorov.github.io/BIOS567.2017/policies/)

- Your final project in the form of your GitHub repository is due Thursday, December 14th at 9:00am.
- Following the submission, you will be assigned to grade one of your peer's project.  
    - The peer-to-peer assignment will be send through Blackboard.
    - Clone your peer's repository on your computer and knit the final project document.
    - Learn from the code and critically assess each section of the final project (Introduction, each Methods/Results subsections, etc.).
    - Critically assess each section as "pass", "fail", "marginal", briefly noting the rationale for the assessment.
    - The goal of your assessment is to learn from the work of others.  
- Your assessment is due to be submitted through Blackboard on or before Monday, December 18th, 9:00am.
- The instructor will formally grade each project, taking your assessment into consideration. 
- The final grades will be entered in the system on or before Tuesday, December 19th, 4:00pm.
