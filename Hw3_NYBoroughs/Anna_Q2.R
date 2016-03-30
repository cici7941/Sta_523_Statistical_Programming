# Required libraries for analysis #

library(rgdal)
library(rgeos)
library(e1071)  # for svm()
library(sp)
library(raster)
library(maptools)
library(plyr)
library(dplyr)
gpclibPermit()
library(nnet)

# load in geocoded data #
load("nyBoroughs.Rdata")
# used to rename polygon data at bottom #
short_to_long = c("BK"="Brooklyn", 
                  "BX"="Bronx",
                  "MN"="Manhattan",
                  "QN"="Queens",
                  "SI"="Staten Island")


# select only the borough, long, and lat columns #
nyBoroughs = nyBoroughs[, c(3,4,5)]

#pluto_sample = sorted20000[, c(3,4,5)]
nyBoroughs$Borough <- as.factor(nyBoroughs$Borough)

# order data by Borough, then longitude, then latitude #
sorted = nyBoroughs[order(nyBoroughs$Borough, nyBoroughs$longitude, 
                        nyBoroughs$latitude),]

#Find number of entries for each borough #
counts = count(sorted$Borough)

#Remove duplicate longitude entries for each borough#
boroughBK = sorted[1:counts[1,2],]
boroughBK = boroughBK[!duplicated(boroughBK$longitude),]
boroughBX = sorted[(counts[1,2]+1):(counts[1,2]+counts[2,2]),]
boroughBX = boroughBX[!duplicated(boroughBX$longitude),]
boroughMN = sorted[(counts[1,2]+counts[2,2]+1):(counts[1,2]+counts[2,2]+counts[3,2]),]
boroughMN = boroughMN[!duplicated(boroughMN$longitude),]
boroughQN = sorted[(counts[1,2]+counts[2,2]+counts[3,2]+1):
                   (counts[1,2]+counts[2,2]+counts[3,2]+counts[4,2]),]
boroughQN = boroughQN[!duplicated(boroughQN$longitude),]
boroughSI = sorted[(dim(sorted)[1] - counts[5,2]+1):dim(sorted)[1],]
boroughSI = boroughSI[!duplicated(boroughSI$longitude),]



#Calculate distance from each point in borough to borough centroid#
#Only select points that are in the 85th percentile in distance from centroid#
#of the borough#
boroughBK = boroughBK %>%
  mutate(distance = sqrt(rowSums((scale(boroughBK[,-1],
                                        center=c(mean(boroughBK$longitude), 
                                                 mean(boroughBK$latitude)),
                                        scale=F)^2)))) %>%
  filter(distance > quantile(distance, probs = 0.85))
if(dim(boroughBK)[1] >10000)
{
  boroughBK = boroughBK %>%
    do(sample_n(., 10000))
}


boroughBX = boroughBX %>%
  mutate(distance = sqrt(rowSums((scale(boroughBX[,-1],
                                        center=c(mean(boroughBX$longitude), 
                                                 mean(boroughBX$latitude)),
                                        scale=F)^2)))) %>%
  filter(distance > quantile(distance, probs = 0.85))
if(dim(boroughBX)[1] >10000)
{
  boroughBX = boroughBX %>%
    do(sample_n(., 10000))
}


boroughMN = boroughMN %>%
  mutate(distance = sqrt(rowSums((scale(boroughMN[,-1],
                                        center=c(mean(boroughMN$longitude), 
                                                 mean(boroughMN$latitude)),
                                        scale=F)^2)))) %>%
  filter(distance > quantile(distance, probs = 0.85))
if(dim(boroughMN)[1] >10000)
{
  boroughMN = boroughMN %>%
    do(sample_n(., 10000))
}


boroughQN = boroughQN %>%
  mutate(distance = sqrt(rowSums((scale(boroughQN[,-1],
                                        center=c(mean(boroughQN$longitude), 
                                                 mean(boroughQN$latitude)),
                                        scale=F)^2)))) %>%
  filter(distance > quantile(distance, probs = 0.85))
if(dim(boroughQN)[1] >10000)
{
  boroughQN = boroughQN %>%
    do(sample_n(., 10000))
}


boroughSI = boroughSI %>%
  mutate(distance = sqrt(rowSums((scale(boroughSI[,-1],
                                        center=c(mean(boroughSI$longitude), 
                                                 mean(boroughSI$latitude)),
                                        scale=F)^2)))) %>%
  filter(distance > quantile(distance, probs = 0.85))
if(dim(boroughSI)[1] >10000)
{
  boroughSI = boroughSI %>%
    do(sample_n(., 10000))
}
  
combined = rbind(boroughBK, boroughBX, boroughMN, boroughQN, boroughSI)

#Code from stackexchange
#http://stackoverflow.com/questions/30585924/spatial-data-in-r-plot-decision-regions-of-multi-class-svm
 
# randomly sample 10000 data points from each borough #
set.seed(98192895)
pluto_sample = nyBoroughs %>%
  group_by(Borough) %>%
  do(sample_n(., 10000))

pluto_sample = combined
# select only the borough, long, and lat columns #
pluto_sample = pluto_sample[, -4]



# rename our data frame #
names(pluto_sample) = c("Borough", "long", "lat")

## Function to create raster just covering sample area ##
## Create a mask of the data region, as a data frame of x/y points. ##
covering <- function(data, xlen=150, ylen=150) {
  # Convex hulls of each class's data points:
  polys <- dlply(data, .(Borough), function(x) Polygon(x[chull(x[-1]), -1]))
  # Union of the hulls:
  bbs <- unionSpatialPolygons(SpatialPolygons(list(Polygons(polys, 1))), 1)
  
  # Pixels that are inside the union polygon:
  grid <- expand.grid(x=seq(min(data$long), max(data$long), length.out=xlen),
                      y=seq(min(data$lat), max(data$lat), length.out=ylen))
  grid[!is.na(over(SpatialPoints(grid), bbs)), ]
}

# does regression, using svm #
m <- svm(Borough ~ long+lat, pluto_sample)
# creates raster grid using covering function for the mask above #
grid <- covering(pluto_sample)


# renames raster grid to match data frame #
names(grid) = c("long","lat")


#Conversion into Spatial Polygons
pred = predict(m, grid)
sp.grid <- cbind(grid, pred)
coordinates(sp.grid) <- ~ long + lat
gridded(sp.grid) <- TRUE
sp.grid <- raster(sp.grid)

poly <- rasterToPolygons(sp.grid, n = 16, dissolve = TRUE)

# Renaming spatial polygon #
names(poly@data) = "Name"

poly@data$Name = short_to_long[levels(pred)]

# writes out results to geoJson file #
source("write_geojson.R")
write_geojson(poly,"boroughs.json")


