library(magick)
library(rsvg)

regi_first <- 34
regi_last <- 103

regi_length <- regi_last - regi_first + 1

setwd("C:/Users/joeyd/Desktop/NIH/PZSA Testing/PoC - Getting it Online/www")

for(i in 1:regi_length)
{
  image <- image_read(paste0("segmentations_1_1/registration_plate_", i + regi_first - 1, ".tif"))
  newpath <- paste0("newseg/registration_plate_", i + regi_first - 1, ".png")
  image_write(image, path = newpath, format = "png")
}