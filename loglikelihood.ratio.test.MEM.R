loglikelihood.ratio.test.MEM <- function(p1,p2,df1,df2){
    a <- logLik(p1,REML=FALSE)
    b <- logLik(p2,REML=FALSE)
    d1=attr(a,"df")        
    d2=attr(b,"df")    
    ll.diff <- -2*(a[1]-b[1])

    res <- matrix(,nrow=2,ncol=4)
    colnames(res) <- c('df','logLik','logRatio (chisq)','pvalue')
    rownames(res) <- c('pm1','pm2')    
    res[,'df'] <- c(d1,d2)
    res[,'logLik'] <- c(a[1],b[1])
    
    if(ll.diff<0)
    {
        pm1 <- p2
        pm2 <- p1
        ll.diff=-ll.diff
        tt <- res
        tt[1,] <- res[2,]
        tt[2,] <- res[1,]
        res <- tt
        betterFitModel <- 1
    } else {
        pm1 <- p1
        pm2 <- p2
        betterFitModel <- 2
    }
    pvalue2 <- pchisq(ll.diff,df=abs(d1-d2),lower.tail=FALSE)
    res[2,'logRatio (chisq)'] <- ll.diff
    res[2,'pvalue'] <- pvalue2

    cat('pm1: ')
    show(formula(pm1))
    cat('pm2: ')
    show(formula(pm2))
    show(res)

    return(list('logLikeTable'=res,'whichModel'=betterFitModel))


    # had this originally (from Vickis book), but not correct?;
    ## a <- logLik(p1,REML=TRUE)
    ## b <- logLik(p2,REML=TRUE)
    ## ll.diff <- -2*(a[1]-b[1])

    ## pvalue <- 0.5*(1-pchisq(ll.diff,df1)) + 0.5*(1-pchisq(ll.diff,df2))
    
    ## show(p1@call)
    ## show(p2@call)
    ## print(sprintf('logLik1=%f',a))
    ## print(sprintf('logLik2=%f',b))
    ## print(sprintf('log-like difference=%f; p-value=%f',ll.diff,pvalue))    
    
    ## return(pvalue)
}
