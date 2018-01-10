--Problem1
register s3n://uw-cse-344-oregon.aws.amazon.com/myudfs.jar
-- load files
raw = LOAD 's3n://uw-cse-344-oregon.aws.amazon.com/btc-2010-chunk-000' USING TextLoader as (line:chararray); 



-- parse each line into ntriples (Map step)
ntriples = foreach raw Generate FLATTEN(myudfs.RDFSplit3(line)) as (subject:chararray,predicate:chararray,object:chararray);




--group the n-triples by object column
objects = GROUP ntriples by (object) PARALLEL 50;



-- flatten the objects out (because groupby produces a tuple of each object
-- in the first column, and we want each object to be a string, not a tuple),
-- and count the number of tuples associated with each object
count_by_object = foreach objects Generate flatten($0), COUNT($1) as count PARALLEL 50;




--order the resulting tuples by their count in descending order
--count_by_object_ordered = order count_by_object by (count)  PARALLEL 50;

---count total rows 
finalgroup = GROUP count_by_object ALL PARALLEL 50;
finalcount = FOREACH finalgroup GENERATE COUNT(count_by_object) PARALLEL 50;


-- store the results in the folder /user/hadoop/example-results
-- store count_by_object_ordered into '/user/hadoop/example-results' using PigStorage();
-- Alternatively, you can store the results in S3, see instructions:
store finalcount into 's3n://pig2018/output';
