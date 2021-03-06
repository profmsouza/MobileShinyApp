library(shiny)
# library(shinyMobile)
# library(dplyr)
# library(randomForest)
# library(caret)
# library(PRROC)
# library(sf)

inc = readRDS("inc.RDS")
model_uf = readRDS("model_UF_slim.RDS")
best_mod = readRDS("best_mod.RDS")
hans = readRDS("train.RDS") %>% as.data.frame()

###############
tabCards <- shinyMobile::f7Tab(
    tabName = "Cards",
    icon = shinyMobile::f7Icon("rectangle_stack", shinyMobile::f7Badge(8, color = "green")),
    active = FALSE,
    
    shinyMobile::f7BlockTitle(title = "shinyMobile::f7Block") %>% shinyMobile::f7Align(side = "center"),
    shinyMobile::f7Block(
        shinyMobile::f7BlockHeader(text = "Header"),
        "Here comes paragraph within content block.
     Donec et nulla auctor massa pharetra
     adipiscing ut sit amet sem. Suspendisse
     molestie velit vitae mattis tincidunt.
     Ut sit amet quam mollis, vulputate
     turpis vel, sagittis felis.",
        shinyMobile::f7BlockFooter(text = "Footer")
    ),    # update cards
    shinyMobile::f7BlockTitle(title = "updateshinyMobile::f7Card") %>% shinyMobile::f7Align(side = "center"),
    shinyMobile::f7Block(shinyMobile::f7Button(inputId = "goCard", label = "Expand card 3"))
)

###########
tabInputs <- shinyMobile::f7Tab(
    tabName = "Inputs",
    icon = shinyMobile::f7Icon("rocket_fill"),
    active = TRUE,
    
    shinyMobile::f7BlockTitle(title = "GEOGRAPHICAL INFORMATION", size = "large") %>% shinyMobile::f7Align(side = "left"),
    
    # Geographical inputs
    #shinyMobile::f7BlockTitle(title = "Region:") %>% shinyMobile::f7Align(side = "left"),
    shinyMobile::f7SmartSelect(
        inputId = "reg",
        label = "Region: ",
        choices = levels(inc$Região),
        selected = "Sudeste",
        openIn = "sheet"
    ),
    #br(),
    
    #shinyMobile::f7BlockTitle(title = "State:") %>% shinyMobile::f7Align(side = "left"),
    shinyMobile::f7SmartSelect(
        inputId = "uf",
        label = "State: ",
        choices = levels(inc$Nome_UF),
        selected = "Minas Gerais",
        openIn = "sheet"
    ),
    #br(),
    
    #shinyMobile::f7BlockTitle(title = "City:") %>% shinyMobile::f7Align(side = "left"),
    shinyMobile::f7SmartSelect(
        inputId = "cid",
        label = "City: ",
        choices = levels(inc$Nome_Município),
        selected = "Governador Valadares",
        openIn = "sheet"
    ),
    br(),
    
    shinyMobile::f7BlockTitle(title = "DEMOGRAPHIC INFORMATION", size = "large") %>% shinyMobile::f7Align(side = "left"),
    
    shinyMobile::f7BlockTitle(title = "Age:") %>% shinyMobile::f7Align(side = "left"),
    shinyMobile::f7Block(
        strong = TRUE,
        shinyMobile::f7Stepper(
            inputId = "idade",
            label = "",
            min = 0,
            color = "default",
            max = 120,
            fill = TRUE,
            rounded = TRUE,
            manual = TRUE,
            value = 20
        )
    ),
    
    shinyMobile::f7Radio(
        inputId = "sexo",
        label = "Gender:",
        choices = c("M", "F"),
        selected = "M"
    ),
    
    shinyMobile::f7Radio(
        inputId = "escol",
        label = "Education:",
        choices = c('Illiterate','Incomplete Elementary School','Complete Elementary School','Middle School','High School','Higher Education'),
        selected = 'Complete Elementary School'
    )
    
)

#############

