####### Plot 1 R code #######
# Question 1
# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
# Using the base plotting system, make a plot showing the total PM2.5 emission from all sources
# for each of the years 1999, 2002, 2005, and 2008.

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

# Use melt function to convert wide data to long data
melted_NEI = melt(NEI, id = "year", measure.vars = "Emissions")
# to calculate sum by year using dcast() function
Total_PM25_by_Year = dcast(melted_NEI, year ~ variable, sum)

# Prepare and make plot1
png("plot1.png")
plot(Total_PM25_by_Year$year, Total_PM25_by_Year$Emissions, type="l",
     xlab="Year", ylab=expression("Total" ~ PM[2.5] ~ "Emissions (tons)"),
     main=expression("Total" ~ PM[2.5] ~ "Emissions in the US by Year"),
     col="blue")
dev.off()

# Answer:
# Yes, the emissions sharply declined from 1999 to 2002.
# Then, they slowly declined between 2002 and 2005.
# And, they sharply declined from 2005 to 2008.