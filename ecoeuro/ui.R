shinyUI(fluidPage(
    titlePanel("How much European countries use renewable energy?"),
    sidebarLayout(position = "right",
                  sidebarPanel(
                      helpText("Pick a country to find out how much it uses renewable energy."),
                      
                      selectInput("country", label = "Choose a country", 
                                  choices = list("Austria", "Belgium", "Bulgaria", "Croatia", "Cyprus", 
                                                 "Czech Republic", "Denmark", "Estonia", "European Union", 
                                                 "Finland", "France", "Germany", "Greece", "Hungary", 
                                                 "Ireland", "Italy", "Latvia", "Lithuania", "Luxembourg", 
                                                 "Malta", "Netherlands", "Norway", "Poland", "Portugal", 
                                                 "Romania", "Slovakia", "Slovenia", "Spain", "Sweden", 
                                                 "United Kingdom"), 
                                  selected = "European Union"),
                      
                      helpText("Want to look into the crystal ball? See how well the country will perform
                               in the future."),
                      
                      selectInput("prediction", label = "Choose a year to predict",
                                  choices = list("2012", "2013", "2014", "2015", "2016", "2017", 
                                                 "2018", "2019", "2020", "2021", "2022", "2023", "2024",
                                                 "2025", "2026", "2027", "2028", "2029", "2030", "2031",
                                                 "2032", "2033", "2034", "2035", "2036", "2037", "2038",
                                                 "2039", "2040"),
                                  selected = "2012")
                      ),
                  mainPanel(
                      plotOutput("plot"),
                      
                      textOutput("text"),
                      
                      HTML("<BR>"),
                      
                      textOutput("text2"),
                      
                      HTML("<BR><I><STRONG>Instructions:</STRONG></I> <P>Select a country from the drop-down list on
           top right to see how well it performs. The red line shows the target level and the blue line shows 
           actual figures from 2004 to 2012. Please note that the y-axis scale  
           varies between different countries, because they have different targets
           for renewable energy use.</P><P>Below the country selection box you can select a year in the 
           future (from 2012 perspective) to see how the country will perform if the development continues 
           as it has been doing between 2004 and 2012. The prediction is based on a simple linear model and shown here as a
           purple dotted line. The text also the tells the year the target would be reached.</P><P>The data
           used for the calculations comes from <A HREF=\"http://ec.europa.eu/eurostat/web/products-datasets/-/t2020_31\" target=_blank>Eurostat</A>
           Share of Renewable Energy in Gross Final Energy Consumption, code t2020_31. The dataset was downloaded from
           <A HREF=\"http://pxweb2.stat.fi/Database/Eurostat/ene/ene_en.asp\" target=_blank>Statistics Finland's site</A> and
           used here as is without modifications.</P>")
                  )
    )
))