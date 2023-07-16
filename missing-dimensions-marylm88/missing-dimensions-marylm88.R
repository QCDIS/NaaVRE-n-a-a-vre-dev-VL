setwd('/app')

# retrieve input parameters

library(optparse)
library(jsonlite)

option_list = list

option_list = list(
make_option(c("--id"), action="store", default=NA, type='character', help="my description"),
make_option(c("--output_dfmerged_1"), action="store", default=NA, type='character', help="my description"),
make_option(c("--param_CalcType"), action="store", default=NA, type='character', help="my description"),
make_option(c("--param_hostname"), action="store", default=NA, type='character', help="my description"),
make_option(c("--param_login"), action="store", default=NA, type='character', help="my description"),
make_option(c("--param_password"), action="store", default=NA, type='character', help="my description")
)

# set input parameters accordingly
opt = parse_args(OptionParser(option_list=option_list))


id = opt$id
output_dfmerged_1 = opt$output_dfmerged_1

param_CalcType = opt$param_CalcType
param_hostname = opt$param_hostname
param_login = opt$param_login
param_password = opt$param_password


conf_output = 'traits/output'
conf_local <- c('traits','traits/input','traits/output')


conf_output = 'traits/output'
conf_local <- c('traits','traits/input','traits/output')

install.packages("RCurl",repos = "http://cran.us.r-project.org")
RCurl = ''
library(RCurl)
install.packages("httr",repos = "http://cran.us.r-project.org")
httr = ''
library(httr)


directory = ''
for (directory in conf_local) {
  if (!file.exists(directory)) {
    dir.create(directory)
  }
}


auth = basicTextGatherer()
cred = paste(param_login, param_password, sep = ":")
file_content <- getURL(paste0(param_hostname,output_dfmerged_1), curl = getCurlHandle(userpwd = cred))
writeLines(file_content, output_dfmerged_1)


df.merged=read.csv(output_dfmerged_1,stringsAsFactors=FALSE,sep = ";", dec = ".")

formulaformissingdimension = '' 
formulaformissingdimensionsimplified = '' 
df.temp = ''  
md.form = ''
df.temp2 = ''
index = ''
md = ''
df.merged.concat = '' 
md.formulas = ''

if(param_CalcType=='advanced'){
  df.merged.concat = df.merged[is.na(df.merged[,'formulaformissingdimension']),]
  md.formulas = unique(df.merged[!is.na(df.merged[,'formulaformissingdimension']),'formulaformissingdimension'])
  for(md.form in md.formulas){
    df.temp = subset(df.merged,formulaformissingdimension==md.form)
    for(md in unique(df.temp[,'missingdimension'])){
      df.temp2 = df.temp[df.temp[,'missingdimension']==md,]
      df.temp2[[md]] = round(with(df.temp2,eval(parse(text=md.form))),2)
      df.merged.concat = rbind(df.merged.concat,df.temp2)
    }
  }
  df.merged.concat = df.merged.concat[order(df.merged.concat[,'index']),]
  df.merged = df.merged.concat
} else if(param_CalcType=='simplified'){
  df.merged.concat = df.merged[is.na(df.merged[,'formulaformissingdimensionsimplified']),]
  md.formulas = unique(df.merged[!is.na(df.merged[,'formulaformissingdimensionsimplified']),'formulaformissingdimensionsimplified'])
  for(md.form in md.formulas){
    df.temp = subset(df.merged,formulaformissingdimensionsimplified==md.form)
    for(md in unique(df.temp[,'missingdimensionsimplified'])){
      df.temp2 = df.temp[df.temp[,'missingdimensionsimplified']==md,]
      df.temp2[[md]] = round(with(df.temp2,eval(parse(text=md.form))),2)
      df.merged.concat = rbind(df.merged.concat,df.temp2)
    }
  }
  df.merged.concat = df.merged.concat[order(df.merged.concat[,'index']),]
  df.merged = df.merged.concat
}

output_dfmerged_2 = 'traits/output/dfmerged.csv'
write.table(df.merged,output_dfmerged_2,row.names=FALSE,sep = ";",dec = ".",quote=FALSE) 

outputs <- c(output_dfmerged_2)

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

output_dfmerged_2 = paste0(conf_output,'/dfmerged.csv')



