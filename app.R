library(shiny)
library(sunburstR)
library(shinydashboard)
library(dplyr)
library(shinyjs)
library(rsconnect)
library(shinyBS)

load("data2.RData")

ui <- dashboardPage(
  
  dashboardHeader(title = "Shaham Lab",
                  titleWidth = 300),
  
  dashboardSidebar(
    width = 300,
    sidebarMenu(style = "font-size: 16px",
      menuItem("Home", tabName = "Home", icon = icon("th")),
      menuItem("Background", tabName = "Background"),
      menuItem("Data", tabName = "Wholebrain_Sunburst_Plots", icon = icon("stats", lib = "glyphicon"),
               menuItem('Naive', tabName = 'Group_1', icon = icon('line-chart'),
                      menuSubItem('Animal 1', tabName = 'Animal_1_1'),
                      menuSubItem('Animal 2 (Incomplete)', tabName = 'Animal_1_2'),
                      menuSubItem('Animal 3 (Incomplete)', tabName = 'Animal_1_3')),
               menuItem('Aggression Trained', tabName = 'Group_2', icon = icon('line-chart'),
                      menuSubItem('Animal 1 (Incomplete)', tabName = 'Animal_2_1'),
                      menuSubItem('Animal 2 (Incomplete)', tabName = 'Animal_2_2'),
                      menuSubItem('Animal 3 (Incomplete)', tabName = 'Animal_2_3')),
               menuItem('Aggression Trained (Relapse)', tabName = 'Group_3', icon = icon('line-chart'),
                      menuSubItem('Animal 1 (Incomplete)', tabName = 'Animal_3_1'),
                      menuSubItem('Animal 2 (Incomplete)', tabName = 'Animal_3_2'),
                      menuSubItem('Animal 3 (Incomplete)', tabName = 'Animal_3_3')),
               menuItem('Aggression Trained (Delay)', tabName = 'Group_4', icon = icon('line-chart'),
                      menuSubItem('Animal 1 (Incomplete)', tabName = 'Animal_4_1'),
                      menuSubItem('Animal 2 (Incomplete)', tabName = 'Animal_4_2'),
                      menuSubItem('Animal 3 (Incomplete)', tabName = 'Animal_4_3')),     
               menuItem('Aggression Trained (Delay + Relapse)', tabName = 'Group_5', icon = icon('line-chart'),
                      menuSubItem('Animal 1 (Incomplete)', tabName = 'Animal_5_1'),
                      menuSubItem('Animal 2 (Incomplete)', tabName = 'Animal_5_2'),
                      menuSubItem('Animal 3 (Incomplete)', tabName = 'Animal_5_3'))),   

  
      menuItem("Summary of Results", tabName = "Results"),
      menuItem("Contact Information & Links", tabName = "Contact")
    )),
  
  dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
    ),
    
    tabItems(
      tabItem(tabName = "Home",
              fluidRow(column(12, align = "center",
                useShinyjs(),
                br(),
                br(),
                br(),
                br(),
                br(),
                br(),
                br(),
                br(),
                br(),
                br(),
                br(),
                br(),
                h1("Project Zephyr", style = "font-size: 100pt"),
                br(),
                br(),
                h1("The Shaham Lab", style = "font-size: 70pt"),
                br(),
                br(),
                br(),
                h1("A connectomic study of appetitive aggression in CD-1 mice", style = "font-size: 40pt"),
                #HTML("<div style='height: 180px;'>"), # this is the code for the subtitle image
                #imageOutput("subtitle"),
                #HTML("</div>"),
                br(),
                br()
              ))
      ),
      
      tabItem(tabName = "Background",
              h1("Project Background", align = "center"),
              br(),
              h3("Introduction", align = "center"),
              br(),
              fluidRow(style = "font-size: 15px",
                column(3, align = "center",
                       HTML("<div style='height: 274px;'>"),
                       imageOutput("operant"),
                       HTML("</div>"),
                       br(),
                       p("Components of the operant chamber used in all experiments. The delivery magazine (second image down, right side) was used on the right side as opposed to manual intruder delivery."),
                       br(),
                       br(),
                       br(),
                       br(),
                       br(),
                       HTML("<div style='height: 181px;'>"),
                       imageOutput("cluster"),
                       HTML("</div>"),
                       br(),
                       p("Graphical depiction of the results of the cluster analysis.  Colors in the scatter plot correspond to colors in the pie chart."),
                       br(),
                       br(),
                       br(),
                       br(),
                       br(),
                       HTML("<div style='height: 182px;'>"),
                       imageOutput("transgenic"),
                       HTML("</div>"),
                       br(),
                       p("Graphical depiction of the creation of the transgenic F1 hybrid mouse line."),
                       br(),
                       br(),
                       br(),
                       br(),
                       br(),
                       HTML("<div style='height: 381px;'>"),
                       imageOutput("pipeline"),
                       HTML("</div>"),
                       br(),
                       p("Graphical abstract of the WholeBrain pipeline."),
                       br(),
                       br(),
                       br(),
                       br(),
                       br(),
                       HTML("<div style='height: 279px;'>"),
                       imageOutput("sample_segmentation"),
                       HTML("</div>"),
                       br(),
                       p("Segmentation results for a sample coronal brain slice. Cells are shown as dots.")
                       ),
                column(6, 
                       p("Aggression is evolutionarily advantageous, critical to survival, and well-conserved across species. However, voluntarily seeking aggression against 
                         members of one's own species, and finding the experience reinforcing, has been described as an almost entirely human 
                         occurrence. We have modeled this phenomenon in mice and documented our results", a(href = "https://www.sciencedirect.com/science/article/pii/S0006322317313598?via%3Dihub", "here.")),
                       h3("Compulsive Addiction-Like Aggression", align = "center"),
                       br(),
                       p("For our first 3 experiments, documented in greater detail in the link above, we trained CD-1 mice (an aggressive breed) to lever press for opportunities to attack younger C57 mice. The experiments were conducted in operant chambers. In experiment 1, 32 mice were trained for aggression self-administration for 9 days with rest days interspersed between training days. During each of the 20 daily trials, a red house light was turned on. If the CD-1 mouse in the chamber pressed the lever, two things occurred: first, a tone cue was played. This cue was used as a discriminative stimulus for the mice to associate with lever pressing. After the cue was played, the magazine door opened to release a C57 mouse. It is important to note that we removed the C57 mouse as soon as the CD-1 attacked, to minimize the risk of injury. Out of the 32 CD-1 mice, 26 of them successfully acquired self-administration."),
                       p("After self-administration, the successful mice were then divided into two groups: one group was tested for relapse immediately after completion, while the other group was tested after a 15-day delay. During the relapse test, the mice were given cues associated with aggression, including the operant chamber and red house light. They were given the opportunity to press two different levers: one of them activated the tone cue (active lever), and the other did nothing (inactive lever). Neither lever dispensed a C57 mouse. The number of lever presses was recorded, and both groups of mice significantly preferred the active lever to the inactive one. This suggested that the mice did successfully relapse."),
                       p("In experiment 2, 54 mice were trained for aggression self-administration just like in experiment 1. 31 of these 54 mice successfully acquired self-administration. In this experiment, the self-administration period was followed by a punishment-induced suppression period. These trials were similar to the self-administration ones, with one key caveat: 50% of lever presses resulted in an electric footshock. The intensity of this shock increased as the 10-day suppression period went on, and lever presses decreased significantly. Following punishment-induced suppression, the mice were divided into two groups and tested for relapse to aggression-seeking: 16 mice were tested 3 times (immediately, after 15 days, and after 35 days), and the other 15 mice were tested twice (after 15 days and after 35 days). These relapse tests were identical to those in experiment 1. On day 1 (group 1) and day 15 (both groups), there was no significant difference between active and inactive lever presses. On day 35 (both groups), the active lever was pressed significantly more than the inactive lever, suggesting that the punishment-induced suppression of aggression seeking had subsided."),
                       p("In experiment 3, 60 mice were trained for aggression self-administration, like in the previous experiments. A larger cohort was used in an effort to discern differences between individuals in the cohort. 43 of the 60 mice successfully acquired self-administration. Following self-administration, the mice entered a 14-day voluntary suppression period. During this time, two levers were extended: one of them deployed a C57 mouse, and the other one dispensed a palatable food reward. Mice were forced to choose between the two, and the tests showed they strongly preferred the food. Both house lights were on at the start of the test, but only the light associated with the action of choice (blue for food, red for aggression) remained on after the lever was pressed. The aggression lever triggered a sound cue, while the food reward triggered a light cue. Out of the 43 aggressive mice, 17 underwent relapse tests before and after the voluntary suppression period. Neither intruder nor food was dispensed, but the appropriate cues were given. In both tests, the mice significantly preferred the active lever to the inactive one."),
                       p("Following this period, all 43 mice were tested under the progressive ratio schedule for both food and aggression self-administration. Each progressive ratio session began with the illumination of the appropriate house light (aggression or food), and the extension of the appropriate lever. Pressing the lever granted the proper reward, but the number of presses required for a reward increased as the test went on (e.g. 40 lever presses were required for the 10th reward). The results of this test further suggested that the mice preferred food to aggression. The progressive ratio period was followed by a 7-day punishment-induced suppression period. Just like in experiment 2, shock intensity increased over time, and lever presses decreased."),
                       p("Based on their results, the data of 41 of the 43 successful mice were analyzed via two unsupervised cluster analysis algorithms: TwoStep (BIC) and Hierarchical (C-H). Two of the mice were excluded, as they were more than 2.5 standard deviations and 3 median absolute deviations from the five-dimensional centroid of the sample. Both of the clustering algorithms broke the cohort into two groups, only disagreeing one one mouse. Out of the entire 60-mouse sample, 29% were deemed non-aggressive, 19% termed 'compulsive aggression seeking', and the remaining 52% called 'typical aggression seeking'."),
                       hr(),
                       h3("Nucleus Accumbens Cell-Type Specific Modulation", align = "center"),
                       br(),
                       p("The purpose of the next part of the project was to determine whether the nucleus accumbens, the part of the brain known to govern reward seeking, is involved in appetitive aggression seeking, and if so, which neurons in the accumbens play a role. The first step was to generate a transgenic hybrid mouse line. An outbred CD-1 mouse was crossed with a C57 D1- or D2- Cre transgenic mouse, to produce a transgenic F1 hybrid. The purpose of the hybrid line is to combine the Cre transgene from the C57 mice with the aggressive nature of the CD-1 mice. A resident-intruder test was performed on these hybrid mice to test their aggression. In these tests, an intruder C57 mouse was placed in the home cage of a CD-1, and latency to attack was measured. Both CD-1 x C57 D1-Cre and CD-1 x C57 D2-Cre hybrids were roughly as aggressive as the original strain of CD-1s. Following this test, they were trained for aggression self-administration for 7 days and tested for relapse. Their results were similar to those of purebred CD-1 mice in part 1, albeit slightly lower across the board."),
                       p("Following this validation of the hybrid mice, they were tested for susceptibility to clozapine-induced behavioral changes. The mice were trained for aggression self-administration for 7 days, and then tested under the same conditions as their training sessions, with one caveat: they were administered clozapine prior to the test. When the clozapine dose was 0.2 mg/kg or less, their behavior remained unchanged. However, a dose of 1 mg/kg caused nearly complete abstinence, providing validation that clozapine is not behaviorally inert."),
                       p("To determine whether D1-MSNs, D2-MSNs, or both played a role in aggression seeking, subsets of both cohorts of mice were injected with a virus containing an inhibitory DREADD (hM4Di) that is activated by clozapine. After training all of the mice for self-administration, and administering them a 0.1 mg/kg dose of clozapine, they were tested for aggression seeking. Only the CD-1 x C57 D1-Cre mice showed reduced aggression seeking, suggesting that D1-MSNs in the accumbens play a role in compulsive aggression seeking."),
                       hr(),
                       h3("WholeBrain: A Connectomic Perspective", align = "center"),
                       br(),
                       p("After determining this, we shifted our focus to a connectomic view of the brain. A cohort of mice was divided into five groups."),
                       tags$ol(
                         tags$li("Naive"),
                         tags$li("Aggression self-administration"),
                         tags$li("Aggression self-administration (delayed perfusion)"),
                         tags$li("Day 15 relapse"),
                         tags$li("Day 15 relapse (delayed perfusion)")
                       ),
                       p("Groups 2 and 3 were harvested 90 minutes after the activity, when fos signals peaked. The purpose of delaying perfusion (by 24 hours) in groups 4 and 5 was to give fos time to degrade. Once the brains were perfused, they were stained for fos with mCherry and cleared via iDisco+ to remove lipids and grant them translucence. They were subsequently coronally imaged in two channels (488 nm, for autofluorescence, and 599 nm, for c-Fos) via light-sheet fluorescent microscopy. Allen Mouse Brain Atlas plates were manually overlaid onto brain slices every 100 microns, allowing accurate determination of how many cells are contained in each region."),
                       p("After this step, known as registration, was complete, an automated segmentation algorithm determined whether signals in the fos channel were cells are not. The parameters could be manually adjusted, but this automated segmentation removed the need to manually count cells. Following segmentation, the atlas plates adjusted during registration were forward-warped onto unmodified atlas plates to determine where in the brain segmented cells were located. This step provided the data used in the sunburst plots (made using sunburstR), data tables, and 'glass' brains."),
                       p("This project is still in progress, and results will be posted to the Results page when data collection is complete.")
                       ),
                column(3, align = "center",
                       HTML("<div style='height: 285px;'>"),
                       imageOutput("interior"),
                       HTML("</div>"),
                       br(),
                       p("An image of the interior of an operant chamber."),
                       br(),
                       br(),
                       br(),
                       br(),
                       br(),
                       HTML("<div style='height: 332px;'>"),
                       imageOutput("intruder"),
                       HTML("</div>"),
                       br(),
                       p("The magazine stores intruder C57 mice before they are pushed, with the flag (pictured sticking out of slot), into the operant chamber. New mice are loaded in through the door at the top."),
                       br(),
                       br(),
                       br(),
                       br(),
                       br(),
                       HTML("<div style='height: 212px;'>"),
                       imageOutput("clozapine"),
                       HTML("</div>"),
                       br(),
                       p("Images of the mouse brain after CNO administration, vs after clozapine administration."),
                       br(),
                       br(),
                       br(),
                       br(),
                       br(),
                       HTML("<div style='height: 143px;'>"),
                       imageOutput("histological"),
                       HTML("</div>"),
                       br(),
                       p("Histological validation of hybrid mice."),
                       br(),
                       br(),
                       br(),
                       br(),
                       br(),
                       HTML("<div style='height: 214px;'>"),
                       imageOutput("sample_registration"),
                       HTML("</div>"),
                       br(),
                       p("Manually adjusted registration plate for a sample coronal brain slice."))
                )),
      
      tabItem(tabName = "Animal_1_1",
              tabsetPanel(type = "tabs",
                          tabPanel("Data",
                                   fluidRow(
                                     column(6, align = "center", #style = "border-right: 4px solid; border-left: 4px solid; border-bottom: 4px solid; border-top: 4px solid; padding: 10px",
                                            tabsetPanel(type = "tabs",
                                                        tabPanel("Sunburst Plot",
                                                                 box(id ="sunburst_box_1_1", align = "left", width = "auto",
                                                                     br(),
                                                                     sunburstOutput("sunburst_plot", height = "500px"),
                                                                     br(),
                                                                     p("This is a sunburst plot containing all of the fos-positive cells in the brain. Mouse over a region to see its identity, parent regions, and cell count. Regions are colored based on their color in the Allen Mouse Brain Atlas, and arc lengths are proportional to regional cell counts. For more detailed data, use the 'Cell Count Data Table' tab.", align = "center")
                                                                 )),
                                                        tabPanel("Cell Count Data Table",
                                                                 br(),
                                                                 span(DT::dataTableOutput("table_1_1"), style = "color: grey"),
                                                                 br(),
                                                                 p("This table contains the cell counts used to generate the plot. Click the title of any column to sort the data, and type any abbreviation into the search bar to quickly find its cell count. To download this data table, use the 'Data Download' tab.", align = "center")
                                                        ),
                                                        tabPanel("Data Download",
                                                                 br(),
                                                                 h3("Data Download Tutorial"),
                                                                 br(),
                                                                 tags$ol(align = "left",
                                                                         tags$li("Click 'Download Data Table' above and save it in a folder of choice."), 
                                                                         tags$li("Open the data as an Excel document, saying 'yes' if a pop-up window asks if you would like to open it. The data should all be in the left column, separated by commas."), 
                                                                         tags$li("Highlight the entire first column (this can be done by clicking the column label) and click 'Text to Columns' under the 'Data' tab."),
                                                                         tags$li("Select 'Delimited' and click 'Next'."),
                                                                         tags$li("Select 'Comma' as the delimiter and click 'Finish'."),
                                                                         tags$li("Save the file as an Excel document. From this format, it can be exported as a .csv file.")),
                                                                 downloadButton("download_table_1_1", 'Download Data Table')
                                                                 
                                                        )
                                                        
                                            )
                                            
                                     ),
                                     column(6, align = "center", #style = "border-right: 4px solid; border-bottom: 4px solid; border-top: 4px solid; border-left: 4px solid; padding: 10px;",
                                            tabsetPanel(type = "tabs",
                                                        tabPanel("Description",
                                                                 h2("Animal Description and Behavioral Data"),
                                                                 br(),
                                                                 p("This animal is the", strong("first"),"animal in the", strong("naive"), "group, meaning it was not tested before being perfused in its home cage."
                                                                  )),
                                                        tabPanel("Glass Brain",
                                                                 br(),
                                                                 HTML("<div style='height: auto;'>"),
                                                                 imageOutput("glassbrain_1_1"),
                                                                 HTML("</div>"),
                                                                 br(),
                                                                 br(),
                                                                 br(),
                                                                 hr(),
                                                                 p("The spinning glass brain is a visual representation of the cells in the brain, with spatial precision. Cells are colored based on their region in the Allen Mouse Brain Atlas (and the sunburst plot).")),
                                                        tabPanel("Registrations",
                                                                 br(),
                                                                 HTML("<div style='height: auto;'>"),
                                                                 imageOutput("registration_1_1"),
                                                                 HTML("</div>"),
                                                                 sliderInput("registration_slide_number_1_1", label = "Pick a slice", 34, 103, 70),
                                                                 actionButton("registration_button", "Expand Image"),
                                                                 bsModal("regi", "Registration", "registration_button", size = "large", imageOutput("registration_1_1_2")),
                                                                 hr(),
                                                                 p("This shows all of the manually adjusted registration plates used to determine region boundaries. Registration plates are 100 microns apart (oriented coronally).")),
                                                        tabPanel("Segmentations",
                                                                 br(),
                                                                 HTML("<div style='height: auto;'>"),
                                                                 imageOutput("segmentation_1_1"),
                                                                 HTML("</div>"),
                                                                 br(),
                                                                 br(),
                                                                 br(),
                                                                 br(),
                                                                 br(),
                                                                 sliderInput("segmentation_slide_number_1_1", label = "Pick a slice", 34, 103, 70),
                                                                 actionButton("segmentation_button", "Expand Image"),
                                                                 bsModal("seg", "Segmentation", "segmentation_button", size = "large", imageOutput("segmentation_1_1_2")),
                                                                 hr(),
                                                                 p("This shows segmentation results every 100 microns throughout the brain.")),
                                                        tabPanel("Forward Warp",
                                                                 br(),
                                                                 HTML("<div style='height: auto;'>"),
                                                                 imageOutput("forward_warp_1_1"),
                                                                 HTML("</div>"),
                                                                 sliderInput("forward_warp_slide_number_1_1", label = "Pick a slice", 34, 103, 70),
                                                                 actionButton("forward_warp_button", "Expand Image"),
                                                                 bsModal("fw", "Forward Warp", "forward_warp_button", size = "large", imageOutput("forward_warp_1_1_2")),
                                                                 hr(),
                                                                 p("The atlas image (and segmented cells) are warped to fit the modified atlas plate on the registration image. Z-slices are shown every 25 microns.")),
                                                        tabPanel("Heat Maps", 
                                                                 br(),
                                                                 HTML("<div style='height: auto;'>"),
                                                                 imageOutput("heatmap_1_1"),
                                                                 HTML("</div>"),
                                                                 br(),
                                                                 br(),
                                                                 br(),
                                                                 br(),
                                                                 br(),
                                                                 sliderInput("heatmap_slide_number_1_1", label = "Pick a slice", 34, 103, 70),
                                                                 actionButton("heatmap_button", "Expand Image"),
                                                                 bsModal("heatmap", "Heatmap", "heatmap_button", size = "large", imageOutput("heatmap_1_1_2")),
                                                                 hr(),
                                                                 p("This shows heat maps every 100 microns throughout the brain."))
                                            ),
                                            tags$head(tags$style(
                                              type="text/css",
                                              "#glassbrain_1_1 img {max-width: 70%; width: 70%; height: auto}"
                                            )),
                                            tags$head(tags$style(
                                              type="text/css",
                                              "#registration_1_1 img {max-width: 90%; width: 90%; height: auto}"
                                            )),
                                            tags$head(tags$style(
                                              type="text/css",
                                              "#segmentation_1_1 img {max-width: 70%; width: 70%; height: auto}"
                                            )),
                                            tags$head(tags$style(
                                              type="text/css",
                                              "#forward_warp_1_1 img {max-width: 90%; width: 90%; height: auto}"
                                            )),
                                            tags$head(tags$style(
                                              type="text/css",
                                              "#heatmap_1_1 img {max-width: 70%; width: 70%; height: auto}"
                                            ))
                                     ))
                                   ),
                          
                          tabPanel("Explorer")
                          )
              
              
                  
              ),
      
      tabItem(tabName = "Results",
              h1("Results", align = "center"),
              h3("TBD")
              
              ),
      
      tabItem(tabName = "Contact",
              h1("Contact Us", align = "center"),
              br(),
              fluidRow(
                column(3, offset = 3,
                       br(),
                       imageOutput("sam"),
                       br()),
                column(3,
                       h3("Sam A. Golden, Ph.D."),
                       h4("Assistant Professor, Tenure Track"),
                       h4("Dr. Golden received his BS in Neuroscience from Bates College (Lewiston, ME) in 2006, PhD in Neuroscience from the Icahn School of Medicine (New York City, NY) in 2015 under Dr. Scott J. Russo, and completed in Postdoctoral Fellowship at the National Institute on Drug Abuse (Baltimore, MD) in 2018 under Dr. Yavin Shaham.  Dr. Golden joined the University of Washington Department of Biological Structure in 2019, with a co-appointment as a participating faculty in the The UW Center of Excellence in Neurobiology of Addiction, Pain, and Emotion (NAPE)."),
                       h4(a(href = "https://static1.squarespace.com/static/5b1b659871069912b3022368/t/5b4e7ba688251bb298c8ceb4/1531870119543/Golden+Sam+-+CV+-+UW+-+July+2018.pdf", "Curricululm Vitae"), " - ", a(href = "mailto:sagolden@uw.edu", "Email"), " - ", a(href = "https://scholar.google.com/citations?user=fcR9Oa4AAAAJ&hl=en", "Google Scholar"), " - ", a(href = "https://www.ncbi.nlm.nih.gov/pubmed/?term=golden+sa", "PubMed"), " - ", a(href = "https://www.researchgate.net/profile/Sam_Golden", "ResearchGate"), " - ", a(href = "https://twitter.com/GoldenNeuron", "Twitter"))
                       )),
              hr(),
              br(),
              h1("Links", align = "center"),
              br(),
              br(),
              fluidRow(
                column(4, offset = 2,
                  h4(a(href = "https://www.sciencedirect.com/science/article/pii/S0006322317313598?via%3Dihub", "Compulsive Addiction-like Aggressive Behavior in Mice")),
                  h4(a(href = "https://www.wholebrainsoftware.org/", "Download WholeBrain")),
                  h4(a(href = "https://www.rstudio.com/products/shiny/", "Download RShiny")),
                  h4(a(href = "https://goldenneurolab.com/", "Golden Lab")),
                  h4(a(href = "https://irp.drugabuse.gov/staff-members/yavin-shaham/", "Shaham Lab"))
                ),
                column(3, 
                       imageOutput("GFP"))
              ))

) #end tabItems
) #end dashboardBody
) #end dashboardPage


