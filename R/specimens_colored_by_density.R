## Get data with, e.g.
## SELECT dec_long, dec_lat FROM flat
##   WHERE phylclass = 'Magnoliopsida'
##   AND guid ~ 'UAM:Herb'
##   AND dec_long is not null

## Thanks to:
##   https://bonburubird.blogspot.com/2013/12/density-heat-map-in-r.html

library(maps)
library(mapdata)

makemap <- function(dataf, fname) {

jpeg(fname, width = 800, height = 600)

ww2 <- map('worldHires', wrap=c(0,360), plot=FALSE)
map(ww2, xlim = c(180, 235), ylim=c(52,72))
box()

dat <- read.table(dataf, header=T, sep=",")
x <- dat$dec_long
y <- dat$dec_lat

x[x < 0] <- 360+x[x<0] # need to swap the long=-ve to values > 180E 

c1 <- densCols(x,y, colramp=colorRampPalette(c("black", "white")),nbin=500)
dens <- col2rgb(c1)[1,] + 1L
cols <-  colorRampPalette(c("#000099", "#00FEFF", "#45FE4F", 
                            "#FCFF00", "#FF9400", "#FF3100"))(256)
c2 <- cols[dens]

points(x , y, pch=20, col=c2, cex=2) 

dev.off()

}

# makemap("pinopsida.csv", "pinopsida.jpg")
# makemap("bryophyta.csv", "bryophyta.jpg")
makemap("magnoliopsida.csv","magnoliopsida.jpg")
# makemap("salix.csv","salix.jpg")
