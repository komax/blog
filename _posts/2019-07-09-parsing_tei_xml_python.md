---
layout: post
title:  "Parsing TEI XML documents with Python"
date:   2019-07-09 13:51:07 +0200
categories: text python xml
---

In the previous blogpost, we learned about [GROBID which outputs TEI XMLs from PDFs as input](https://komax.github.io/blog/text/mining/grobid/). We now attain some hand-on experience with juggling TEI XML documents.

First, we interactively parse a TEI XML document using [Beautiful Soup](https://www.crummy.com/software/BeautifulSoup/bs4/doc/). Then, we map a TEI document to a [Python](https://www.python.org/) object allowing us to systemically retrieve publication's information with just two lines of Python code. We use this implementation to generate a [pandas data frame](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.html) and to store the extracted information as a CSV.

## Interactive XML parsing with Beautiful Soup
I presume you setup Python and installed the following packages:
 * ```beautifulsoup4```
 * ```lxml```
 * ```pandas```
 
For more information how to do this, please check out this [README](https://github.com/komax/teitocsv).

We briefly review now how we can parse XML and retrieve a paper's title, digital object identifier (DOI) and abstract.
First of all, we need to import ```Beautiful Soup```:


```python
from bs4 import BeautifulSoup
```

Next, we open a file handle and read the XML using the ```lxml``` parser. This parser transforms the XML document into a traversable tree, a beautiful soup stored in variable ```soup```. 


```python
tei_doc = 'nathan_2009_movement_ecology.tei.xml'
with open(tei_doc, 'r') as tei:
    soup = BeautifulSoup(tei, 'lxml')
```

Let's fish in this soup for the paper's title by selecting the element/tag ```title```:


```python
soup.title
```




    <title level="a" type="main">A movement ecology paradigm for unifying organismal movement research</title>



Unfortunately, this expression returns the entire element with its enclosing tags. As a remedy, Beautiful Soup offers a versatile ```getText()``` to output the plain text contained in this element:


```python
soup.title.getText()
```




    'A movement ecology paradigm for unifying organismal movement research'



```getText()``` returns a string of the text inside a tag and recursively transform all subelements accordingly. This is handy if we want to output the paper's abstract without any XML. We can apply this functionality to the ```abstract``` element:


```python
soup.abstract
```




    <abstract>
    <div xmlns="http://www.tei-c.org/ns/1.0"><p>Movement of individual organisms is fundamental to life, quilting our planet in a rich tapestry of phenomena with diverse implications for ecosystems and humans. Movement research is both plentiful and insightful, and recent methodological advances facilitate obtaining a detailed view of individual movement. Yet, we lack a general unifying paradigm, derived from first principles, which can place movement studies within a common context and advance the development of a mature scientific discipline. This introductory article to the Movement Ecology Special Feature proposes a paradigm that integrates conceptual, theoretical, methodological, and empirical frameworks for studying movement of all organisms, from microbes to trees to elephants. We introduce a conceptual framework depicting the interplay among four basic mechanistic components of organismal movement: the internal state (why move?), motion (how to move?), and navigation (when and where to move?) capacities of the individual and the external factors affecting movement. We demonstrate how the proposed framework aids the study of various taxa and movement types; promotes the formulation of hypotheses about movement; and complements existing biomechanical, cognitive, random, and optimality paradigms of movement. The proposed framework integrates eclectic research on movement into a structured paradigm and aims at providing a basis for hypothesis generation and a vehicle facilitating the understanding of the causes, mechanisms, and spatiotemporal patterns of movement and their role in various ecological and evolutionary processes.</p><p>''Now we must consider in general the common reason for moving with any movement whatever.'' (Aristotle, De Motu Animalium, 4th century B.C.) motion capacity 񮽙 navigation capacity 񮽙 migration 񮽙 dispersal 񮽙 foraging</p></div>
    </abstract>



As you can see in the output above, an abstract entails multiple ```p```s and ```div``` elements. GROBID (semi)structures the abstract in the first paragraph (```p```), the actual abstract, and additional information in the second paragraph like important tags and a quote. Suppose we are interested in the entire abstract as plain text, we can return the abstract as a string by invoking:


```python
soup.abstract.getText(separator=' ', strip=True)
```




    "Movement of individual organisms is fundamental to life, quilting our planet in a rich tapestry of phenomena with diverse implications for ecosystems and humans. Movement research is both plentiful and insightful, and recent methodological advances facilitate obtaining a detailed view of individual movement. Yet, we lack a general unifying paradigm, derived from first principles, which can place movement studies within a common context and advance the development of a mature scientific discipline. This introductory article to the Movement Ecology Special Feature proposes a paradigm that integrates conceptual, theoretical, methodological, and empirical frameworks for studying movement of all organisms, from microbes to trees to elephants. We introduce a conceptual framework depicting the interplay among four basic mechanistic components of organismal movement: the internal state (why move?), motion (how to move?), and navigation (when and where to move?) capacities of the individual and the external factors affecting movement. We demonstrate how the proposed framework aids the study of various taxa and movement types; promotes the formulation of hypotheses about movement; and complements existing biomechanical, cognitive, random, and optimality paradigms of movement. The proposed framework integrates eclectic research on movement into a structured paradigm and aims at providing a basis for hypothesis generation and a vehicle facilitating the understanding of the causes, mechanisms, and spatiotemporal patterns of movement and their role in various ecological and evolutionary processes. ''Now we must consider in general the common reason for moving with any movement whatever.'' (Aristotle, De Motu Animalium, 4th century B.C.) motion capacity \U0006ef59 navigation capacity \U0006ef59 migration \U0006ef59 dispersal \U0006ef59 foraging"



Let's walk through the parameters:
 * ```strip=True``` ensures that we don't have any newlines from the original XML document
 * ```separator=' '``` specifies which character (or string) we want to use as delimiter between subelements/children in the abstract. The default is ```'\n'```, but in our case we simply want to concatenate all tags contained the ```abstract``` element.

Now, we are able to search systemically whether the abstract contains terms of interest. Let's check whether the abstract contains movement, ecology and computer.


```python
abstract_text = soup.abstract.getText(separator=' ', strip=True)
'movement' in abstract_text.lower(), 'ecology' in abstract_text.lower(), 'computer' in abstract_text.lower()
```




    (True, True, False)


## Data mapping TEI to python objects
In the previous section, we manually extracted information from a publication. We reuse this code to programmatically extract textual information in a TEI XML document. First of all, we define a function to transform a TEI document into a ```BeautitfulSoup```:


```python
def read_tei(tei_file):
    with open(tei_file, 'r') as tei:
        soup = BeautifulSoup(tei, 'lxml')
        return soup
    raise RuntimeError('Cannot generate a soup from the input')
```


```python
soup = read_tei('nathan_2009_movement_ecology.tei.xml')
```


```python
soup.title.getText()
```




    'A movement ecology paradigm for unifying organismal movement research'




```python
soup.foobarelem.getText()
```


    ---------------------------------------------------------------------------

    AttributeError                            Traceback (most recent call last)

    <ipython-input-52-01067cf73e09> in <module>
    ----> 1 soup.foobarelem.getText()
    

    AttributeError: 'NoneType' object has no attribute 'getText'


Suppose we reference an element, which might exist for some documents while for others it does not. BeautifulSoup will yield an ```AttributeError``` then. We can bypass this by defining a function which retrieves the text only if the tag exists. Otherwise, we define a default value.


```python
def elem_to_text(elem, default=''):
    if elem:
        return elem.getText()
    else:
        return default
```


```python
elem_to_text(soup.foobarelem, default="NA")
```




    'NA'



The ```elem_to_text()``` function works like charm and is good practice as well. Alternatively, we can use ```find``` to select an element with this layout ```<idno type='DOI'>...</idno>```.


```python
idno_elem = soup.find('idno', type='DOI')
print(f"The DOI is {idno_elem.getText()}")
```

    The DOI is 10.1073/pnas.0800375105


We obtained the DOI for a publication. This element can also be used to extract a ISBN by setting ```type='ISBN'```.

To store authors' names, we define a our first class. If you use Python in version below 3.7, checkout [namedtuples](https://docs.python.org/3.6/library/collections.html#collections.namedtuple) to mimic a dataclass.


```python
from dataclasses import dataclass

@dataclass
class Person:
    firstname: str
    middlename: str
    surname: str

turing_author = Person(firstname='Alan', middlename='M', surname='Turing')

f"{turing_author.firstname} {turing_author.surname} authored many influential publications in computer science."
```




    'Alan Turing authored many influential publications in computer science.'



We equipped ourselves with all code to write a class integrating the text extraction features we have seen thus far. A ```TEIFile``` has 
 * a filename referring to the file which needs to be parsed,
 * a property ```doi``` to return a paper's doi,
 * the paper's ```title`` property,
 * a property for the abstract, and
 * ```authors```, a property to return all authors as a list of ```Person```s.


```python
class TEIFile(object):
    def __init__(self, filename):
        self.filename = filename
        self.soup = read_tei(filename)
        self._text = None
        self._title = ''
        self._abstract = ''

    @property
    def doi(self):
        idno_elem = self.soup.find('idno', type='DOI')
        if not idno_elem:
            return ''
        else:
            return idno_elem.getText()

    @property
    def title(self):
        if not self._title:
            self._title = self.soup.title.getText()
        return self._title

    @property
    def abstract(self):
        if not self._abstract:
            abstract = self.soup.abstract.getText(separator=' ', strip=True)
            self._abstract = abstract
        return self._abstract

    @property
    def authors(self):
        authors_in_header = self.soup.analytic.find_all('author')

        result = []
        for author in authors_in_header:
            persname = author.persname
            if not persname:
                continue
            firstname = elem_to_text(persname.find("forename", type="first"))
            middlename = elem_to_text(persname.find("forename", type="middle"))
            surname = elem_to_text(persname.surname)
            person = Person(firstname, middlename, surname)
            result.append(person)
        return result
    
    @property
    def text(self):
        if not self._text:
            divs_text = []
            for div in self.soup.body.find_all("div"):
                # div is neither an appendix nor references, just plain text.
                if not div.get("type"):
                    div_text = div.get_text(separator=' ', strip=True)
                    divs_text.append(div_text)

            plain_text = " ".join(divs_text)
            self._text = plain_text
        return self._text
```

Let's review how to use this class:


```python
tei = TEIFile('nathan_2009_movement_ecology.tei.xml')
f"The authors of the paper entitled '{tei.title}' are {tei.authors}"
```




    "The authors of the paper entitled 'A movement ecology paradigm for unifying organismal movement research' are [Person(firstname='R', middlename='', surname='Nathan'), Person(firstname='W', middlename='M', surname='Getz'), Person(firstname='E', middlename='', surname='Revilla'), Person(firstname='M', middlename='', surname='Holyoak'), Person(firstname='R', middlename='', surname='Kadmon'), Person(firstname='D', middlename='', surname='Saltz'), Person(firstname='P', middlename='E', surname='Smouse')]"




```python
tei.abstract
```




    "Movement of individual organisms is fundamental to life, quilting our planet in a rich tapestry of phenomena with diverse implications for ecosystems and humans. Movement research is both plentiful and insightful, and recent methodological advances facilitate obtaining a detailed view of individual movement. Yet, we lack a general unifying paradigm, derived from first principles, which can place movement studies within a common context and advance the development of a mature scientific discipline. This introductory article to the Movement Ecology Special Feature proposes a paradigm that integrates conceptual, theoretical, methodological, and empirical frameworks for studying movement of all organisms, from microbes to trees to elephants. We introduce a conceptual framework depicting the interplay among four basic mechanistic components of organismal movement: the internal state (why move?), motion (how to move?), and navigation (when and where to move?) capacities of the individual and the external factors affecting movement. We demonstrate how the proposed framework aids the study of various taxa and movement types; promotes the formulation of hypotheses about movement; and complements existing biomechanical, cognitive, random, and optimality paradigms of movement. The proposed framework integrates eclectic research on movement into a structured paradigm and aims at providing a basis for hypothesis generation and a vehicle facilitating the understanding of the causes, mechanisms, and spatiotemporal patterns of movement and their role in various ecological and evolutionary processes. ''Now we must consider in general the common reason for moving with any movement whatever.'' (Aristotle, De Motu Animalium, 4th century B.C.) motion capacity \U0006ef59 navigation capacity \U0006ef59 migration \U0006ef59 dispersal \U0006ef59 foraging"



Our implementation works! With just two lines of code, we are able to extract all what we need. I call this concise.

## Constructing a data frame
 A ```TEIFile``` enables us to handle multiple files at a time and to build a table-like structure. For this purpose, we apply our ```TEIFile``` implementation to a handful TEI XML.
First, we will write a function ```tei_to_csv_entry()``` which captures the paper's title, doi and abstract. Then, we we will use this function to build a data frame wherein each row represents an output from ```tei_to_csv_entry()```. Eventually, we dump the results as CSV.

In addition to the extracted text, it's essential and good practice to have a unique identifier for each paper. To this end, we define a helper function ```base_name_without_ext()``` outputting the paper's filename without path and file type extension:


```python
from os.path import basename, splitext

def basename_without_ext(path):
    base_name = basename(path)
    stem, ext = splitext(base_name)
    if stem.endswith('.tei'):
        # Return base name without tei file
        return stem[0:-4]
    else:
        return stem
    
basename_without_ext(tei_doc)
```




    'nathan_2009_movement_ecology'



Now, it's time to output the paper's title, doi and abstract as a tuple.


```python
def tei_to_csv_entry(tei_file):
    tei = TEIFile(tei_file)
    print(f"Handled {tei_file}")
    base_name = basename_without_ext(tei_file)
    return base_name, tei.doi, tei.title, tei.abstract
```


```python
tei_to_csv_entry(tei_doc)
```

    Handled nathan_2009_movement_ecology.tei.xml





    ('nathan_2009_movement_ecology',
     '10.1073/pnas.0800375105',
     'A movement ecology paradigm for unifying organismal movement research',
     "Movement of individual organisms is fundamental to life, quilting our planet in a rich tapestry of phenomena with diverse implications for ecosystems and humans. Movement research is both plentiful and insightful, and recent methodological advances facilitate obtaining a detailed view of individual movement. Yet, we lack a general unifying paradigm, derived from first principles, which can place movement studies within a common context and advance the development of a mature scientific discipline. This introductory article to the Movement Ecology Special Feature proposes a paradigm that integrates conceptual, theoretical, methodological, and empirical frameworks for studying movement of all organisms, from microbes to trees to elephants. We introduce a conceptual framework depicting the interplay among four basic mechanistic components of organismal movement: the internal state (why move?), motion (how to move?), and navigation (when and where to move?) capacities of the individual and the external factors affecting movement. We demonstrate how the proposed framework aids the study of various taxa and movement types; promotes the formulation of hypotheses about movement; and complements existing biomechanical, cognitive, random, and optimality paradigms of movement. The proposed framework integrates eclectic research on movement into a structured paradigm and aims at providing a basis for hypothesis generation and a vehicle facilitating the understanding of the causes, mechanisms, and spatiotemporal patterns of movement and their role in various ecological and evolutionary processes. ''Now we must consider in general the common reason for moving with any movement whatever.'' (Aristotle, De Motu Animalium, 4th century B.C.) motion capacity \U0006ef59 navigation capacity \U0006ef59 migration \U0006ef59 dispersal \U0006ef59 foraging")



Finally, we can apply ```tei_to_csv_entry()``` to multiple papers by, firstly, selecting all TEI XML documents:


```python
import glob
from pathlib import Path

papers = sorted(Path("tei_papers").glob('*.tei.xml'))
```

Secondly, we setup a thread pool which can handle multiple papers simultaneously (limited by the number of CPUs in your machine):


```python
import multiprocessing
print(f"My machine has {multiprocessing.cpu_count()} cores.")

from multiprocessing.pool import Pool
pool = Pool()

```

    My machine has 4 cores.
    Handled tei_papers/nathan_2009_movement_ecology.tei.xml
    Handled tei_papers/demsar_2015_move.tei.xml


Then, we apply the thread pool to the TEI documents with ```tei_to_csv_entry()```:


```python
csv_entries = pool.map(tei_to_csv_entry, papers)
csv_entries
```




    [('demsar_2015_move',
      '10.1186/s40462-015-0032-y',
      'Analysis and visualisation of movement: an interdisciplinary review',
      'Abstract The processes that cause and influence movement are one of the main points of enquiry in movement ecology. However, ecology is not the only discipline interested in movement: a number of information sciences are specialising in analysis and visualisation of movement data. The recent explosion in availability and complexity of movement data has resulted in a call in ecology for new appropriate methods that would be able to take full advantage of the increasingly complex and growing data volume. One way in which this could be done is to form interdisciplinary collaborations between ecologists and experts from information sciences that analyse movement. In this paper we present an overview of new movement analysis and visualisation methodologies resulting from such an interdisciplinary research network: the European COST Action "MOVE -Knowledge Discovery from Moving Objects" (http://www.move-cost.info). This international network evolved over four years and brought together some 140 researchers from different disciplines: those that collect movement data (out of which the movement ecology was the largest represented group) and those that specialise in developing methods for analysis and visualisation of such data (represented in MOVE by computational geometry, geographic information science, visualisation and visual analytics). We present MOVE achievements and at the same time put them in ecological context by exploring relevant ecological themes to which MOVE studies do or potentially could contribute.'),
     ('nathan_2009_movement_ecology',
      '10.1073/pnas.0800375105',
      'A movement ecology paradigm for unifying organismal movement research',
      "Movement of individual organisms is fundamental to life, quilting our planet in a rich tapestry of phenomena with diverse implications for ecosystems and humans. Movement research is both plentiful and insightful, and recent methodological advances facilitate obtaining a detailed view of individual movement. Yet, we lack a general unifying paradigm, derived from first principles, which can place movement studies within a common context and advance the development of a mature scientific discipline. This introductory article to the Movement Ecology Special Feature proposes a paradigm that integrates conceptual, theoretical, methodological, and empirical frameworks for studying movement of all organisms, from microbes to trees to elephants. We introduce a conceptual framework depicting the interplay among four basic mechanistic components of organismal movement: the internal state (why move?), motion (how to move?), and navigation (when and where to move?) capacities of the individual and the external factors affecting movement. We demonstrate how the proposed framework aids the study of various taxa and movement types; promotes the formulation of hypotheses about movement; and complements existing biomechanical, cognitive, random, and optimality paradigms of movement. The proposed framework integrates eclectic research on movement into a structured paradigm and aims at providing a basis for hypothesis generation and a vehicle facilitating the understanding of the causes, mechanisms, and spatiotemporal patterns of movement and their role in various ecological and evolutionary processes. ''Now we must consider in general the common reason for moving with any movement whatever.'' (Aristotle, De Motu Animalium, 4th century B.C.) motion capacity \U0006ef59 navigation capacity \U0006ef59 migration \U0006ef59 dispersal \U0006ef59 foraging")]



Finally, we build a pandas DataFrame from these entries.


```python
import pandas as pd

result_csv = pd.DataFrame(csv_entries, columns=['ID', 'DOI','Title', 'Abstract'])
result_csv
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>ID</th>
      <th>DOI</th>
      <th>Title</th>
      <th>Abstract</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>demsar_2015_move</td>
      <td>10.1186/s40462-015-0032-y</td>
      <td>Analysis and visualisation of movement: an int...</td>
      <td>Abstract The processes that cause and influenc...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>nathan_2009_movement_ecology</td>
      <td>10.1073/pnas.0800375105</td>
      <td>A movement ecology paradigm for unifying organ...</td>
      <td>Movement of individual organisms is fundamenta...</td>
    </tr>
  </tbody>
</table>
</div>



We store the results as comma separated values (CSV) and we are done!


```python
result_csv.to_csv("summary_papers.csv", index=False)
```

## Conclusion

To sum up, XML parsing isn't hard or complex. BeautifulSoup offers a convenient way to select and transform XML elements into data abstractions which can serve as intermediate layer to extract text and to store the results originated from many papers in a table-like structure like a DataFrame or a CSV.

We applied these skills to extract information like title, abstract, doi and authors from a TEI XML, which was straight-forward to implement.

### Further readings

- [Documentation for BeautifulSoup](https://www.crummy.com/software/BeautifulSoup/bs4/doc/)
- [Pandas' DataFrame API documentation](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.html)
- [Blogpost on GROBID](https://komax.github.io/blog/text/mining/grobid/)