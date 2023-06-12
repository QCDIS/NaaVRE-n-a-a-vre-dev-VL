setwd('/app')

# retrieve input parameters

library(optparse)
library(jsonlite)

option_list = list

option_list = list(
make_option(c("--biovolume"), action="store", default=NA, type='character', help="my description"),

make_option(c("--density"), action="store", default=NA, type='character', help="my description"),

make_option(c("--F"), action="store", default=NA, type='character', help="my description"),

make_option(c("--id"), action="store", default=NA, type='character', help="my description"),

make_option(c("--TBV_calc"), action="store", default=NA, type='character', help="my description")


make_option(c("--param_biovolume"), action="store", default=NA, type='character', help="my description"),
make_option(c("--param_density"), action="store", default=NA, type='character', help="my description"),
make_option(c("--param_totalbiovolume"), action="store", default=NA, type='character', help="my description")
)

# set input parameters accordingly
opt = parse_args(OptionParser(option_list=option_list))


biovolume = fromJSON(opt$biovolume)
density = fromJSON(opt$density)
F = opt$F
id = opt$id
TBV_calc = fromJSON(opt$TBV_calc)

param_biovolume = opt$param_biovolume
param_density = opt$param_density
param_totalbiovolume = opt$param_totalbiovolume




df.merged=read.csv('~/Unisalento/Lifewatch/Phyto_VRE/Script_R/Traits_Computation/dfmerged.csv',stringsAsFactors=F,sep = ";", dec = ".")

TraitTotalbiovolume=param_totalbiovolume
TraitDensity=param_density
TraitBiovolume=param_biovolume

if(TraitTotalbiovolume==1){
  if((TraitDensity==0) & (!'density'%in%names(df.merged))) df.merged$density<-NA
  if((TraitBiovolume==0) & (!'biovolume'%in%names(df.merged))) df.merged$biovolume<-NA
  TBV_calc = round(df.merged$density*df.merged$biovolume,2)
}

write.table(df.merged,paste('~/Unisalento/Lifewatch/Phyto_VRE/Script_R/Traits_Computation/dfmerged.csv',sep=''),row.names=F,sep = ";",dec = ".",quote=F)



# capturing outputs
file <- file(paste0('/tmp/TraitBiovolume_', id, '.json'))
writeLines(toJSON(TraitBiovolume, auto_unbox=TRUE), file)
close(file)
file <- file(paste0('/tmp/TraitDensity_', id, '.json'))
writeLines(toJSON(TraitDensity, auto_unbox=TRUE), file)
close(file)
file <- file(paste0('/tmp/TraitTotalbiovolume_', id, '.json'))
writeLines(toJSON(TraitTotalbiovolume, auto_unbox=TRUE), file)
close(file)
