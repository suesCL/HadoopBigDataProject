# Overview
This repository describes an assignment for working with ~600GB of graph data using modern analytics languages Hadoop and Pig. 
It perform some basic analysis over a relatively large social network graph derived from the billion triple challenge associated 
with the Semantic Web. The dataset is represented using the Resource Description Framework (RDF), where each 
record represents one edge in the graph.
RDF data is represented as a set of triples of the form:
subject predicate object [context].

# Problems:

* Find the distribution of node out-degrees:


The out-degree of a node is the number of edges coming out of the node. I calculated the node out-degrees by finding the number of edges sharing the same subject. I created a histogram of the data where y is the number of subjects assicoated with the count x. I run the script on the big graph in Problem 4. The result shows the distribution of node out-degrees follows a power law (1/d^k for some constant k and it will look roughly like a straight-line on a graph with logarithmic scales on both the x and y axes) instead of an exponential distribution. It suggests the web and semantic web requires a different theoretical model to explain their behavior.

* Find all chains of lengths 2 on a sub-graph of the big graph:

I performed a filter on the big graph to find the sub-graph. And then I performed a join on two copies of subgraphs where subject = subject2. The schema of the second subgraph copy  is represented as subject2 predicate2 object2. This is a simple version of more complex algorithms that try to measure the diameter of a graph or try to extract other related properties
