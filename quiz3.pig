--compute a join on chunk-000

register s3n://uw-cse-344-oregon.aws.amazon.com/myudfs.jar

-- load the test file into Pig
raw = LOAD 's3n://uw-cse-344-oregon.aws.amazon.com/cse344-test-file' USING TextLoader as (line:chararray);


-- parse each line into ntriples
ntriples = foreach raw generate FLATTEN(myudfs.RDFSplit3(line)) as (subject:chararray,predicate:chararray,object:chararray);


--filter data to get tuples whose subjects matches 'rdfabout.com'
--filtered = FILTER ntriples BY subject == '.*rdfabout\.com.*';
filtered = FILTER ntriples BY subject matches '.*business.*';

--make a new copy of filtered 
newFilter = FOREACH filtered Generate * AS(subject2:chararray,predicate2:chararray,object2:chararray); 

--Join two copies 
--joins = JOIN newFilter BY subject2, filtered BY object PARALLEL 50;
joins = JOIN newFilter BY subject2, filtered BY subject PARALLEL 50;

--remove duplicate tuples from result of join 
nonDupjoins = DISTINCT joins;

--count number of records after joins 
groupRecords =  GROUP nonDupjoins ALL PARALLEL 50;
records = FOREACH groupRecords GENERATE COUNT(nonDupjoins) PARALLEL 50;



-- store the results in the folder /user/hadoop/example-results
-- store count_by_object_ordered into '/user/hadoop/example-results' using PigStorage();
-- Alternatively, you can store the results in S3, see instructions:
store records into 's3n://pig2018/output';
