setwd('/app')

# retrieve input parameters

library(optparse)
library(jsonlite)

option_list = list

option_list = list(
make_option(c("--id"), action="store", default=NA, type='character', help="my description"),

make_option(c("--param_CountingStrategy"), action="store", default=NA, type='character', help="my description")


)

# set input parameters accordingly
opt = parse_args(OptionParser(option_list=option_list))


id = opt$id
param_CountingStrategy = opt$param_CountingStrategy








if (param_density==1) {param_CountingStrategy <- 'density0'}

df.datain=read.csv(param_datain,stringsAsFactors=FALSE,sep = ";", dec = ".")
measurementremarks = tolower(df.datain$measurementremarks) # eliminate capital letters
df.datain$measurementremarks <- tolower(df.datain$measurementremarks) # eliminate capital letters
index = c(1:nrow(df.datain))
df.datain$index <- c(1:nrow(df.datain)) # needed to restore rows order later

df.operator<-read.csv('input/2_FILEinformativo_OPERATORE.csv',stringsAsFactors=FALSE,sep = ";", dec = ".") ## load internal database 
df.operator[df.operator==('no')]<-NA
df.operator[df.operator==('see note')]<-NA

df.merged <- merge(x = df.datain, y = df.operator, by = c("scientificname","measurementremarks"), all.x = TRUE)

diameterofsedimentationchamber = 'diameterofsedimentationchamber'
diameteroffieldofview = 'diameteroffieldofview'
transectcounting = 'transectcounting'
numberofcountedfields = 'numberofcountedfields'
numberoftransects = 'numberoftransects'
settlingvolume = 'settlingvolume'
dilutionfactor = 'dilutionfactor'

if(!'diameterofsedimentationchamber'%in%names(df.merged))df.merged$diameterofsedimentationchamber=NA
if(!'diameteroffieldofview'%in%names(df.merged))df.merged$diameteroffieldofview=NA
if(!'transectcounting'%in%names(df.merged))df.merged$transectcounting=NA
if(!'numberofcountedfields'%in%names(df.merged))df.merged$numberofcountedfields=df.merged$transectcounting
if(!'numberoftransects'%in%names(df.merged))df.merged$numberoftransects==df.merged$transectcounting
if(!'settlingvolume'%in%names(df.merged))df.merged$settlingvolume=NA
if(!'dilutionfactor'%in%names(df.merged))df.merged$dilutionfactor=1

write.table(df.merged,paste('output/dfmerged.csv',sep=''),row.names=FALSE,sep = ";",dec = ".",quote=FALSE)
write.table(df.datain,paste('output/dfdatain.csv',sep=''),row.names=FALSE,sep = ";",dec = ".",quote=FALSE) 



# capturing outputs
file <- file(paste0('/tmp/diameterofsedimentationchamber_', id, '.json'))
writeLines(toJSON(diameterofsedimentationchamber, auto_unbox=TRUE), file)
close(file)
file <- file(paste0('/tmp/dilutionfactor_', id, '.json'))
writeLines(toJSON(dilutionfactor, auto_unbox=TRUE), file)
close(file)
file <- file(paste0('/tmp/index_', id, '.json'))
writeLines(toJSON(index, auto_unbox=TRUE), file)
close(file)
file <- file(paste0('/tmp/numberoftransects_', id, '.json'))
writeLines(toJSON(numberoftransects, auto_unbox=TRUE), file)
close(file)
file <- file(paste0('/tmp/diameteroffieldofview_', id, '.json'))
writeLines(toJSON(diameteroffieldofview, auto_unbox=TRUE), file)
close(file)
file <- file(paste0('/tmp/numberofcountedfields_', id, '.json'))
writeLines(toJSON(numberofcountedfields, auto_unbox=TRUE), file)
close(file)
file <- file(paste0('/tmp/transectcounting_', id, '.json'))
writeLines(toJSON(transectcounting, auto_unbox=TRUE), file)
close(file)
file <- file(paste0('/tmp/settlingvolume_', id, '.json'))
writeLines(toJSON(settlingvolume, auto_unbox=TRUE), file)
close(file)
