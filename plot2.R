if (!file.exists("data")) {
  message("Creating Dataset directory")
  dir.create("data")
}
  
  if (!file.exists("data/data_were_working_with.txt")) {
  
    # download the data
    fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    zipfile="data/electric_power_consumption.zip"
    message("Downloading data")
    download.file(fileURL, destfile=zipfile, method="curl")
    unzip(zipfile, exdir="data")
    
    message("Reading Dataset")
    data <- read.csv("data/household_power_consumption.txt", header=TRUE, sep=";", na.strings = "?", stringsAsFactors = FALSE)
    
    message("Converting Data Types")
    data$Date = as.Date(data$Date, "%d/%m/%Y")
    #data$Time = strptime(data$Time, "%H:%M:%S")
    
    message("Subsetting Dataset")
    data <- subset(data, Date >= as.Date("2007-02-01") & Date <= as.Date("2007-02-02"))
    
    #Write out the cleaned tidy data
    message("Save data to a file so we can work with it")
    write.table(data , "data/data_were_working_with.txt", row.names=FALSE)
  
  } else {
    message("Data Aready Exists, Reading from subsetted Dataset")
    data <- read.table("data/data_were_working_with.txt", header=TRUE, na.strings = "?")
  }



message("Generating Plot")
png(file="plot2.png", width=480, height=480)
days <- strptime(paste(data$Date, data$Time), "%Y-%m-%d %H:%M:%S")
with(data, plot(days, data$Global_active_power, type="l", ylab="Global Active Power (kilowatts)", xlab=""))
dev.off()
message("Plot Generated")
