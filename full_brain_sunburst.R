#wholebrain and sunburstR libraries must be loaded

full_brain_sunburst <- function(dataset, savepath = NULL){
  
  
  #Set-Up
  
  paxTOallen <- function(paxinos){
    round(214+(20-(paxinos*1000))/25)
  }
  
  get_roi <- function(dataset, roi = c('MO', 'TH')){
    out <- unlist(lapply(roi, function(x)sum(dataset$acronym %in% get.sub.structure(x)) ) )
    roi.data <- data.frame(acronym = roi, cell.count = out)
    return(roi.data)
  }
  
  init_rois <- c("CH", "BS") #ROIs of choice - generally use CH and BS to get all grey matter brain regions
  
  #Assemble Nested ROIs List
  
  rois <- init_rois #The new rois list will contain all ROIs of choice plus all parent regions. This is necessary for the sunburst plot to work properly. It will also include all child regions (useful but not necessary)
  
  for(i in 1:length(init_rois)) #This code creates the new rois list by iterating through the ROIs of choice and adding all parent regions to the list until "grey" is reached, and all child regions until NA is reached
  {
    new_parent_addition <- wholebrain::get.acronym.parent(init_rois[i]) #parent regions - straightforward because it is always linear from child to parent to parent etc.
    while(new_parent_addition != "grey") #the linear path continues from the child region until it hits "grey", the last parent region (except for root)
    {
      rois <- c(rois, new_parent_addition)
      new_parent_addition <- wholebrain::get.acronym.parent(new_parent_addition)
    }
    
    new_child_additions <- wholebrain::get.acronym.child(init_rois[i]) #child regions - more complicated because there are usually multiple child regions
    next_level_additions <- c() #this is a placeholder list to temporarily hold region names
    while(length(new_child_additions) > 0) #as long as the list of new child regions exists, they will be added to rois
    {
      for(j in 1:length(new_child_additions)) #cycles through list of child regions
      {
        next_level_additions <- c(next_level_additions, wholebrain::get.acronym.child(new_child_additions[j])) #temporary list of new child regions
      }
      rois <- c(rois, new_child_additions) #add data to list
      new_child_additions <- next_level_additions
      next_level_additions <- c() #resets the list for the next loop iteration
      new_child_additions <- new_child_additions[is.na(new_child_additions) == FALSE] #if you take the child region of a region with no children, it produces NA. This code gets rid of all NAs from the list
    }
  }
  
  rois <- unique(c(rois, "grey")) #This code cleans up duplicate regions in the rois list
  rois <- rois[is.na(rois) == FALSE]
  
  #Get Paths
  
  paths <- c() #In order for the plot to know the nesting pattern, each region must contain a path to the outermost region "grey"
  
  for(i in 1:length(rois)) #This code takes each item in rois and adds its path to a list of paths
  {
    most_recent <- wholebrain::get.acronym.parent(rois[i]) #this variable stores the newest addition of the path
    most_recent_path <- rois[i] #this variable stores the entire path
    if(grepl("-", most_recent_path)){
      most_recent_path <- gsub("-", "_", most_recent_path)
    }
    if(rois[i] != "grey") #Applies to all rois except for "grey" itself
    {
      while(most_recent != "grey" & most_recent_path != "grey") # True if region and parent region are NOT grey. This code creates the path and adds it to the list of paths
      {
        next_path <- wholebrain::get.acronym.parent(most_recent)
        if(grepl("-", most_recent)){
          most_recent <- gsub("-", "_", most_recent)
        }
        most_recent_path <- paste0(most_recent, "-", most_recent_path)
        most_recent <- next_path
      }
      most_recent_path <- paste0("grey-", most_recent_path)
      paths <- c(paths, most_recent_path)
    }
    if(rois[i] == "grey") #This is necessary for the program to work properly. "grey" will be in rois every time, but the path must be "grey-end"
    {
      paths <- c(paths, "grey-end")
    }
  }
  
  #Get Counts
  
  counts <- c() #Cell counts of different regions are stored in this vector
  initial_counts <- get_roi(glass_dataset_exact_AP, roi=rois) #This gets initial cell counts of all rois (including the new subregions added to rois)
  
  for(i in 1:length(rois))
  {
    if(is.na(wholebrain::get.acronym.child(rois[i]))) #If there are no child regions that are ROIs, simply add the region to "counts"
    {
      new_count <- initial_counts$cell.count[i]
    }
    else #If there are child regions that are ROIs, subtract the ROI child region counts from the parent region count. The parent region count should only contain cells that are in the parent region but not in any child ROIs, since those are included by sunburstr
    {
      subregion_list_with_counts <- get_roi(glass_dataset_exact_AP, roi=c(wholebrain::get.acronym.child(rois[i]))) #list of child regions and cell counts
      subregion_count <- 0
      for (j in 1:length(subregion_list_with_counts$cell.count))
      {
        if(subregion_list_with_counts$acronym[j] %in% rois) #This cycles through the child regions to find those that are in rois
        {
          subregion_count <- subregion_count + subregion_list_with_counts$cell.count[j] #subregion_count contains the total number of cells in all direct child regions of the ROI
        }
        new_count <- initial_counts$cell.count[i] - subregion_count #The net count is the initial count - subregion counts
      }
    }
    counts <- c(counts, new_count) #Add the new count to the list
  }
  
  #Colors
  
  colorv <- c()
  
  for(i in 1:length(rois)) #This iterates through rois and finds the color that accompanies each region, and creates a vector of them
  {
    newcolor <- wholebrain::color.from.acronym(rois[i])
    colorv <- c(colorv, newcolor)
  }
  
  rois2 <- rois #This makes a new list of rois that contains underscores instead of hyphens, so they can be found by the same acronym they are found as in paths
  
  for(i in 1:length(rois2)){
    if(grepl("-", rois2[i])){
      rois2[i] <- gsub("-", "_", rois2[i])
    }}
  
  #To make the plots, run the code below
  
  sunburst_wholebrain <- structure(list(paths, counts), Names = c("paths", "counts"), class = "data.frame", row.names = c(NA, -25L))
  sunburst_plot <- sunburstR::sunburst(sunburst_wholebrain, count = TRUE, percent = TRUE, colors = list(range = colorv, domain = rois2), legend = FALSE, breadcrumb = list(w = 65, h = 30, r = 100, s = 0))
  
  if(is.null(savepath) == FALSE) {
    file = paste0(savepath, "/sunburst.RData")
    save(sunburst_plot, file = file)
  }          
}


full_brain_sunburst(all_dataset, "C:/Users/joeyd/Desktop/NIH/PZSA Testing/PoC - Sunburst Function")