# tabOthers <- shinyMobile::f7Tab(
#     tabName = "Others",
#     icon = shinyMobile::f7Icon("plus_circle"),
#     
#     # standalone tabs
#     shinyMobile::f7BlockTitle(title = "shinyMobile::f7Tabs") %>% shinyMobile::f7Align(side = "center"),
#     shinyMobile::f7Tabs(
#         style = "strong",
#         animated = TRUE,
#         swipeable = FALSE,
#         shinyMobile::f7Tab(
#             tabName = "Tab 1",
#             active = TRUE,
#             shinyMobile::f7Block(
#                 strong = TRUE,
#                 shinyMobile::f7BlockHeader(text = "Header"),
#                 "Here comes Tab 1.",
#                 shinyMobile::f7BlockFooter(text = "Footer")
#             )
#           )#,
#     #     shinyMobile::f7Tab(
#     #         tabName = "Tab 2",
#     #         shinyMobile::f7Block(
#     #             strong = TRUE,
#     #             shinyMobile::f7BlockHeader(text = "Header"),
#     #             "Here comes Tab 2.",
#     #             shinyMobile::f7BlockFooter(text = "Footer")
#     #         )
#     #     ),
#     #     shinyMobile::f7Tab(
#     #         tabName = "Tab 3",
#     #         shinyMobile::f7Block(
#     #             strong = TRUE,
#     #             shinyMobile::f7BlockHeader(text = "Header"),
#     #             "Here comes Tab 3.",
#     #             shinyMobile::f7BlockFooter(text = "Footer")
#     #         )
#     #     )
#     # )#,
#     
# #     # skeletons
# #     shinyMobile::f7BlockTitle(title = "shinyMobile::f7Skeleton") %>% shinyMobile::f7Align(side = "center"),
# #     shinyMobile::f7List(
# #         shinyMobile::f7ListItem(title = "Item 1"),
# #         shinyMobile::f7ListItem(title = "Item 2")
# #     ) %>% shinyMobile::f7Skeleton(duration = 5000),
# #     
# #     br(),
# #     
# #     # Badges
# #     shinyMobile::f7BlockTitle(title = "shinyMobile::f7Badge") %>% shinyMobile::f7Align(side = "center"),
# #     shinyMobile::f7Block(
# #         strong = TRUE,
# #         shinyMobile::f7Badge(32, color = "purple"),
# #         shinyMobile::f7Badge("Badge", color = "green"),
# #         shinyMobile::f7Badge(10, color = "teal"),
# #         shinyMobile::f7Badge("Ok", color = "orange")
# #     ),
# #     br(),
# #     
# #     # chips
# #     shinyMobile::f7BlockTitle(title = "shinyMobile::f7Chip") %>% shinyMobile::f7Align(side = "center"),
# #     shinyMobile::f7Block(
# #         strong = TRUE,
# #         shinyMobile::f7Chip(label = "Example Chip"),
# #         shinyMobile::f7Chip(label = "Example Chip", outline = TRUE),
# #         shinyMobile::f7Chip(label = "Example Chip", icon = shinyMobile::f7Icon("add_round"), icon_status = "pink"),
# #         shinyMobile::f7Chip(label = "Example Chip", img = "https://picsum.photos/200"),
# #         shinyMobile::f7Chip(label = "Example Chip", closable = TRUE),
# #         shinyMobile::f7Chip(label = "Example Chip", status = "green"),
# #         shinyMobile::f7Chip(label = "Example Chip", status = "green", outline = TRUE)
# #     ),
# #     br(),
# #     
# #     # accordion
# #     shinyMobile::f7BlockTitle(title = "shinyMobile::f7Accordion") %>% shinyMobile::f7Align(side = "center"),
# #     shinyMobile::f7Accordion(
# #         inputId = "accordion1",
# #         shinyMobile::f7AccordionItem(
# #             title = "Item 1",
# #             shinyMobile::f7Block("Item 1 content")
# #         ),
# #         shinyMobile::f7AccordionItem(
# #             title = "Item 2",
# #             shinyMobile::f7Block("Item 2 content")
# #         )
# #     ),
# #     shinyMobile::f7Toggle(
# #         inputId = "goAccordion",
# #         label = "Toggle accordion item 1",
# #         color = "orange"
# #     ),
# #     br(),
# #     
# #     # swiper
# #     shinyMobile::f7BlockTitle(title = "shinyMobile::f7Swiper") %>% shinyMobile::f7Align(side = "center"),
# #     shinyMobile::f7Swiper(
# #         id = "my-swiper",
# #         shinyMobile::f7Slide(
# #             plotOutput("sin")
# #         ),
# #         shinyMobile::f7Slide(
# #             plotOutput("cos")
# #         )
# #     ),
# #     
# #     br(), br(), br(),
# #     
# #     # timelines
# #     shinyMobile::f7BlockTitle(title = "shinyMobile::f7PhotoBrowser") %>% shinyMobile::f7Align(side = "center"),
# #     shinyMobile::f7Block(
# #         shinyMobile::f7PhotoBrowser(
# #             id = "photobrowser1",
# #             label = "Open",
# #             theme = "light",
# #             type = "standalone",
# #             photos = c(
# #                 "https://cdn.framework7.io/placeholder/sports-1024x1024-1.jpg",
# #                 "https://cdn.framework7.io/placeholder/sports-1024x1024-2.jpg",
# #                 "https://cdn.framework7.io/placeholder/sports-1024x1024-3.jpg"
# #             )
# #         )
# #     ),
# #     br(), br(),
# #     
# #     # timelines
# #     shinyMobile::f7BlockTitle(title = "shinyMobile::f7Timeline") %>% shinyMobile::f7Align(side = "center"),
# #     shinyMobile::f7Timeline(
# #         sides = TRUE,
# #         shinyMobile::f7TimelineItem(
# #             "Another text",
# #             date = "01 Dec",
# #             card = FALSE,
# #             time = "12:30",
# #             title = "Title",
# #             subtitle = "Subtitle",
# #             side = "left"
# #         ),
# #         shinyMobile::f7TimelineItem(
# #             "Another text",
# #             date = "02 Dec",
# #             card = TRUE,
# #             time = "13:00",
# #             title = "Title",
# #             subtitle = "Subtitle"
# #         ),
# #         shinyMobile::f7TimelineItem(
# #             "Another text",
# #             date = "03 Dec",
# #             card = FALSE,
# #             time = "14:45",
# #             title = "Title",
# #             subtitle = "Subtitle"
# #         )
# #     ),
# #     br(),
# #     
# #     # progress bars
# #     shinyMobile::f7BlockTitle(title = "shinyMobile::f7Progress") %>% shinyMobile::f7Align(side = "center"),
# #     shinyMobile::f7Block(
# #         strong = TRUE,
# #         shinyMobile::f7Progress(id = "pg1", value = 10, color = "yellow"),
# #         shinyMobile::f7Slider(
# #             inputId = "updatepg1",
# #             label = "Update progress 1",
# #             max = 100,
# #             min = 0,
# #             value = 50,
# #             scale = TRUE
# #         ),
# #         br(),
# #         shinyMobile::f7Progress(id = "pg2", value = 100, color = "green"),
# #         br(),
# #         shinyMobile::f7Progress(id = "pg3", value = 50, color = "deeppurple"),
# #         br(),
# #         shinyMobile::f7ProgressInf()
# #     ),
# #     br(),
# #     
# #     
# #     # gauges
# #     shinyMobile::f7BlockTitle(title = "shinyMobile::f7Gauge") %>% shinyMobile::f7Align(side = "center"),
# #     shinyMobile::f7Block(
# #         strong = TRUE,
# #         shinyMobile::f7Row(
# #             shinyMobile::f7Col(
# #                 shinyMobile::f7Gauge(
# #                     id = "mygauge1",
# #                     type  = "semicircle",
# #                     value = 50,
# #                     borderColor = "#2196f3",
# #                     borderWidth = 10,
# #                     valueFontSize = 41,
# #                     valueTextColor = "#2196f3",
# #                     labelText = "amount of something"
# #                 )
# #             ),
# #             shinyMobile::f7Col(
# #                 shinyMobile::f7Gauge(
# #                     id = "mygauge2",
# #                     type  = "circle",
# #                     value = 30,
# #                     borderColor = "orange",
# #                     borderWidth = 10,
# #                     valueFontSize = 41,
# #                     valueTextColor = "orange",
# #                     labelText = "Other thing"
# #                 )
# #             )
# #         ),
# #         shinyMobile::f7Stepper(
# #             inputId = "updategauge1",
# #             label = "Update gauge 1",
# #             step = 10,
# #             min = 0,
# #             max = 100,
# #             value = 50
# #         )
# #     ),
# #     
# #     # update shinyMobile::f7Panel
# #     br(),
# #     shinyMobile::f7BlockTitle(title = "updateshinyMobile::f7Panel") %>% shinyMobile::f7Align(side = "center"),
# #     shinyMobile::f7Block(
# #         shinyMobile::f7Button(
# #             inputId = "goPanel",
# #             label = "Toggle left panel"
# #         )
# #     ),
# #     br(),
# #     
# #     # preloaders
# #     shinyMobile::f7BlockTitle(title = "shinyMobile::f7ShowPreloader/shinyMobile::f7HidePreloader") %>% shinyMobile::f7Align(side = "center"),
# #     shinyMobile::f7Card(plotOutput("preloaderPlot"), shinyMobile::f7Button("showLoader", "Show loader"))
# #     
# # )
# # ###############
# # 

