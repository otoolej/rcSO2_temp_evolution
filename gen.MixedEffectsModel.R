rm(list = ls())
source('loglikelihood.ratio.test.MEM.R')
source('show.mem.coeffs.R')
require(lme4)

##-------------------------------------------------------------------
## load the data:
##-------------------------------------------------------------------


cat('** NIRS data required for analysis **\n')
return
## <uncomment to load data (see structure of data frame below)>
## cat('** load data\n')
## source('loadDataAll.R')
## drData <- loadDataAll(0)
## str(drData)


## data frame with columns:
##     ID = baby ID,
##     GA_type = either very or extremely preterm,
##     gender = 0/1,
##     outcome = either 'normal', 'moderate', or 'severe'
##     time = time index for rcSO2 (in days), and
##     rcSO2 = regional cerebral oxygenation values



##-------------------------------------------------------------------
## FULL model (i.e. with everything)
##-------------------------------------------------------------------
pd.t.t2.t3 <- 
    lme4::lmer(rcSO2 ~ 1 + time + I(time^2) + I(time^3) +
               GA_type + GA_type:time + GA_type:I(time^2) + GA_type:I(time^3) +
               gender + gender:time + gender:I(time^2) + gender:I(time^3) +
               outcome + outcome:time + outcome:I(time^2) + outcome:I(time^3) +
               (1 + time + I(time^2) + I(time^3) | ID),
               drData, REML=FALSE)

pd.full <- pd.t.t2.t3



##-------------------------------------------------------------------
## 1. test removing random effects first:
##    (use REML and likelihood ratio test when comparing random effects;
##     assumption here is that the fixed effects don't change)
##-------------------------------------------------------------------
p.t.t2.t3 <- 
    lme4::lmer(rcSO2 ~ 1 + time + I(time^2) + I(time^3) +
               GA_type + GA_type:time + GA_type:I(time^2) + GA_type:I(time^3) +
               gender + gender:time + gender:I(time^2) + gender:I(time^3) +
               outcome + outcome:time + outcome:I(time^2) + outcome:I(time^3) +
               (1 + time + I(time^2) + I(time^3) | ID),
               drData, REML=TRUE)

p.t.t2 <- 
    lme4::lmer(rcSO2 ~ 1 + time + I(time^2) + I(time^3) +
               GA_type + GA_type:time + GA_type:I(time^2) + GA_type:I(time^3) +
               gender + gender:time + gender:I(time^2) + gender:I(time^3) +
               outcome + outcome:time + outcome:I(time^2) + outcome:I(time^3) +
               (1 + time + I(time^2) | ID),
               drData, REML=TRUE)

p.t <- 
    lme4::lmer(rcSO2 ~ 1 + time + I(time^2) + I(time^3) +
               GA_type + GA_type:time + GA_type:I(time^2) + GA_type:I(time^3) +
               gender + gender:time + gender:I(time^2) + gender:I(time^3) +
               outcome + outcome:time + outcome:I(time^2) + outcome:I(time^3) +
               (1 + time | ID),
               drData, REML=TRUE)

p <- 
    lme4::lmer(rcSO2 ~ 1 + time + I(time^2) + I(time^3) +
               GA_type + GA_type:time + GA_type:I(time^2) + GA_type:I(time^3) +
               gender + gender:time + gender:I(time^2) + gender:I(time^3) +
               outcome + outcome:time + outcome:I(time^2) + outcome:I(time^3) +
               (1 | ID),
               drData, REML=TRUE)

cat('\n** COMPARING MODELS with random effects, all\n')
loglikelihood.ratio.test.MEM(p.t.t2,pd.t.t2.t3)
loglikelihood.ratio.test.MEM(p.t,pd.t.t2.t3)
loglikelihood.ratio.test.MEM(p,pd.t.t2.t3)

print(anova(p,p.t,p.t.t2,pd.t.t2.t3))

##-------------------------------------------------------------------
## 2. test removing fixed effects:
##-------------------------------------------------------------------

