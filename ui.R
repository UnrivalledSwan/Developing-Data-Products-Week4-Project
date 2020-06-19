#
# This is the user-interface definition for the ballparks
# shiny application
#


library(shiny)
library(leaflet)

# Define UI for an application that shows ballparks
shinyUI(fluidPage(

    # Application title
    titlePanel("Find a Major Leage Ball Park"),

    # Sidebar with 2 select inputs for league and division
    sidebarLayout(
        sidebarPanel(
            selectInput("league", "Select a League:",
                        c("Both" = "Both",
                          "AL" = "AL",
                          "NL" = "NL")),
            selectInput("division", "Select a Division:",
                        c("All" = "All",
                          "Central" = "Central",
                          "East" = "East",
                          "West","West"))
        ),

        # Show a map and a table of data
        mainPanel(
            leafletOutput("mymap"),
            tableOutput("table")
        )
    )
))
