setwd('/app')

# retrieve input parameters

library(optparse)
library(jsonlite)

option_list = list

option_list = list(
make_option(c("--cluster1"), action="store", default=NA, type='character', help="my description"),

make_option(c("--id"), action="store", default=NA, type='character', help="my description"),

make_option(c("--output_filter_2"), action="store", default=NA, type='character', help="my description"),

make_option(c("--output_filter_D"), action="store", default=NA, type='character', help="my description")


make_option(c("--param_cluster_whole"), action="store", default=NA, type='character', help="my description"),
make_option(c("--param_taxlev"), action="store", default=NA, type='character', help="my description"),
make_option(c("--param_threshold"), action="store", default=NA, type='character', help="my description"),
make_option(c("--param_totalbiovolume"), action="store", default=NA, type='character', help="my description"),
make_option(c("--param_totalcarboncontent"), action="store", default=NA, type='character', help="my description")
)

# set input parameters accordingly
opt = parse_args(OptionParser(option_list=option_list))


cluster1 = fromJSON(opt$cluster1)
id = opt$id
output_filter_2 = opt$output_filter_2
output_filter_D = opt$output_filter_D

param_cluster_whole = opt$param_cluster_whole
param_taxlev = opt$param_taxlev
param_threshold = opt$param_threshold
param_totalbiovolume = opt$param_totalbiovolume
param_totalcarboncontent = opt$param_totalcarboncontent





dataset=read.csv(output_filter_2,stringsAsFactors=FALSE,sep = ";", dec = ".")
dataset.d=read.csv(output_filter_D,stringsAsFactors=FALSE,sep = ";", dec = ".")

cluster=cluster1

ID = ''
IDLIST = ''
IDZ = ''
dataset.b = ''
dataset.c = ''
ddd = ''
k = ''
j = ''
matz = ''
matzx = ''
totz = ''
trs = ''
x = ''


if(param_cluster_whole==0) {
  if(length(cluster)>1) ID=apply(dataset[,cluster],1,function(x)paste(x,collapse='.'))
  if(length(cluster)==1) ID=dataset[,cluster]
} else if(param_cluster_whole==1) {
  ID=rep('all',dim(dataset)[1]) }

if (param_totalbiovolume==1) {
  
  IDZ<-unique(ID)  
  IDLIST<-list()
  length(IDLIST)<-length(IDZ)
  names(IDLIST)<-IDZ
  
  # ranked distribution of the taxa
  for(j in 1:length(IDZ)){
    ddd<-dataset[ID==IDZ[j],]
    totz<-sum(ddd[,'totalbiovolume'],na.rm=TRUE)
    matz<-tapply(ddd[,'totalbiovolume'],ddd[,param_taxlev],function(x)sum(x,na.rm=TRUE)/totz)
    matz<-sort(matz,decreasing=TRUE) 
    
    # cumulative contribution to the overall total biovolume
    k<-2
    trs<-max(matz)
    while (trs<param_threshold) {
      matz[k]<-matz[k-1]+matz[k]
      trs<-matz[k]
      k<-k+1 }
    
    matzx<-matz[1:k-1]
    
    IDLIST[[j]] <- ddd[ddd[,param_taxlev]%in%names(matzx),]
  }
  
  # filtered dataset for total biovolume
  dataset.b <- do.call('rbind',IDLIST)
  
} else dataset.b <- dataset[NA,]
                 
                 

if (param_totalcarboncontent==1) {
  
  IDZ<-unique(ID)  
  IDLIST<-list()
  length(IDLIST)<-length(IDZ)
  names(IDLIST)<-IDZ
  
  # ranked distribution of the taxa
  for(j in 1:length(IDZ)){
    ddd<-dataset[ID==IDZ[j],]
    totz<-sum(ddd[,'totalcarboncontent'],na.rm=TRUE)
    matz<-tapply(ddd[,'totalcarboncontent'],ddd[,param_taxlev],function(x)sum(x,na.rm=TRUE)/totz)
    matz<-sort(matz,decreasing=TRUE) 
    
    # cumulative contribution to the overall total cell carbon content
    k<-2
    trs<-max(matz)
    while (trs<param_threshold) {
      matz[k]<-matz[k-1]+matz[k]
      trs<-matz[k]
      k<-k+1 }
    
    matzx<-matz[1:k-1]
    
    IDLIST[[j]] <- ddd[ddd[,param_taxlev]%in%names(matzx),]
  }
  
  # filtered dataset for total cell carbon content
  dataset.c <- do.call('rbind',IDLIST)
  
} else dataset.c <- dataset[NA,]
                 

output_filter_D1 = 'output/datasetD.csv'
write.table(dataset.d,output_filter_D1,row.names=FALSE,sep = ";",dec = ".",quote=FALSE) 
output_filter_B = 'output/datasetB.csv'
write.table(dataset.b,output_filter_B,row.names=FALSE,sep = ";",dec = ".",quote=FALSE) 
output_filter_C = 'output/datasetC.csv'
write.table(dataset.c,output_filter_C,row.names=FALSE,sep = ";",dec = ".",quote=FALSE) 



# capturing outputs
file <- file(paste0('/tmp/output_filter_D1_', id, '.json'))
writeLines(toJSON(output_filter_D1, auto_unbox=TRUE), file)
close(file)
file <- file(paste0('/tmp/output_filter_B_', id, '.json'))
writeLines(toJSON(output_filter_B, auto_unbox=TRUE), file)
close(file)
file <- file(paste0('/tmp/output_filter_C_', id, '.json'))
writeLines(toJSON(output_filter_C, auto_unbox=TRUE), file)
close(file)
