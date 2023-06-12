setwd('/app')

# retrieve input parameters

library(optparse)
library(jsonlite)

option_list = list

option_list = list(
make_option(c("--biovolume"), action="store", default=NA, type='character', help="my description"),

make_option(c("--F"), action="store", default=NA, type='character', help="my description"),

make_option(c("--id"), action="store", default=NA, type='character', help="my description"),

make_option(c("--surfacearea"), action="store", default=NA, type='character', help="my description"),

make_option(c("--SVR_calc"), action="store", default=NA, type='character', help="my description")


make_option(c("--param_biovolume"), action="store", default=NA, type='character', help="my description"),
make_option(c("--param_surfacearea"), action="store", default=NA, type='character', help="my description"),
make_option(c("--param_surfacevolumeratio"), action="store", default=NA, type='character', help="my description")
)

# set input parameters accordingly
opt = parse_args(OptionParser(option_list=option_list))


biovolume = fromJSON(opt$biovolume)
F = opt$F
id = opt$id
surfacearea = fromJSON(opt$surfacearea)
SVR_calc = fromJSON(opt$SVR_calc)

param_biovolume = opt$param_biovolume
param_surfacearea = opt$param_surfacearea
param_surfacevolumeratio = opt$param_surfacevolumeratio




df.merged=read.csv('~/Unisalento/Lifewatch/Phyto_VRE/Script_R/Traits_Computation/dfmerged.csv',stringsAsFactors=F,sep = ";", dec = ".")

TraitSurfacevolumeratio=param_surfacevolumeratio
TraitSurfacearea=param_surfacearea
TraitBiovolume=param_biovolume

if(TraitSurfacevolumeratio==1){
  if((TraitSurfacearea==0) & (!'surfacearea'%in%names(df.merged))) df.merged$surfacearea<-NA
  if((TraitBiovolume==0) & (!'biovolume'%in%names(df.merged))) df.merged$biovolume<-NA
  SVR_calc<-round(df.merged$surfacearea/df.merged$biovolume,2)
}

write.table(df.merged,paste('~/Unisalento/Lifewatch/Phyto_VRE/Script_R/Traits_Computation/dfmerged.csv',sep=''),row.names=F,sep = ";",dec = ".",quote=F)



# capturing outputs
file <- file(paste0('/tmp/TraitSurfacevolumeratio_', id, '.json'))
writeLines(toJSON(TraitSurfacevolumeratio, auto_unbox=TRUE), file)
close(file)
file <- file(paste0('/tmp/TraitBiovolume_', id, '.json'))
writeLines(toJSON(TraitBiovolume, auto_unbox=TRUE), file)
close(file)
file <- file(paste0('/tmp/TraitSurfacearea_', id, '.json'))
writeLines(toJSON(TraitSurfacearea, auto_unbox=TRUE), file)
close(file)
