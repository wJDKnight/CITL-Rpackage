if (!requireNamespace("bnlearn", quietly = TRUE))
  install.packages("bnlearn")

if (!requireNamespace("snow", quietly = TRUE))
  install.packages("snow")
library(bnlearn)
library(snow)

#source("R/functions_s.R")


#' @title Infer time-lagged causality
#' @description CITL addresses the limitations of the existing methods for inferring time-lagged causal relationships among genes on single-cell RNA sequencing scRNA-seq data. It adopts the changing information of genes estimated by RNA velocity for causal inference algorithm. Based on the Time-lagged assumption, CITL can infer time-lagged relationships which are validated by published literature. More information and demonstration is in out article (Wei et al., 2021).Before using CITL, annotations of unspliced/spliced reads could be obtained using velocyto CLI or kallisto first.
#'
#' @param spliced a data frame of mRNA expression data. the colname of it is gene names.
#' @param velocity a data frame of velocity data. the colname of it is gene names.
#' @param genes the gene name list
#' @param n_cluster the number of computational threads
#' @param maxsx the maximum allowed size of the conditioning sets used in constructing causal graph
#'
#' @return a summary data frame of time-lagged causal pairs
#' @export
#'
inferTLPs= function(spliced, velocity, genes = colnames(spliced), n_cluster=1, maxsx = floor(sqrt(ncol(spliced)))){
  Spliced = spliced
  delta_s = velocity
  gene_names = genes

  s_gene_names<-paste0(unlist(gene_names),"_1")
  colnames(Spliced)<-s_gene_names
  de_gene_names<-paste0(unlist(gene_names),"_2")
  colnames(delta_s)<-de_gene_names
  spl_del<-cbind(Spliced,delta_s)

  #bnet calculation
  if(n_cluster>1){
    cl=makeCluster(n_cluster,type = "SOCK")
    bn=pc.stable(spl_del,max.sx=maxsx,undirected = T, cluster = cl)
    stopCluster(cl)
  } else {
    bn=pc.stable(spl_del,max.sx=maxsx,undirected = T)
  }

  #TLPs summary
  A1B2_arcs<-arcs.1.2(bn)
  nodup_A1B2_arcs<-A1B2_arcs[!duplicated(A1B2_arcs),]
  pure_direct_A1B2_arcs<-rm.bidirect(nodup_A1B2_arcs)$no_bidirect_arcs

  sum_results<-data.frame()
  for (i in 1:nrow(pure_direct_A1B2_arcs)) {
    a=pure_direct_A1B2_arcs[i,1]
    b=pure_direct_A1B2_arcs[i,2]

    cur_cur=cor(Spliced[[paste0(a,"_1")]],Spliced[[paste0(b,"_1")]])
    cur_cha=cor(Spliced[[paste0(a,"_1")]],delta_s[[paste0(b,"_2")]])
    cur_sub=cor(Spliced[[paste0(a,"_1")]],(delta_s[[paste0(b,"_2")]]+Spliced[[paste0(b,"_1")]]))
    x=data.frame(from=a,to=b,cur_cur=cur_cur,cur_cha=cur_cha,cur_sub=cur_sub)

    sum_results=rbind(sum_results,x)
  }

  return(sum_results)
}





















