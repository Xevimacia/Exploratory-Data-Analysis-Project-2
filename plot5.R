####### Plot 5 R code #######
# Question 5
# How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?

# Set working directory
setwd("~/Coursera") 

# Load libraries
# install.packages("reshape2") # to run this if package is not already installed
# load reshape2 tool for melt() and dcast() operations.
library(reshape2)
# install.packages("ggplot2") # to run this if package is not already installed
# powerful graphics language for creating elegant and complex plots.
library(ggplot2)

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

# Assumption:
#       "Motor Vehicles" means on road (or type = "ON-ROAD")
BaltimoreCityMotorVehicles <- subset(NEI, fips == "24510" & type == "ON-ROAD")

# Use melt function to convert wide data to long data
melted_BaltimoreCityMV = melt(BaltimoreCityMotorVehicles, id = "year", measure.vars = "Emissions")
# to calculate sum by year using dcast() function
Type_PM25_by_Year = dcast(melted_BaltimoreCityMV, year ~ variable, sum)

# prepare to plot to png
png("plot5.png")
qplot(year, Emissions, data=Type_PM25_by_Year, geom ="line") +
        ggtitle(expression("Baltimore City" ~ PM[2.5] ~ "Motor Vehicle Emissions, 1999-2008")) +
        xlab("Year") +
        ylab(expression("Total" ~ PM[2.5] ~ "Emissions (tons)"))
dev.off()

# Answer:
# In 1999, the emissions were close to 350 tons
# emission levels dropped sharply until 2002.
# From 2002 to 2005 emission levels were flat.
# Finally, from 2005 the emission levels dropped and in 2008 the levels were below 100 tons.