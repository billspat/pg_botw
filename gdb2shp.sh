# Convert GDB to SHP
# For bird polygons
# QDR / NEON / 22 Jun 2018
# stolen from Quentin Read, written to run on the MSU HPCC

module load GDAL/2.0.1

# change to folder with BOTW downloaded. 
# Modify this for currently location of gdb file, or leave commented and use the current dir
# cd /mnt/research/nasabio/data/bbs/birds_of_the_world

# Confirm that fileGDB is supported
ogrinfo --formats

# Get the scientific name from each shape file (load the CSV into R and match taxonomic lists to figure out which polygons we need to subset)
ogr2ogr -nlt NONE -f "CSV" botwmetadata.csv BOTW.gdb/

# Create .shp file with only the polygons from NEON taxa (small enough file size to work with)
# Use a SQL query constructed from the scientific name text file scinames_oneline.txt created with R
scinamestring=$(cat scinames_oneline.txt)
ogr2ogr -f "ESRI Shapefile" -sql "SELECT * FROM All_Species WHERE SCINAME IN ($scinamestring)" ./botw_neon_taxa BOTW.gdb/ 
