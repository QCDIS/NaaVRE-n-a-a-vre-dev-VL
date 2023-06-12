setwd('/app')

# retrieve input parameters

library(optparse)
library(jsonlite)

option_list = list

option_list = list(
make_option(c("--df.merged.concat"), action="store", default=NA, type='character', help="my description"),

make_option(c("--df.temp"), action="store", default=NA, type='character', help="my description"),

make_option(c("--df.temp2"), action="store", default=NA, type='character', help="my description"),

make_option(c("--F"), action="store", default=NA, type='character', help="my description"),

make_option(c("--formulaformissingdimension"), action="store", default=NA, type='character', help="my description"),

make_option(c("--formulaformissingdimensionsimplified"), action="store", default=NA, type='character', help="my description"),

make_option(c("--id"), action="store", default=NA, type='character', help="my description"),

make_option(c("--index"), action="store", default=NA, type='character', help="my description"),

make_option(c("--md"), action="store", default=NA, type='character', help="my description"),

make_option(c("--md.form"), action="store", default=NA, type='character', help="my description"),

make_option(c("--md.formulas"), action="store", default=NA, type='character', help="my description"),

make_option(c("--missingdimension"), action="store", default=NA, type='character', help="my description"),

make_option(c("--missingdimensionsimplified"), action="store", default=NA, type='character', help="my description")


make_option(c("--param_CalcType"), action="store", default=NA, type='character', help="my description")
)

# set input parameters accordingly
opt = parse_args(OptionParser(option_list=option_list))


df.merged.concat = fromJSON(opt$df.merged.concat)
df.temp = fromJSON(opt$df.temp)
df.temp2 = fromJSON(opt$df.temp2)
F = opt$F
formulaformissingdimension = fromJSON(opt$formulaformissingdimension)
formulaformissingdimensionsimplified = fromJSON(opt$formulaformissingdimensionsimplified)
id = opt$id
index = fromJSON(opt$index)
md = opt$md
md.form = fromJSON(opt$md.form)
md.formulas = fromJSON(opt$md.formulas)
missingdimension = fromJSON(opt$missingdimension)
missingdimensionsimplified = fromJSON(opt$missingdimensionsimplified)

param_CalcType = opt$param_CalcType




df.merged=read.csv('~/Unisalento/Lifewatch/Phyto_VRE/Script_R/Traits_Computation/dfmerged.csv',stringsAsFactors=F,sep = ";", dec = ".")
CalcType=param_CalcType

if(CalcType=='advanced'){
  df.merged.concat <- df.merged[is.na(df.merged$formulaformissingdimension),]
  md.formulas <- unique(df.merged[!is.na(df.merged$formulaformissingdimension),]$formulaformissingdimension)
  for(md.form in md.formulas){
    df.temp <- subset(df.merged,formulaformissingdimension==md.form)
    for(md in unique(df.temp$missingdimension)){
      df.temp2 <- df.temp[df.temp$missingdimension==md,]
      df.temp2[[md]] <- round(with(df.temp2,eval(parse(text=md.form))),2)
      df.merged.concat <- rbind(df.merged.concat,df.temp2)
    }
  }
  df.merged.concat <- df.merged.concat[order(df.merged.concat$index),]
  df.merged <- df.merged.concat
} else if(CalcType=='simplified'){
  df.merged.concat <- df.merged[is.na(df.merged$formulaformissingdimensionsimplified),]
  md.formulas <- unique(df.merged[!is.na(df.merged$formulaformissingdimensionsimplified),]$formulaformissingdimensionsimplified)
  for(md.form in md.formulas){
    df.temp <- subset(df.merged,formulaformissingdimensionsimplified==md.form)
    for(md in unique(df.temp$missingdimensionsimplified)){
      df.temp2 <- df.temp[df.temp$missingdimensionsimplified==md,]
      df.temp2[[md]] <- round(with(df.temp2,eval(parse(text=md.form))),2)
      df.merged.concat <- rbind(df.merged.concat,df.temp2)
    }
  }
  df.merged.concat <- df.merged.concat[order(df.merged.concat$index),]
  df.merged <- df.merged.concat
}
    
write.table(df.merged,paste('~/Unisalento/Lifewatch/Phyto_VRE/Script_R/Traits_Computation/dfmerged.csv',sep=''),row.names=F,sep = ";",dec = ".",quote=F)    



