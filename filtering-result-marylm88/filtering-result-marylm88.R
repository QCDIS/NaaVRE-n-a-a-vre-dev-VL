setwd('/app')

# retrieve input parameters

library(optparse)
library(jsonlite)

option_list = list

option_list = list(
make_option(c("--id"), action="store", default=NA, type='character', help="my description"),

make_option(c("--output_filter_B"), action="store", default=NA, type='character', help="my description"),

make_option(c("--output_filter_C"), action="store", default=NA, type='character', help="my description"),

make_option(c("--output_filter_D1"), action="store", default=NA, type='character', help="my description")


make_option(c("--param_threshold"), action="store", default=NA, type='character', help="my description")
)

# set input parameters accordingly
opt = parse_args(OptionParser(option_list=option_list))


id = opt$id
output_filter_B = opt$output_filter_B
output_filter_C = opt$output_filter_C
output_filter_D1 = opt$output_filter_D1

param_threshold = opt$param_threshold





dataset.d=read.csv(output_filter_D1,stringsAsFactors=FALSE,sep = ";", dec = ".")
dataset.b=read.csv(output_filter_B,stringsAsFactors=FALSE,sep = ";", dec = ".")
dataset.c=read.csv(output_filter_C,stringsAsFactors=FALSE,sep = ";", dec = ".")

dtc=as.data.frame(bind_rows(dataset.d,dataset.b,dataset.c))
final=unique(dtc)
final=final[rowSums(is.na(final)) != ncol(final), ]

threshold.str <- paste('_ThresholdValue_',param_threshold,sep="")   

output_filtering = paste('output/FilteringOutput_',threshold.str,'.csv',sep='')
write.table(final,output_filtering,row.names=FALSE,sep = ";",dec = ".",quote=FALSE)