# Define UI for application that draws a histogram
shinyUI(
    shinyMobile::f7Page(
        title = "HansenApp v2.0",
        init = shinyMobile::f7Init(
            skin = "ios",
            theme = "light",
            filled = TRUE,
            hideNavOnPageScroll = FALSE,
            hideTabsOnPageScroll = FALSE,
            serviceWorker = "service-worker.js",
            iosTranslucentBars = FALSE,
            pullToRefresh = FALSE
        ),
        shinyMobile::f7TabLayout(
            appbar = shinyMobile::f7Appbar(
                shinyMobile::f7Flex(shinyMobile::f7Back(targetId = "tabset"), shinyMobile::f7Next(targetId = "tabset")),
                shinyMobile::f7Searchbar(id = "search1", inline = TRUE, placeholder = "")
            ),
            #messagebar = shinyMobile::f7MessageBar(inputId = "mymessagebar", placeholder = "Message"),
            panels = tagList(
                shinyMobile::f7Panel(
                    title = "Right Panel",
                    side = "right",
                    theme = "light",
                    "This application is under development and will undergo a validation step. For more information about the study that generated this tool, visit: www.jmir.org",
                    effect = "cover"
                )
            ),
            navbar = shinyMobile::f7Navbar(
                title = "HansenApp v2.0",
                subtitle = "for Shiny",
                hairline = TRUE,
                shadow = TRUE,
                left_panel = TRUE,
                right_panel = TRUE,
                bigger = TRUE,
                transparent = FALSE
            ),
            shinyMobile::f7Login(
                id = "loginPage",
                title = "You really think you can go here?",
                footer = "This section simulates an authentication process. There
        is actually no user and password database. Put whatever you want but
        don't leave blank!",
                startOpen = FALSE,
            ),
            # recover the color picker input and update the text background
            # color accordingly.
            shiny::tags$script(
                "$(function() {
          Shiny.addCustomMessageHandler('text-color', function(message) {
            $('#colorPickerVal').css('background-color', message);
          });
          // toggle message bar based on the currently selected tab
          Shiny.addCustomMessageHandler('toggleMessagebar', function(message) {
            if (message === 'chat') {
              $('#mymessagebar').show();
              $('.toolbar.tabLinks').hide();
            } else {
              $('#mymessagebar').hide();
              $('.toolbar.tabLinks').show();
            }
          });
        });
        "
            ),
            shinyMobile::f7Tabs(
                id = "tabset",
                animated = FALSE,
                swipeable = TRUE,
                tabInputs,
                #tabOthers,
                tabCards
            )
        )
     )
)
