setwd('/app')

# retrieve input parameters

library(optparse)
library(jsonlite)

option_list = list

option_list = list(
make_option(c("--id"), action="store", default=NA, type='character', help="my description")


)

# set input parameters accordingly
opt = parse_args(OptionParser(option_list=option_list))


id = opt$id











df.datain=read.csv(param_datain,stringsAsFactors=FALSE,sep = ";", dec = ".")
df.datain[,'measurementremarks'] = tolower(df.datain[,'measurementremarks']) # eliminate capital letters
df.datain[,'index'] = c(1:nrow(df.datain)) # needed to restore rows order later

df.operator=read.csv('input/2_FILEinformativo_OPERATORE.csv',stringsAsFactors=FALSE,sep = ";", dec = ".") # load internal database 
df.operator[df.operator==('no')]<-NA
df.operator[df.operator==('see note')]<-NA

df.merged = merge(x = df.datain, y = df.operator, by = c("scientificname","measurementremarks"), all.x = TRUE)

if(!'diameterofsedimentationchamber'%in%names(df.merged))df.merged[,'diameterofsedimentationchamber']=NA
if(!'diameteroffieldofview'%in%names(df.merged))df.merged[,'diameteroffieldofview']=NA
if(!'transectcounting'%in%names(df.merged))df.merged[,'transectcounting']=NA
if(!'numberofcountedfields'%in%names(df.merged))df.merged[,'numberofcountedfields']=df.merged[,'transectcounting']
if(!'numberoftransects'%in%names(df.merged))df.merged[,'numberoftransects']=df.merged[,'transectcounting']
if(!'settlingvolume'%in%names(df.merged))df.merged[,'settlingvolume']=NA
if(!'dilutionfactor'%in%names(df.merged))df.merged[,'dilutionfactor']=1

output_dfmerged_1 = 'output/dfmerged.csv'
write.table(df.merged,output_dfmerged_1,row.names=FALSE,sep = ";",dec = ".",quote=FALSE)


df.merged=read.csv(output_dfmerged_1,stringsAsFactors=FALSE,sep = ";", dec = ".")

formulaformissingdimension = '' 
formulaformissingdimensionsimplified = '' 
df.temp = ''  
md.form = ''
df.temp2 = ''
md = ''
df.merged.concat = '' 
md.formulas = ''


if(param_CalcType=='advanced'){
  df.merged.concat = df.merged[is.na(df.merged[,'formulaformissingdimension']),]
  md.formulas = unique(df.merged[!is.na(df.merged[,'formulaformissingdimension']),'formulaformissingdimension'])
  for(md.form in md.formulas){
    df.temp = subset(df.merged,formulaformissingdimension==md.form)
    for(md in unique(df.temp[,'missingdimension'])){
      df.temp2 = df.temp[df.temp[,'missingdimension']==md,]
      df.temp2[[md]] = round(with(df.temp2,eval(parse(text=md.form))),2)
      df.merged.concat = rbind(df.merged.concat,df.temp2)
    }
  }
  df.merged.concat = df.merged.concat[order(df.merged.concat[,'index']),]
  df.merged = df.merged.concat
} else if(param_CalcType=='simplified'){
  df.merged.concat = df.merged[is.na(df.merged[,'formulaformissingdimensionsimplified']),]
  md.formulas = unique(df.merged[!is.na(df.merged[,'formulaformissingdimensionsimplified']),'formulaformissingdimensionsimplified'])
  for(md.form in md.formulas){
    df.temp = subset(df.merged,formulaformissingdimensionsimplified==md.form)
    for(md in unique(df.temp[,'missingdimensionsimplified'])){
      df.temp2 = df.temp[df.temp[,'missingdimensionsimplified']==md,]
      df.temp2[[md]] = round(with(df.temp2,eval(parse(text=md.form))),2)
      df.merged.concat = rbind(df.merged.concat,df.temp2)
    }
  }
  df.merged.concat = df.merged.concat[order(df.merged.concat[,'index']),]
  df.merged = df.merged.concat
}

output_dfmerged_2 = 'output/dfmerged.csv'
write.table(df.merged,output_dfmerged_2,row.names=FALSE,sep = ";",dec = ".",quote=FALSE) 


df.merged=read.csv(output_dfmerged_2,stringsAsFactors=FALSE,sep = ";", dec = ".")

formulaforbiovolume = '' 
formulaforbiovolumesimplified = '' 
df.temp = ''  
bv.form = ''
df.merged.concat = '' 
bv.formulas = ''


