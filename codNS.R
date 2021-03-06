
# ---- install ----
library(devtools)
install_github("msy", "wgmg")
install_github("FLCore", "flr")

# ---- library ----
library(msy)

# ---- loadcod ----
load("data/codNS.rData")

# ---- setupcod ----
codsetup <- list(
           data = codNS,
           wt.years = c(2008, 2012),
           Fscan = seq(0, 1.5, len = 40),
           Bpa = 150000,
           Blim = 70000,
           Btrigger = 150000,
           verbose = FALSE) # set verbose to TRUE if you want to see simulation progress

# ---- codsegreg ----
codsg <-
  within(codsetup,
  {
    fit <- fitModels(data, nsamp = 2000, model = "segreg")
    sim <- EqSim(fit, wt.years = wt.years, Fscan = Fscan, verbose = verbose)
    ref <- Eqplot(sim, fit, Blim = Blim, Bpa = Bpa, plot = FALSE)
  })

# ---- getref1 ----
t(codsg $ ref $ Refs)

# ---- plotref1 ----
with(codsg, Eqplot(sim, fit, Blim = Blim, Bpa = Bpa))

# ---- plotsr1 ----
SRplot(codsg $ fit)


# ---- codsgfit ----
str(codsg $ fit, 2)

# ---- codsgsim ----
str(codsg $ sim, 2)

# ---- codbevholt ----
codbh <-
  within(codsetup,
  {
    fit <- fitModels(data, nsamp = 2000, model = "bevholt")
    sim <- EqSim(fit, wt.years = wt.years, Fscan = Fscan, verbose = verbose)
    ref <- Eqplot(sim, fit, Blim = Blim, Bpa = Bpa, plot = FALSE)
  })

# ---- codricker ----
codrk <-
  within(codsetup,
  {
    fit <- fitModels(data, nsamp = 2000, model = "bevholt")
    sim <- EqSim(fit, wt.years = wt.years, Fscan = Fscan, verbose = verbose)
    ref <- Eqplot(sim, fit, Blim = Blim, Bpa = Bpa, plot = FALSE)
  })

# ---- codall ----
codall <-
  within(codsetup,
  {
    fit <- fitModels(data, nsamp = 2000, model = c("segreg", "bevholt","ricker"))
    sim <- EqSim(fit, wt.years = wt.years, Fscan = Fscan, verbose = verbose)
    ref <- Eqplot(sim, fit, Blim = Blim, Bpa = Bpa, plot = FALSE)
  })


# ---- codallvar ----
codall_variations <-
  within(codall, 
  {
    # simulate without process error in the recruitment predictions
    sim2 <- EqSim(fit, wt.years = wt.years, Fscan = Fscan, process.error = FALSE, verbose = verbose)
    # simulate with process error (i.e. using predictive distrution of recruitment) and include a simple HCR
    sim3 <- EqSim(fit, wt.years = wt.years, Fscan = Fscan, Btrigger = Btrigger, verbose = verbose)
    # simulate without process error (i.e. using model and parameter error only, not including "observation" error) and include a simple HCR
    sim4 <- EqSim(fit, wt.years = wt.years, Fscan = Fscan, process.error = FALSE, Btrigger = Btrigger, verbose = verbose)

    # now calculate the reference points for each simulation
    ref2 <- Eqplot(sim2, fit, Blim = Blim, Bpa = Bpa, plot = FALSE)
    ref3 <- Eqplot(sim3, fit, Blim = Blim, Bpa = Bpa, plot = FALSE)
    ref4 <- Eqplot(sim4, fit, Blim = Blim, Bpa = Bpa, plot = FALSE)
  })



# ---- summarise ----
#out <- data.frame(statistic = "Med", 
#                  method    = rep(paste0("M3",1:4), 3), 
#                  what      = rep(c("FMSY","BMSY","MSY"), each = 4),
#                  value     = c(refNS $ Refs["F",4], refNS2 $ Refs["F",4], refNS3 $ Refs["F",4], refNS4 $ Refs["F",4],
#                                refNS $ Refs["SSB",4], refNS2 $ Refs["SSB",4], refNS3 $ Refs["SSB",4], refNS4 $ Refs["SSB",4],
#                                refNS $ Refs["Catch",4], refNS2 $ Refs["Catch",4], refNS3 $ Refs["Catch",4], refNS4 $ Refs["Catch",4]))

#out $ value[-(1:4)] <- out $ value[-(1:4)] / 1000


#out <- do.call(rbind, modout)
#out $ model <- rep(c("S","B","R","all"), each = 12)
#write.table(out, file = "colins.csv", sep = ",", row.names = FALSE)


