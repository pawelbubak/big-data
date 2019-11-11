create database if not exists persons;
use persons;

ADD JAR /usr/lib/hive/lib/hive-hcatalog-core.jar;

drop table if exists result;

create temporary table persons_sf(nconst string, actor int, director int)
  ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' STORED AS TEXTFILE;
create temporary table names_sf(nconst string, primaryName string, birthYear string,
  deathYear string, primaryProfession ARRAY<string>, knownForTitles ARRAY<string>)
  ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
  COLLECTION ITEMS TERMINATED by ',' STORED AS TEXTFILE;
create temporary table persons_orc(nconst string, actor int, director int)
  STORED AS ORC;
create temporary table names_orc(nconst string, primaryName string, birthYear string,
  deathYear string, primaryProfession ARRAY<string>, knownForTitles ARRAY<string>)
  STORED AS ORC;
create external table if not exists result(primaryName string, role string, movies int)
  ROW FORMAT SERDE 'org.apache.hive.hcatalog.data.JsonSerDe' STORED AS TEXTFILE
  LOCATION '/user/132197/labs/project/persons/output/';

load data inpath '/user/132197/labs/project/persons/st_output/part-*' into table persons_sf;
load data inpath '/user/132197/labs/project/persons/input/name.basics.tsv' into table names_sf;

insert into persons_orc select * from persons_sf where nconst != 'nconst';
insert into names_orc select * from names_sf where nconst != 'nconst';

ANALYZE TABLE persons_orc COMPUTE STATISTICS FOR COLUMNS;
ANALYZE TABLE names_orc COMPUTE STATISTICS FOR COLUMNS;

insert into result select names_orc.primaryName, 'actor', persons_orc.actor
  from persons_orc join names_orc on (persons_orc.nconst = names_orc.nconst)
  where array_contains(names_orc.primaryProfession, 'actress') or array_contains(names_orc.primaryProfession, 'actor')
  order by persons_orc.actor desc limit 3;

insert into result select names_orc.primaryName, 'director', persons_orc.director
  from persons_orc join names_orc on (persons_orc.nconst = names_orc.nconst)
  where array_contains(names_orc.primaryProfession, 'director')
  order by persons_orc.director desc limit 3;
