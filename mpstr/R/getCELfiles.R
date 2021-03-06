#' 1) Process local Affymetrix CEL files for mouse or human data 
#' 
#' @export
#' @param projectId A unique identifier for the project
#' @param listGroups Group assignments for each sample, follow alphabetical order of samples
#' @param listBatches Optional list of batches for each sample, follow alphabetical order of samples
#' @param workspace Working directory
#' @return ExpressionFeatureSet object with raw data and phenotype information
#' @examples 
#' celfiles = getCELfiles(projectId='NCI_Project_1',listGroups=c('Ctl_1','Ctl_1','Ctl_1','KO_1','KO_1','KO_1'),workspace='/Users/name/folderName')
#' celfiles = getCELfiles(projectId='NCI_Project_2',listGroups=c('Ctl','Ctl','Ctl','Ctl','RNA_1','RNA_1','RNA_1','RNA_1','RNA_2','RNA_2','RNA_2','RNA_2'),listBatches=c(rep('A',6),rep('B',6)),workspace='/Users/name/folderName')      
#' @references See packages tools, Biobase, oligo

getCELfiles <- function(projectId,listGroups,listBatches=NULL,workspace) {
  library(tools)
  library(Biobase)
  library(oligo)
  
  getCELfiles_ERR = file(paste0(workspace,'/getCELfiles.err'),open='wt')
  sink(getCELfiles_ERR,type='message',append=TRUE)
  
  SampleName = list.files(path = workspace, pattern = '/*CEL.gz|/*CEL$', ignore.case = T, full.names=T)
  celfiles = read.celfiles(SampleName)
  pData(celfiles)$title = basename(file_path_sans_ext(SampleName))  #add sample name to pheno
  pData(celfiles)$groups = listGroups                               #add groups to pheno
  if(!is.null(listBatches)) {
    pData(celfiles)$batch = listBatches                             # add optional batch to pheno
  }
  ####creates a list of colors specific to each group
  fs = factor(pData(celfiles)$groups)
  lFs=levels(fs)
  numFs=length(lFs)
  colors = list()
  for (i in 1:numFs){
    colors[which(fs==lFs[i])] = i*5
  }
  colors = unlist(colors)
  pData(celfiles)$colors = colors
  return(celfiles)
  sink(type='message')
}