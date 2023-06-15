setwd('/app')

# retrieve input parameters

library(optparse)
library(jsonlite)

option_list = list

option_list = list(
make_option(c("--id"), action="store", default=NA, type='character', help="my description"),

make_option(c("--output_dfmerged_2"), action="store", default=NA, type='character', help="my description")


make_option(c("--param_biovolume"), action="store", default=NA, type='character', help="my description"),
make_option(c("--param_CalcType"), action="store", default=NA, type='character', help="my description")
)

# set input parameters accordingly
opt = parse_args(OptionParser(option_list=option_list))


id = opt$id
output_dfmerged_2 = opt$output_dfmerged_2

param_biovolume = opt$param_biovolume
param_CalcType = opt$param_CalcType





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



# capturing outputs
file <- file(paste0('/tmp/output_dfmerged_3_', id, '.json'))
writeLines(toJSON(output_dfmerged_3, auto_unbox=TRUE), file)
close(file)
