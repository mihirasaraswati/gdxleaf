library(shiny)
library(shinydashboard)

ui = shinyUI(
  
  navbarPage("Header",
             tabPanel("home",
                      tags$head(tags$script(HTML('
        var fakeClick = function(tabName) {
          var dropdownList = document.getElementsByTagName("a");
          for (var i = 0; i < dropdownList.length; i++) {
            var link = dropdownList[i];
            if(link.getAttribute("data-value") == tabName) {
              link.click();
            };
          }
        };
      '))),
                      fluidPage(
                        fluidRow(box("this 1st box should lead me to tab1a", onclick = "fakeClick('tab1a')")),
                        fluidRow(box("this 2nd box should lead me to tab1b", onclick = "fakeClick('tab1b')")),
                        fluidRow(box("this 2nd box should lead me to tab2", onclick = "fakeClick('tab2')"))
                      )
             ), 
             navbarMenu("tab1",
                        tabPanel("tab1a", "Some Text inside Tab 1a."),
                        tabPanel("tab1b", "Some Text inside Tab 1b.")
             ),
             
             tabPanel("tab2", "Some Text inside Tab 2.")
  )
)

server = function(input, output, session){}

runApp(shinyApp(ui, server), launch.browser = TRUE)