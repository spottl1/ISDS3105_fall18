#' This is the code to create a colorpleth map of incomes for BR
#' Income data are collected by block on the City of Baton Rouge open-data portal
#' url: https://data.brla.gov/Housing-and-Development/Census-Demographics/xsrb-mxqt/data
#' and also on https://datausa.io/ (we use the latter)
library(tidyverse)
library(jsonlite)
library(here)
income <- read_json('https://api.datausa.io/api/?sort=desc&show=geo&required=income&sumlevel=tract&year=all&where=geo%3A16000US2205000')
income <- tibble(year = map_dbl(income$data,1),
                 geo= map_chr(income$data,2),
                 income = map_dbl(income$data,3, .default = NA))
#' each geoID is a neighborhood
inc <- income %>% filter(year == 2016) %>% mutate(geo = str_sub(geo, 8, -1)) 

#' for last year of income data https://api.datausa.io/api?show=geo&sumlevel=nation&year=latest&required=pop
#' To download income data by county for the last 5 years:
apiCall <- jsonlite::fromJSON('https://api.datausa.io/api/?sort=desc&show=geo&required=income&sumlevel=tract&year=all&where=geo%3A16000US2205000')
dt <- as_tibble(apiCall$data) 
names(dt) <- apiCall$headers


#' We are going to make maps, thus we can already prepare a theme with no bg, axes titles, etc.
mytheme <- theme(axis.ticks = element_blank(),
                 axis.text = element_blank(),
                 axis.title = element_blank(),
                 panel.grid = element_blank(),
                 panel.background = element_blank()
)

#' This is the function to download the shapefiles from census.gov
#' download and unzip shapefile. Check if the shp exists in the downloaded repo
retrieve_shapefile <- function(shapefile, destination, type ) {
  destfile <- here(destination, paste0(shapefile, '.zip')) 
  if (!file.exists(destfile)) {
    download.file(paste0('https://www2.census.gov/geo/tiger/TIGER2018/', type, '/',shapefile, '.zip'), destfile = destfile)  
    unzip(zipfile = destfile, exdir = here(destination, shapefile))
  }
  if (!file.exists(here(destination, shapefile))) unzip(zipfile = destfile, exdir = here(destination, shapefile))
  
  fe <- list.files(here(destination,shapefile), pattern='\\.shp$')
  if(!file.exists(here(destination, shapefile, fe))) stop('shp file does not exists', call. = F)
}
retrieve_shapefile('tl_2018_22_puma10' , 'dataset', 'PUMA')



pumafile <- 'tl_2018_22_puma10'                       #the name of the shapefile source
destfile <- here('dataset', paste0(pumafile, '.zip')) #name of the folder with shapefiles

#' PUMA: public use microdata areas. Each PUMA containts +100k people
callInstall <- function(x) {
  if (!require(x)) install.packages(x, type="source")
  callInstall(x)
}
callInstall('rgdal')
if (!require(rgdal)) install.packages("gpclib", type="source")
if (!require(maptools)) install.packages("gpclib", type="source")
if (!require(gpclib)) install.packages("gpclib", type="source")
gpclibPermit()


louisiana <- readOGR(here('dataset',pumafile), layer = pumafile)
louisiana@data$id <-  rownames(louisiana@data)
louisianaPoints <-fortify(louisiana, region="id")
df <-  inner_join(louisianaPoints, louisiana@data, by="id")

ggplot(df, aes(long,lat,group=group), fill = 'blue') + 
  geom_polygon() +
  geom_path(color="white") +
  coord_equal() +
  scale_fill_brewer("Louisiana ") +
  mytheme


# take census tracks from here https://www.census.gov/cgi-bin/geo/shapefiles/index.php

download.file(paste0('https://www2.census.gov/geo/tiger/TIGER2018/PUMA/',shapefile, '.zip'), destfile = destfile) 

#https://www.census.gov/cgi-bin/geo/shapefiles/index.php?year=2018&layergroup=Census+Tracts
shapefile = 'tl_2018_22_tract'
retrieve_shapefile(shapefile , 'dataset', type = 'TRACT')
br <- readOGR(here('dataset', shapefile), layer = shapefile)
br@data$id <-  rownames(br@data)
brPoints <-fortify(br, region="id")
br <-  as_tibble(inner_join(brPoints, br@data, by="id"))
br$GEOID <- as.character(br$GEOID)
br$TRACTCE <- as.character(br$TRACTCE)
### DOWLOAD CENSUS DEMOGRAPHICS FROM BR-OpenData

library(RSocrata)
demographics <- 'https://data.brla.gov/resource/hme2-7hqu.csv'
#' Need to create an APP on socrata with secret token and app id
readRDS(here('dataset', 'tokens.RDS'))
source('socrataToken.R')
if (!exists('token')) stop('You need to a token access for the Socrata API')

dem <- read.socrata(demographics, app_token = token[['app']])
dem <- as_tibble(dem %>% filter(census_year == 2010))
unique(dem$tract)
unique(br$TRACTCE)

#' each GEOID is ~4k people
br_shp <- inner_join(inc, br, by = c('geo' = 'GEOID'))


fb <- read_csv(here::here('dataset/BRFlood2016_FBpost.csv')) %>% rename(long = lon)
# each GEOID is a neighborhood
map <- ggmap::get_map(location = c( lon = -91.1500, lat = 30.5000),  zoom = 10, maptype = 'toner') 

ggmap::ggmap(map) + 
  geom_polygon(data = br_shp, aes(long,lat, fill = income, group=group)) +
  geom_path(data= br_shp, aes(long,lat, group=group), color="white") +
  geom_point(data =fb, aes(long,lat)) +
  coord_equal(1.3) +
  scale_fill_continuous(name = 'Median Income', labels = scales::dollar) +
  mytheme


library(sf)
br_shp <- st_as_sf(br_shp, coords = c('long','lat'))
fb <- st_as_sf(select(fb, long, lat), coords = c('long','lat'))
st_crs(br_shp) <- st_crs(fb) <- 4326



#reload original shapefile
br <- readOGR(here('dataset', shapefile), layer = shapefile)
br <- st_as_sf(br)
st_crs(br) <- 4326
inside <- st_intersection(br, fb) 
inside_count <- inside %>% group_by(GEOID) %>% count 





dt1 <- tibble(group = inside_count$GEOID, n = inside_count$n) %>% right_join(filter(inc, year==2016), by = c('group'='geo')) %>% 
  mutate(n = if_else(is.na(n), 0L, n)) 

#model

fbPosts_model <- function(data, family) {
  glm(n ~ income, family = family, data = data)
}
extract_p <- function(fit) {
  summary(fit) %>% coefficients() %>% .[2,4]
}
percIncrease <- function(coef, units = 10000) {
  exp(coef)/(1+exp(coef))
}
tibble(data = list(dt1,
                   mutate(dt1, n = n>0)  ),
       family = c('poisson', 'binomial')
) %>% 
  mutate(fit = map2(data, family, fbPosts_model)) %>% 
  mutate(incomeCoeff10k = map_dbl(map(fit, coefficients), 'income')*10^4,
         glance = map(fit, broom::glance)) %>% unnest(glance, .drop = F) %>% 
  mutate(p.value = map_dbl(fit, extract_p),
         percIncrease = map_dbl(incomeCoeff10k, percIncrease))






