Articles = LOAD '/input/article/article.txt' AS (title, link, description);
TopN = LOAD '/output/topn/part-r-00000' AS (word, count);
X = CROSS Articles, TopN;
Y = FOREACH X {
	constr = CONCAT('.*', word, '.*');
	GENERATE *, constr AS conword;
}
Z = FILTER Y BY (description matches conword);
A = GROUP Z BY word;
STORE A into '/output/pig_out';

