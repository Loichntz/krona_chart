args<-commandArgs(TRUE)
library(tidyverse)

mef_tsv <- function(file)
{
	tax<-read.table(file,sep="\t",header=T)
	tax$OTU.ID<-str_replace_all(tax$OTU.ID,'s','s')
	tax<-data.frame(tax,tax$OTU.ID)
	colnames(tax)[7]<-"taxo"
	tax$OTU.ID<-NULL
	colnames(tax)<-str_replace(colnames(tax),'X','')
	return(tax)
}
write.table(mef_tsv(args[1]),file=args[2],sep="\t")

