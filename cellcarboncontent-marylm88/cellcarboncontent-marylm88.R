setwd('/app')

# retrieve input parameters

library(optparse)
library(jsonlite)

option_list = list

option_list = list(
make_option(c("--id"), action="store", default=NA, type='character', help="my description"),

make_option(c("--output_dfmerged_4"), action="store", default=NA, type='character', help="my description")


make_option(c("--param_biovolume"), action="store", default=NA, type='character', help="my description"),
make_option(c("--param_cellcarboncontent"), action="store", default=NA, type='character', help="my description")
)

# set input parameters accordingly
opt = parse_args(OptionParser(option_list=option_list))


id = opt$id
output_dfmerged_4 = opt$output_dfmerged_4

param_biovolume = opt$param_biovolume
param_cellcarboncontent = opt$param_cellcarboncontent





df.merged=read.csv(output_dfmerged_4,stringsAsFactors=FALSE,sep = ";", dec = ".")

formulaforweight1 = '' 
formulaforweight2 = '' 
biovolume = ''
cellcarboncontent = ''
df.temp = ''  
cc.form = ''
df.merged.concat = '' 
cc.formulas1 = ''
cc.formulas2 = ''
df.cc = ''
df.cc1 = ''
df.cc2 = ''


if(param_cellcarboncontent==1){
  df.merged[,'cellcarboncontent'] = rep(NA,length=nrow(df.merged))
  if(param_biovolume==1){
    df.merged.concat = df.merged[is.na(df.merged[,'biovolume']),]
    df.cc = df.merged[!is.na(df.merged[,'biovolume']),]
    df.cc1 = subset(df.cc,biovolume <= 3000)
    df.cc2 = subset(df.cc,biovolume > 3000)
    cc.formulas1 = unique(df.merged[!is.na(df.merged[,'formulaforweight1']),'formulaforweight1'])
    for(cc.form in cc.formulas1){
      df.temp = subset(df.cc1,formulaforweight1==cc.form)
      df.temp[,'cellcarboncontent'] = round(with(df.temp,eval(parse(text=tolower(cc.form)))),2)
      df.merged.concat = rbind(df.merged.concat,df.temp)
    }
    cc.formulas2 = unique(df.merged[!is.na(df.merged[,'formulaforweight2']),'formulaforweight2'])
    for(cc.form in cc.formulas2){
      df.temp = subset(df.cc2,formulaforweight2==cc.form)
      df.temp$cellcarboncontent = round(with(df.temp,eval(parse(text=tolower(cc.form)))),2)
      df.merged.concat = rbind(df.merged.concat,df.temp)
    }
    df.merged.concat = df.merged.concat[order(df.merged.concat[,'index']),]
    df.merged = df.merged.concat
  }
}

output_dfmerged_5 = 'output/dfmerged.csv'
write.table(df.merged,output_dfmerged_5,row.names=FALSE,sep = ";",dec = ".",quote=FALSE) 



# capturing outputs
file <- file(paste0('/tmp/output_dfmerged_5_', id, '.json'))
writeLines(toJSON(output_dfmerged_5, auto_unbox=TRUE), file)
close(file)
