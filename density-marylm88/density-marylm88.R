setwd('/app')

# retrieve input parameters

library(optparse)
library(jsonlite)

option_list = list

option_list = list(
make_option(c("--areaofcountingfield"), action="store", default=NA, type='character', help="my description"),

make_option(c("--areaofsedimentationchamber"), action="store", default=NA, type='character', help="my description"),

make_option(c("--D_calc"), action="store", default=NA, type='character', help="my description"),

make_option(c("--density"), action="store", default=NA, type='character', help="my description"),

make_option(c("--df.merged.concat"), action="store", default=NA, type='character', help="my description"),

make_option(c("--df.temp"), action="store", default=NA, type='character', help="my description"),

make_option(c("--df.temp1"), action="store", default=NA, type='character', help="my description"),

make_option(c("--df.temp2"), action="store", default=NA, type='character', help="my description"),

make_option(c("--df.temp3"), action="store", default=NA, type='character', help="my description"),

make_option(c("--df.temp4"), action="store", default=NA, type='character', help="my description"),

make_option(c("--df.temp5"), action="store", default=NA, type='character', help="my description"),

make_option(c("--diameteroffieldofview"), action="store", default=NA, type='character', help="my description"),

make_option(c("--diameterofsedimentationchamber"), action="store", default=NA, type='character', help="my description"),

make_option(c("--dilutionfactor"), action="store", default=NA, type='character', help="my description"),

make_option(c("--F"), action="store", default=NA, type='character', help="my description"),

make_option(c("--id"), action="store", default=NA, type='character', help="my description"),

make_option(c("--index"), action="store", default=NA, type='character', help="my description"),

make_option(c("--numberofcountedfields"), action="store", default=NA, type='character', help="my description"),

make_option(c("--numberoftransects"), action="store", default=NA, type='character', help="my description"),

make_option(c("--organismquantity"), action="store", default=NA, type='character', help="my description"),

make_option(c("--param_CountingStrategy"), action="store", default=NA, type='character', help="my description"),

make_option(c("--pi"), action="store", default=NA, type='character', help="my description"),

make_option(c("--settlingvolume"), action="store", default=NA, type='character', help="my description"),

make_option(c("--transectcounting"), action="store", default=NA, type='character', help="my description"),

make_option(c("--volumeofsedimentationchamber"), action="store", default=NA, type='character', help="my description")


make_option(c("--param_density"), action="store", default=NA, type='character', help="my description")
)

# set input parameters accordingly
opt = parse_args(OptionParser(option_list=option_list))


areaofcountingfield = fromJSON(opt$areaofcountingfield)
areaofsedimentationchamber = fromJSON(opt$areaofsedimentationchamber)
D_calc = fromJSON(opt$D_calc)
density = fromJSON(opt$density)
df.merged.concat = fromJSON(opt$df.merged.concat)
df.temp = fromJSON(opt$df.temp)
df.temp1 = fromJSON(opt$df.temp1)
df.temp2 = fromJSON(opt$df.temp2)
df.temp3 = fromJSON(opt$df.temp3)
df.temp4 = fromJSON(opt$df.temp4)
df.temp5 = fromJSON(opt$df.temp5)
diameteroffieldofview = fromJSON(opt$diameteroffieldofview)
diameterofsedimentationchamber = fromJSON(opt$diameterofsedimentationchamber)
dilutionfactor = fromJSON(opt$dilutionfactor)
F = opt$F
id = opt$id
index = fromJSON(opt$index)
numberofcountedfields = fromJSON(opt$numberofcountedfields)
numberoftransects = fromJSON(opt$numberoftransects)
organismquantity = fromJSON(opt$organismquantity)
param_CountingStrategy = opt$param_CountingStrategy
pi = opt$pi
settlingvolume = fromJSON(opt$settlingvolume)
transectcounting = fromJSON(opt$transectcounting)
volumeofsedimentationchamber = fromJSON(opt$volumeofsedimentationchamber)

