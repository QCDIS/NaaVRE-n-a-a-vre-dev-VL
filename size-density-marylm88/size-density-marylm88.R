setwd('/app')

# retrieve input parameters

library(optparse)
library(jsonlite)

option_list = list

option_list = list(
make_option(c("--id"), action="store", default=NA, type='character', help="my description"),

make_option(c("--output_filtering"), action="store", default=NA, type='character', help="my description")


)

# set input parameters accordingly
opt = parse_args(OptionParser(option_list=option_list))


id = opt$id
output_filtering = opt$output_filtering








install.packages("reshape",repos = "http://cran.us.r-project.org")
library("reshape")

install.packages("dplyr",repos = "http://cran.us.r-project.org")
library("dplyr")




dataset=read.csv(output_filtering,stringsAsFactors=FALSE,sep = ";", dec = ".")





if(!'density'%in%names(dataset))dataset[,'density']=1
if(!'biovolume'%in%names(dataset))dataset[,'biovolume']=NA
if(!'cellcarboncontent'%in%names(dataset))dataset[,'cellcarboncontent']=NA

output_sizeDensity_1 = 'output/TraitsOutput.csv'
write.table(dataset,output_sizeDensity_1,row.names=FALSE,sep = ";",dec = ".",quote=FALSE) 



