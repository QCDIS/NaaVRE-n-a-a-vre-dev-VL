setwd('/app')

# retrieve input parameters

library(optparse)
library(jsonlite)

option_list = list

option_list = list(
make_option(c("--id"), action="store", default=NA, type='character', help="my description"),

make_option(c("--output_traits"), action="store", default=NA, type='character', help="my description")


)

# set input parameters accordingly
opt = parse_args(OptionParser(option_list=option_list))


id = opt$id
output_traits = opt$output_traits






dplyr = ''
library(dplyr)


dataset=read.csv(output_traits,stringsAsFactors=FALSE,sep = ";", dec = ".")





cluster = c()
if (param_cluster_whole==1) cluster="whole"
if (param_cluster_country==1) cluster=append(cluster,"country")
if (param_cluster_locality==1) cluster=append(cluster,"locality")
if (param_cluster_year==1) cluster=append(cluster,"year")
if (param_cluster_month==1) cluster=append(cluster,"month")
if (param_cluster_day==1) cluster=append(cluster,"day")
if (param_cluster_parenteventid==1) cluster=append(cluster,"parenteventid")
if (param_cluster_eventid==1) cluster=append(cluster,"eventid")


if(!'density'%in%names(dataset)) dataset[,'density']=1
if(!'biovolume'%in%names(dataset)) dataset[,'biovolume']=1
if(!'cellcarboncontent'%in%names(dataset)) dataset[,'cellcarboncontent']=1
if(!'totalbiovolume'%in%names(dataset)) dataset[,'totalbiovolume']=dataset[,'biovolume']*dataset[,'density']
if(!'totalcarboncontent'%in%names(dataset)) dataset[,'totalcarboncontent']=dataset[,'cellcarboncontent']*dataset[,'density']

output_filter_1 = 'output/TraitsOutput.csv'
write.table(dataset,output_filter_1,row.names=FALSE,sep = ";",dec = ".",quote=FALSE) 



# capturing outputs
file <- file(paste0('/tmp/output_filter_1_', id, '.json'))
writeLines(toJSON(output_filter_1, auto_unbox=TRUE), file)
close(file)
file <- file(paste0('/tmp/cluster_', id, '.json'))
writeLines(toJSON(cluster, auto_unbox=TRUE), file)
close(file)
