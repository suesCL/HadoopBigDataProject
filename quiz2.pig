-- compute a histogram on cse344 test file

register s3n://uw-cse-344-oregon.aws.amazon.com/myudfs.jar

-- load the test file into Pig
raw = LOAD 's3n://uw-cse-344-oregon.aws.amazon.com/btc-2010-chunk-000' USING TextLoader as (line:chararray);


-- parse each line into ntriples
ntriples = foreach raw generate FLATTEN(myudfs.RDFSplit3(line)) as (subject:chararray,predicate:chararray,object:chararray);




--group the n-triples by subject column
subjects = group ntriples by (subject) PARALLEL 50;



-- flatten the objects out (because group by produces a tuple of each subject
-- in the first column, and we want each subject to be a string, not a tuple),
-- and count the number of tuples associated with each subject
count_by_subject = foreach subjects generate flatten($0), COUNT($1) as count PARALLEL 50;


--group the count_by_object by count, then compute the final count
counts = group count_by_subject by (count) PARALLEL 50;
count_by_count = foreach counts generate flatten($0), COUNT($1) as finalCount PARALLEL 50;


--order the resulting tuples by their count in descending order
count_by_count_ordered = order count_by_count by (group) PARALLEL 50;

groupall = GROUP count_by_count ALL PARALLEL 50;
finalGroup = FOREACH  groupall GENERATE COUNT(count_by_count) PARALLEL 50;




-- store the results in the folder /user/hadoop/example-results
-- store count_by_object_ordered into '/user/hadoop/example-results' using PigStorage();
-- Alternatively, you can store the results in S3, see instructions:
store finalGroup into 's3n://pig2018/output';
