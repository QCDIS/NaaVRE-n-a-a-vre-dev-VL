setwd('/app')

# retrieve input parameters

library(optparse)
library(jsonlite)

option_list = list

option_list = list(
make_option(c("--id"), action="store", default=NA, type='character', help="my description")


make_option(c("--param_biovolume"), action="store", default=NA, type='character', help="my description"),
make_option(c("--param_cellcarboncontent"), action="store", default=NA, type='character', help="my description"),
make_option(c("--param_CountingStrategy"), action="store", default=NA, type='character', help="my description"),
make_option(c("--param_density"), action="store", default=NA, type='character', help="my description"),
make_option(c("--param_surfacearea"), action="store", default=NA, type='character', help="my description"),
make_option(c("--param_surfacevolumeratio"), action="store", default=NA, type='character', help="my description"),
make_option(c("--param_totalbiovolume"), action="store", default=NA, type='character', help="my description"),
make_option(c("--param_totalcarboncontent"), action="store", default=NA, type='character', help="my description")
)

# set input parameters accordingly
opt = parse_args(OptionParser(option_list=option_list))


id = opt$id

param_biovolume = opt$param_biovolume
param_cellcarboncontent = opt$param_cellcarboncontent
param_CountingStrategy = opt$param_CountingStrategy
param_density = opt$param_density
param_surfacearea = opt$param_surfacearea
param_surfacevolumeratio = opt$param_surfacevolumeratio
param_totalbiovolume = opt$param_totalbiovolume
param_totalcarboncontent = opt$param_totalcarboncontent






df.merged=read.csv(output_dfmerged,stringsAsFactors=FALSE,sep = ";", dec = ".")

volumeofsedimentationchamber = '' 
df.temp = ''
df.temp1 = ''
df.temp2 = ''  
df.temp3 = ''  
df.temp4 = ''  
df.temp5 = ''  
df.merged.concat = '' 
pi = 3.14159



if(param_density==1){
  df.merged[,'density'] = rep(NA,length=nrow(df.merged))
  # default method to calculate the density
  if(param_CountingStrategy=='density0'){  
    df.merged.concat = df.merged[(is.na(df.merged[,'volumeofsedimentationchamber'])) & (is.na(df.merged[,'transectcounting'])),]
    df.temp = df.merged[!is.na(df.merged[,'volumeofsedimentationchamber']) & !is.na(df.merged[,'transectcounting']),]
    df.temp1 = subset(df.temp,volumeofsedimentationchamber <= 5)
    df.temp1[,'density'] = df.temp1[,'organismquantity']/df.temp1[,'transectcounting']*1000/0.001979
    df.merged.concat = rbind(df.merged.concat,df.temp1)
    df.temp2 = subset(df.temp,(volumeofsedimentationchamber > 5) & (volumeofsedimentationchamber <= 10))
    df.temp2[,'density'] = df.temp2[,'organismquantity']/df.temp2[,'transectcounting']*1000/0.00365
    df.merged.concat = rbind(df.merged.concat,df.temp2)
    df.temp3 = subset(df.temp,(volumeofsedimentationchamber > 10) & (volumeofsedimentationchamber <= 25))
    df.temp3[,'density'] = df.temp3[,'organismquantity']/df.temp3[,'transectcounting']*1000/0.010555
    df.merged.concat = rbind(df.merged.concat,df.temp3)
    df.temp4 = subset(df.temp,(volumeofsedimentationchamber > 25) & (volumeofsedimentationchamber <= 50))
    df.temp4[,'density'] = df.temp4[,'organismquantity']/df.temp4[,'transectcounting']*1000/0.021703
    df.merged.concat = rbind(df.merged.concat,df.temp4)
    df.temp5 = subset(df.temp,volumeofsedimentationchamber > 50)
    df.temp5[,'density'] = df.temp5[,'organismquantity']/df.temp5[,'transectcounting']*1000/0.041598
    df.merged.concat = rbind(df.merged.concat,df.temp5)
    df.merged.concat = df.merged.concat[order(df.merged.concat[,'index']),]
    df.merged = df.merged.concat
    df.merged[,'density'] = round(df.merged[,'density'],2)
  }
  # counts per random field
  else if(param_CountingStrategy=='density1'){
    df.merged[,'areaofsedimentationchamber'] = ((df.merged[,'diameterofsedimentationchamber']/2)^2)*pi
    df.merged[,'areaofcountingfield'] = ((df.merged[,'diameteroffieldofview']/2)^2)*pi
    df.merged[,'density'] = round(df.merged[,'organismquantity']*1000*df.merged[,'areaofsedimentationchamber']/df.merged[,'numberofcountedfields']*df.merged[,'areaofcountingfield']*df.merged[,'settlingvolume'],2)
  }
  # counts per diameter transects
  else if(param_CountingStrategy=='density2'){
    df.merged[,'density'] = round(((df.merged[,'organismquantity']/df.merged[,'numberoftransects'])*(pi/4)*(df.merged[,'diameterofsedimentationchamber']/df.merged[,'diameteroffieldofview']))*1000/df.merged[,'settlingvolume'],2)
  }
  # counting method for whole chamber
  else if(param_CountingStrategy=='density3'){
    df.merged[,'density'] = round((df.merged[,'organismquantity']*1000)/df.merged[,'settlingvolume'],2)
  }
  df.merged[,'density'] = df.merged[,'density']/df.merged[,'dilutionfactor']
}
    
    

if(param_totalbiovolume==1){
  if((param_density==0) & (!'density'%in%names(df.merged))) df.merged[,'density']=NA
  if((param_biovolume==0) & (!'biovolume'%in%names(df.merged))) df.merged[,'biovolume']=NA
  df.merged[,'totalbiovolume'] = round(df.merged[,'density']*df.merged[,'biovolume'],2)
}

    

if(param_surfacevolumeratio==1){
  if((param_surfacearea==0) & (!'surfacearea'%in%names(df.merged))) df.merged[,'surfacearea']=NA
  if((param_biovolume==0) & (!'biovolume'%in%names(df.merged))) df.merged[,'biovolume']=NA
  df.merged[,'surfacevolumeratio']=round(df.merged[,'surfacearea']/df.merged[,'biovolume'],2)
}

    

if(param_totalcarboncontent==1){
  if((param_density==0) & (!'density'%in%names(df.merged))) df.merged[,'density']=NA
  if((param_cellcarboncontent==0) & (!'cellcarboncontent'%in%names(df.merged))) df.merged[,'cellcarboncontent']=NA
  df.merged[,'totalcarboncontent']=round(df.merged[,'density']*df.merged[,'cellcarboncontent'],2)
}
   
output_dfmerged = 'output/dfmerged.csv'    
write.table(df.merged,paste(output_dfmerged,sep=''),row.names=FALSE,sep = ";",dec = ".",quote=FALSE) 



# capturing outputs
file <- file(paste0('/tmp/output_dfmerged_', id, '.json'))
writeLines(toJSON(output_dfmerged, auto_unbox=TRUE), file)
close(file)
