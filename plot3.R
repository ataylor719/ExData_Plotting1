## This function takes no arguments. It plots three lines reflecting
## changes in energy sub-metering over time. It saves the plot as a PNG in
## the working directory.

plot3 <- function() {
        
        ## Load the household power consumption data via load_data.R
        source("load_data.R")
        powerdata <- load_data()
        
        ## Open png device and create plot3.png
        png(file = "plot3.png")
        
        # Create plot and send to file
        with(powerdata, plot(datetime, Sub_metering_1, col = "transparent",
                             xlab = "",
                             ylab = "Energy sub metering"))
        with(powerdata, lines(datetime, Sub_metering_1, col = "Black"))
        with(powerdata, lines(datetime, Sub_metering_2, col = "Red"))
        with(powerdata, lines(datetime, Sub_metering_3, col = "Blue"))
        legend("topright", lty = 1, col = c("Black", "Red", "Blue"), 
               legend = (colnames(powerdata)[7:9]))
        
        ## Close png file device
        dev.off()
}


## This function takes no arguments. It reads household power consumption data
## located in the working directory and returns a 2-day subset with date and
## time formatted for analysis. It is called from within the plot3 function.

load_data <- function() {
        
        ## If the household power consumption data is not present in the
        ## working directory, download and unzip.
        datafile <- "household_power_consumption.txt"
        if(!file.exists(datafile)) {
                fileurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
                filename <- "exdata-data-household_power_consumption.zip"
                download.file(fileurl, destfile = filename, method = "curl")
                unzip(filename)
        }
        
        ## If the download or unzipping process fails to provide the right file
        ## stop the function and return an error message.
        if(!file.exists(datafile)) {
                stop("Error: household_power_consumption.txt is not in the working directory.")
        }
        
        ## Read the household power consumption table in to the environment
        powerdata <- read.table(datafile, header = TRUE, sep = ";", 
                                as.is = TRUE, na.strings = "?")
        
        ## Create logical vector identifying the dates in question as character
        ## then subset the frame based on that vector
        daterange <- powerdata$Date == "1/2/2007" | powerdata$Date == "2/2/2007"
        powersubset <- powerdata[daterange, ]
        
        ## To free up memory, remove the original table from the environment
        rm(powerdata)
        
        ## Convert the Date from character to POSIXlt
        datadate <- as.Date(powersubset$Date, "%d/%m/%Y")
        
        # Combine Date and Time, then convert to POSIXlt, POSIXt
        datetimechar <- paste(datadate, powersubset$Time)
        datetime <- strptime(datetimechar, "%F %T")
        
        # Create a character vector for the abbreviated version of the weekday
        dateday <- strftime(datetime, "%a")
        
        # Create and return a new tidy data.frame
        tidydata <- data.frame(datetime, dateday, powersubset[, 3:9], 
                               row.names = NULL)
        tidydata
}