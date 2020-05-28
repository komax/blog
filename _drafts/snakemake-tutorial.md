---
layout: post
title:  "Introduction to Snakemake"
date:   2018-09-03 15:00:09 +0200
categories: bioinformatics workflows pipeline
---

In this tutorial, we will learn how to operate snakemake to create executable workflows.

## Objectives
1. Basic understanding how dependencies between files is used in snakemake
2. Execute snakemake on the command-line
3. Being able to understand why and how map-reduce parallelism is pertinent to handle large inputs

## 1. Hello, snakemake!
Snakemake executes workflows which consist of multiple rules. Each rule is a unit/step in the data analysis. You can think of a typical data analysis workflow:
1. Preprocessing the dataset
2. Data cleansing and transforms
3. Analyze the data (compute metrics, training models)
4. Evaluate the results (calculate statistics, cross-validation)
5. Plot the results

We will model data analysis pipeline which resembles such a data workflow.
Let's execute our very first rule:


```python
! snakemake hello
```

    [33mBuilding DAG of jobs...[0m
    [33mUsing shell: /usr/bin/bash[0m
    [33mProvided cores: 4[0m
    [33mRules claiming more threads will be scaled down.[0m
    [33mJob counts:
    	count	jobs
    	1	hello
    	1[0m
    [32m[0m
    [32m[Tue Feb 18 17:34:23 2020][0m
    [32mrule hello:
        jobid: 0[0m
    [32m[0m
    [33mJob counts:
    	count	jobs
    	1	hello
    	1[0m
    hello world
    [32m[Tue Feb 18 17:34:23 2020][0m
    [32mFinished job 0.[0m
    [32m1 of 1 steps (100%) done[0m
    [33mComplete log: /home/max/code/snakemake-tutorial/.snakemake/log/2020-02-18T173423.021843.snakemake.log[0m


Great! This worked well! The rule outputted ```hello world```, such a classic thing to do.

Next, let's look up which rules exist in the ```Snakefile```:


```python
! snakemake --list
```

    [32mall[0m
    [32mgenerate_data[0m
    [32mchunk_dataset[0m
    [32madd_country[0m
    [32mmerge_results[0m
    [32mplot_results[0m
    [32mhello[0m
    [32mclean[0m


## 2. Clean snakemake

Intriguing, this list gives us a clue how our rules are ordered:
1. ```generate_data```: we first generate data, 
2. ```chunk_dataset```: chunk the data in multiple pieces, 
3. ```add_country```: apply a transform by adding a country to each observation,
4. ```merge_results```: we merge the results from step 3,
5. ```plot_results```: finally we plot the results.

We already know what the rule ```hello``` does. We will cover what and how the rule ```all``` operates after we learned how the rules above are lined up.

Let's focus on a much simpler rule: ```clean``` wipes intermediate output (data, plots, CSVs, etc.) of previous snakemake runs from our current working directory.


```python
! snakemake clean
```

    [33mBuilding DAG of jobs...[0m
    [33mUsing shell: /usr/bin/bash[0m
    [33mProvided cores: 4[0m
    [33mRules claiming more threads will be scaled down.[0m
    [33mJob counts:
    	count	jobs
    	1	clean
    	1[0m
    [32m[0m
    [32m[Tue Feb 18 17:34:33 2020][0m
    [32mrule clean:
        jobid: 0[0m
    [32m[0m
    [33mJob counts:
    	count	jobs
    	1	clean
    	1[0m
    [32m[Tue Feb 18 17:34:33 2020][0m
    [32mFinished job 0.[0m
    [32m1 of 1 steps (100%) done[0m
    [33mComplete log: /home/max/code/snakemake-tutorial/.snakemake/log/2020-02-18T173433.136755.snakemake.log[0m


Smooth, a nice, clean directory.

Wait, what is this ```.snakemake``` directory? ```.snakemake``` stores information about when and which rules were executed and for how long. We will use these logs to plot some statistics after we ran some more comprehensive workflows. To do so, we will use Python, R and shell in interoperable rules without any code to glue them together.

## 3. Generate a dataset
The rule ```generate_data``` makes use of a Python script ```generate-data.py``` which outputs ```my_dataset.csv``` in the folder ```data```.

We can either 
1. call the rule ```generate_data``` by typing: 
```bash
$ snakemake generate_data
```

2. or request to generate the output file ```my_dataset.csv``` by executing:
```bash
$ snakemake data/my_dataset.csv
```


```python
! snakemake generate_data
```

    [33mBuilding DAG of jobs...[0m
    [33mUsing shell: /usr/bin/bash[0m
    [33mProvided cores: 4[0m
    [33mRules claiming more threads will be scaled down.[0m
    [33mJob counts:
    	count	jobs
    	1	generate_data
    	1[0m
    [32m[0m
    [32m[Tue Feb 18 17:34:40 2020][0m
    [32mrule generate_data:
        output: data/my_dataset.csv
        jobid: 0[0m
    [32m[0m
    Generating a new dataset...
    Added observation: (site=site_A1, species=genus sp.a, abundance=40)
    Added observation: (site=site_A1, species=genus sp.b, abundance=7)
    Added observation: (site=site_A1, species=genus sp.c, abundance=1)
    Added observation: (site=site_A1, species=genus sp.d, abundance=17)
    Added observation: (site=site_A1, species=genus sp.e, abundance=15)
    Added observation: (site=site_A1, species=genus sp.f, abundance=14)
    Added observation: (site=site_A1, species=genus sp.g, abundance=8)
    Added observation: (site=site_A1, species=genus sp.h, abundance=6)
    Added observation: (site=site_A1, species=genus sp.i, abundance=34)
    Added observation: (site=site_A1, species=genus sp.j, abundance=5)
    Added observation: (site=site_A1, species=genus sp.k, abundance=37)
    Added observation: (site=site_A2, species=genus sp.a, abundance=27)
    Added observation: (site=site_A2, species=genus sp.b, abundance=2)
    Added observation: (site=site_A2, species=genus sp.c, abundance=1)
    Added observation: (site=site_A2, species=genus sp.d, abundance=5)
    Added observation: (site=site_A2, species=genus sp.e, abundance=13)
    Added observation: (site=site_A2, species=genus sp.f, abundance=14)
    Added observation: (site=site_A2, species=genus sp.g, abundance=32)
    Added observation: (site=site_A2, species=genus sp.h, abundance=38)
    Added observation: (site=site_A2, species=genus sp.i, abundance=1)
    Added observation: (site=site_A2, species=genus sp.j, abundance=35)
    Added observation: (site=site_A2, species=genus sp.k, abundance=12)
    Added observation: (site=site_A3, species=genus sp.a, abundance=41)
    Added observation: (site=site_A3, species=genus sp.b, abundance=34)
    Added observation: (site=site_A3, species=genus sp.c, abundance=26)
    Added observation: (site=site_A3, species=genus sp.d, abundance=14)
    Added observation: (site=site_A3, species=genus sp.e, abundance=28)
    Added observation: (site=site_A3, species=genus sp.f, abundance=37)
    Added observation: (site=site_A3, species=genus sp.g, abundance=17)
    Added observation: (site=site_A3, species=genus sp.h, abundance=0)
    Added observation: (site=site_A3, species=genus sp.i, abundance=10)
    Added observation: (site=site_A3, species=genus sp.j, abundance=27)
    Added observation: (site=site_A3, species=genus sp.k, abundance=21)
    Added observation: (site=site_A4, species=genus sp.a, abundance=17)
    Added observation: (site=site_A4, species=genus sp.b, abundance=9)
    Added observation: (site=site_A4, species=genus sp.c, abundance=13)
    Added observation: (site=site_A4, species=genus sp.d, abundance=21)
    Added observation: (site=site_A4, species=genus sp.e, abundance=6)
    Added observation: (site=site_A4, species=genus sp.f, abundance=5)
    Added observation: (site=site_A4, species=genus sp.g, abundance=24)
    Added observation: (site=site_A4, species=genus sp.h, abundance=6)
    Added observation: (site=site_A4, species=genus sp.i, abundance=22)
    Added observation: (site=site_A4, species=genus sp.j, abundance=22)
    Added observation: (site=site_A4, species=genus sp.k, abundance=38)
    Completed saving dataset as CSV.
    [32m[Tue Feb 18 17:34:41 2020][0m
    [32mFinished job 0.[0m
    [32m1 of 1 steps (100%) done[0m
    [33mComplete log: /home/max/code/snakemake-tutorial/.snakemake/log/2020-02-18T173440.773803.snakemake.log[0m


Neat, we created a dataset from random samples.

If we try to rerun the same rule, ```snakemake``` detects that we already generated ```my_dataset.csv```.


```python
! snakemake generate_data
```

    [33mBuilding DAG of jobs...[0m
    [33mNothing to be done.[0m
    [33mComplete log: /home/max/code/snakemake-tutorial/.snakemake/log/2020-02-18T173446.112048.snakemake.log[0m


So, nothing happens.

### 4. Split the dataset

Next, we chunk the dataset into multiple pieces of same size by calling:


```python
! snakemake chunk_dataset
```

    [33mBuilding DAG of jobs...[0m
    [33mUsing shell: /usr/bin/bash[0m
    [33mProvided cores: 4[0m
    [33mRules claiming more threads will be scaled down.[0m
    [33mJob counts:
    	count	jobs
    	1	chunk_dataset
    	1[0m
    [32m[0m
    [32m[Tue Feb 18 17:34:59 2020][0m
    [32mrule chunk_dataset:
        input: data/my_dataset.csv
        output: data/blocks/subset_0.csv, data/blocks/subset_1.csv, data/blocks/subset_2.csv, data/blocks/subset_3.csv
        jobid: 0[0m
    [32m[0m
    [32m[Tue Feb 18 17:35:00 2020][0m
    [32mFinished job 0.[0m
    [32m1 of 1 steps (100%) done[0m
    [33mComplete log: /home/max/code/snakemake-tutorial/.snakemake/log/2020-02-18T173459.513863.snakemake.log[0m


Great, we now have four (nearly) equal-sized chunk of our dataset. So, why? Let's start our excursion into parallelism:

## 5. Map-reduce parallelism
Map-reduce paradigms become popular to handle large amount of data in parallel (e.g., [Apache Hadoop](https://hadoop.apache.org/) or [Apache Spark](https://spark.apache.org/) among others). The main idea of a map-reduce approach is a two-phase computation:
1. Map step: apply a function to each element/sublist and yield a transformed return value, e.g. x => 2**x
2. Reduce step: merge the elements from 1. to a data collection back or fold them to discrete value

The map step can be carried out in parallel, whereas the reduce step requires that all map steps have successfully been carried out beforehand.

Snakemake support such a parallelization in workflows. Let's investigate which rules can be executed in parallel:


```python
! snakemake --dag merge_results | dot -Tsvg >dag.svg
```

    [33mBuilding DAG of jobs...[0m


![](dag.svg)

1. ```add_country``` appends a country to each observation of the dataset. As this operation is independent from another observation, we are able to execute this rule in parallel as a map function.
2. After we completed ```add_country``` for each of the four subsets, we merge the results into a single CSV.

Alright, let's trigger the execution of the ```merge_results``` rule and it's preceding steps which hasn't been executed thus far (the ones with solid edges):


```python
! snakemake merge_results
```

    [33mBuilding DAG of jobs...[0m
    [33mUsing shell: /usr/local/bin/bash[0m
    [33mProvided cores: 4[0m
    [33mRules claiming more threads will be scaled down.[0m
    [33mJob counts:
    	count	jobs
    	4	add_country
    	1	merge_results
    	5[0m
    [32m[0m
    [32m[Tue Feb 18 16:11:20 2020][0m
    [32mrule add_country:
        input: data/blocks/subset_1.csv
        output: results/blocks/datasubset_w_country_1.csv
        jobid: 2
        wildcards: chunk=1[0m
    [32m[0m
    [32m[Tue Feb 18 16:11:20 2020][0m
    [32mrule add_country:
        input: data/blocks/subset_0.csv
        output: results/blocks/datasubset_w_country_0.csv
        jobid: 1
        wildcards: chunk=0[0m
    [32m[0m
    [32m[Tue Feb 18 16:11:20 2020][0m
    [32mrule add_country:
        input: data/blocks/subset_3.csv
        output: results/blocks/datasubset_w_country_3.csv
        jobid: 4
        wildcards: chunk=3[0m
    [32m[0m
    [32m[Tue Feb 18 16:11:20 2020][0m
    [32mrule add_country:
        input: data/blocks/subset_2.csv
        output: results/blocks/datasubset_w_country_2.csv
        jobid: 3
        wildcards: chunk=2[0m
    [32m[0m
    [1] "Adding countries..."
    [1] "Done with file = results/blocks/datasubset_w_country_3.csv"
    [1] "Adding countries..."
    [1] "Done with file = results/blocks/datasubset_w_country_2.csv"
    [1] "Adding countries..."
    [1] "Done with file = results/blocks/datasubset_w_country_0.csv"
    [32m[Tue Feb 18 16:11:20 2020][0m
    [32mFinished job 4.[0m
    [32m1 of 5 steps (20%) done[0m
    [32m[Tue Feb 18 16:11:20 2020][0m
    [32mFinished job 3.[0m
    [32m2 of 5 steps (40%) done[0m
    [1] "Adding countries..."
    [1] "Done with file = results/blocks/datasubset_w_country_1.csv"
    [32m[Tue Feb 18 16:11:20 2020][0m
    [32mFinished job 1.[0m
    [32m3 of 5 steps (60%) done[0m
    [32m[Tue Feb 18 16:11:20 2020][0m
    [32mFinished job 2.[0m
    [32m4 of 5 steps (80%) done[0m
    [32m[0m
    [32m[Tue Feb 18 16:11:20 2020][0m
    [32mrule merge_results:
        input: results/blocks/datasubset_w_country_0.csv, results/blocks/datasubset_w_country_1.csv, results/blocks/datasubset_w_country_2.csv, results/blocks/datasubset_w_country_3.csv
        output: results/dataset_results.csv
        jobid: 0[0m
    [32m[0m
    [32m[Tue Feb 18 16:11:20 2020][0m
    [32mFinished job 0.[0m
    [32m5 of 5 steps (100%) done[0m
    [33mComplete log: /Users/mk21womu/code/snakemake-tutorial/.snakemake/log/2020-02-18T161120.376772.snakemake.log[0m


We can see in the output of the computations are interleaving. This is due to the parallelization.

## 6. Plot the results
Finally, we plot the results by making use of ggplot. We bin the abundances and show often these abundances occur in specific countries:


```python
! snakemake plot_results
```

    [33mBuilding DAG of jobs...[0m
    [33mUsing shell: /usr/local/bin/bash[0m
    [33mProvided cores: 4[0m
    [33mRules claiming more threads will be scaled down.[0m
    [33mJob counts:
    	count	jobs
    	1	plot_results
    	1[0m
    [32m[0m
    [32m[Tue Feb 18 16:11:21 2020][0m
    [32mrule plot_results:
        input: results/dataset_results.csv
        output: plots/abundance_histogram.png
        jobid: 0[0m
    [32m[0m
    `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
    Saving 7 x 7 in image
    `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
    [32m[Tue Feb 18 16:11:22 2020][0m
    [32mFinished job 0.[0m
    [32m1 of 1 steps (100%) done[0m
    [33mComplete log: /Users/mk21womu/code/snakemake-tutorial/.snakemake/log/2020-02-18T161121.240098.snakemake.log[0m


![](plots/abundance_histogram.png)

## 7. Snakemake reports
Snakemake comes with batteries loaded to provide run-time statistics.
1. We wipe our output directories by running 
```bash
$ snakemake clean
```
2. We request to run the entire pipeline:
```bash
$ snakemake
```
3. Finally we generate a report as a html webpage:
```bash
$ snakemake --report report.html
```
4. We inspect the report with a browser


```python
! snakemake clean && snakemake && snakemake --report report.html
```

    [33mBuilding DAG of jobs...[0m
    [33mUsing shell: /usr/local/bin/bash[0m
    [33mProvided cores: 4[0m
    [33mRules claiming more threads will be scaled down.[0m
    [33mJob counts:
    	count	jobs
    	1	clean
    	1[0m
    [32m[0m
    [32m[Tue Feb 18 16:11:23 2020][0m
    [32mrule clean:
        jobid: 0[0m
    [32m[0m
    [33mJob counts:
    	count	jobs
    	1	clean
    	1[0m
    [32m[Tue Feb 18 16:11:23 2020][0m
    [32mFinished job 0.[0m
    [32m1 of 1 steps (100%) done[0m
    [33mComplete log: /Users/mk21womu/code/snakemake-tutorial/.snakemake/log/2020-02-18T161123.150446.snakemake.log[0m
    [33mBuilding DAG of jobs...[0m
    [33mUsing shell: /usr/local/bin/bash[0m
    [33mProvided cores: 4[0m
    [33mRules claiming more threads will be scaled down.[0m
    [33mJob counts:
    	count	jobs
    	4	add_country
    	1	all
    	1	chunk_dataset
    	1	generate_data
    	1	merge_results
    	1	plot_results
    	9[0m
    [32m[0m
    [32m[Tue Feb 18 16:11:23 2020][0m
    [32mrule generate_data:
        output: data/my_dataset.csv
        jobid: 8[0m
    [32m[0m
    Generating a new dataset...
    Added observation: (site=site_A1, species=genus sp.a, abundance=40)
    Added observation: (site=site_A1, species=genus sp.b, abundance=7)
    Added observation: (site=site_A1, species=genus sp.c, abundance=1)
    Added observation: (site=site_A1, species=genus sp.d, abundance=17)
    Added observation: (site=site_A1, species=genus sp.e, abundance=15)
    Added observation: (site=site_A1, species=genus sp.f, abundance=14)
    Added observation: (site=site_A1, species=genus sp.g, abundance=8)
    Added observation: (site=site_A1, species=genus sp.h, abundance=6)
    Added observation: (site=site_A1, species=genus sp.i, abundance=34)
    Added observation: (site=site_A1, species=genus sp.j, abundance=5)
    Added observation: (site=site_A1, species=genus sp.k, abundance=37)
    Added observation: (site=site_A2, species=genus sp.a, abundance=27)
    Added observation: (site=site_A2, species=genus sp.b, abundance=2)
    Added observation: (site=site_A2, species=genus sp.c, abundance=1)
    Added observation: (site=site_A2, species=genus sp.d, abundance=5)
    Added observation: (site=site_A2, species=genus sp.e, abundance=13)
    Added observation: (site=site_A2, species=genus sp.f, abundance=14)
    Added observation: (site=site_A2, species=genus sp.g, abundance=32)
    Added observation: (site=site_A2, species=genus sp.h, abundance=38)
    Added observation: (site=site_A2, species=genus sp.i, abundance=1)
    Added observation: (site=site_A2, species=genus sp.j, abundance=35)
    Added observation: (site=site_A2, species=genus sp.k, abundance=12)
    Added observation: (site=site_A3, species=genus sp.a, abundance=41)
    Added observation: (site=site_A3, species=genus sp.b, abundance=34)
    Added observation: (site=site_A3, species=genus sp.c, abundance=26)
    Added observation: (site=site_A3, species=genus sp.d, abundance=14)
    Added observation: (site=site_A3, species=genus sp.e, abundance=28)
    Added observation: (site=site_A3, species=genus sp.f, abundance=37)
    Added observation: (site=site_A3, species=genus sp.g, abundance=17)
    Added observation: (site=site_A3, species=genus sp.h, abundance=0)
    Added observation: (site=site_A3, species=genus sp.i, abundance=10)
    Added observation: (site=site_A3, species=genus sp.j, abundance=27)
    Added observation: (site=site_A3, species=genus sp.k, abundance=21)
    Added observation: (site=site_A4, species=genus sp.a, abundance=17)
    Added observation: (site=site_A4, species=genus sp.b, abundance=9)
    Added observation: (site=site_A4, species=genus sp.c, abundance=13)
    Added observation: (site=site_A4, species=genus sp.d, abundance=21)
    Added observation: (site=site_A4, species=genus sp.e, abundance=6)
    Added observation: (site=site_A4, species=genus sp.f, abundance=5)
    Added observation: (site=site_A4, species=genus sp.g, abundance=24)
    Added observation: (site=site_A4, species=genus sp.h, abundance=6)
    Added observation: (site=site_A4, species=genus sp.i, abundance=22)
    Added observation: (site=site_A4, species=genus sp.j, abundance=22)
    Added observation: (site=site_A4, species=genus sp.k, abundance=38)
    Completed saving dataset as CSV.
    [32m[Tue Feb 18 16:11:24 2020][0m
    [32mFinished job 8.[0m
    [32m1 of 9 steps (11%) done[0m
    [32m[0m
    [32m[Tue Feb 18 16:11:24 2020][0m
    [32mrule chunk_dataset:
        input: data/my_dataset.csv
        output: data/blocks/subset_0.csv, data/blocks/subset_1.csv, data/blocks/subset_2.csv, data/blocks/subset_3.csv
        jobid: 7[0m
    [32m[0m
    [32m[Tue Feb 18 16:11:24 2020][0m
    [32mFinished job 7.[0m
    [32m2 of 9 steps (22%) done[0m
    [32m[0m
    [32m[Tue Feb 18 16:11:24 2020][0m
    [32mrule add_country:
        input: data/blocks/subset_1.csv
        output: results/blocks/datasubset_w_country_1.csv
        jobid: 4
        wildcards: chunk=1[0m
    [32m[0m
    [32m[Tue Feb 18 16:11:24 2020][0m
    [32mrule add_country:
        input: data/blocks/subset_3.csv
        output: results/blocks/datasubset_w_country_3.csv
        jobid: 6
        wildcards: chunk=3[0m
    [32m[0m
    [32m[0m
    [32m[Tue Feb 18 16:11:24 2020][0m
    [32mrule add_country:
        input: data/blocks/subset_0.csv
        output: results/blocks/datasubset_w_country_0.csv
        jobid: 3
        wildcards: chunk=0[0m
    [32m[0m
    [32m[0m
    [32m[Tue Feb 18 16:11:24 2020][0m
    [32mrule add_country:
        input: data/blocks/subset_2.csv
        output: results/blocks/datasubset_w_country_2.csv
        jobid: 5
        wildcards: chunk=2[0m
    [32m[0m
    [1] "Adding countries..."
    [1] "Done with file = results/blocks/datasubset_w_country_3.csv"
    [1] "Adding countries..."
    [1] "Done with file = results/blocks/datasubset_w_country_1.csv"
    [1] "Adding countries..."
    [1] "Done with file = results/blocks/datasubset_w_country_0.csv"
    [1] "Adding countries..."
    [32m[Tue Feb 18 16:11:25 2020][0m
    [32mFinished job 6.[0m
    [1][32m3 of 9 steps (33%) done[0m
     "Done with file = results/blocks/datasubset_w_country_2.csv"
    [32m[Tue Feb 18 16:11:25 2020][0m
    [32mFinished job 4.[0m
    [32m4 of 9 steps (44%) done[0m
    [32m[Tue Feb 18 16:11:25 2020][0m
    [32mFinished job 3.[0m
    [32m5 of 9 steps (56%) done[0m
    [32m[Tue Feb 18 16:11:25 2020][0m
    [32mFinished job 5.[0m
    [32m6 of 9 steps (67%) done[0m
    [32m[0m
    [32m[Tue Feb 18 16:11:25 2020][0m
    [32mrule merge_results:
        input: results/blocks/datasubset_w_country_0.csv, results/blocks/datasubset_w_country_1.csv, results/blocks/datasubset_w_country_2.csv, results/blocks/datasubset_w_country_3.csv
        output: results/dataset_results.csv
        jobid: 2[0m
    [32m[0m
    [32m[Tue Feb 18 16:11:25 2020][0m
    [32mFinished job 2.[0m
    [32m7 of 9 steps (78%) done[0m
    [32m[0m
    [32m[Tue Feb 18 16:11:25 2020][0m
    [32mrule plot_results:
        input: results/dataset_results.csv
        output: plots/abundance_histogram.png
        jobid: 1[0m
    [32m[0m
    `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
    Saving 7 x 7 in image
    `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
    [32m[Tue Feb 18 16:11:26 2020][0m
    [32mFinished job 1.[0m
    [32m8 of 9 steps (89%) done[0m
    [32m[0m
    [32m[Tue Feb 18 16:11:26 2020][0m
    [32mrule all:
        input: plots/abundance_histogram.png
        jobid: 0[0m
    [32m[0m
    [33mJob counts:
    	count	jobs
    	1	all
    	1[0m
    Done with executing the workflow.
    The results are stored here: 
    [32m[Tue Feb 18 16:11:26 2020][0m
    [32mFinished job 0.[0m
    [32m9 of 9 steps (100%) done[0m
    [33mComplete log: /Users/mk21womu/code/snakemake-tutorial/.snakemake/log/2020-02-18T161123.563650.snakemake.log[0m
    [33mBuilding DAG of jobs...[0m
    [33mCreating report...[0m
    /Users/mk21womu/miniconda3/envs/snakemake-tutorial/lib/python3.7/site-packages/pygraphviz/agraph.py:1341: RuntimeWarning: Warning: Could not load "/Users/mk21womu/miniconda3/envs/snakemake-tutorial/lib/graphviz/libgvplugin_pango.6.dylib" - file not found
    
      warnings.warn(b"".join(errors).decode(self.encoding), RuntimeWarning)
    [33mLoading script code for rule plot_results[0m
    [33mLoading script code for rule add_country[0m
    [33mLoading script code for rule chunk_dataset[0m
    [33mLoading script code for rule generate_data[0m
    [33mReport created.[0m


## Sum up
We learned to integrate Python, bash and R to build reproducible workflows in Snakemake. A workflow consists of multiple rules. A rule in Snakemake defines its dependencies via input and output files. These dependencies permits us to model and run consecutive pipeline constituted of multiple rules. We covered more advanced features like parallelization of rules and report generation.

