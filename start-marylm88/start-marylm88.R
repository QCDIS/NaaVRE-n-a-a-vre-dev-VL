setwd('/app')

# retrieve input parameters

library(optparse)
library(jsonlite)

option_list = list

option_list = list(
make_option(c("--id"), action="store", default=NA, type='character', help="my description")


)

# set input parameters accordingly
opt = parse_args(OptionParser(option_list=option_list))


id = opt$id








df.datain=read.csv(param_datain,stringsAsFactors=FALSE,sep = ";", dec = ".")
df.datain[,'measurementremarks'] = tolower(df.datain[,'measurementremarks']) # eliminate capital letters
df.datain[,'index'] = c(1:nrow(df.datain)) # needed to restore rows order later

df.operator=read.csv('input/2_FILEinformativo_OPERATORE.csv',stringsAsFactors=FALSE,sep = ";", dec = ".") # load internal database 
df.operator[df.operator==('no')]<-NA
df.operator[df.operator==('see note')]<-NA

df.merged = merge(x = df.datain, y = df.operator, by = c("scientificname","measurementremarks"), all.x = TRUE)

if(!'diameterofsedimentationchamber'%in%names(df.merged))df.merged[,'diameterofsedimentationchamber']=NA
if(!'diameteroffieldofview'%in%names(df.merged))df.merged[,'diameteroffieldofview']=NA
if(!'transectcounting'%in%names(df.merged))df.merged[,'transectcounting']=NA
if(!'numberofcountedfields'%in%names(df.merged))df.merged[,'numberofcountedfields']=df.merged[,'transectcounting']
if(!'numberoftransects'%in%names(df.merged))df.merged[,'numberoftransects']=df.merged[,'transectcounting']
if(!'settlingvolume'%in%names(df.merged))df.merged[,'settlingvolume']=NA
if(!'dilutionfactor'%in%names(df.merged))df.merged[,'dilutionfactor']=1

output_dfmerged = 'output/dfmerged.csv'
output_dfdatain = 'output/dfdatain.csv'
write.table(df.merged,paste(output_dfmerged,sep=''),row.names=FALSE,sep = ";",dec = ".",quote=FALSE)
write.table(df.datain,paste(output_dfdatain,sep=''),row.names=FALSE,sep = ";",dec = ".",quote=FALSE)



# capturing outputs
file <- file(paste0('/tmp/output_dfmerged_', id, '.json'))
writeLines(toJSON(output_dfmerged, auto_unbox=TRUE), file)
close(file)
