
radar <- fread('/Users/thom/sync/data/radar.csv', verbose=T)
radar <- mutate(radar, time = ymd_hms(`_time`))
radar <- filter(radar, time > as.POSIXct('2015-07-01') )

r <- melt(radar, id.vars = "time", measure.vars = c("Bay_Area", "Pinellas","St_Petersburg"))


ggplot(r ,aes(x=time  ,y=value )) +
    geom_jitter(stat="identity",  position="dodge", alpha=.8 , aes(size=value, color= variable))  +
    labs(title=expression("Storm Activity by Location"), x="time", y=expression("Storm Coverage"), size="Percent")

