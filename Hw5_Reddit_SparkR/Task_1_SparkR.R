################################################
##########System code for SparkR################
###############Do not alter#####################

Sys.setenv(HADOOP_CONF="/data/hadoop/etc/hadoop")
Sys.setenv(YARN_CONF="/data/hadoop/etc/hadoop")
Sys.setenv(SPARK_HOME="/data/hadoop/spark")

.libPaths(c(file.path(Sys.getenv("SPARK_HOME"), "R/lib"), .libPaths()))
library(SparkR)

sc = sparkR.init(master="yarn-client")
#sc = sparkR.init()
sqlContext = sparkRSQL.init(sc)


##Data for January##
# set file path for Jaunary data #
jData = jsonFile(sqlContext, "hdfs://localhost:9000/data/RC_2015-01.json")

# count by subreddit #
jan = count(group_by(jData, "subreddit"))
jan2 = collect(jan)

# get top 25 subreddits #
topJan = head(jan2[order(jan2$count, decreasing = TRUE),], 25)

# save as R data file #
save(topJan, file = "Subreddits_Jan.Rdata")


##Data for February##
# set file path for  February data #
fData = jsonFile(sqlContext, "hdfs://localhost:9000/data/RC_2015-02.json")

# count by subreddit #
feb = count(group_by(fData, "subreddit"))
feb2 = collect(feb)

# get top 25 subreddits #
topFeb = head(feb2[order(feb2$count, decreasing = TRUE),], 25)

# save as R data file #
save(topFeb, file = "Subreddits_Feb.Rdata")


##Data for March##
# set file path for  March data #
mData = jsonFile(sqlContext, "hdfs://localhost:9000/data/RC_2015-03.json")

# count by subreddit #
mar = count(group_by(fData, "subreddit"))
mar2 = collect(mar)

# get top 25 subreddits #
topMar = head(mar2[order(mar2$count, decreasing = TRUE),], 25)

# save as R data file #
save(topMar, file = "Subreddits_Mar.Rdata")


##Data for April##
# set file path for  April data #
aData = jsonFile(sqlContext, "hdfs://localhost:9000/data/RC_2015-04.json")

# count by subreddit #
apr = count(group_by(mData, "subreddit"))
apr2 = collect(apr)

# get top 25 subreddits #
topApr = head(apr2[order(apr2$count, decreasing = TRUE),], 25)

# save as R data file #
save(topApr, file = "Subreddits_Apr.Rdata")


##Data for May##
# set file path for May data #
maData = jsonFile(sqlContext, "hdfs://localhost:9000/data/RC_2015-05.json")

# count by subreddit #
may = count(group_by(maData, "subreddit"))
may2 = collect(may)

# get top 25 subreddits #
topMay = head(may2[order(may2$count, decreasing = TRUE),], 25)

# save as R data file #
save(topMay, file = "Subreddits_May.Rdata")
