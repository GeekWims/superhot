Articles = LOAD 'article.txt' AS (title, link, description);
TopN = LOAD 'part-r-00000' AS (word, count);
X = CROSS Articles, TopN;
STORE X into 'pig_out/raw_x';
Y = FOREACH X {
	constr = CONCAT('.*', word, '.*');
	GENERATE *, constr AS conword;
}
STORE Y into 'pig_out/raw_y';
Z = FILTER Y BY (description matches conword);
STORE Z into 'pig_out/raw_z';
A = GROUP Z BY word;
STORE A into 'pig_out/top_articles';

