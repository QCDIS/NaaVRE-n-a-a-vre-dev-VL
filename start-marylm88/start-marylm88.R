setwd('/app')

# retrieve input parameters

library(optparse)
library(jsonlite)

option_list = list

option_list = list(
make_option(c("--diameteroffieldofview"), action="store", default=NA, type='character', help="my description"),

make_option(c("--diameterofsedimentationchamber"), action="store", default=NA, type='character', help="my description"),

make_option(c("--dilutionfactor"), action="store", default=NA, type='character', help="my description"),

make_option(c("--F"), action="store", default=NA, type='character', help="my description"),

make_option(c("--id"), action="store", default=NA, type='character', help="my description"),

make_option(c("--index"), action="store", default=NA, type='character', help="my description"),

make_option(c("--measurementremarks"), action="store", default=NA, type='character', help="my description"),

make_option(c("--numberofcountedfields"), action="store", default=NA, type='character', help="my description"),

make_option(c("--numberoftransects"), action="store", default=NA, type='character', help="my description"),

make_option(c("--param_CountingStrategy"), action="store", default=NA, type='character', help="my description"),

make_option(c("--settlingvolume"), action="store", default=NA, type='character', help="my description"),

make_option(c("--transectcounting"), action="store", default=NA, type='character', help="my description")


)

# set input parameters accordingly
opt = parse_args(OptionParser(option_list=option_list))


diameteroffieldofview = opt$diameteroffieldofview
diameterofsedimentationchamber = opt$diameterofsedimentationchamber
dilutionfactor = opt$dilutionfactor
F = opt$F
id = opt$id
index = opt$index
measurementremarks = opt$measurementremarks
numberofcountedfields = opt$numberofcountedfields
numberoftransects = opt$numberoftransects
param_CountingStrategy = opt$param_CountingStrategy
settlingvolume = opt$settlingvolume
transectcounting = opt$transectcounting








if (param_density==1) {param_CountingStrategy <- 'density0'}

df.datain=read.csv(param_datain,stringsAsFactors=F,sep = ";", dec = ".")
df.datain$measurementremarks <- tolower(df.datain$measurementremarks) # eliminate capital letters
df.datain$index <- c(1:nrow(df.datain)) # needed to restore rows order later

df.operator<-read.csv('~/Unisalento/Lifewatch/Phyto_VRE/Script_R/Traits_Computation/2_FILEinformativo_OPERATORE.csv',stringsAsFactors=F,sep = ";", dec = ".") ## load internal database 
df.operator[df.operator==('no')]<-NA
df.operator[df.operator==('see note')]<-NA

df.merged <- merge(x = df.datain, y = df.operator, by = c("scientificname","measurementremarks"), all.x = TRUE)

if(!'diameterofsedimentationchamber'%in%names(df.merged))df.merged$diameterofsedimentationchamber=NA
if(!'diameteroffieldofview'%in%names(df.merged))df.merged$diameteroffieldofview=NA
if(!'transectcounting'%in%names(df.merged))df.merged$transectcounting=NA
if(!'numberofcountedfields'%in%names(df.merged))df.merged$numberofcountedfields=df.merged$transectcounting
if(!'numberoftransects'%in%names(df.merged))df.merged$numberoftransects==df.merged$transectcounting
if(!'settlingvolume'%in%names(df.merged))df.merged$settlingvolume=NA
if(!'dilutionfactor'%in%names(df.merged))df.merged$dilutionfactor=1

write.table(df.merged,paste('~/Unisalento/Lifewatch/Phyto_VRE/Script_R/Traits_Computation/dfmerged.csv',sep=''),row.names=F,sep = ";",dec = ".",quote=F)
write.table(df.datain,paste('~/Unisalento/Lifewatch/Phyto_VRE/Script_R/Traits_Computation/dfdatain.csv',sep=''),row.names=F,sep = ";",dec = ".",quote=F) 



