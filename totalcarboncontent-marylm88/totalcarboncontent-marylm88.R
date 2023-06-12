setwd('/app')

# retrieve input parameters

library(optparse)
library(jsonlite)

option_list = list

option_list = list(
make_option(c("--cellcarboncontent"), action="store", default=NA, type='character', help="my description"),

make_option(c("--density"), action="store", default=NA, type='character', help="my description"),

make_option(c("--F"), action="store", default=NA, type='character', help="my description"),

make_option(c("--id"), action="store", default=NA, type='character', help="my description"),

make_option(c("--TCC_calc"), action="store", default=NA, type='character', help="my description")


make_option(c("--param_cellcarboncontent"), action="store", default=NA, type='character', help="my description"),
make_option(c("--param_density"), action="store", default=NA, type='character', help="my description"),
make_option(c("--param_totalcarboncontent"), action="store", default=NA, type='character', help="my description")
)

# set input parameters accordingly
opt = parse_args(OptionParser(option_list=option_list))


cellcarboncontent = fromJSON(opt$cellcarboncontent)
density = fromJSON(opt$density)
F = opt$F
id = opt$id
TCC_calc = fromJSON(opt$TCC_calc)

param_cellcarboncontent = opt$param_cellcarboncontent
param_density = opt$param_density
param_totalcarboncontent = opt$param_totalcarboncontent




df.merged=read.csv('~/Unisalento/Lifewatch/Phyto_VRE/Script_R/Traits_Computation/dfmerged.csv',stringsAsFactors=F,sep = ";", dec = ".")

TraitTotalcarboncontent=param_totalcarboncontent
TraitDensity=param_density
TraitCellcarboncontent=param_cellcarboncontent

if(TraitTotalcarboncontent==1){
  if((TraitDensity==0) & (!'density'%in%names(df.merged))) df.merged$density<-NA
  if((TraitCellcarboncontent==0) & (!'cellcarboncontent'%in%names(df.merged))) df.merged$cellcarboncontent<-NA
  TCC_calc<-round(df.merged$density*df.merged$cellcarboncontent,2)
}

write.table(df.merged,paste('~/Unisalento/Lifewatch/Phyto_VRE/Script_R/Traits_Computation/dfmerged.csv',sep=''),row.names=F,sep = ";",dec = ".",quote=F)



# capturing outputs
file <- file(paste0('/tmp/TraitCellcarboncontent_', id, '.json'))
writeLines(toJSON(TraitCellcarboncontent, auto_unbox=TRUE), file)
close(file)
file <- file(paste0('/tmp/TraitTotalcarboncontent_', id, '.json'))
writeLines(toJSON(TraitTotalcarboncontent, auto_unbox=TRUE), file)
close(file)
file <- file(paste0('/tmp/TraitDensity_', id, '.json'))
writeLines(toJSON(TraitDensity, auto_unbox=TRUE), file)
close(file)
