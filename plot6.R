####### Plot 6 R code #######
# Question 6
# Compare emissions from motor vehicle sources in Baltimore City with emissions
# from motor vehicle sources in Los Angeles County, California (fips == "06037").
# Which city has seen greater changes over time in motor vehicle emissions?

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
BA_LA_MotorVehicles <- subset(NEI, type == "ON-ROAD" & (fips == "24510" | fips == "06037"))
BA_LA_MotorVehicles <- transform(BA_LA_MotorVehicles, Cities = ifelse(fips == "24510", "Baltimore", "Los Angeles"))

# Use melt function to convert wide data to long data
melted_BA_LA_MotorVehicles = melt(BA_LA_MotorVehicles, id = c("year","Cities"), measure.vars = "Emissions")
# to calculate sum by year using dcast() function
Type_PM25_by_Year = dcast(melted_BA_LA_MotorVehicles, year + Cities ~ variable, sum)

# prepare to plot to png
png("plot6.png")
qplot(year, Emissions, data=Type_PM25_by_Year, geom ="line", color=Cities) +
        ggtitle(expression("Baltimore and Los Angeles" ~ PM[2.5] ~ "Motor Vehicle Emissions, 1999-2008")) +
        xlab("Year") +
        ylab(expression("Total" ~ PM[2.5] ~ "Emissions (tons)"))
dev.off()

# The solution does not show well the change over time.
# To normalize it by 100% relative to 1999 values to show better the change
# Create a plot normalized to 1999 levels to better show change over time
BaltimoreEmissions1999 <- subset(Type_PM25_by_Year, year == 1999 & Cities == "Baltimore")$Emissions
LAEmissions1999 <- subset(Type_PM25_by_Year, year == 1999 & Cities == "Los Angeles")$Emissions
Type_PM25_by_YearNorm <- transform(Type_PM25_by_Year, EmissionsNorm = ifelse(Cities == "Baltimore",
                                                              100*Emissions / BaltimoreEmissions1999,
                                                              100*Emissions / LAEmissions1999))

# prepare to plot to png
png("plot6a.png")
qplot(year, EmissionsNorm, data=Type_PM25_by_YearNorm, geom ="line", color=Cities) +
        ggtitle(expression("Baltimore and Los Angeles" ~ PM[2.5] ~ "Motor Vehicle Emissions, 1999-2008")) +
        xlab("Year") +
        ylab(expression("Total" ~ PM[2.5] ~ "Emissions (tons)"))
dev.off()

# Answer:
# Plot6: As we are comparing a city with a county the absolute numbers do not show the which one has greater changes over time in motor vehicle emissions
# Plot6a: Therefore, I normalized relative to the value in 1999 in percentage
# After normalizing, we can see that Baltimore city has experienced a much larger changes over time with 75% reduction in 2008 compared to 1999.
# Baltimore experienced a sharp decline in emissions from 1999 to 2002 with about 62% reduction
# LA emissions of motor vehicles have slighlty increased from 1999 to 2008 with a peak in 2005 of 17% increase.