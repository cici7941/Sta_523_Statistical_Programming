################################################
##########System code for SparkR################
###############Do not alter#####################

Sys.setenv(HADOOP_CONF="/data/hadoop/etc/hadoop")
Sys.setenv(YARN_CONF="/data/hadoop/etc/hadoop")
Sys.setenv(SPARK_HOME="/data/hadoop/spark")

.libPaths(c(file.path(Sys.getenv("SPARK_HOME"), "R/lib"), .libPaths()))
library(SparkR)
library(ggplot2)
library(scales)

sc = sparkR.init(master="yarn-client")
#sc = sparkR.init()
sqlContext = sparkRSQL.init(sc)


##Data for January##
j = jsonFile(sqlContext, "hdfs://localhost:9000/data/RC_2015-01.json")

# count by created_utc #
time = count(group_by(j, "created_utc"))
time2 = collect(time)

time2$created_utc = as.POSIXct(as.numeric(time2$created_utc), 
                               origin = "1970-01-01", tz = "GMT")
# aggregate by hour
resHour <- aggregate(time2$count,
                 by=list(format(time2$created_utc, "%Y-%m-%d %H", tz = "GMT")),
                 sum)
names(resHour) = c("date","count")

# convert from character to POSIX
resHour$date = as.POSIXlt(resHour$date, format = "%Y-%m-%d %H")

# add new column represent day of week and hour
resHour$dow = format(resHour$date, "%w %H")

# aggregate by day of week
resHourDay = aggregate(resHour$count,by = list(resHour$dow), sum)
names(resHourDay) = c("dow", "count")
resHourDay$dow = as.factor(resHourDay$dow)

save(resHour, file = "Post_Freq.Rdata")
save(resHourDay, file = "Post_Freq_Dow.Rdata")

# subsetting gilded comments
gilded = filter(j, j$gilded == 1)

# count by created_utc #
timeGilded = count(group_by(gilded, "created_utc"))
timeGilded2 = collect(timeGilded)

timeGilded2$created_utc = as.POSIXct(as.numeric(timeGilded2$created_utc), 
                                     origin = "1970-01-01", tz = "GMT")

resHourGilded = aggregate(timeGilded2$count,
                     by=list(format(timeGilded2$created_utc, "%Y-%m-%d %H")),
                     sum)

names(resHourGilded) = c("date","count")
resHourGilded$date = as.POSIXlt(resHourGilded$date, format = "%Y-%m-%d %H")

# add new column represent day of week and hour
resHourGilded$dow = format(resHourGilded$date, "%w %H")

# aggregate by day of week
resHourDayGilded = aggregate(resHourGilded$count,by = list(resHourGilded$dow), sum)
names(resHourDayGilded) = c("dow", "count")
resHourDayGilded$dow = as.factor(resHourDayGilded$dow)

save(resHourGilded, file = "Post_Freq_Gilded.Rdata")
save(resHourDayGilded, file = "Post_Freq_Gilded_Dow.Rdata")

sparkR.stop()
