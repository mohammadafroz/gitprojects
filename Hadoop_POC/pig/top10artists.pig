--Find the top 10 artists with number of listens


records = LOAD '/last.fm/user_artists.dat' AS (user:chararray, artist:chararray, listens:int);
artist_listens = FOREACH records GENERATE artist,listens;
grouped_records = GROUP artist_listens BY artist;
summed_records = FOREACH grouped_records GENERATE group,sum(artist_listens.listens);
ordered = ORDER summed_records by $1 DESC;
top10 = LIMIT ordered 10;
artists = LOAD '/last.fm/artists.dat' AS (id:chararry, name:chararray, url:chararray, pictureURL:chararray);
top10artists = JOIN top10 BY $0, artists BY $0;
top10list = FOREACH top10artists GENERATE $0,$3,$1,$4,$5;
top10listorder = ORDER top10list BY $2 DESC;
STORE top10listorder INTO '/last.fm/results/top10artists_by_listens';

