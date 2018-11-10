require(lattice)
library(magick)
library(viridis)
library(colormap)

setwd("C:/Joseph's Scripts and Plots/Heat Map Testing")
out_heat <- paste0("C:/Joseph's Scripts and Plots/Heat Map Testing/all_slices_test_heat ", Sys.Date())
dir.create(out_heat)

#The following values are found in glass_dataset_exact_AP

minimum_ML <- -6 #Enter the minimum ML value, rounded down to the nearest whole number
maximum_ML <-  6 #Enter the maximum ML value, rounded up to the nearest whole number
minimum_DV <- -8 #Enter the minimum DV value, rounded down to the nearest whole number
maximum_DV <-  1 #Enter the maximum DV value, rounded up to the nearest whole number

resolution <- 20 #Enter the number of points per millimeter you want to detect (across x and y axes). Increasing resolution by a factor of x increases runtime by roughly a factor of x^2.
#Recommended resolution: 15-30

#Change the following parameters to choose how large an area you would like to detect cells in
#Higher numbers -> smoother heatmap, lower precision
#Lower numbers -> spottier heatmap, higher precision
#Increasing the number will increase runtime. Recommended width/height/depth: 0.2-0.5

x_width  <- 0.3 #Enter the width of the detection square 
y_height <- 0.3 #Enter the height of the detection square 
z_depth  <- 0.3 #Enter the depth of the detection square

#Adjust legend parameters below

min_cells <- 0    #Enter the minimum number of cells - generally 0
max_cells <- 6000 #Enter the maximum number of cells based on your given parameters - round up to the nearest 1000 cells

#Set colors below

low_color  <- "white" #color to denote low cell density
high_color <- "red"   #color to denote high cell density

#If you would like to create a custom color gradient, set "custom_gradient" to TRUE, and list your colors below using #ffffff format. Otherwise, set custom_gradient to FALSE and use the color commands above
#The number of colors to list depends on min_cells and max_cells. Run a plot without the custom gradient and count how many colors are used, and make the custom gradient w/ that many colors
custom_gradient <- FALSE
#cell_colors <- c("#ffffff", "#fff7f7", "#fff0f0", "#ffe7e7", "#ffe0e0", "#ffd7d7", "#ffd0d0", "#ffc0c0", "#ffb0b0", "#ffa0a0", "#ff9090", "#ff8080", "#ff6060", "#ff4040", "#ff2020", "#ff0000")
cell_colors <- colormap() #This is to use viridis (yellow to dark blue)
# cell_colors <- viridis_pal(option = "D") #This also works to use viridis

#------------------------------------------------------Adjust code above and then run the program (all of the code)-------------------------------------

#This will output an image for every reference slice

