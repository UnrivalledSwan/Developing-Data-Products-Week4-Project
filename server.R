#
# This is the server logic of ballpark application

# MLB Ballparks
mlb_ballparks <- data.frame(
    lat = c(33.80029,33.89127,39.283944,42.346561,41.948314,41.829892,39.097213,41.496005,39.756175,42.339063,
            29.757041,39.051604,34.073878,25.778165,43.028232,44.981749,40.757134,40.829586,37.751619,39.906109,
            33.44542,40.446835,32.70753,47.591443,37.778324,38.622622,27.768254,32.7511,43.641256,38.872987),
    long = c(-117.882685,-84.4681,-76.621572,-71.097337,-87.655397,-87.633703,-84.506483,-81.685326,-104.99413,
             -83.048627,-95.355429,-94.480149,-118.239951,-80.219541,-87.970966,-93.278026,-73.84584,-73.926413,
             -122.200451,-75.166485,-112.066793,-80.005683,-117.157056,-122.332283,-122.389221,-90.192841,
             -82.653431,-97.0832,-79.389054,-77.007435),
    league = c('AL','NL','AL','AL','NL','AL','NL','AL','NL','AL','AL','AL','NL','NL','NL','AL','NL','AL','AL',
               'NL','NL','NL','NL','AL','NL','NL','AL','AL','AL','NL'),
    division = c('West','East','East','East','Central',
                 'Central','Central','Central','West','Central',
                 'West','Central','West','East','Central',
                 'Central','East','East','West','East',
                 'West','Central','West','West',
                 'West','Central','East','West','East','East'),
    team = c('Anaheim Angels','Atlanta Braves','Baltimore Orioles','Boston Red Sox','Chicago Cubs',
             'Chicago White Sox','Cincinnati Reds','Cleveland Indians','Colorado Rockies','Detroit Tigers',
             'Houston Astros','Kansas City Royals','Los Angeles Dodgers','Miami Marlins','Milwaukee Brewers',
             'Minnesota Twins','New York Mets','New York Yankees','Oakland As','Philadelphia Phillies',
             'Arizona Diamondbacks','Pittsburgh Pirates','San Diego Padres','Seattle Mariners',
             'San Francisco Giants','St Louis Cardinals','Tampa Rays','Texas Rangers','Toronto Blue Jays',
             'Washington Nationals'),
    info = c('Angel Stadium of Anaheim','SunTrust Park','Oriole Park at Camden Yards','Fenway Park','Wrigley Field',
             'Guarantee Rate Park','Great American Ballpark','Progressive Field','Coors Field','Comerica Park','Minute Maid Park',
             'Kauffman Stadium','Dodger Stadium','Marlins Park','Miller Park','Target Field','Citi Field',
             'New Yankee Stadium','Oakland-Alameda County Coliseum','Citizens Bank Park','Chase Field','PNC Park',
             'Petco Park','T-Mobile Park','Oracle Park','Busch Stadium','Tropicana Field','Globe Life Park',
             'Rogers Centre','Nationals Park'))

library(shiny)
library(leaflet)
library(dplyr)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    #Create a Reactive Table.  This is our working table
    tab <- reactive({ 
        
        if (input$league != "Both") {
            if (input$division != "All"){
                mlb_ballparks %>% filter(league == input$league, division == input$division) %>% arrange(league,division,team)
            }else{
                mlb_ballparks %>% filter(league == input$league) %>% arrange(league,division,team)
            }
        }else{
            if (input$division != "All"){
                mlb_ballparks %>% filter(division == input$division) %>% arrange(league,division,team)
            }else{
                mlb_ballparks %>% arrange(league,division,team)
            }  
        }
        
    })
    
    output$mymap <- renderLeaflet({
        leaflet(data=tab()) %>% 
            addTiles() %>% 
            addMarkers(clusterOptions = markerClusterOptions(),
                       label = paste(tab()$team,',',tab()$info))
        
    })
    
    #create an output table to show the results
    output$table <- renderTable({ 
        
        tab()
        
    }) #output$table
    

})
