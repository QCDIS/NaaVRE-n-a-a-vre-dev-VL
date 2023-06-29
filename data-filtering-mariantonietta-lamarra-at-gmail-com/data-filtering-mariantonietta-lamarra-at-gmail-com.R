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











dataset=read.csv(output_traits,stringsAsFactors=FALSE,sep = ";", dec = ".")






if(!'density'%in%names(dataset)) dataset[,'density']=1
if(!'biovolume'%in%names(dataset)) dataset[,'biovolume']=1
if(!'cellcarboncontent'%in%names(dataset)) dataset[,'cellcarboncontent']=1
if(!'totalbiovolume'%in%names(dataset)) dataset[,'totalbiovolume']=dataset[,'biovolume']*dataset[,'density']
if(!'totalcarboncontent'%in%names(dataset)) dataset[,'totalcarboncontent']=dataset[,'cellcarboncontent']*dataset[,'density']

output_filter_1 = 'output/TraitsOutput.csv'
write.table(dataset,output_filter_1,row.names=FALSE,sep = ";",dec = ".",quote=FALSE) 


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
  dataset.d = do.call('rbind',IDLIST)
  
} else dataset.d = dataset[FALSE,]

cluster1=cluster   
output_filter_2 = 'output/filtered.csv'
write.table(dataset,output_filter_2,row.names=FALSE,sep = ";",dec = ".",quote=FALSE)                 
output_filter_D = 'output/datasetD.csv'
write.table(dataset.d,output_filter_D,row.names=FALSE,sep = ";",dec = ".",quote=FALSE) 
                

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
  
  IDZ=unique(ID)  
  IDLIST=list()
  length(IDLIST)=length(IDZ)
  names(IDLIST)=IDZ
  
  # ranked distribution of the taxa
  for(j in 1:length(IDZ)){
    ddd=dataset[ID==IDZ[j],]
    totz=sum(ddd[,'totalbiovolume'],na.rm=TRUE)
    matz=tapply(ddd[,'totalbiovolume'],ddd[,param_taxlev],function(x)sum(x,na.rm=TRUE)/totz)
    matz=sort(matz,decreasing=TRUE) 
    
    # cumulative contribution to the overall total biovolume
    k=2
    trs=max(matz)
    while (trs<param_threshold) {
      matz[k]=matz[k-1]+matz[k]
      trs=matz[k]
      k=k+1 }
    
    matzx=matz[1:k-1]
    
    IDLIST[[j]] = ddd[ddd[,param_taxlev]%in%names(matzx),]
  }
  
  # filtered dataset for total biovolume
  dataset.b = do.call('rbind',IDLIST)
  
} else dataset.b = dataset[FALSE,]
                 
                 

if (param_totalcarboncontent==1) {
  
  IDZ=unique(ID)  
  IDLIST=list()
  length(IDLIST)=length(IDZ)
  names(IDLIST)=IDZ
  
  # ranked distribution of the taxa
  for(j in 1:length(IDZ)){
    ddd=dataset[ID==IDZ[j],]
    totz=sum(ddd[,'totalcarboncontent'],na.rm=TRUE)
    matz=tapply(ddd[,'totalcarboncontent'],ddd[,param_taxlev],function(x)sum(x,na.rm=TRUE)/totz)
    matz=sort(matz,decreasing=TRUE) 
    
    # cumulative contribution to the overall total cell carbon content
    k=2
    trs=max(matz)
    while (trs<param_threshold) {
      matz[k]=matz[k-1]+matz[k]
      trs=matz[k]
      k=k+1 }
    
    matzx=matz[1:k-1]
    
    IDLIST[[j]] = ddd[ddd[,param_taxlev]%in%names(matzx),]
  }
  
  # filtered dataset for total cell carbon content
  dataset.c = do.call('rbind',IDLIST)
  
} else dataset.c = dataset[FALSE,]
                 

output_filter_D1 = 'output/datasetD.csv'
write.table(dataset.d,output_filter_D1,row.names=FALSE,sep = ";",dec = ".",quote=FALSE) 
output_filter_B = 'output/datasetB.csv'
write.table(dataset.b,output_filter_B,row.names=FALSE,sep = ";",dec = ".",quote=FALSE) 
output_filter_C = 'output/datasetC.csv'
write.table(dataset.c,output_filter_C,row.names=FALSE,sep = ";",dec = ".",quote=FALSE) 
                

dataset.d=read.csv(output_filter_D1,stringsAsFactors=FALSE,sep = ";", dec = ".")
dataset.b=read.csv(output_filter_B,stringsAsFactors=FALSE,sep = ";", dec = ".")
dataset.c=read.csv(output_filter_C,stringsAsFactors=FALSE,sep = ";", dec = ".")

dtc=rbind(dataset.d,dataset.b,dataset.c)
no_dupl = !duplicated(dtc[,'catalognumber'])
final = dtc[no_dupl,]
  

output_filtering = 'output/FilteringOutput.csv'
write.table(final,output_filtering,row.names=FALSE,sep = ";",dec = ".",quote=FALSE)



# capturing outputs
file <- file(paste0('/tmp/output_filtering_', id, '.json'))
writeLines(toJSON(output_filtering, auto_unbox=TRUE), file)
close(file)
