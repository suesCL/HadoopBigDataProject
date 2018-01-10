# Overview
This repository describes an assignment for working with ~600GB of graph data using modern analytics languages Hadoop and Pig. 
It perform some basic analysis over a relatively large social network graph derived from the billion triple challenge associated 
with the Semantic Web. The dataset is represented using the Resource Description Framework (RDF), where each 
record represents one edge in the graph.

RDF data is represented as a set of triples of the form:
subject predicate object [context]

* It creates a histogram of the data where y is the number of subjects assicoated with the count x.
We will run the script on the big graph in Problem 4. We will find the distribution of node out-degrees to 
follow a power law (1/d^k for some constant k and it will look roughly like a 
straight-line on a graph with logarithmic scales on both the x and y axes) instead of an exponential distribution. 

* It performs a join. It looks at a sub-graph of the big graph and tried to find all chains of lengths 2. 
