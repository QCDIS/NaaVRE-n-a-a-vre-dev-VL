setwd('/app')

# retrieve input parameters

library(optparse)
library(jsonlite)

option_list = list

option_list = list(
make_option(c("--id"), action="store", default=NA, type='character', help="my description")


make_option(c("--param_a"), action="store", default=NA, type='character', help="my description"),
make_option(c("--param_b"), action="store", default=NA, type='character', help="my description")
)

# set input parameters accordingly
opt = parse_args(OptionParser(option_list=option_list))


id = opt$id

param_a = opt$param_a
param_b = opt$param_b




c=param_a+1
d=param_b+2



# capturing outputs
file <- file(paste0('/tmp/d_', id, '.json'))
writeLines(toJSON(d, auto_unbox=TRUE), file)
close(file)
file <- file(paste0('/tmp/c_', id, '.json'))
writeLines(toJSON(c, auto_unbox=TRUE), file)
close(file)