for(m in 1:length(regi_AP)){
  
  #Make vectors of cells (one for x-coordinates, one for y-coordinates)
  
  local_AP <- all_regi[[m]]$coordinate #gets AP coordinate for the slice
  
  all_cells_x <- c()
  all_cells_y <- c()
  
  for(j in 1:length(glass_dataset_exact_AP$image)){
    if(abs(local_AP - glass_dataset_exact_AP$AP[j]) < z_depth/2){ #goes through entire cell dataset to find cells within your chosen z-depth, and adds these cells to a list
      all_cells_x <- c(all_cells_x, glass_dataset_exact_AP$ML[j])
      all_cells_y <- c(all_cells_y, glass_dataset_exact_AP$DV[j])
    }
  }
  
  #Make matrix

  cell_matrix <- matrix(c(0), ncol = (maximum_ML - minimum_ML) * resolution, nrow = (maximum_DV - minimum_DV) * resolution) #Makes matrix based on your parameters and resolution. Increasing resolution -> more rows and columns -> more points from which to detect cells
  
  rownames(cell_matrix) <- (minimum_DV * resolution + 1):(maximum_DV * resolution) #Row names and column names are purely for the tick mark labels on the axes
  colnames(cell_matrix) <- (minimum_ML * resolution + 1):(maximum_ML * resolution)
  
  #Cycle through the boxes in the matrix and find the # of local cells for each
  
  for(i in 1:nrow(cell_matrix)){
    y_estimate <- (i - 1)/resolution + minimum_DV #make it so when i = 1, y_estimate = the minimum value of DV, and y_estimate will reach the maximum value of DV when j peaks
    for(j in 1:ncol(cell_matrix)){
      x_estimate <- (j - 1)/resolution + minimum_ML #make it so when j = 1, x_estimate = the minimum value of ML, and x_estimate will reach the maximum value of ML when j peaks
      counter <- 0
      
      for(k in 1:length(all_cells_x)){ #This iterates through all cells within the chosen z-depth
        if(abs(all_cells_x[k] - x_estimate) < x_width/2 & abs(all_cells_y[k] - y_estimate) < y_height/2){ #This determines whether cells fall within the chosen x-width and y-height of each point
          counter <- counter + 1 #If the cell is within the range, add 1 to a cell counter
        }
      }
      cell_matrix[i,j] <- counter / (x_width*y_height*z_depth) #Put the # of cells into the matrix. The division by parameters is to have matrix values in cells/mm^3 regardless of your parameters
    }
  }
  
  #Make the plot
  
  if(custom_gradient == FALSE){
    cell_colors <- colorRampPalette(c(low_color, high_color), space = "rgb") #automatic color setting. If custom gradient is TRUE, the program will not run this line.
  }
  
  rotated_cell_matrix <- t(cell_matrix) #get the plot oriented properly. It's weird that we have to do it, but it's the only way I could find to orient the plot properly without fundamentally modifying the matrix creation process
  
  #This code is purely to get the axis ticks properly spaced and labeled
  
  xlabels <- round(c(seq(minimum_ML, maximum_ML, by = 1)), digits = 1)
  
  ylabels <- round(c(seq(minimum_DV, maximum_DV, by = 1)), digits = 1)

  #This code is to standardize the legend across slices
  #It will display tick marks every 250 cells, but only display a number every 1000 cells
  #We can change these numbers if we need to later
  
  colorBreaks <- seq(min_cells, max_cells, length.out = ((max_cells - min_cells) %/% 250 + 1))
  
  heatmap_colorkey <- list(at = colorBreaks, labels = list(at = colorBreaks, labels = round(colorBreaks, 1)))
  
  for(z in 1:length(heatmap_colorkey$labels$labels)){
    if((z - 1) %% 4 != 0){
      heatmap_colorkey$labels$labels[z] <- ""
    }
  }
  
  #This formula uses AP to get general atlas plate #
  
  gen_slice <- local_AP %/% -0.101145 + 54
    
  #Make and plot the plot
  
  heatmap_plot <- levelplot(rotated_cell_matrix, 
                            col.regions = cell_colors, 
                            scales = list(
                              y = list(
                                at = seq(0, nrow(cell_matrix) - nrow(cell_matrix)/(maximum_DV - minimum_DV), nrow(cell_matrix)/(maximum_DV - minimum_DV)), #makes x ticks
                                labels = ylabels),
                              x = list(
                                at = seq(0, ncol(cell_matrix) - ncol(cell_matrix)/(maximum_ML - minimum_ML), ncol(cell_matrix)/(maximum_ML - minimum_ML)), #makes y ticks
                                labels = xlabels),
                              tck = c(1,0)), #makes it so the ticks are only on the left and bottom, and not the top and right
                            main = list(paste0("Reference Slice ", gen_slice,", AP Coordinate ", round(local_AP, digits = 2))), #title
                            xlab = "Medial-Lateral (mm)", #x axis label
                            ylab = "Dorsal-Ventral (mm)", #y axis label
                            pretty = FALSE,
                            at = colorBreaks, 
                            colorkey = heatmap_colorkey)
  
  quartz() #Get plot in its own window
  print(heatmap_plot) #print the plot in the window
  
  #This code is to properly label the legend
  
  trellis.focus("legend", side="right", clipp.off=TRUE, highlight=FALSE) #legend parameters
  grid.text(expression(cells/mm^3), 0.25, 0, hjust = 0.5, vjust = 1.5) #legend parameters and name
  trellis.unfocus()

  #Save the plot
  
  savepath <- paste0(out_heat,"/reference_slice_", gen_slice,"_AP_", toString(round(regi_AP[m], digits=2)), ".png")
  curwin <- dev.cur()
  savePlot(filename = savepath, type = "png", device = curwin)
  dev.off()
  
  
} #end of the loop
