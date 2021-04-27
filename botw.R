
# library(RPostgreSQL)

library(DBI)
library(RPostgres)
library(sf)
library(ggplot2)
library(lwgeom)

library(rnaturalearth)
library(rnaturalearthdata)
library(rgeos)
library(dplyr)

world <- ne_countries(scale = "medium", returnclass = "sf")

# get a database connection using params in the .Renviron file

getdb <- function(){
    
    tryCatch({
        db <- dbConnect(RPostgres::Postgres(), 
                    dbname = 'botw',
                    host = Sys.getenv("DBHOST"),
                    port = as.integer(Sys.getenv("DBPORT")),
                    password=Sys.getenv("DBPASSWORD"),
                    user = Sys.getenv("DBUSER"),
                    sslmode='require',
                    timezone = "UTC")
        return(db)
        },
        error = function(err) {
            print(paste("could not conect to ", Sys.getenv("DBHOST"), err))
            return(NULL)
        }
    )
}

get_db_info(db=NA)

get_species_range_map <-function(sciname='Pyrrhura devillei',db=NULL ){
    if(is.null(db)) { db <- getdb()}
    sql <- paste0("select shape  from all_species where sciname = '", sciname, "';")
    shape = st_read(db, query = sql)
    return(shape)
    
}

get_species_range_area <- function(sciname='Pyrrhura devillei', db=NULL ){
    # pulls just the first result from the database of the species
    if(is.null(db)) { db <- getdb()}
    sql <- paste0("select sciname,shape_area from all_species where sciname = '", sciname, "';")
    res <- dbSendQuery(db, sql)
    v<- dbFetch(res)
    dbClearResult(res)
    return(v)
}

calc_species_range_area <- function(sciname='Pyrrhura devillei', db=NULL){
    if(is.null(db)) { db <- getdb()}
    range_map <- get_species_range_map(sciname,db)
    sq_km <- sf::st_area(range_map)/(1000000)
    return(sq_km)

}


get_species_range_areas<-function(scinames, db=NULL){
    if(is.null(db)) { db <- getdb()}
    list_of_areas <- lapply(scinames, get_species_range_area, db) %>% bind_rows()
    return(list_of_areas)
    
}
# get a list of areas from a vector of species names
# do all of this directly from the database, rather than call it repeatedly
get_species_range_areas_db <- function(scinames, db=NULL){
    if(is.null(db)) { db <- getdb() }

    # create a temp table to hold species
    # TODO firt check if table exists
    print("not implemented yet")
    return(FALSE)
    
    # create a temporary table
    # create_table_sql <- paste0("CREATE TEMPORARY TABLE specieslist ( sciname varchar)")
    # insert species sent here into that table
    # create sql that joins that species lisst with all_species table, then uses Postgis to calculate 
    # the area in the "shape" column, excluding those with presence column = extinct code
    # return the results as a data frame with columns 'sciname' and 'areasqkm'
}


plot_species <-function(sciname='Pyrrhura devillei',db=NULL ){
    if(is.null(db)) { db <- getdb()}
    x<- get_species_rangemap(sciname, db)
    # http://vireo.ansp.org/search.html?Form=Search&SEARCHBY=Common&KEYWORDS=Blaze-winged+Parakeet&RESULTS=100&Search2=Search%22
    
    ggplot(data = world) +
        geom_sf() +
        geom_sf(data = x, fill = 'blue') +
        coord_sf(xlim = c(-85,-30), ylim = c(-60,15), expand = FALSE)
}

### another test of getting and mapping the range map of a species
## commented out as it needs to be converted into a function

# if (exists("db") && !inherits(db, "try-error")) {
#         dbListTables(db)
#         
#         # http://vireo.ansp.org/search.html?Form=Search&SEARCHBY=Common&KEYWORDS=Blaze-winged+Parakeet&RESULTS=100&Search2=Search%22
#         sql <- paste0("select shape  from all_species where sciname = '", sciname, "';")
#         
#         x = st_read(db, query = sql)
#         plot(x)
#         # x = st_read(db, table = "public.all_species")
#         
#         ggplot(data = world) +
#             geom_sf() +
#             geom_sf(data = x, fill = 'blue') +
#             coord_sf(xlim = c(-80,-30), ylim = c(-60,0), expand = FALSE)
#         #bbox:           xmin: -60.06708 ymin: -22.56171 xmax: -54.31781 ymax: -17.92462
#         
#         dbDisconnect(db)
# }       
