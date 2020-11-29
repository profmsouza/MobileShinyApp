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
            messagebar = shinyMobile::f7MessageBar(inputId = "mymessagebar", placeholder = "Message"),
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
                tabOthers,
                tabCards
            )
        )
    )
)
