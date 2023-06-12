setwd('/app')

# retrieve input parameters

library(optparse)
library(jsonlite)

option_list = list

option_list = list(
make_option(c("--biovolume"), action="store", default=NA, type='character', help="my description"),

make_option(c("--BV_calc"), action="store", default=NA, type='character', help="my description"),

make_option(c("--BV_column"), action="store", default=NA, type='character', help="my description"),

make_option(c("--CC_calc"), action="store", default=NA, type='character', help="my description"),

make_option(c("--CC_column"), action="store", default=NA, type='character', help="my description"),

make_option(c("--cellcarboncontent"), action="store", default=NA, type='character', help="my description"),

make_option(c("--D_calc"), action="store", default=NA, type='character', help="my description"),

make_option(c("--D_column"), action="store", default=NA, type='character', help="my description"),

make_option(c("--density"), action="store", default=NA, type='character', help="my description"),

make_option(c("--F"), action="store", default=NA, type='character', help="my description"),

make_option(c("--id"), action="store", default=NA, type='character', help="my description"),

make_option(c("--index"), action="store", default=NA, type='character', help="my description"),

make_option(c("--SA_calc"), action="store", default=NA, type='character', help="my description"),

make_option(c("--SA_column"), action="store", default=NA, type='character', help="my description"),

make_option(c("--surfacearea"), action="store", default=NA, type='character', help="my description"),

make_option(c("--surfacevolumeratio"), action="store", default=NA, type='character', help="my description"),

make_option(c("--SVR_calc"), action="store", default=NA, type='character', help="my description"),

make_option(c("--SVR_column"), action="store", default=NA, type='character', help="my description"),

make_option(c("--TBV_calc"), action="store", default=NA, type='character', help="my description"),

make_option(c("--TBV_column"), action="store", default=NA, type='character', help="my description"),

make_option(c("--TCC_calc"), action="store", default=NA, type='character', help="my description"),

make_option(c("--TCC_column"), action="store", default=NA, type='character', help="my description"),

make_option(c("--totalbiovolume"), action="store", default=NA, type='character', help="my description"),

make_option(c("--totalcarboncontent"), action="store", default=NA, type='character', help="my description"),

make_option(c("--TraitBiovolume"), action="store", default=NA, type='character', help="my description"),

make_option(c("--TraitCellcarboncontent"), action="store", default=NA, type='character', help="my description"),

make_option(c("--TraitDensity"), action="store", default=NA, type='character', help="my description"),

make_option(c("--TraitSurfacearea"), action="store", default=NA, type='character', help="my description"),

make_option(c("--TraitSurfacevolumeratio"), action="store", default=NA, type='character', help="my description"),

make_option(c("--TraitTotalbiovolume"), action="store", default=NA, type='character', help="my description"),

make_option(c("--TraitTotalcarboncontent"), action="store", default=NA, type='character', help="my description")


)

# set input parameters accordingly
opt = parse_args(OptionParser(option_list=option_list))


biovolume = fromJSON(opt$biovolume)
BV_calc = fromJSON(opt$BV_calc)
BV_column = fromJSON(opt$BV_column)
CC_calc = fromJSON(opt$CC_calc)
CC_column = fromJSON(opt$CC_column)
cellcarboncontent = fromJSON(opt$cellcarboncontent)
D_calc = fromJSON(opt$D_calc)
D_column = fromJSON(opt$D_column)
density = fromJSON(opt$density)
F = opt$F
id = opt$id
index = fromJSON(opt$index)
SA_calc = fromJSON(opt$SA_calc)
SA_column = fromJSON(opt$SA_column)
surfacearea = fromJSON(opt$surfacearea)
surfacevolumeratio = fromJSON(opt$surfacevolumeratio)
SVR_calc = fromJSON(opt$SVR_calc)
SVR_column = fromJSON(opt$SVR_column)
TBV_calc = opt$TBV_calc
TBV_column = fromJSON(opt$TBV_column)
TCC_calc = fromJSON(opt$TCC_calc)
TCC_column = fromJSON(opt$TCC_column)
totalbiovolume = fromJSON(opt$totalbiovolume)
totalcarboncontent = fromJSON(opt$totalcarboncontent)
TraitBiovolume = opt$TraitBiovolume
TraitCellcarboncontent = opt$TraitCellcarboncontent
TraitDensity = fromJSON(opt$TraitDensity)
TraitSurfacearea = opt$TraitSurfacearea
TraitSurfacevolumeratio = opt$TraitSurfacevolumeratio
TraitTotalbiovolume = opt$TraitTotalbiovolume
TraitTotalcarboncontent = opt$TraitTotalcarboncontent





df.datain=read.csv('~/Unisalento/Lifewatch/Phyto_VRE/Script_R/Traits_Computation/dfdatain.csv',stringsAsFactors=F,sep = ";", dec = ".")

BV=TraitBiovolume 
TBV=TraitTotalbiovolume
D=TraitDensity
SA=TraitSurfacearea
SVR=TraitSurfacevolumeratio
CC=TraitCellcarboncontent
TCC=TraitTotalcarboncontent

if(BV==1) {
    BV_column=BV_calc
    if('biovolume'%in%names(df.datain)) df.datain<-subset(df.datain,select=-biovolume) # drop column if already present
    df.datain$biovolume <- BV_column # write column with the results at the end of the dataframe
    }
if(CC==1) {
    CC_column=CC_calc
    if('cellcarboncontent'%in%names(df.datain)) df.datain<-subset(df.datain,select=-cellcarboncontent)
    df.datain$cellcarboncontent <- CC_column
    }
if(D==1) {
    D_column=D_calc
    df.datain$density <- D_column
    }
if(TBV==1) {
    TBV_column=TBV_calc
    df.datain$totalbiovolume <- TBV_column
    }
if(SA==1) {
    SA_column=SA_calc
    if('surfacearea'%in%names(df.datain)) df.datain<-subset(df.datain,select=-surfacearea)
    df.datain$surfacearea <- SA_column
    }
if(SVR==1) {
    SVR_column=SVR_calc
    df.datain$surfacevolumeratio <- SVR_column
    }
if(TCC==1) {
    TCC_column=TCC_calc
    df.datain$totalcarboncontent <- TCC_column
    }

df.datain <- subset(df.datain,select = -index)

write.table(df.datain,paste('~/Unisalento/Lifewatch/Phyto_VRE/Script_R/Traits_Computation/Output/TraitsOutput.csv',sep=''),row.names=F,sep = ";",dec = ".",quote=F) 



