library(data.table)
library(plyr)
library(ggplot2)
library(dplyr)
library(lubridate)
library(reshape)


wx <- fread('/Users/thom/sync/data/wx_data.csv', verbose=T)
wx <- mutate(wx, time = as.POSIXct(time,origin = "1970-01-01",tz = "GMT"))
wx <- mutate_each(wx, funs( as.numeric ), -c(time,metar, Weather, state))

wx <- filter(wx, metar != 'KWYS' & Temp != 0 & state != 'CA' & state != 'LA' & metar != "KSMO" & metar != 'KMSY')

fl <- filter(wx, state=='FL' & Weather != '')

local <- filter(fl, metar=='KSPG' |metar=='KTPA')

low <- min(wx$Temp) -5
hi  <- max(wx$Temp) +5

p <- ggplot(data=local) 
p <- p + geom_point(alpha=.4, aes(time,Temp, colour=Temp), size=3) 
p <- p + scale_colour_gradient(limits=c(low, hi), low="yellow", high='red') 
p <- p + stat_smooth( aes(time,Temp), color='red', level=.99 )    
p <- p + geom_jitter(alpha=.4, aes(x=time,y=Humidity, fill=Humidity), shape=21, size=4, color="white") 
p <- p + scale_fill_gradient(limits=c(10, 100), low="green", high='blue') 
p <- p + stat_smooth( aes(time,Dewp), color='blue', level=.99 ) 
p <- p + facet_wrap( ~ metar, ncol=4) 
p <- p + theme(axis.text.x = element_text(angle = 90))
p <- p + scale_y_continuous(limits=c(low, hi))
p <- p + labs(title = "St. Petersburg/Tampa Temperature & Humidity", x="Date", y="Degrees Fahrenheit") 
p