param_density = opt$param_density




df.merged=read.csv('~/Unisalento/Lifewatch/Phyto_VRE/Script_R/Traits_Computation/dfmerged.csv',stringsAsFactors=F,sep = ";", dec = ".")

TraitDensity=param_density
CountingStrategy=param_CountingStrategy

if(TraitDensity==1){
  df.merged$density <- rep(NA,length=nrow(df.merged))
  # default method to calculate the density
  if(CountingStrategy=='density0'){  
    df.merged.concat <- df.merged[(is.na(df.merged$volumeofsedimentationchamber)) & (is.na(df.merged$transectcounting)),]
    df.temp <- df.merged[!is.na(df.merged$volumeofsedimentationchamber) & !is.na(df.merged$transectcounting),]
    df.temp1 <- subset(df.temp,volumeofsedimentationchamber <= 5)
    df.temp1$density <- df.temp1$organismquantity/df.temp1$transectcounting*1000/0.001979
    df.merged.concat <- rbind(df.merged.concat,df.temp1)
    df.temp2 <- subset(df.temp,(volumeofsedimentationchamber > 5) & (volumeofsedimentationchamber <= 10))
    df.temp2$density <- df.temp2$organismquantity/df.temp2$transectcounting*1000/0.00365
    df.merged.concat <- rbind(df.merged.concat,df.temp2)
    df.temp3 <- subset(df.temp,(volumeofsedimentationchamber > 10) & (volumeofsedimentationchamber <= 25))
    df.temp3$density <- df.temp3$organismquantity/df.temp3$transectcounting*1000/0.010555
    df.merged.concat <- rbind(df.merged.concat,df.temp3)
    df.temp4 <- subset(df.temp,(volumeofsedimentationchamber > 25) & (volumeofsedimentationchamber <= 50))
    df.temp4$density <- df.temp4$organismquantity/df.temp4$transectcounting*1000/0.021703
    df.merged.concat <- rbind(df.merged.concat,df.temp4)
    df.temp5 <- subset(df.temp,volumeofsedimentationchamber > 50)
    df.temp5$density <- df.temp5$organismquantity/df.temp5$transectcounting*1000/0.041598
    df.merged.concat <- rbind(df.merged.concat,df.temp5)
    df.merged.concat <- df.merged.concat[order(df.merged.concat$index),]
    df.merged <- df.merged.concat
    D_calc <- round(df.merged$density,2)
  }
  # counts per random field
  else if(CountingStrategy=='density1'){
    df.merged$areaofsedimentationchamber <- ((df.merged$diameterofsedimentationchamber/2)^2)*pi
    df.merged$areaofcountingfield <- ((df.merged$diameteroffieldofview/2)^2)*pi
    df.merged$density <- round(df.merged$organismquantity*1000*df.merged$areaofsedimentationchamber/df.merged$numberofcountedfields*df.merged$areaofcountingfield*df.merged$settlingvolume,2)
  }
  # counts per diameter transects
  else if(CountingStrategy=='density2'){
    df.merged$density <- round(((df.merged$organismquantity/df.merged$numberoftransects)*(pi/4)*(df.merged$diameterofsedimentationchamber/df.merged$diameteroffieldofview))*1000/df.merged$settlingvolume,2)
  }
  # counting method for whole chamber
  else if(CountingStrategy=='density3'){
    df.merged$density <- round((df.merged$organismquantity*1000)/df.merged$settlingvolume,2)
  }
  D_calc = df.merged$density/df.merged$dilutionfactor
}
      
    
write.table(df.merged,paste('~/Unisalento/Lifewatch/Phyto_VRE/Script_R/Traits_Computation/dfmerged.csv',sep=''),row.names=F,sep = ";",dec = ".",quote=F)



# capturing outputs
file <- file(paste0('/tmp/TraitDensity_', id, '.json'))
writeLines(toJSON(TraitDensity, auto_unbox=TRUE), file)
close(file)
