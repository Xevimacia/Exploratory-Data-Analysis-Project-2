####### Plot 2 R code #######
# Question 2
# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008?
# Use the base plotting system to make a plot answering this question.

# Set working directory
setwd("~/Coursera") 

# Load libraries
# install.packages("reshape2") # to run this if package is not already installed
# load reshape2 tool for melt() and dcast() operations.
library(reshape2)

# Download the zip file
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
filePath <- "./data/exdata%2Fdata%2FNEI_data.zip"

# Create "data" folder if it does not exist
if (!file.exists("data")) dir.create("data")

# If zip file does not exist download it
if (!file.exists(filePath)) {
        download.file(fileUrl, destfile = filePath)
        # And unzip it
        unzip(filePath, exdir="./data")
}

# Read the data sets
NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")

# Subset NEI by Baltimore City, Maryland (fips == "24510")
BaltimoreCity <- subset(NEI, fips == "24510")

# Use melt function to convert wide data to long data
melted_BaltimoreCity = melt(BaltimoreCity, id = "year", measure.vars = "Emissions")
# to calculate sum by year using dcast() function
Total_PM25_by_Year = dcast(melted_BaltimoreCity, year ~ variable, sum)

# Prepare and make plot2
png("plot2.png")
plot(Total_PM25_by_Year$year, Total_PM25_by_Year$Emissions, type="l",
     xlab="Year", ylab=expression("Total" ~ PM[2.5] ~ "Emissions (tons)"),
     main=expression("Total" ~ PM[2.5] ~ "Emissions in Baltimore City (Maryland) by Year"),
     col="blue")
dev.off()

# Answer:
# The graph indicates a sharp decline between 1999 and 2002.
# Then, the emissions increased from 2002 to 2005.
# And, finally, emissions sharply declined from 2005 to 2008.