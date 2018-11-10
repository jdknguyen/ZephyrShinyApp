#Instructions
#1) Set the working directory and output folder names.
#2) I don't know if we still need outputfile, but set that to something generic.
#3) Set the pixel resolution.
#4) Run section 1
#5) Edit your filter settings, and run section 2
#6) Run section 3
#7) Set image path for section 4A or 4B
#8) Run either section 4A (fos image) or section 4B (GFP image) to loop away

setwd("C:/Users/joeyd/Desktop/NIH/Project Zephyr Shiny App/PZSA Testing/PoC - Brain Map Input")

#Each brain map will get its own folder. Specify the larger folder to house all of them.

output_folder_name <- "C:/Users/joeyd/Desktop/NIH/Project Zephyr Shiny App/PZSA Testing/PoC - Brain Map Input/images"

outputfile <- "Sample_Web_Map"

pixel.resolution <- 5.16

#----------Section 1: Make a list of which segmentations are for registration plates----------

#This goes through all segmentation objects, and basically figures out which ones to compress into single objects. Goal is to get ~2400 segmentation plates into ~80 registration plates

cur_AP <- 0
seg_list <- c()

for(i in 1:length(all_dataset)){
  if(all_dataset[[i]]$AP[1] != cur_AP){
    cur_AP <- all_dataset[[i]]$AP[1]
    seg_list <- c(seg_list, i)
  }
}

#----------End Section 1----------

#----------Section 2: Editing filters----------

#Make custom fos filter

alim_minimum <- 4
alim_maximum <- 100
threshold_minimum <- 1500
threshold_maximum <- 10000
eccentricity <- 300
max <- 8000
min <- 500
brain.threshold <- 400
resize <- 0.25
blur <- 7
downsample <- 2

alim <- c(alim_minimum, alim_maximum)
threshold.range <- c(threshold_minimum, threshold_maximum)

custom_fos_filter <- list("alim" = alim, "threshold.range" = threshold.range, "eccentricity" = eccentricity, "Max" = max, "Min" = min, "brain.threshold" = brain.threshold, "resize" = resize, "blur" = blur, "downsample" = downsample)

#Make custom GFP filter

alim_minimum <- 4
alim_maximum <- 100
threshold_minimum <- 1500
threshold_maximum <- 10000
eccentricity <- 300
max <- 800
min <- 100
brain.threshold <- 400
resize <- 0.25
blur <- 7
downsample <- 2

alim <- c(alim_minimum, alim_maximum)
threshold.range <- c(threshold_minimum, threshold_maximum)

custom_GFP_filter <- list("alim" = alim, "threshold.range" = threshold.range, "eccentricity" = eccentricity, "Max" = max, "Min" = min, "brain.threshold" = brain.threshold, "resize" = resize, "blur" = blur, "downsample" = downsample)

#----------End Section 2----------

#----------Section 3: Compress segmentation objects according to registration plate----------

#Combine datasets

new_dataset <- list()
counter <- 1
dataset_counter <- 1
current_AP <- all_dataset[[1]]$AP[1]

for(i in 1:length(seg_list)){
  new_animal <- c()
  new_AP <- c()
  new_x <- c()
  new_y <- c()
  new_intensity <- c()
  new_area <- c()
  new_id <- c()
  new_color <- c()
  new_right.hemisphere <- c()
  new_ML <- c()
  new_DV <- c()
  new_acronym <- c()
  new_name <- c()
  new_image <- c()
  
  while(current_AP == all_dataset[[counter]]$AP[1]){
    new_animal <- c(new_animal, all_dataset[[counter]]$animal)
    new_AP <- c(new_AP, all_dataset[[counter]]$AP)
    new_x <- c(new_x, all_dataset[[counter]]$x)
    new_y <- c(new_y, all_dataset[[counter]]$y)
    new_intensity <- c(new_intensity, all_dataset[[counter]]$intensity)
    new_area <- c(new_area, all_dataset[[counter]]$area)
    new_id <- c(new_id, all_dataset[[counter]]$id)
    new_color <- c(new_color, all_dataset[[counter]]$color)
    new_right.hemisphere <- c(new_right.hemisphere, all_dataset[[counter]]$right.hemisphere)
    new_ML <- c(new_ML, all_dataset[[counter]]$ML)
    new_DV <- c(new_DV, all_dataset[[counter]]$DV)
    new_acronym <- c(new_acronym, all_dataset[[counter]]$acronym)
    new_name <- c(new_name, all_dataset[[counter]]$name)
    new_image <- c(new_image, all_dataset[[counter]]$image)
    
    counter <- counter + 1
    
    if(counter > length(all_dataset)){
      counter <- 1
    }
  }
  current_AP <- all_dataset[[counter]]$AP[1]
  dataset_counter <- dataset_counter + 1
  
  new_data <- list("animal" = new_animal, "AP" = new_AP, "x" = new_x, "y" = new_y, "intensity" = new_intensity, "area" = new_area, "id" = new_id, "color" = new_color, "right.hemisphere" = new_right.hemisphere,
                   "ML" = new_ML, "DV" = new_DV, "acronym" = new_acronym, "name" = new_name, "image" = new_image) #make list here
  new_dataset[[i]] <- new_data
}

#----------End Section 3----------

#----------Section 4: Make the map----------

#----------Section 4A: brain map with fos image----------

for(i in 1:length(all_regi)){
  imagepath_init <- paste0("C:/Users/joeyd/Desktop/NIH/Data Files/output_R1_S26_SG_N1_coronal_DF15/R1_S26_SG_N1_coronal_DF15_C01/", new_dataset[[i]]$image[1], ".tif")
  imagepath <- gsub("C02", "C01", imagepath_init)
  
  #seg <- new_seg[[i]]
  regi <- all_regi[[i]]
  data_set <- new_dataset[[i]]
  
  makewebmap(img = imagepath,
             filter = custom_fos_filter, #applies segementation filter
             registration = regi, #region boundaries
             dataset = data_set, #segmented cells
             folder.name = "C:/Users/joeyd/Desktop/NIH/Project Zephyr Shiny App/PZSA Testing/PoC - Brain Map Input/images", 
             scale = 0.64, 
             bregmaX = 0, 
             bregmaY = 0, 
             fluorophore = "c-Fos", 
             combine = TRUE, 
             enable.drawing = TRUE, 
             write.tiles = TRUE, 
             verbose = TRUE)
}

#----------End Section 4A----------

#----------Section 4B: brain map with GFP image----------

for(i in 1:length(all_regi)){
  imagepath <- paste0("C:/Users/joeyd/Desktop/NIH/Data Files/output_R1_S26_SG_N1_coronal_DF15/R1_S26_SG_N1_coronal_DF15_C02/", new_dataset[[i]]$image[1], ".tif")

  regi <- all_regi[[i]]
  data_set <- new_dataset[[i]]
  
  makewebmap(img = imagepath,
             filter = custom_GFP_filter, #applies segementation filter
             registration = regi, #region boundaries
             dataset = data_set, #segmented cells
             folder.name = "C:/Users/joeyd/Desktop/NIH/Project Zephyr Shiny App/PZSA Testing/PoC - Brain Map Input/images",
             scale = 0.64, 
             bregmaX = 0, 
             bregmaY = 0, 
             fluorophore = "GFP", 
             combine = TRUE, 
             enable.drawing = TRUE, 
             write.tiles = TRUE, 
             verbose = TRUE)
}

#----------End Section 4B----------

#----------End Section 4----------