## a) outcome:
pd.f.t.t2.t3 <- 
    lme4::lmer(rcSO2 ~ 1 + time + I(time^2) + I(time^3) +
               GA_type + GA_type:time + GA_type:I(time^2) + GA_type:I(time^3) +
               gender + gender:time + gender:I(time^2) + gender:I(time^3) +
               outcome + outcome:time + outcome:I(time^2) + outcome:I(time^3) +
               (1 + time + I(time^2) + I(time^3) | ID),
               drData, REML=FALSE)
pd.f.t.t2 <- 
    lme4::lmer(rcSO2 ~ 1 + time + I(time^2) + I(time^3) +
               GA_type + GA_type:time + GA_type:I(time^2) + GA_type:I(time^3) +
               gender + gender:time + gender:I(time^2) + gender:I(time^3) +
               outcome + outcome:time + outcome:I(time^2) + 
               (1 + time + I(time^2) + I(time^3) | ID),
               drData, REML=FALSE)
pd.f.t <- 
    lme4::lmer(rcSO2 ~ 1 + time + I(time^2) + I(time^3) +
               GA_type + GA_type:time + GA_type:I(time^2) + GA_type:I(time^3) +
               gender + gender:time + gender:I(time^2) + gender:I(time^3) +
               outcome + outcome:time + 
               (1 + time + I(time^2) + I(time^3) | ID),
               drData, REML=FALSE)
pd.f <- 
    lme4::lmer(rcSO2 ~ 1 + time + I(time^2) + I(time^3) +
               GA_type + GA_type:time + GA_type:I(time^2) + GA_type:I(time^3) +
               gender + gender:time + gender:I(time^2) + gender:I(time^3) +
               outcome + 
               (1 + time + I(time^2) + I(time^3) | ID),
               drData, REML=FALSE)
pd <- 
    lme4::lmer(rcSO2 ~ 1 + time + I(time^2) + I(time^3) +
               GA_type + GA_type:time + GA_type:I(time^2) + GA_type:I(time^3) +
               gender + gender:time + gender:I(time^2) + gender:I(time^3) +
               (1 + time + I(time^2) + I(time^3) | ID),
               drData, REML=FALSE)


cat('\n** COMPARING MODELS with outcome fixed-effect, all:\n')
print( anova(pd,pd.f,pd.f.t,pd.f.t.t2,pd.f.t.t2.t3) )

loglikelihood.ratio.test.MEM(pd.f.t.t2,pd.f.t.t2.t3)
loglikelihood.ratio.test.MEM(pd.f.t,pd.f.t.t2)
loglikelihood.ratio.test.MEM(pd.f,pd.f.t)
loglikelihood.ratio.test.MEM(pd,pd.f)




## b) gender:
pd.f.t.t2.t3 <- pd
pd.f.t.t2 <- 
    lme4::lmer(rcSO2 ~ 1 + time + I(time^2) + I(time^3) +
               GA_type + GA_type:time + GA_type:I(time^2) + GA_type:I(time^3) +
               gender + gender:time + gender:I(time^2) + 
               (1 + time + I(time^2) + I(time^3) | ID),
               drData, REML=FALSE)
pd.f.t <- 
    lme4::lmer(rcSO2 ~ 1 + time + I(time^2) + I(time^3) +
               GA_type + GA_type:time + GA_type:I(time^2) + GA_type:I(time^3) +
               gender + gender:time + 
               (1 + time + I(time^2) + I(time^3) | ID),
               drData, REML=FALSE)
pd.f <- 
    lme4::lmer(rcSO2 ~ 1 + time + I(time^2) + I(time^3) +
               GA_type + GA_type:time + GA_type:I(time^2) + GA_type:I(time^3) +
               gender + 
               (1 + time + I(time^2) + I(time^3) | ID),
               drData, REML=FALSE)
pd <- 
    lme4::lmer(rcSO2 ~ 1 + time + I(time^2) + I(time^3) +
               GA_type + GA_type:time + GA_type:I(time^2) + GA_type:I(time^3) +
               (1 + time + I(time^2) + I(time^3) | ID),
               drData, REML=FALSE)


