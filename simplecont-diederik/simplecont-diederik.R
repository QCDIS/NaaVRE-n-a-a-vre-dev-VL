setwd('/app') 

# retrieve input parameters
library(optparse) 
option_list = list( 
	 make_option(c("--a"), action="store", default=NA, type='integer', help="my description"),
	 make_option(c("--id"), action="store", default=NA, type='character', help="my description")
)

# set input parameters accordingly 
opt = parse_args(OptionParser(option_list=option_list)) 
library(jsonlite) 
a = opt$a 
id = opt$id 

# check if the fields are set 
if(is.na(a)){ 
   stop('the `a` parameter is not correctly set. See script usage (--help)') 
}
if(is.na(id)){ 
   stop('the `id` parameter is not correctly set. See script usage (--help)') 
}

# source code 
b <- a * 8

# capturing outputs 
file <- file(paste0('/tmp/b_', id, '.json')) 
writeLines(toJSON(b, auto_unbox=TRUE), file) 
close(file) 
