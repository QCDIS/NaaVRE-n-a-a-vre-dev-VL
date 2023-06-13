setwd('/app')

# retrieve input parameters

library(optparse)
library(jsonlite)

option_list = list

option_list = list(
make_option(c("--id"), action="store", default=NA, type='character', help="my description"),

make_option(c("--output_dfmerged"), action="store", default=NA, type='character', help="my description")


make_option(c("--param_CalcType"), action="store", default=NA, type='character', help="my description")
)

# set input parameters accordingly
opt = parse_args(OptionParser(option_list=option_list))


id = opt$id
output_dfmerged = opt$output_dfmerged

param_CalcType = opt$param_CalcType





df.merged=read.csv(output_dfmerged,stringsAsFactors=FALSE,sep = ";", dec = ".")
CalcType=param_CalcType

df.temp = ''  # Because the Component cannot identify '<-' we need to initialize these variables so they are not showing up as inputs
md.form = ''
missingdimension = ''
df.temp2 = ''
index = ''
formulaformissingdimensionsimplified = '' 
md = ''
df.merged.concat = '' 
md.formulas = ''
missingdimensionsimplified = ''
formulaformissingdimension = '' 

if(CalcType=='advanced'){
  df.merged.concat <- df.merged[is.na(df.merged$formulaformissingdimension),]
  md.formulas = ''
  md.formulas <- unique(df.merged[!is.na(df.merged$formulaformissingdimension),]$formulaformissingdimension)
  for(md.form in md.formulas){
    df.temp <- subset(df.merged,formulaformissingdimension==md.form)
    for(md in unique(df.temp$missingdimension)){
      df.temp2 <- df.temp[df.temp$missingdimension==md,]
      df.temp2[[md]] <- round(with(df.temp2,eval(parse(text=md.form))),2)
      df.merged.concat <- rbind(df.merged.concat,df.temp2)
    }
  }
  df.merged.concat = ''
  df.merged.concat <- df.merged.concat[order(df.merged.concat$index),]
  df.merged = ''  
  df.merged <- df.merged.concat
} else if(CalcType=='simplified'){
  formulaformissingdimensionsimplified  = ''
  df.merged.concat <- df.merged[is.na(df.merged$formulaformissingdimensionsimplified),]
  md.formulas <- unique(df.merged[!is.na(df.merged$formulaformissingdimensionsimplified),]$formulaformissingdimensionsimplified)
  for(md.form in md.formulas){
    df.temp <- subset(df.merged,formulaformissingdimensionsimplified==md.form)
    for(md in unique(df.temp$missingdimensionsimplified)){
      df.temp2 = ''  
      df.temp2 <- df.temp[df.temp$missingdimensionsimplified==md,]
      df.temp2[[md]] <- round(with(df.temp2,eval(parse(text=md.form))),2)
      df.merged.concat <- rbind(df.merged.concat,df.temp2)
    }
  }
  df.merged.concat <- df.merged.concat[order(df.merged.concat$index),]
  df.merged <- df.merged.concat
}
    
write.table(df.merged,paste(output_dfmerged,sep=''),row.names=FALSE,sep = ";",dec = ".",quote=FALSE)    



# capturing outputs
file <- file(paste0('/tmp/index_', id, '.json'))
writeLines(toJSON(index, auto_unbox=TRUE), file)
close(file)
file <- file(paste0('/tmp/df.temp_', id, '.json'))
writeLines(toJSON(df.temp, auto_unbox=TRUE), file)
close(file)
file <- file(paste0('/tmp/df.merged.concat_', id, '.json'))
writeLines(toJSON(df.merged.concat, auto_unbox=TRUE), file)
close(file)
file <- file(paste0('/tmp/df.temp2_', id, '.json'))
writeLines(toJSON(df.temp2, auto_unbox=TRUE), file)
close(file)
