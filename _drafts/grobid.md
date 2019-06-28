---
layout: post
title:  "GROBID: Structured text from PDFs"
date:   2019-06-28 13:00:09 +0200
categories: text mining
---

In this post, we learn how to turn a pdf into a structured text document. To this end, we will use a tool called [GROBID](https://github.com/kermitt2/grobid) which outputs an xml document. This approach has these advantages over OCR techniques to be
 * light-weighted: computation takes a couple of seconds vs. 3-5 minutes [with tesseract, a state-of-the-art OCR framework](https://github.com/tesseract-ocr/tesseract)
 * easy to use:  you just need to parse xml
 * storage-efficient: the resulting [(tei) xml file](https://tei-c.org/) takes just some kB for an entire paper
 * [REST-full](https://en.wikipedia.org/wiki/Representational_state_transfer): GROBID can be run locally or remotely
  
I'll conclude with a brief discussion of the TEI format which (semi)structures a PDF and of an application of GROBID.

What is GROBID?
==
[GROBID](https://github.com/kermitt2/grobid) stands for GeneRation Of Bibliographic Data. It's a Java tool which transforms a unstructured PDF into a (semi)structured text format. *The* application for GROBID is the analysis of scientific publications. GROBID can extract scholarly units, such as references, affiliations, authors, DOIs, and abstracts by utilizing machine learning and deep learning.

How to set up GROBID?
==
1. Obtain the latest version via GitHub, Docker or simply pull the latest release by
```bash
$ wget https://github.com/kermitt2/grobid/archive/0.5.5.zip && unzip 0.5.5.zip
```
2. Build GROBID using gradle
```bash
$ ./gradlew clean install
```
3. Run the REST service
```bash
$ ./gradlew run
```

which makes the GROBID service available on port ```8070```. 

How to use GROBID
==
GROBID offer a web user interface to interactively use the tool. 
Open <http://localhost:8070> in your browser to do so.

We use [this open access publication](https://www.pnas.org/content/105/49/19052/) for demonstrating GROBID:
```
Nathan, R., Getz, W. M., Revilla, E., Holyoak, M., Kadmon, R., Saltz, D., & Smouse, P. E. (2008). A movement ecology paradigm for unifying organismal movement research. Proceedings of the National Academy of Sciences, 105(49), 19052-19059.
```
I presume this paper is in your home directory stored as ```papers/nathan_2009_movement_ecology.pdf```




Application of GROBID: RobotReviewer
===
Systematic reviews have an important role in clinical trials. One aspect of such reviews is the risk of bias assessment in form of the [PICO (population, intervention, comparators and outcomes) scheme](https://en.wikipedia.org/wiki/PICO_process).
Automatic reports compiled from publications can be a help to identify how individual papers fall into a PICO scheme. RobotReviewer analyzes such trail characteristics and generates an evidence report.

RobotReviewer internally uses GROBID to generate textual information from PDFs.




Hi there,
I am Max and thank you for your time checking out my new blog about code, data and open science. In this blogpost, I will give a brief overview about me and this blog's objective.

Who
====
I am [Maximilian Konzack](https://komax.github.io/), a computer scientist employed as a postdoctoral researcher at [iDiv, the German Centre for Integrative Biodiversity Research Halle-Jena-Leipzig](https://www.idiv.de/en.html). I am keen on many topics: I like programming and research the best when it's put into code. My interests include:
 * visual analytics
 * programming
 * algorithm engineering
 * visualization
 * open source
 * movement ecology
 * text mining
 * biodiversity
 * programming languages
 * tinkering with Raspberry Pis and microcontrollers.

Why
====
Why, yet another blog? Blogs allow people to share their knowledge and to pass it in an accessible and casual way to others. I think this is great and I love reading many, many blogs of others. I'd guess I'll post about my most favorite blogs in the near future.

Secondly, I want to report on some interesting stuff and insights which came along while working on the topics above in a rather casual writings.

What are the topics and what is the objective?
===
Cross-cutting topics revolving around computer science and means to gain knowledge from data and visual representations of data.

I will pinpoint the topics as this blog matures. They will appear pretty scattered in the beginning, but there will be always something about science, coding and data.



How and when?
===
I'll drop a post every other week, but those promises for blogs are probably the same as for adhering to New Year's resolutions.

I do my best to have at least a post within two weeks.


Thank you
===
This is it, my first post.

Feel free to subscribe to the RSS feed if you want to automatically get the latest posts.

  
If you want to get in contact, please drop me an email.


```bash
$ python3 grobid-client.py --n 3 --input ~/papers --output ~/tei_papers processFulltextDocument
```