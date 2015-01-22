#ecoeuro program
#the data file is in the 'data' folder

library(pxR)

#read in the data
ecodata <- read.px("./data/t2020_31.px")
ecoframe <- as.data.frame(ecodata)

#shorten too long country name entries
levels(ecoframe$geo)[match("Germany (until 1990 former territory of the FRG)",
                           levels(ecoframe$geo))] <- "Germany"
levels(ecoframe$geo)[match("European Union (28 countries)",
                           levels(ecoframe$geo))] <- "European Union"

shinyServer(
    function(input, output, session) {
        
        output$plot <- renderPlot({ 
            
            #get country input
            country <- subset(ecoframe, geo == input$country)
            name <- country$geo[1]
            
            #get values
            values <- country$value[1:9]
            times <- as.numeric(as.character(country$time[1:9]))
            target <- country$value[10]
            
            #set y-axis topvalue
            topvalue <- round(target + 1, digits = 0)
            
            #how well the target has been achieved
            #fromtarget <- round((values[9] / target) * 100)
            fromtarget <- round(target - values[9], 1)
            
            #get the prediction year input
            predictyear <- as.numeric(as.character(input$prediction))
            numyear <- 9 + (predictyear - 2012)
            
            #predict by simple linear regression
            regression <- lm(values ~ times)      
            future <- predict(regression, data.frame(times = c(2013:predictyear)))
            
            #Find out when target is reached:
            future100 <- predict(regression, data.frame(times = c(2013:2063)))
            valuereached <- which(future100 > target)[1]
            reachedyear <- 2012 + as.numeric(valuereached)
            predictvalue <- future[predictyear - 2012]
            #predictfromtarget <- round((predictvalue / target) * 100)
            predictfromtarget <- round(target - predictvalue, 1)
            
            if(predictyear != 2012) {
                #add new years in x-axis and predicted values to y-axis
                times <- c(times, 2013:predictyear)
                #values <- c(values, future[1:numyear])
                startpredictx <- 9
                endpredictx <- numyear
                startpredicty <- values[9]
                endpredicty <- tail(future, n = 1)
            }
            
            #draw the plot
            plot(values, type = "l", col = "blue", ylim = c(0, topvalue), 
                 xlim = c(1, numyear), lwd = 2, ann = FALSE, axes = FALSE)
            axis(1, at = 1:numyear, labels = times)
            axis(2, las = 1, at = 2 * 0:topvalue)
            abline(h = target, col = "red", lwd = 2)
            
            #add prediction line
            if(predictyear != 2012) segments(startpredictx, startpredicty, endpredictx, 
                                             endpredicty, col = "purple", lwd = 2, lty = 2)
            
            title(main = name, xlab = "Year", ylab = "% from total energy use")
            legend("bottomright", c("Ren. energy", "Target", "Prediction"), lty = c(1, 1, 2), col = c("blue", "red", "purple"))
            
            
            output$text <- renderText({
                
                if(fromtarget <= 0){
                    paste("The figure above shows that", name, " has reached its target (the red line) of", 
                          target, "% for renewable energy use. Good for them!")
                } else {
                    paste("The figure above shows that", name, " is ", fromtarget, 
                          "percentage points away from its target of ", target, "% (the red line) for renewable energy use in 2012.")
                }
                
            }) # output text ends
            
            output$text2 <- renderText({
                if(predictyear == 2012){
                    paste("")
                } else if(predictyear >= reachedyear){
                    paste("Prediction: ", name, "has already reached the target.")
                } else 
                    paste("Prediction: In ", predictyear, name, " is still ", 
                          predictfromtarget, "percentage points away from the target.",
                          "The target will be reached in ", reachedyear, "
                          if progress continues in the same way.")
            }) # output text 2 ends   
            })
        }) #shiny server ends
