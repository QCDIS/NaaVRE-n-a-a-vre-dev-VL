setwd('/app')

# retrieve input parameters

library(optparse)
library(jsonlite)

option_list = list

option_list = list(
make_option(c("--id"), action="store", default=NA, type='character', help="my description"),

make_option(c("--output_filter_1"), action="store", default=NA, type='character', help="my description")


make_option(c("--param_cluster_country"), action="store", default=NA, type='character', help="my description"),
make_option(c("--param_cluster_day"), action="store", default=NA, type='character', help="my description"),
make_option(c("--param_cluster_eventid"), action="store", default=NA, type='character', help="my description"),
make_option(c("--param_cluster_locality"), action="store", default=NA, type='character', help="my description"),
make_option(c("--param_cluster_month"), action="store", default=NA, type='character', help="my description"),
make_option(c("--param_cluster_parenteventid"), action="store", default=NA, type='character', help="my description"),
make_option(c("--param_cluster_whole"), action="store", default=NA, type='character', help="my description"),
make_option(c("--param_cluster_year"), action="store", default=NA, type='character', help="my description"),
make_option(c("--param_density"), action="store", default=NA, type='character', help="my description"),
make_option(c("--param_taxlev"), action="store", default=NA, type='character', help="my description"),
make_option(c("--param_threshold"), action="store", default=NA, type='character', help="my description")
)

# set input parameters accordingly
opt = parse_args(OptionParser(option_list=option_list))


id = opt$id
output_filter_1 = opt$output_filter_1

param_cluster_country = opt$param_cluster_country
param_cluster_day = opt$param_cluster_day
param_cluster_eventid = opt$param_cluster_eventid
param_cluster_locality = opt$param_cluster_locality
param_cluster_month = opt$param_cluster_month
param_cluster_parenteventid = opt$param_cluster_parenteventid
param_cluster_whole = opt$param_cluster_whole
param_cluster_year = opt$param_cluster_year
param_density = opt$param_density
param_taxlev = opt$param_taxlev
param_threshold = opt$param_threshold





dataset=read.csv(output_filter_1,stringsAsFactors=FALSE,sep = ";", dec = ".")

ID = ''
IDLIST = ''
IDZ = ''
dataset.d = ''
ddd = ''
k = ''
j = ''
matz = ''
matzx = ''
totz = ''
trs = ''
x = ''


cluster = c()
if (param_cluster_whole==1) cluster="whole"
if (param_cluster_country==1) cluster=append(cluster,"country")
if (param_cluster_locality==1) cluster=append(cluster,"locality")
if (param_cluster_year==1) cluster=append(cluster,"year")
if (param_cluster_month==1) cluster=append(cluster,"month")
if (param_cluster_day==1) cluster=append(cluster,"day")
if (param_cluster_parenteventid==1) cluster=append(cluster,"parenteventid")
if (param_cluster_eventid==1) cluster=append(cluster,"eventid")

if(param_cluster_whole==0) {
  if(length(cluster)>1) ID=apply(dataset[,cluster],1,function(x)paste(x,collapse='.'))
  if(length(cluster)==1) ID=dataset[,cluster]
} else if(param_cluster_whole==1) {
  ID=rep('all',dim(dataset)[1]) }

if (param_density==1) {
  
  IDZ=unique(ID)  
  IDLIST=list()
  length(IDLIST)=length(IDZ)
  names(IDLIST)=IDZ
  
  # ranked distribution of the taxa
  for(j in 1:length(IDZ)){
    ddd=dataset[ID==IDZ[j],]
    totz=sum(ddd[,'density'],na.rm=TRUE)
    matz=tapply(ddd[,'density'],ddd[,param_taxlev],function(x)sum(x,na.rm=TRUE)/totz)
    matz=sort(matz,decreasing=TRUE) 
    
    # cumulative contribution to the overall density
    k=2
    trs=max(matz)
    while (trs<param_threshold) {
      matz[k]=matz[k-1]+matz[k]
      trs=matz[k]
      k=k+1 }
    
    matzx=matz[1:k-1]
    
    IDLIST[[j]] = ddd[ddd[,param_taxlev]%in%names(matzx),]
  }
  
  # filtered dataset for density
  dataset.d <- do.call('rbind',IDLIST)
  
} else dataset.d <- dataset[FALSE,]

cluster1=cluster   
output_filter_2 = 'output/filtered.csv'
write.table(dataset,output_filter_2,row.names=FALSE,sep = ";",dec = ".",quote=FALSE)                 
output_filter_D = 'output/datasetD.csv'
write.table(dataset.d,output_filter_D,row.names=FALSE,sep = ";",dec = ".",quote=FALSE) 



# capturing outputs
file <- file(paste0('/tmp/cluster1_', id, '.json'))
writeLines(toJSON(cluster1, auto_unbox=TRUE), file)
close(file)
file <- file(paste0('/tmp/output_filter_D_', id, '.json'))
writeLines(toJSON(output_filter_D, auto_unbox=TRUE), file)
close(file)
file <- file(paste0('/tmp/output_filter_2_', id, '.json'))
writeLines(toJSON(output_filter_2, auto_unbox=TRUE), file)
close(file)
