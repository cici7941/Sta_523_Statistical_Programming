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

##Task 3##

##Timestamps converted by http://www.epochconverter.com/##

##Beginning timestamp for Valentine's Day = 1423872000##
##Ending timestamp for Valentine's Day = 1423958399##

##Beginning timestamp for 2/2/15  = 1422835200##
##Ending timestamp for 2/2/15 = 1422921599##

##Beginning timestamp for 2/20/15 = 1424390400##
##Ending timestamp for 2/20/15 = 1424476799##

#Load reddit data for Feb#
Feb = jsonFile(sqlContext, "hdfs://localhost:9000/data/RC_2015-02.json")

#Register these DataFrames as a table#
registerTempTable(Feb, "february")

#SQL statements to select dates 2/2, 2/14 and 2/20#
feb20 <- sql(sqlContext, "SELECT body FROM february 
             WHERE created_utc BETWEEN 1424390400 and 1424476799")

feb14 <- sql(sqlContext, "SELECT body FROM february 
             WHERE created_utc BETWEEN 1423872000 and 1423958399")

feb2 <- sql(sqlContext, "SELECT body FROM february 
             WHERE created_utc BETWEEN 1422835200 and 1422921599")

#Convert into RDD format#
feb2 = SparkR:::toJSON(feb2)
feb14 = SparkR:::toJSON(feb14)
feb20 = SparkR:::toJSON(feb20)

#Count occurence of 10 words below on Feb 2#
flower_feb2 <- count(SparkR:::filterRDD(feb2, function(s) { grepl("flower|Flower", s) }))
chocolate_feb2 <- count(SparkR:::filterRDD(feb2, function(s) { grepl("chocolate|Chocolate", s) }))
love_feb2 <- count(SparkR:::filterRDD(feb2, function(s) { grepl("love|Love", s) }))
valentine_feb2 <- count(SparkR:::filterRDD(feb2, function(s) { grepl("valentine|Valentine", s) }))
hug_feb2 <- count(SparkR:::filterRDD(feb2, function(s) { grepl("hug|Hug", s) }))
kiss_feb2 <- count(SparkR:::filterRDD(feb2, function(s) { grepl("kiss|Kiss", s) }))
heart_feb2 <- count(SparkR:::filterRDD(feb2, function(s) { grepl("heart|Heart", s) }))
lonely_feb2 <- count(SparkR:::filterRDD(feb2, function(s) { grepl("lonely|Lonely", s) }))
time_feb2 <- count(SparkR:::filterRDD(feb2, function(s) { grepl("time|Time", s) }))
government_feb2 <- count(SparkR:::filterRDD(feb2, function(s) { grepl("government|Government", s) }))

#Save counts for 10 words as a dataframe#
Feb_2 = data.frame(flower = flower_feb2, chocolate = chocolate_feb2,
                   love = love_feb2, valentine = valentine_feb2, 
                   hug = hug_feb2, kiss = kiss_feb2, heart = heart_feb2, 
                   lonely = lonely_feb2, time = time_feb2, 
                   government = government_feb2)

#Count occurence of 10 words below on Feb 14#
flower_feb14 <- count(SparkR:::filterRDD(feb14, function(s) { grepl("flower|Flower", s) }))
chocolate_feb14 <- count(SparkR:::filterRDD(feb14, function(s) { grepl("chocolate|Chocolate", s) }))
love_feb14 <- count(SparkR:::filterRDD(feb14, function(s) { grepl("love|Love", s) }))
valentine_feb14 <- count(SparkR:::filterRDD(feb14, function(s) { grepl("valentine|Valentine", s) }))
hug_feb14 <- count(SparkR:::filterRDD(feb14, function(s) { grepl("hug|Hug", s) }))
kiss_feb14 <- count(SparkR:::filterRDD(feb14, function(s) { grepl("kiss|Kiss", s) }))
heart_feb14 <- count(SparkR:::filterRDD(feb14, function(s) { grepl("heart|Heart", s) }))
lonely_feb14 <- count(SparkR:::filterRDD(feb14, function(s) { grepl("lonely|Lonely", s) }))
time_feb14 <- count(SparkR:::filterRDD(feb14, function(s) { grepl("time|Time", s) }))
government_feb14 <- count(SparkR:::filterRDD(feb14, function(s) { grepl("government|Government", s) }))


#Save counts for 10 words as a dataframe#
Feb_14 = data.frame(flower = flower_feb14, chocolate = chocolate_feb14,
                   love = love_feb14, valentine = valentine_feb14, 
                   hug = hug_feb14, kiss = kiss_feb14, heart = heart_feb14, 
                   lonely = lonely_feb14, time = time_feb14, 
                   government = government_feb14)

#Count occurence of 10 words below on Feb 20#
flower_feb20 <- count(SparkR:::filterRDD(feb20, function(s) { grepl("flower|Flower", s) }))
chocolate_feb20 <- count(SparkR:::filterRDD(feb20, function(s) { grepl("chocolate|Chocolate", s) }))
love_feb20 <- count(SparkR:::filterRDD(feb20, function(s) { grepl("love|Love", s) }))
valentine_feb20 <- count(SparkR:::filterRDD(feb20, function(s) { grepl("valentine|Valentine", s) }))
hug_feb20 <- count(SparkR:::filterRDD(feb20, function(s) { grepl("hug|Hug", s) }))
kiss_feb20 <- count(SparkR:::filterRDD(feb20, function(s) { grepl("kiss|Kiss", s) }))
heart_feb20 <- count(SparkR:::filterRDD(feb20, function(s) { grepl("heart|Heart", s) }))
lonely_feb20 <- count(SparkR:::filterRDD(feb20, function(s) { grepl("lonely|Lonely", s) }))
time_feb20 <- count(SparkR:::filterRDD(feb20, function(s) { grepl("time|Time", s) }))
government_feb20 <- count(SparkR:::filterRDD(feb20, function(s) { grepl("government|Government", s) }))

#Save counts for 10 words as a dataframe#
Feb_20 = data.frame(flower = flower_feb20, chocolate = chocolate_feb20,
                   love = love_feb20, valentine = valentine_feb20, 
                   hug = hug_feb20, kiss = kiss_feb20, heart = heart_feb20, 
                   lonely = lonely_feb20, time = time_feb20, 
                   government = government_feb20)

#Save data frames as Rdata files#
save(Feb_2, file = "Feb_2.Rdata")
save(Feb_14, file = "Feb_14.Rdata")
save(Feb_20, file = "Feb_20.Rdata")

# end SparkR session#
sparkR.stop()

