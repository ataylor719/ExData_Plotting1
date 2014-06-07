## This function takes no arguments. It creates 4 plots reflecting changes in
## global active power, voltage, energy sub-metering, and global reactive power
## over time. It saves the plots as a single PNG in the working directory.

plot4 <- function() {
        
        ## Load the household power consumption data via the load_data function
        powerdata <- load_data()
        
        ## Open png device and create plot4.png
        png(file = "plot4.png")
        
        ## Set parameter to produce a 2x2 plot
        par(mfcol = c(2, 2))
        
        # Create 1st item
        with(powerdata, plot(datetime, Global_active_power, type = "l", xlab = "",
                             ylab = "Global Active Power (kilowatts)"))
        
        # Create 2nd item
        with(powerdata, plot(datetime, Sub_metering_1, col = "transparent",
                             xlab = "",
                             ylab = "Energy sub metering"))
        with(powerdata, lines(datetime, Sub_metering_1, col = "Black"))
        with(powerdata, lines(datetime, Sub_metering_2, col = "Red"))
        with(powerdata, lines(datetime, Sub_metering_3, col = "Blue"))
        legend("topright", lty = 1, col = c("Black", "Red", "Blue"), 
               legend = (colnames(powerdata)[7:9]), bty = "n")
        
        # Create 3rd item
        with(powerdata, plot(datetime, Voltage, col = "transparent"))
        with(powerdata, lines(datetime, Voltage))
        
        # Create 4th item
        with(powerdata, plot(datetime, Global_reactive_power, col = "transparent"))
        with(powerdata, lines(datetime, Global_reactive_power))
        
        ## Close png file device
        dev.off()
}


## This function takes no arguments. It reads household power consumption data
## located in the working directory and returns a 2-day subset with date and
## time formatted for analysis. It is called from within the plot4 function.

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