Rprof("Rprof-mem.out", memory.profiling=T)
mean(1:1000)
summaryRprof("Rprof-mem.out")


tryCatch({
  restart(4)
}, error=function(e){cat('ERROR :', conditionMessage(e), '\n')})
