-- percentage of each genres(tags) of music listened to total listens

-- prepare the count of users per tag
tag_records = LOAD '/last.fm/user_taggedartists.dat' AS (userID:chararray, artistID:chararray, tagID:chararray, day:chararray, month:chararray, year:chararray);
tags_users = FOREACH tag_records GENERATE userID,tagID;
user_list = FOREACH tags_users GENERATE userID;
users_group = GROUP user_list all;
user_count = FOREACH users_group GENERATE COUNT(user_list.userID) as tot_count;
group_tags = GROUP tags_users BY tagID;
percentage = FOREACH group_tags GENERATE group,(COUNT(tags_users.userID)/(float)user_count.tot_count)*100 as percent;
order_tags = ORDER percentage BY percent DESC;
top10 = LIMIT order_tags 10;

--prepare tags
tags = LOAD '/last.fm/tags.dat' AS (tagID:chararray, tagValue:chararray);
join_tags = JOIN top10 BY group,tags BY tagID;
tags_order = ORDER join_tags BY percent DESC;
dump tags_order;
