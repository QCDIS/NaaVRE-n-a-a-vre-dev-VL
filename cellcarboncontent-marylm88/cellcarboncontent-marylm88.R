setwd('/app')

# retrieve input parameters

library(optparse)
library(jsonlite)

option_list = list

option_list = list(
make_option(c("--biovolume"), action="store", default=NA, type='character', help="my description"),

make_option(c("--cc.form"), action="store", default=NA, type='character', help="my description"),

make_option(c("--cc.formulas1"), action="store", default=NA, type='character', help="my description"),

make_option(c("--cc.formulas2"), action="store", default=NA, type='character', help="my description"),

make_option(c("--CC_calc"), action="store", default=NA, type='character', help="my description"),

make_option(c("--cellcarboncontent"), action="store", default=NA, type='character', help="my description"),

make_option(c("--df.cc"), action="store", default=NA, type='character', help="my description"),

make_option(c("--df.cc1"), action="store", default=NA, type='character', help="my description"),

make_option(c("--df.cc2"), action="store", default=NA, type='character', help="my description"),

make_option(c("--df.merged.concat"), action="store", default=NA, type='character', help="my description"),

make_option(c("--df.temp"), action="store", default=NA, type='character', help="my description"),

make_option(c("--F"), action="store", default=NA, type='character', help="my description"),

make_option(c("--formulaforweight1"), action="store", default=NA, type='character', help="my description"),

make_option(c("--formulaforweight2"), action="store", default=NA, type='character', help="my description"),

make_option(c("--id"), action="store", default=NA, type='character', help="my description"),

make_option(c("--index"), action="store", default=NA, type='character', help="my description")


make_option(c("--param_biovolume"), action="store", default=NA, type='character', help="my description"),
make_option(c("--param_cellcarboncontent"), action="store", default=NA, type='character', help="my description")
)

# set input parameters accordingly
opt = parse_args(OptionParser(option_list=option_list))


biovolume = fromJSON(opt$biovolume)
cc.form = opt$cc.form
cc.formulas1 = fromJSON(opt$cc.formulas1)
cc.formulas2 = fromJSON(opt$cc.formulas2)
CC_calc = fromJSON(opt$CC_calc)
cellcarboncontent = fromJSON(opt$cellcarboncontent)
df.cc = fromJSON(opt$df.cc)
df.cc1 = fromJSON(opt$df.cc1)
df.cc2 = fromJSON(opt$df.cc2)
df.merged.concat = fromJSON(opt$df.merged.concat)
df.temp = fromJSON(opt$df.temp)
F = opt$F
formulaforweight1 = fromJSON(opt$formulaforweight1)
formulaforweight2 = fromJSON(opt$formulaforweight2)
id = opt$id
index = fromJSON(opt$index)

param_biovolume = opt$param_biovolume
param_cellcarboncontent = opt$param_cellcarboncontent




df.merged=read.csv('~/Unisalento/Lifewatch/Phyto_VRE/Script_R/Traits_Computation/dfmerged.csv',stringsAsFactors=F,sep = ";", dec = ".")

TraitCellcarboncontent=param_cellcarboncontent
TraitBiovolume=param_biovolume

if(TraitCellcarboncontent==1){
  
  df.merged$cellcarboncontent <- rep(NA,length=nrow(df.merged))
  if(TraitBiovolume==1){
    df.merged.concat <- df.merged[is.na(df.merged$biovolume),]
    df.cc <- df.merged[!is.na(df.merged$biovolume),]
    df.cc1 <- subset(df.cc,biovolume <= 3000)
    df.cc2 <- subset(df.cc,biovolume > 3000)
    cc.formulas1 <- unique(df.merged[!is.na(df.merged$formulaforweight1),]$formulaforweight1)
    for(cc.form in cc.formulas1){
      df.temp <- subset(df.cc1,formulaforweight1==cc.form)
      df.temp$cellcarboncontent <- round(with(df.temp,eval(parse(text=tolower(cc.form)))),2)
      df.merged.concat <- rbind(df.merged.concat,df.temp)
    }
    cc.formulas2 <- unique(df.merged[!is.na(df.merged$formulaforweight2),]$formulaforweight2)
    for(cc.form in cc.formulas2){
      df.temp <- subset(df.cc2,formulaforweight2==cc.form)
      df.temp$cellcarboncontent <- round(with(df.temp,eval(parse(text=tolower(cc.form)))),2)
      df.merged.concat <- rbind(df.merged.concat,df.temp)
    }
    df.merged.concat <- df.merged.concat[order(df.merged.concat$index),]
    df.merged <- df.merged.concat
    CC_calc = df.merged$cellcarboncontent
  }
}
    
write.table(df.merged,paste('~/Unisalento/Lifewatch/Phyto_VRE/Script_R/Traits_Computation/dfmerged.csv',sep=''),row.names=F,sep = ";",dec = ".",quote=F) 



# capturing outputs
file <- file(paste0('/tmp/TraitCellcarboncontent_', id, '.json'))
writeLines(toJSON(TraitCellcarboncontent, auto_unbox=TRUE), file)
close(file)
file <- file(paste0('/tmp/TraitBiovolume_', id, '.json'))
writeLines(toJSON(TraitBiovolume, auto_unbox=TRUE), file)
close(file)
