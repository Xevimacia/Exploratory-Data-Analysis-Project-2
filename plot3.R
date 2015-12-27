####### Plot 3 R code #######
# Question 3
# Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable,
# which of these four sources have seen decreases in emissions from 1999-2008 for Baltimore City?
# Which have seen increases in emissions from 1999-2008?
# Use the ggplot2 plotting system to make a plot answer this question.

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

# Subset NEI by Baltimore City, Maryland (fips == "24510")
BaltimoreCity <- subset(NEI, fips == "24510")

# Use melt function to convert wide data to long data
melted_BaltimoreCity = melt(BaltimoreCity, id = c("year","type"), measure.vars = "Emissions")
# to calculate sum by year using dcast() function
Type_PM25_by_Year = dcast(melted_BaltimoreCity, year + type ~ variable, sum)

# prepare to plot to png
png("plot3.png")
qplot(year, Emissions, data=Type_PM25_by_Year, color=type, geom ="line") +
        ggtitle(expression(PM[2.5] * " Emissions, Baltimore City 1999-2008 by Source Type")) +
        xlab("Year") +
        ylab(expression("Total" ~ PM[2.5] ~ "Emissions (tons)"))
dev.off()

# Answer:
# nonpoint emissions (green line) sharply decreased from 1999 to 2002. They remained flat from 2002 to 2005. Finally, slightly decreased between 2005 and 2008.
# Point emissions (purple line) slightly increased from 1999 to 2002. They sharply increased from 2002 to 2005. Finally, the emissions sharply decreased from 2005 to 2008.
# Onroad emissions (blue line) slightly decreased from 1999 to 2002. They remained somehow flat from 2002 to 2005. Finally, slightly decreased between 2005 and 2008.
# Nonroad emissions (red line), similarly to onroad emissions but with higher values, slightly decreased from 1999 to 2002. They remained somehow flat from 2002 to 2005. Finally, slightly decreased between 2005 and 2008.