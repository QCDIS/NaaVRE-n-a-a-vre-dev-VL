setwd('/app')

# retrieve input parameters

library(optparse)
library(jsonlite)

option_list = list

option_list = list(
make_option(c("--c"), action="store", default=NA, type='character', help="my description"),

make_option(c("--d"), action="store", default=NA, type='character', help="my description"),

make_option(c("--id"), action="store", default=NA, type='character', help="my description")


)

# set input parameters accordingly
opt = parse_args(OptionParser(option_list=option_list))


c = opt$c
d = opt$d
id = opt$id





e=c+1
f=d+2