cat('\n** COMPARING MODELS with outcome fixed-effect, all:\n')
show.anova(pd,pd.f,pd.f.t,pd.f.t.t2,pd.f.t.t2.t3)

loglikelihood.ratio.test.MEM(pd.f.t.t2,pd.f.t.t2.t3)
loglikelihood.ratio.test.MEM(pd.f.t,pd.f.t.t2)
loglikelihood.ratio.test.MEM(pd.f,pd.f.t)
loglikelihood.ratio.test.MEM(pd,pd.f)


## c) gestational age (GA)
pd.f.t.t2.t3 <- pd
pd.f.t.t2 <- 
    lme4::lmer(rcSO2 ~ 1 + time + I(time^2) + I(time^3) +
               GA_type + GA_type:time + GA_type:I(time^2) + 
               (1 + time + I(time^2) + I(time^3) | ID),
               drData, REML=FALSE)
pd.f.t <- 
    lme4::lmer(rcSO2 ~ 1 + time + I(time^2) + I(time^3) +
               GA_type + GA_type:time + 
               (1 + time + I(time^2) + I(time^3) | ID),
               drData, REML=FALSE)
pd.f <- 
    lme4::lmer(rcSO2 ~ 1 + time + I(time^2) + I(time^3) +
               GA_type + 
               (1 + time + I(time^2) + I(time^3) | ID),
               drData, REML=FALSE)
pd <- 
    lme4::lmer(rcSO2 ~ 1 + time + I(time^2) + I(time^3) +
               (1 + time + I(time^2) + I(time^3) | ID),
               drData, REML=FALSE)


cat('\n** COMPARING MODELS with outcome fixed-effect, all:\n')
show.anova(pd,pd.f,pd.f.t,pd.f.t.t2,pd.f.t.t2.t3)

loglikelihood.ratio.test.MEM(pd.f.t.t2,pd.f.t.t2.t3)
loglikelihood.ratio.test.MEM(pd.f.t,pd.f.t.t2)
loglikelihood.ratio.test.MEM(pd.f,pd.f.t)
loglikelihood.ratio.test.MEM(pd,pd.f)


##-------------------------------------------------------------------
## 3. test removing fixed-time effects:
##-------------------------------------------------------------------
pd.f.t.t2.t3 <- pd.f
pd.f.t.t2 <- 
    lme4::lmer(rcSO2 ~ 1 + time + I(time^2) + 
               GA_type + 
               (1 + time + I(time^2) + I(time^3) | ID),
               drData, REML=FALSE)
pd.f.t <- 
    lme4::lmer(rcSO2 ~ 1 + time + 
               GA_type + 
               (1 + time + I(time^2) + I(time^3) | ID),
               drData, REML=FALSE)
pd.f <- 
    lme4::lmer(rcSO2 ~ 1 + 
               GA_type + 
               (1 + time + I(time^2) + I(time^3) | ID),
               drData, REML=FALSE)
pd.f.t2.t3 <- 
    lme4::lmer(rcSO2 ~ 1 + I(time^2) + I(time^3) + 
               GA_type + 
               (1 + time + I(time^2) + I(time^3) | ID),
               drData, REML=FALSE)


cat('\n** COMPARING MODELS with outcome fixed-effect, all:\n')
show.anova(pd.f,pd.f.t,pd.f.t.t2,pd.f.t.t2.t3,pd.f.t2.t3)

loglikelihood.ratio.test.MEM(pd.f.t.t2,pd.f.t.t2.t3)
loglikelihood.ratio.test.MEM(pd.f.t,pd.f.t.t2.t3)
loglikelihood.ratio.test.MEM(pd.f,pd.f.t.t2.t3)


##-------------------------------------------------------------------
## FINAL model: 
##-------------------------------------------------------------------
## final, with no group x time interactions
library(lmerTest)
pd.final <-
    lmerTest::lmer(rcSO2 ~ 1 + time + I(time^2) + I(time^3) + GA_type +
                       (1 + time + I(time^2) + I(time^3) | ID),
                   drData,REML=TRUE)

## confidence intervals:
h <- show.mem.coeffs(pd.final)
cat('\n*** 95% CI for coefficients\n')
print(h)


