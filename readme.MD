# BoTW: reading a PostGIS version of the BOTW database

When requesting data from BoTW you may be presented with a huge GDB file.  

## installing RPostgres library on Mac

this is a royal pain.  While installing postgresql itself, and the utilties to connect are not hard, for some reason installing the libraries that the Rpostgres package depends on with MacOS is tricky for an Azure-based Postgresql database (it's related to security lib and apple's war with open source software).  

I think this is what I had to do on MacOS 10.15 (all using the MacOS terminal).  This has not be tested exactly as listed on a new MacOS system, and not on MacOS 11 at all.    

install homebrew if you don't have it.  Homebrew makes installing geo packages easy.  See https://brew.sh/ for terminal instructions.  

Then in the terminal do the following: 

```sh
brew install openssl 
brew link --force openssl
echo 'export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"' >> /Users/billspat/.bash_profile

export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include"
brew install postgresql 
# or  brew reinstall postgresql   if you already have installed postgresql
```

In R: 

Start a new R session
If you already hae tried to install Rpostgres, install it again


```R
remove.packages('RPostgres')
install.packages('RPostgres', type = 'source')

```

There is another Postgres connection package, `RPostgreSQL` which may work better but it hasn't been maintained in a while and apparently has some serious numerical accuracy issues.   The 'RPostgres' package is maintained by Rstudio.  


Note that to use many of these you'll need to install geos and gdal on your mac which is a diferent topic and I assume you have these working but before in.  (link to instructions?) `brew install proj gdal geos` then in R `install.packages('rgeos')` 


### setting database configuration

To keep database username and passwords out of git and this script, this  uses a personalized
`.Renviron` file that you must create.  Copy the `exampleRenviron` file to `.Renviron` 
(or save-as) and edit with the correct values.   the .gitignore file will keep it out of git.  
Do not edit the exampleRenviron file directly directly. 

 
 ### Using this library
 
 ```R
 sciname <- 'Pyrrhura devillei'
 db<- getdb()  
 # this will error if it's not configured
 # or if the database firewall is not open to your computer
 plot_species(sciname, db)
 ```

 (example_Pyrrhura_devillei_range_map.png, "Pyrrhura devillei range")

 
 ```R
 scinames <- c("Selenidera maculirostris", 'Pyrrhura devillei')
 areas_df <- get_species_range_areas(scinames, db)
 # a data frame :
 
                   sciname shape_area
1 Selenidera maculirostris   81.94514
2        Pyrrhura devillei   12.43406
 
```

