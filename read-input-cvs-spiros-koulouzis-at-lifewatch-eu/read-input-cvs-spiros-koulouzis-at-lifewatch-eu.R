setwd('/app')

# retrieve input parameters

library(optparse)
library(jsonlite)

option_list = list

option_list = list(
make_option(c("--id"), action="store", default=NA, type='character', help="my description"),
make_option(c("--param_hostname"), action="store", default=NA, type='character', help="my description"),
make_option(c("--param_login"), action="store", default=NA, type='character', help="my description"),
make_option(c("--param_password"), action="store", default=NA, type='character', help="my description")
)

# set input parameters accordingly
opt = parse_args(OptionParser(option_list=option_list))


id = opt$id

param_hostname = opt$param_hostname
param_login = opt$param_login
param_password = opt$param_password


conf_output = 'traits/output'
conf_datain2 = 'traits/input/2_FILEinformativo_OPERATORE.csv'
conf_datain1 = "traits/input/Phytoplankton__Progetto_Strategico_2009_2012_Australia.csv"
conf_local <- c('traits','traits/input','traits/output')
conf_density = 1


conf_output = 'traits/output'
conf_datain2 = 'traits/input/2_FILEinformativo_OPERATORE.csv'
conf_datain1 = "traits/input/Phytoplankton__Progetto_Strategico_2009_2012_Australia.csv"
conf_local <- c('traits','traits/input','traits/output')
conf_density = 1

install.packages("RCurl",repos = "http://cran.us.r-project.org")
RCurl = ''
library(RCurl)
install.packages("httr",repos = "http://cran.us.r-project.org")
httr = ''
library(httr)

countingStrategy = ''
if (conf_density==1) {countingStrategy <- 'density0'}

index = 0

directory = ''
for (directory in conf_local) {
  if (!file.exists(directory)) {
    dir.create(directory)
  }
}


auth = basicTextGatherer()
cred = paste(param_login, param_password, sep = ":")
download_file = paste0(param_hostname,conf_datain1)
print(download_file)
file_content <- getURL(download_file, curl = getCurlHandle(userpwd = cred))
writeLines(file_content, conf_datain1)

df.datain=read.csv(conf_datain1,stringsAsFactors=FALSE,sep = ";", dec = ".")
head(df.datain, n = 3)
df.datain[,'measurementremarks'] = tolower(df.datain[,'measurementremarks']) # eliminate capital letters
df.datain[,'index'] = c(1:nrow(df.datain)) # needed to restore rows order later

file_content <- getURL(paste0(param_hostname,conf_datain2), curl = getCurlHandle(userpwd = cred))
writeLines(file_content, conf_datain2)

df.operator=read.csv(conf_datain2,stringsAsFactors=FALSE,sep = ";", dec = ".") # load internal database 
head(df.operator, n = 3)
df.operator[df.operator==('no')]<-NA
df.operator[df.operator==('see note')]<-NA

df.merged = merge(x = df.datain, y = df.operator, by = c("scientificname","measurementremarks"), all.x = TRUE)
head(df.merged, n = 3)

if(!'diameterofsedimentationchamber'%in%names(df.merged))df.merged[,'diameterofsedimentationchamber']=NA
if(!'diameteroffieldofview'%in%names(df.merged))df.merged[,'diameteroffieldofview']=NA
if(!'transectcounting'%in%names(df.merged))df.merged[,'transectcounting']=NA
if(!'numberofcountedfields'%in%names(df.merged))df.merged[,'numberofcountedfields']=df.merged[,'transectcounting']
if(!'numberoftransects'%in%names(df.merged))df.merged[,'numberoftransects']=df.merged[,'transectcounting']
if(!'settlingvolume'%in%names(df.merged))df.merged[,'settlingvolume']=NA
if(!'dilutionfactor'%in%names(df.merged))df.merged[,'dilutionfactor']=1


output_dfmerged_1 = 'traits/output/dfmerged.csv'
write.table(df.merged,output_dfmerged_1,row.names=FALSE,sep = ";",dec = ".",quote=FALSE)

outputs <- c(output_dfmerged_1)

file = ''
size = 0 
category = '' 
file_name = '' 
response = ''
for (file in outputs) {
    # Read the file content
    file_content <- readBin(file, what = "raw", n = file.info(file)$size)
    file_name <- basename(file)
    # Create a PUT request
    response <- httr::PUT(
      url = paste0(param_hostname, conf_output,'/',file_name),
      body = file_content,
      httr::authenticate(user = param_login, password = param_password),
      verbose()
    )
    print(response)
}

output_dfmerged = paste0(conf_output,'/dfmerged.csv')



