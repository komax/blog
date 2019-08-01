# Naming species:  taxize in R and GFBio’s REST API

Naming living organisms is ubiquitous in biological sciences. Looking up, cataloging, categorizing, and grouping species' names and data is central to most data analyses in biodiversity and ecology.

Scientific names are constituted as binomial names. The first part specifies the genus and the second part the actual species. Sometimes, a third part describes a subspecies of the species. In this case, the scientific name is trinomial. Some researchers compiled a [list of curiosities in species names](http://www.curioustaxonomy.net/rules.html).

To guide researchers in defining new names, standards exist. Renaming and merging names into existing genera occurs through new technological advances and means which allows scientists to explore species' traits more accurately.

[Curiosities of Biological Nomenclature: Rules](http://www.curioustaxonomy.net/rules.html)

[Binomial nomenclature - Wikipedia](https://en.wikipedia.org/wiki/Binomial_nomenclature)

[International Code of Zoological Nomenclature](https://www.nhm.ac.uk/hosted-sites/iczn/code/)

## Goals

In this post, we will transform species' common and scientific names back and forth. Unifying names is a common task in data analyses which integrates multiple sources. For this purpose, we use R to obtain some hands-on experience:

1. We use the `taxize` package to execute these transforms. `taxize` is pretty versatile and allows us to use many services/backends,
2. We develop our own custom REST client which translates common names to scientific names by making use [GFBio's terminology service](https://terminologies.gfbio.org/api/). [GFBio](https://www.gfbio.org/) is multidisciplinary hub of scientists who work provide data services for ecology and biodiversity.

## Taxize in R

[ropensci/taxize](https://github.com/ropensci/taxize)

## REST API with GFBio

[GFBio website - Welcome](https://www.gfbio.org/)

TODO httr vs rCurl

## Summary

This blog post concerned procedures of naming species in R. We covered how to make use of the package `taxize` which offers functions to translate between common names and scientific names back and forth. Then, we have seen  how to develop a slick REST client in R which pulled data from GFBio's terminology service. The R package TODO httr vs. rCurl enabled us to develop such a REST client with few lines in R. By doing so, we learned how to  handle REST APIs.
