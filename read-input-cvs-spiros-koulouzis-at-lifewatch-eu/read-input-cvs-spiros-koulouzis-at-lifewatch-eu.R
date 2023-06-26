setwd('/app')

# retrieve input parameters

library(optparse)
library(jsonlite)

option_list = list

option_list = list(
make_option(c("--id"), action="store", default=NA, type='character', help="my description")


make_option(c("--param_hostname"), action="store", default=NA, type='character', help="my description"),
make_option(c("--param_login"), action="store", default=NA, type='character', help="my description"),
make_option(c("--param_password"), action="store", default=NA, type='character', help="my description")
)

# set input parameters accordingly
opt = parse_args(OptionParser(option_list=option_list))


id = opt$id

param_hostname = opt$param_hostname
param_login = opt$param_login
param_password = opt$param_password


conf_density = 1
conf_datain1 = 'traits/input/Phytoplankton__Progetto_Strategico_2009_2012_Australia.csv'
conf_datain2 = 'traits/input/2_FILEinformativo_OPERATORE.csv'
conf_local_datain1 = 'input/Phytoplankton__Progetto_Strategico_2009_2012_Australia.csv'
conf_local_datain2 = 'input/Phytoplankton__Progetto_Strategico_2009_2012_Australia.csv'


conf_density = 1
conf_datain1 = 'traits/input/Phytoplankton__Progetto_Strategico_2009_2012_Australia.csv'
conf_datain2 = 'traits/input/2_FILEinformativo_OPERATORE.csv'
conf_local_datain1 = 'input/Phytoplankton__Progetto_Strategico_2009_2012_Australia.csv'
conf_local_datain2 = 'input/Phytoplankton__Progetto_Strategico_2009_2012_Australia.csv'

install.packages("RCurl",repos = "http://cran.us.r-project.org")
RCurl = ''
library(RCurl)


UserPwd = ''

auth <- basicTextGatherer()
auth$UserPwd <- paste(param_login, param_password, sep = ":")


countingStrategy = ''
if (conf_density==1) {countingStrategy <- 'density0'}


file_content <- getURL(paste0(param_hostname,conf_datain1), curl = getCurlHandle(userpwd = auth$UserPwd))
writeLines(file_content, conf_local_datain1)

df.datain=read.csv(conf_local_datain1,stringsAsFactors=FALSE,sep = ";", dec = ".")
measurementremarks = tolower(df.datain$measurementremarks) # eliminate capital letters
df.datain$measurementremarks <- tolower(df.datain$measurementremarks) # eliminate capital letters
index = c(1:nrow(df.datain))
df.datain$index <- c(1:nrow(df.datain)) # needed to restore rows order later

file_content <- getURL(paste0(param_hostname,conf_datain2), curl = getCurlHandle(userpwd = auth$UserPwd))
writeLines(file_content, conf_local_datain2)

df.operator<-read.csv(conf_local_datain2,stringsAsFactors=FALSE,sep = ";", dec = ".") ## load internal database 
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

output_dfmerged = 'output/dfmerged.csv'
output_dfdatain = 'output/dfdatain.csv'
write.table(df.merged,paste(output_dfmerged,sep=''),row.names=FALSE,sep = ";",dec = ".",quote=FALSE)
write.table(df.datain,paste(output_dfdatain,sep=''),row.names=FALSE,sep = ";",dec = ".",quote=FALSE)





# capturing outputs
file <- file(paste0('/tmp/settlingvolume_', id, '.json'))
writeLines(toJSON(settlingvolume, auto_unbox=TRUE), file)
close(file)
file <- file(paste0('/tmp/transectcounting_', id, '.json'))
writeLines(toJSON(transectcounting, auto_unbox=TRUE), file)
close(file)
file <- file(paste0('/tmp/output_dfmerged_', id, '.json'))
writeLines(toJSON(output_dfmerged, auto_unbox=TRUE), file)
close(file)
file <- file(paste0('/tmp/diameteroffieldofview_', id, '.json'))
writeLines(toJSON(diameteroffieldofview, auto_unbox=TRUE), file)
close(file)
file <- file(paste0('/tmp/diameterofsedimentationchamber_', id, '.json'))
writeLines(toJSON(diameterofsedimentationchamber, auto_unbox=TRUE), file)
close(file)
file <- file(paste0('/tmp/dilutionfactor_', id, '.json'))
writeLines(toJSON(dilutionfactor, auto_unbox=TRUE), file)
close(file)
file <- file(paste0('/tmp/numberofcountedfields_', id, '.json'))
writeLines(toJSON(numberofcountedfields, auto_unbox=TRUE), file)
close(file)
file <- file(paste0('/tmp/auth_', id, '.json'))
writeLines(toJSON(auth, auto_unbox=TRUE), file)
close(file)
file <- file(paste0('/tmp/UserPwd_', id, '.json'))
writeLines(toJSON(UserPwd, auto_unbox=TRUE), file)
close(file)
file <- file(paste0('/tmp/numberoftransects_', id, '.json'))
writeLines(toJSON(numberoftransects, auto_unbox=TRUE), file)
close(file)
file <- file(paste0('/tmp/index_', id, '.json'))
writeLines(toJSON(index, auto_unbox=TRUE), file)
close(file)
file <- file(paste0('/tmp/countingStrategy_', id, '.json'))
writeLines(toJSON(countingStrategy, auto_unbox=TRUE), file)
close(file)
