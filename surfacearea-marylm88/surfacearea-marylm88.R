setwd('/app')

# retrieve input parameters

library(optparse)
library(jsonlite)

option_list = list

option_list = list(
make_option(c("--df.merged.concat"), action="store", default=NA, type='character', help="my description"),

make_option(c("--df.temp"), action="store", default=NA, type='character', help="my description"),

make_option(c("--F"), action="store", default=NA, type='character', help="my description"),

make_option(c("--formulaforsurface"), action="store", default=NA, type='character', help="my description"),

make_option(c("--formulaforsurfacesimplified"), action="store", default=NA, type='character', help="my description"),

make_option(c("--id"), action="store", default=NA, type='character', help="my description"),

make_option(c("--index"), action="store", default=NA, type='character', help="my description"),

make_option(c("--sa.form"), action="store", default=NA, type='character', help="my description"),

make_option(c("--sa.formulas"), action="store", default=NA, type='character', help="my description"),

make_option(c("--SA_calc"), action="store", default=NA, type='character', help="my description"),

make_option(c("--surfacearea"), action="store", default=NA, type='character', help="my description")


make_option(c("--param_CalcType"), action="store", default=NA, type='character', help="my description"),
make_option(c("--param_surfacearea"), action="store", default=NA, type='character', help="my description")
)

# set input parameters accordingly
opt = parse_args(OptionParser(option_list=option_list))


df.merged.concat = fromJSON(opt$df.merged.concat)
df.temp = fromJSON(opt$df.temp)
F = opt$F
formulaforsurface = fromJSON(opt$formulaforsurface)
formulaforsurfacesimplified = fromJSON(opt$formulaforsurfacesimplified)
id = opt$id
index = fromJSON(opt$index)
sa.form = opt$sa.form
sa.formulas = fromJSON(opt$sa.formulas)
SA_calc = fromJSON(opt$SA_calc)
surfacearea = fromJSON(opt$surfacearea)

param_CalcType = opt$param_CalcType
param_surfacearea = opt$param_surfacearea




df.merged=read.csv('~/Unisalento/Lifewatch/Phyto_VRE/Script_R/Traits_Computation/dfmerged.csv',stringsAsFactors=F,sep = ";", dec = ".")

TraitSurfacearea=param_surfacearea
CalcType=param_CalcType

if(TraitSurfacearea==1){
  if(CalcType=='advanced'){
    df.merged$surfacearea <- rep(NA,length=nrow(df.merged))
    df.merged.concat <- df.merged[is.na(df.merged$formulaforsurface),]
    sa.formulas <- unique(df.merged[!is.na(df.merged$formulaforsurface),]$formulaforsurface)
    for(sa.form in sa.formulas){
      df.temp <- subset(df.merged,formulaforsurface==sa.form)
      df.temp$surfacearea <- round(with(df.temp,eval(parse(text=sa.form))),2)
      df.merged.concat <- rbind(df.merged.concat,df.temp)
    }
    df.merged.concat <- df.merged.concat[order(df.merged.concat$index),]
    df.merged <- df.merged.concat
    SA_calc <- df.merged$surfacearea
  }
  else if(CalcType=='simplified'){
    df.merged$surfacearea <- rep(NA,length=nrow(df.merged))
    df.merged.concat <- df.merged[is.na(df.merged$formulaforsurfacesimplified),]
    sa.formulas <- unique(df.merged[!is.na(df.merged$formulaforsurfacesimplified),]$formulaforsurfacesimplified)
    for(sa.form in sa.formulas){
      df.temp <- subset(df.merged,formulaforsurfacesimplified==sa.form)
      df.temp$surfacearea <- round(with(df.temp,eval(parse(text=sa.form))),2)
      df.merged.concat <- rbind(df.merged.concat,df.temp)
    }
    df.merged.concat <- df.merged.concat[order(df.merged.concat$index),]
    df.merged <- df.merged.concat
    SA_calc <- df.merged$surfacearea
  }
}

write.table(df.merged,paste('~/Unisalento/Lifewatch/Phyto_VRE/Script_R/Traits_Computation/dfmerged.csv',sep=''),row.names=F,sep = ";",dec = ".",quote=F)



# capturing outputs
file <- file(paste0('/tmp/TraitSurfacearea_', id, '.json'))
writeLines(toJSON(TraitSurfacearea, auto_unbox=TRUE), file)
close(file)
