rois_sunburst <- function(dataset = NULL, rois = c("CH", "BS", "CB"), parents = TRUE, savepath = NULL){

  #Set Up
  
  paxTOallen <- function(paxinos){
    round(214+(20-(paxinos*1000))/25)
  }
  
  get_roi <- function(dataset, roi = c('MO', 'TH')){
    out <- unlist(lapply(roi, function(x)sum(dataset$acronym %in% get.sub.structure(x))))
    roi.data <- data.frame(acronym = roi, cell.count = out)
    return(roi.data)
  }
  
  #Assemble Nested ROIs List
  
  init_rois <- rois
  for(i in 1:length(init_rois)){
    if(parents == TRUE){ #This adds in parent regions - only do this if parents == TRUE
      new_parent_addition <- wholebrain::get.acronym.parent(init_rois[i])
      while(new_parent_addition != "grey"){
        rois <- c(rois, new_parent_addition)
        new_parent_addition <- wholebrain::get.acronym.parent(new_parent_addition)
      }
    }
    new_child_additions <- wholebrain::get.acronym.child(init_rois[i]) #This adds in child regions - these must always be added
    next_level_additions <- c()
    while(length(new_child_additions) > 0){
      for(j in 1:length(new_child_additions)){
        next_level_additions <- c(next_level_additions, wholebrain::get.acronym.child(new_child_additions[j]))
      }
      rois <- c(rois, new_child_additions)
      new_child_additions <- next_level_additions
      next_level_additions <- c()
      new_child_additions <- new_child_additions[is.na(new_child_additions) == FALSE]
    }
  }

  rois <- unique(rois)
  rois <- rois[is.na(rois) == FALSE]
  
  #Get Paths
  
  paths <- c()
  
  for(i in 1:length(rois)){
   most_recent <- wholebrain::get.acronym.parent(rois[i])
   most_recent_path <- rois[i]
   if(grepl("-", most_recent_path)){
     most_recent_path <- gsub("-", "_", most_recent_path)
   }
   if(parents == TRUE){ #Finds paths all the way to the CH/BS layer
     if(rois[i] != "grey"){
       while(most_recent != "grey" & most_recent_path != "grey"){
         next_path <- wholebrain::get.acronym.parent(most_recent)
         if(grepl("-", most_recent)){
           most_recent <- gsub("-", "_", most_recent)
         }
         most_recent_path <- paste0(most_recent, "-", most_recent_path)
         most_recent <- next_path
       }
       paths <- c(paths, most_recent_path)
     }
   }
   if(parents == FALSE){ #Finds paths only to the initially specified ROI
     roi_parent <- wholebrain::get.acronym.parent(rois[1])
     if(rois[i] != roi_parent){
       while(most_recent != roi_parent & most_recent_path != roi_parent){
         next_path <- wholebrain::get.acronym.parent(most_recent)
         if(grepl("-", most_recent)){
           most_recent <- gsub("-", "_", most_recent)
         }
         most_recent_path <- paste0(most_recent, "-", most_recent_path)
         most_recent <- next_path
       }
       paths <- c(paths, most_recent_path)
     }
   }
  }

  for(i in 1:length(paths)){
    if(grepl("-", paths[i]) == FALSE){
      paths[i] <- paste0(paths[i], "-end")
    }
  }
  
  #Get Cell Counts
  
  counts <- c()
  initial_counts <- get_roi(glass_dataset_exact_AP, roi=rois)
  
  for(i in 1:length(rois)){
    if(is.na(wholebrain::get.acronym.child(rois[i]))){
      new_count <- initial_counts$cell.count[i]
    }
    else{
      subregion_list_with_counts <- get_roi(glass_dataset_exact_AP, roi=c(wholebrain::get.acronym.child(rois[i])))
      subregion_count <- 0
      for (j in 1:length(subregion_list_with_counts$cell.count)){
        if(subregion_list_with_counts$acronym[j] %in% rois){
          subregion_count <- subregion_count + subregion_list_with_counts$cell.count[j]
        }
        new_count <- initial_counts$cell.count[i] - subregion_count
      }
    }
    counts <- c(counts, new_count)
  }
  
  #Get Colors
  
  colorv <- c()
  
  for(i in 1:length(rois)){
    newcolor <- wholebrain::color.from.acronym(rois[i])
    colorv <- c(colorv, newcolor)
  }
  
  rois2 <- rois
  
  for(i in 1:length(rois2)){
    if(grepl("-", rois2[i])){
      rois2[i] <- gsub("-", "_", rois2[i])
    }
  }
  
  colorv <- c(colorv, "ffffff")
  rois2 <- c(rois2, "end")
  
  #Create and Save Plots
  
  sunburst_wholebrain <- structure(list(paths, counts), Names = c("paths", "counts"), class = "data.frame", row.names = c(NA, -25L))
  sunburst_plot <- sunburstR::sunburst(sunburst_wholebrain, count = TRUE, percent = TRUE, colors = list(range = colorv, domain = rois2), legend = FALSE, breadcrumb = list(w = 65, h = 30, r = 100, s = 0))
  
  if(is.null(savepath) == FALSE) {
    file = paste0(savepath, "/sunburst.RData")
    save(sunburst_plot, file = file)
  }
}

#Example of Use

rois_sunburst(dataset = all_dataset, rois = c("CB"), parents = TRUE, savepath = "C:/Users/joeyd/Desktop/NIH/PZSA Testing/PoC - Sunburst ROIs Function")
