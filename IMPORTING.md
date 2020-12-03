# Importing the BOTW geodatabase into PostGIS database

Azure could not handle 7z or the botw 7zip file
so on the HPC, used 7z to unsip the file, Then used tar to create new tgz file that
could be pulled into an Azure linux shell and extracted



install anaconda to get python AND gdal.  I did not have much luck installing gdal from scratch in the azure cloud shell.  

```sh
curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash ./Miniconda3-latest-Linux-x86_64.sh 
rm Miniconda3-latest-Linux-x86_64.sh
conda create --name geo; conda activate geo
conda install -c conda-forge gdal
```

### create PG server, install postgis

```
ADMINUSER=
ADMINPW=
psql "host=frugivoria-dev.postgres.database.azure.com port=5432 dbname=botw user=${ADMINUSER}@frugivoria-dev password=$ADMINPW sslmode=require"
```
once logged into the server, creata a new database just for this

```SQL
create database botw;
```

here is the ogr2ogr2 command that actually worked to import this huge GDB file
```sh
PG_USE_COPY=YES ogr2ogr -overwrite -progress -f "PostgreSQL" PG:"host=frugivoria-dev.postgres.database.azure.com  port=5432 dbname=botw user=frugivoriaadmin@frugivoria-dev password=EFCodd1972" BOTW.gdb "All_Species" -nlt MULTIPOLYGON
