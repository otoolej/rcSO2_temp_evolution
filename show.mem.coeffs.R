show.mem.coeffs <- function(pd.final,bootCI=0){

    b <- summary(pd.final)
    if(bootCI){
        cintr <- data.frame(confint(pd.final,method="boot",nsim=1000,
                                    parallel="multicore",ncpus=4))
    } else {
        cintr <- data.frame(confint(pd.final,method="Wald"))
    }

    i_cintr <- which(grepl( ".sig", rownames(cintr)) ==FALSE)

    bcoef <- cbind(b$coef[,1])
    bpvalue <- cbind(b$coef[,5])
    rownames(bcoef) <- rownames(b$coef)
    rownames(bpvalue) <- rownames(b$coef)
    cis <- cintr[i_cintr,]
    rownames(cis) <- rownames(b$coef)
    oldtable <- cbind(bcoef,cintr[i_cintr,],bpvalue)
    newtable <- oldtable
    colnames(newtable) <- c('coefficient','2.5%','97.5%','Pr(>|t|)')
    ntable <- format(newtable,digits=3)

    
    return(ntable)
}