server <- function(input, output) { #This section designs the server-side aspect
  
  #Make Front Page
  output$title_image <- renderImage({
    return(list(
      src = "www/title_image.png",
      contentType = "image/png",
      width = 1400,
      height = 275,
      alt = "Title Image"))}, deleteFile = FALSE)
  
  output$subtitle <- renderImage({
    return(list(
      src = "www/subtitle.png",
      contentType = "image/png",
      width = 1015,
      height = 180,
      alt = "Subitle Image"))}, deleteFile = FALSE)
  
  output$side_image <- renderImage({
    return(list(
      src = "www/side_image.png",
      contentType = "image/png",
      width = 360,
      alt = "Cleared Brain"))}, deleteFile = FALSE)
  
  #Make Background Page
  
  output$operant <- renderImage({
    return(list(
      src = "www/operant.jpg",
      contentType = "image/jpg",
      width = 320,
      alt = "Operant Chamber"))}, deleteFile = FALSE)
  
  output$cluster <- renderImage({
    return(list(
      src = "www/cluster.JPG",
      contentType = "image/jpg",
      width = 320,
      alt = "Cluster Analysis"))}, deleteFile = FALSE)
  
  output$transgenic <- renderImage({
    return(list(
      src = "www/transgenic.jpg",
      contentType = "image/jpg",
      width = 320,
      alt = "Transgenic Hybrid Cross"))}, deleteFile = FALSE)
  
  output$pipeline <- renderImage({
    return(list(
      src = "www/pipeline.JPG",
      contentType = "image/jpg",
      width = 320,
      alt = "WholeBrain Pipeline"))}, deleteFile = FALSE)
  
  output$sample_segmentation <- renderImage({
    return(list(
      src = "www/sample_segmentation.JPG",
      contentType = "image/jpg",
      width = 320,
      alt = "Sample Segmentation"))}, deleteFile = FALSE)
  
  output$interior <- renderImage({
    return(list(
      src = "www/interior.jpg",
      contentType = "image/jpg",
      width = 320,
      alt = "Interior"))}, deleteFile = FALSE)
  
  output$intruder <- renderImage({
    return(list(
      src = "www/intruder.png",
      contentType = "image/png",
      width = 320,
      alt = "Intruder"))}, deleteFile = FALSE)
  
  output$clozapine <- renderImage({
    return(list(
      src = "www/clozapine.jpg",
      contentType = "image/jpg",
      width = 320,
      alt = "Clozapine vs CNO"))}, deleteFile = FALSE)
  
  output$histological <- renderImage({
    return(list(
      src = "www/histological.jpg",
      contentType = "image/jpg",
      width = 320,
      alt = "Histological Validation"))}, deleteFile = FALSE)

  output$sample_registration <- renderImage({
    return(list(
      src = "www/sample_registration.JPG",
      contentType = "image/jpg",
      width = 320,
      alt = "Sample Registration"))}, deleteFile = FALSE)
  
  #Make Contacts Page
  
  output$sam <- renderImage({
    return(list(
      src = "www/sam.jpg",
      contentType = "image/jpg",
      width = 360,
      alt = "Sam"))}, deleteFile = FALSE)
  
  output$GFP <- renderImage({
    return(list(
      src = "www/GFP2.png",
      contentType = "image/png",
      width = 360,
      alt = "GFP Brain"))}, deleteFile = FALSE)
  
  #Make Table

  output$table_1_1 = DT::renderDataTable({myTable})
  observeEvent(input$data_button_1_1, {
    shinyjs::toggle("data_box_1_1")})
  
  observeEvent(input$data_tutorial_button, {
    shinyjs::toggle("data_tutorial_box")})
  
  output$download_table_1_1 <- downloadHandler(filename = function() {paste("data-", Sys.Date(), ".csv", sep="")}, content = function(file){write.csv(myTable, file)})

  output$sunburst_plot <- renderSunburst({sunburst_plot})
  
 # Make Glass Brains

  output$glassbrain_1_1 <- renderImage({
    return(list(
      src = "www/small_glassbrain_1_1.gif",
      contentType = "image/gif",
      alt = "Spinning WholeBrain"))}, deleteFile = FALSE)

  registration_1_1_img_src <- reactive({paste0("www/registrations_1_1/registration_plate_", input$registration_slide_number_1_1, ".png")})
  
  observeEvent(input$registration_slide_number_1_1,{
    output$registration_1_1 <- renderImage({
      return(list(
        src = registration_1_1_img_src(),
        contentType = "image/png",
        alt = "Registrations"))}, deleteFile = FALSE)
    output$registration_1_1_2 <- renderImage({
      return(list(
        src = registration_1_1_img_src(),
        contentType = "image/png",
        width = "1300",
        alt = "Registrations"))}, deleteFile = FALSE)
  })
  
  segmentation_1_1_img_src <- reactive({paste0("www/segmentations_1_1/registration_plate_", input$segmentation_slide_number_1_1, ".png")})
  
  observeEvent(input$segmentation_slide_number_1_1,{
    output$segmentation_1_1 <- renderImage({
      return(list(
        src = segmentation_1_1_img_src(),
        contentType = "image/png",
        alt = "Segmentations"))}, deleteFile = FALSE)
    output$segmentation_1_1_2 <- renderImage({
      return(list(
        src = segmentation_1_1_img_src(),
        contentType = "image/png",
        width = "800",
        alt = "Segmentations"))}, deleteFile = FALSE)
  })
  
  forward_warp_1_1_img_src <- reactive({paste0("www/forward_warp_1_1/registration_plate_", input$forward_warp_slide_number_1_1, ".png")})
  
  observeEvent(input$forward_warp_slide_number_1_1,{
    output$forward_warp_1_1 <- renderImage({
      return(list(
        src = forward_warp_1_1_img_src(),
        contentType = "image/png",
        alt = "Forward Warp"))}, deleteFile = FALSE)
    output$forward_warp_1_1_2 <- renderImage({
      return(list(
        src = forward_warp_1_1_img_src(),
        contentType = "image/png",
        width = "1300",
        alt = "Forward Warp"))}, deleteFile = FALSE)
  })
  
  heatmap_1_1_img_src <- reactive({paste0("www/heatmaps_1_1/reference_slice_", input$heatmap_slide_number_1_1, ".png")})
  
  observeEvent(input$heatmap_slide_number_1_1,{
    output$heatmap_1_1 <- renderImage({
      return(list(
        src = heatmap_1_1_img_src(),
        contentType = "image/png",
        alt = "Heat Map"))}, deleteFile = FALSE)
    output$heatmap_1_1_2 <- renderImage({
      return(list(
        src = heatmap_1_1_img_src(),
        contentType = "image/png",
        width = "800",
        alt = "Heat Map"))}, deleteFile = FALSE)
  })
}

shinyApp(ui = ui, server = server)
