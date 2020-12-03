
# library(RPostgreSQL)

library(RPostgres)
library(sf)
library(ggplot2)

library(rnaturalearth)
library(rnaturalearthdata)
library(rgeos)
world <- ne_countries(scale = "medium", returnclass = "sf")

# get a database connection using params in the .Renviron file

try(db <- dbConnect(RPostgres::Postgres(), 
                    dbname = 'botw',
                    host = Sys.getenv("DBHOST"),
                    port = as.integer(Sys.getenv("DBPORT")),
                    password=Sys.getenv("DBPASSWORD"),
                    user = Sys.getenv("DBUSER"),
                    sslmode='require'
)
)



if (exists("db") && !inherits(db, "try-error")) {
    dbListTables(db)
    ex_species <-  'Pyrrhura devillei' 
    # http://vireo.ansp.org/search.html?Form=Search&SEARCHBY=Common&KEYWORDS=Blaze-winged+Parakeet&RESULTS=100&Search2=Search%22
    sql <- paste0("select shape  from all_species where sciname = '", ex_species, "';")
    
    x = st_read(db, query = sql)
    plot(x)
    # x = st_read(db, table = "public.all_species")
    
    ggplot(data = world) +
        geom_sf() +
        geom_sf(data = x, fill = 'blue') +
        coord_sf(xlim = c(-80,-30), ylim = c(-60,0), expand = FALSE)
        #bbox:           xmin: -60.06708 ymin: -22.56171 xmax: -54.31781 ymax: -17.92462

    dbDisconnect(db)
}
