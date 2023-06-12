setwd('/app')

# retrieve input parameters

library(optparse)
library(jsonlite)

option_list = list

option_list = list(
make_option(c("--biovolume"), action="store", default=NA, type='character', help="my description"),

make_option(c("--bv.form"), action="store", default=NA, type='character', help="my description"),

make_option(c("--bv.formulas"), action="store", default=NA, type='character', help="my description"),

make_option(c("--BV_calc"), action="store", default=NA, type='character', help="my description"),

make_option(c("--df.merged.concat"), action="store", default=NA, type='character', help="my description"),

make_option(c("--df.temp"), action="store", default=NA, type='character', help="my description"),

make_option(c("--F"), action="store", default=NA, type='character', help="my description"),

make_option(c("--formulaforbiovolume"), action="store", default=NA, type='character', help="my description"),

make_option(c("--formulaforbiovolumesimplified"), action="store", default=NA, type='character', help="my description"),

make_option(c("--id"), action="store", default=NA, type='character', help="my description"),

make_option(c("--index"), action="store", default=NA, type='character', help="my description")


make_option(c("--param_biovolume"), action="store", default=NA, type='character', help="my description"),
make_option(c("--param_CalcType"), action="store", default=NA, type='character', help="my description")
)

# set input parameters accordingly
opt = parse_args(OptionParser(option_list=option_list))


biovolume = fromJSON(opt$biovolume)
bv.form = opt$bv.form
bv.formulas = fromJSON(opt$bv.formulas)
BV_calc = fromJSON(opt$BV_calc)
df.merged.concat = fromJSON(opt$df.merged.concat)
df.temp = fromJSON(opt$df.temp)
F = opt$F
formulaforbiovolume = fromJSON(opt$formulaforbiovolume)
formulaforbiovolumesimplified = fromJSON(opt$formulaforbiovolumesimplified)
id = opt$id
index = fromJSON(opt$index)

param_biovolume = opt$param_biovolume
param_CalcType = opt$param_CalcType




df.merged=read.csv('~/Unisalento/Lifewatch/Phyto_VRE/Script_R/Traits_Computation/dfmerged.csv',stringsAsFactors=F,sep = ";", dec = ".")
TraitBiovolume=param_biovolume
CalcType=param_CalcType

if(TraitBiovolume==1){
  
  if(CalcType=='advanced'){
    df.merged$biovolume <- rep(NA,length=nrow(df.merged))
    df.merged.concat <- df.merged[is.na(df.merged$formulaforbiovolume),]
    bv.formulas <- unique(df.merged[!is.na(df.merged$formulaforbiovolume),]$formulaforbiovolume)
    for(bv.form in bv.formulas){
      df.temp <- subset(df.merged,formulaforbiovolume==bv.form)
      df.temp$biovolume <- round(with(df.temp,eval(parse(text=bv.form))),2)
      df.merged.concat <- rbind(df.merged.concat,df.temp)
    }
    df.merged.concat <- df.merged.concat[order(df.merged.concat$index),]
    df.merged <- df.merged.concat
    BV_calc = df.merged$biovolume
  }
  else if(CalcType=='simplified'){
    df.merged$biovolume <- rep(NA,length=nrow(df.merged))
    df.merged.concat <- df.merged[is.na(df.merged$formulaforbiovolumesimplified),]
    bv.formulas <- unique(df.merged[!is.na(df.merged$formulaforbiovolumesimplified),]$formulaforbiovolumesimplified)
    for(bv.form in bv.formulas){
      df.temp <- subset(df.merged,formulaforbiovolumesimplified==bv.form)
      df.temp$biovolume <- round(with(df.temp,eval(parse(text=bv.form))),2)
      df.merged.concat <- rbind(df.merged.concat,df.temp)
    }
    df.merged.concat <- df.merged.concat[order(df.merged.concat$index),]
    df.merged <- df.merged.concat
    BV_calc = df.merged$biovolume
  }
} 

write.table(df.merged,paste('~/Unisalento/Lifewatch/Phyto_VRE/Script_R/Traits_Computation/dfmerged.csv',sep=''),row.names=F,sep = ";",dec = ".",quote=F)



# capturing outputs
file <- file(paste0('/tmp/TraitBiovolume_', id, '.json'))
writeLines(toJSON(TraitBiovolume, auto_unbox=TRUE), file)
close(file)
