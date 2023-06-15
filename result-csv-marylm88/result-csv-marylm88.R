setwd('/app')

# retrieve input parameters

library(optparse)
library(jsonlite)

option_list = list

option_list = list(
make_option(c("--id"), action="store", default=NA, type='character', help="my description"),

make_option(c("--output_dfmerged_6"), action="store", default=NA, type='character', help="my description")


make_option(c("--param_biovolume"), action="store", default=NA, type='character', help="my description"),
make_option(c("--param_cellcarboncontent"), action="store", default=NA, type='character', help="my description"),
make_option(c("--param_datain"), action="store", default=NA, type='character', help="my description"),
make_option(c("--param_density"), action="store", default=NA, type='character', help="my description"),
make_option(c("--param_surfacearea"), action="store", default=NA, type='character', help="my description"),
make_option(c("--param_surfacevolumeratio"), action="store", default=NA, type='character', help="my description"),
make_option(c("--param_totalbiovolume"), action="store", default=NA, type='character', help="my description"),
make_option(c("--param_totalcarboncontent"), action="store", default=NA, type='character', help="my description")
)

# set input parameters accordingly
opt = parse_args(OptionParser(option_list=option_list))


id = opt$id
output_dfmerged_6 = opt$output_dfmerged_6

param_biovolume = opt$param_biovolume
param_cellcarboncontent = opt$param_cellcarboncontent
param_datain = opt$param_datain
param_density = opt$param_density
param_surfacearea = opt$param_surfacearea
param_surfacevolumeratio = opt$param_surfacevolumeratio
param_totalbiovolume = opt$param_totalbiovolume
param_totalcarboncontent = opt$param_totalcarboncontent





df.datain=read.csv(param_datain,stringsAsFactors=FALSE,sep = ";", dec = ".")
df.merged=read.csv(output_dfmerged_6,stringsAsFactors=FALSE,sep = ";", dec = ".")

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


write.table(df.datain,paste('output/TraitsOutput.csv',sep=''),row.names=FALSE,sep = ";",dec = ".",quote=FALSE) 