if(param_biovolume==1){
  if(param_CalcType=='advanced'){
    df.merged[,'biovolume'] = rep(NA,length=nrow(df.merged))
    df.merged.concat = df.merged[is.na(df.merged[,'formulaforbiovolume']),]
    bv.formulas = unique(df.merged[!is.na(df.merged[,'formulaforbiovolume']),'formulaforbiovolume'])
    for(bv.form in bv.formulas){
      df.temp = subset(df.merged,formulaforbiovolume==bv.form)
      df.temp[,'biovolume'] = round(with(df.temp,eval(parse(text=bv.form))),2)
      df.merged.concat = rbind(df.merged.concat,df.temp)
    }
    df.merged.concat = df.merged.concat[order(df.merged.concat[,'index']),]
    df.merged = df.merged.concat
  }
  else if(param_CalcType=='simplified'){
    df.merged[,'biovolume'] = rep(NA,length=nrow(df.merged))
    df.merged.concat = df.merged[is.na(df.merged[,'formulaforbiovolumesimplified']),]
    bv.formulas = unique(df.merged[!is.na(df.merged[,'formulaforbiovolumesimplified']),'formulaforbiovolumesimplified'])
    for(bv.form in bv.formulas){
      df.temp = subset(df.merged,formulaforbiovolumesimplified==bv.form)
      df.temp[,'biovolume'] = round(with(df.temp,eval(parse(text=bv.form))),2)
      df.merged.concat <- rbind(df.merged.concat,df.temp)
    }
    df.merged.concat = df.merged.concat[order(df.merged.concat[,'index']),]
    df.merged = df.merged.concat
  }
} 

output_dfmerged_3 = 'output/dfmerged.csv'
write.table(df.merged,output_dfmerged_3,row.names=FALSE,sep = ";",dec = ".",quote=FALSE)  


df.merged=read.csv(output_dfmerged_2,stringsAsFactors=FALSE,sep = ";", dec = ".")

formulaforbiovolume = '' 
formulaforbiovolumesimplified = '' 
df.temp = ''  
bv.form = ''
df.merged.concat = '' 
bv.formulas = ''


if(param_biovolume==1){
  if(param_CalcType=='advanced'){
    df.merged[,'biovolume'] = rep(NA,length=nrow(df.merged))
    df.merged.concat = df.merged[is.na(df.merged[,'formulaforbiovolume']),]
    bv.formulas = unique(df.merged[!is.na(df.merged[,'formulaforbiovolume']),'formulaforbiovolume'])
    for(bv.form in bv.formulas){
      df.temp = subset(df.merged,formulaforbiovolume==bv.form)
      df.temp[,'biovolume'] = round(with(df.temp,eval(parse(text=bv.form))),2)
      df.merged.concat = rbind(df.merged.concat,df.temp)
    }
    df.merged.concat = df.merged.concat[order(df.merged.concat[,'index']),]
    df.merged = df.merged.concat
  }
  else if(param_CalcType=='simplified'){
    df.merged[,'biovolume'] = rep(NA,length=nrow(df.merged))
    df.merged.concat = df.merged[is.na(df.merged[,'formulaforbiovolumesimplified']),]
    bv.formulas = unique(df.merged[!is.na(df.merged[,'formulaforbiovolumesimplified']),'formulaforbiovolumesimplified'])
    for(bv.form in bv.formulas){
      df.temp = subset(df.merged,formulaforbiovolumesimplified==bv.form)
      df.temp[,'biovolume'] = round(with(df.temp,eval(parse(text=bv.form))),2)
      df.merged.concat <- rbind(df.merged.concat,df.temp)
    }
    df.merged.concat = df.merged.concat[order(df.merged.concat[,'index']),]
    df.merged = df.merged.concat
  }
} 

output_dfmerged_3 = 'output/dfmerged.csv'
write.table(df.merged,output_dfmerged_3,row.names=FALSE,sep = ";",dec = ".",quote=FALSE)  


df.datain=read.csv(param_datain,stringsAsFactors=FALSE,sep = ";", dec = ".")

biovolume = ''
cellcarboncontent = ''
surfacearea = ''


if(param_biovolume==1) {
    if('biovolume'%in%names(df.datain)) df.datain=subset(df.datain,select=-biovolume) # drop column if already present
    df.datain[,'biovolume'] = df.merged[,'biovolume'] # write column with the results at the end of the dataframe
    }
if(param_cellcarboncontent==1) {
    if('cellcarboncontent'%in%names(df.datain)) df.datain=subset(df.datain,select=-cellcarboncontent)
    df.datain[,'cellcarboncontent'] = df.merged[,'cellcarboncontent']
    }
if(param_density==1) {
    df.datain[,'density'] = df.merged[,'density']
    }
if(param_totalbiovolume==1) {
    df.datain[,'totalbiovolume'] = df.merged[,'totalbiovolume']
    }
if(param_surfacearea==1) {
    if('surfacearea'%in%names(df.datain)) df.datain=subset(df.datain,select=-surfacearea)
    df.datain[,'surfacearea'] = df.merged[,'surfacearea']
    }
if(param_surfacevolumeratio==1) {
    df.datain[,'surfacevolumeratio'] = df.merged[,'surfacevolumeratio']
    }
if(param_totalcarboncontent==1) {
    df.datain[,'totalcarboncontent'] = df.merged[,'totalcarboncontent']
    }

output_traits = 'output/TraitsOutput.csv'
write.table(df.datain,output_traits,row.names=FALSE,sep = ";",dec = ".",quote=FALSE)



# capturing outputs
file <- file(paste0('/tmp/output_traits_', id, '.json'))
writeLines(toJSON(output_traits, auto_unbox=TRUE), file)
close(file)
