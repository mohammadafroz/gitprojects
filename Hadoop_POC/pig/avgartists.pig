--average number of artists listened by users. Means how many different artists do users listen to



records = LOAD '/last.fm/user_artists.dat' AS (userID:chararray, artistID:chararray, weight:int);
user_artist = FOREACH records GENERATE userID,artistID;
group_users = GROUP user_artist BY userID;
artist_count = FOREACH group_users GENERATE group,COUNT(user_artist.artistID) as ct;
avg_group = GROUP artist_count all;
avg_count = FOREACH avg_group GENERATE AVG(artist_count.ct);
dump avg_count;


