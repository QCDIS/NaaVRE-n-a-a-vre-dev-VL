setwd('/app')

# retrieve input parameters

library(optparse)
library(jsonlite)

option_list = list

option_list = list(
make_option(c("--id"), action="store", default=NA, type='character', help="my description"),

make_option(c("--output_dfmerged_3"), action="store", default=NA, type='character', help="my description")


make_option(c("--param_CalcType"), action="store", default=NA, type='character', help="my description"),
make_option(c("--param_surfacearea"), action="store", default=NA, type='character', help="my description")
)

# set input parameters accordingly
opt = parse_args(OptionParser(option_list=option_list))


id = opt$id
output_dfmerged_3 = opt$output_dfmerged_3

param_CalcType = opt$param_CalcType
param_surfacearea = opt$param_surfacearea





df.merged=read.csv(output_dfmerged_3,stringsAsFactors=FALSE,sep = ";", dec = ".")

formulaforsurface = '' 
formulaforsurfacesimplified = '' 
df.temp = ''  
df.merged.concat = '' 
sa.formulas = ''
sa.form = ''


if(param_surfacearea==1){
  if(param_CalcType=='advanced'){
    df.merged[,'surfacearea'] = rep(NA,length=nrow(df.merged))
    df.merged.concat = df.merged[is.na(df.merged[,'formulaforsurface']),]
    sa.formulas = unique(df.merged[!is.na(df.merged[,'formulaforsurface']),'formulaforsurface'])
    for(sa.form in sa.formulas){
      df.temp = subset(df.merged,formulaforsurface==sa.form)
      df.temp[,'surfacearea'] = round(with(df.temp,eval(parse(text=sa.form))),2)
      df.merged.concat = rbind(df.merged.concat,df.temp)
    }
    df.merged.concat = df.merged.concat[order(df.merged.concat[,'index']),]
    df.merged = df.merged.concat
  }
  else if(param_CalcType=='simplified'){
    df.merged[,'surfacearea'] = rep(NA,length=nrow(df.merged))
    df.merged.concat = df.merged[is.na(df.merged[,'formulaforsurfacesimplified']),]
    sa.formulas = unique(df.merged[!is.na(df.merged[,'formulaforsurfacesimplified']),'formulaforsurfacesimplified'])
    for(sa.form in sa.formulas){
      df.temp = subset(df.merged,formulaforsurfacesimplified==sa.form)
      df.temp[,'surfacearea'] = round(with(df.temp,eval(parse(text=sa.form))),2)
      df.merged.concat = rbind(df.merged.concat,df.temp)
    }
    df.merged.concat = df.merged.concat[order(df.merged.concat[,'index']),]
    df.merged = df.merged.concat
  }
}

output_dfmerged_4 = 'output/dfmerged.csv'
write.table(df.merged,output_dfmerged_4,row.names=FALSE,sep = ";",dec = ".",quote=FALSE) 



# capturing outputs
file <- file(paste0('/tmp/output_dfmerged_4_', id, '.json'))
writeLines(toJSON(output_dfmerged_4, auto_unbox=TRUE), file)
close(file)
