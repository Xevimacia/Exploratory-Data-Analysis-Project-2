####### Plot 4 R code #######
# Question 4
# Across the United States, how have emissions from coal combustion-related sources changed from 1999-2008?

# Set working directory
setwd("~/Coursera") 

# Load libraries
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

# Assumption:   The SCC levels go from generic to specific.
#               Assume that coal combustion related SCC values are the ones
#               where SCC.Level.One contains the string "coal"

# Get the row numbers containing "coal" in the SCC$Short.Name
SCC_CoalComb <- grep("coal", SCC$Short.Name, ignore.case = TRUE)

# Subset SCC with the row numbers containing containing "coal" string
SCC_CoalComb <- SCC[SCC_CoalComb, ]

# Get SCC Coal Combustion Source name to subset in NEI dataset 
SCC.CoalCombSourceName <- as.character(SCC_CoalComb$SCC)

# Subset NEI dataset based on SCC Coal Combustion Source name
NEI_CoalComb <- NEI[NEI$SCC %in% SCC.CoalCombSourceName, ]

# prepare to plot to png
png("plot4.png")
ggplot(NEI_CoalComb,aes(factor(year),Emissions)) +
        geom_bar(stat="identity",fill="grey",width=0.75) +
        theme_bw() +  guides(fill=FALSE) +
        labs(x="year", y=expression("Total PM"[2.5]*" Emission")) +
        labs(title=expression("PM"[2.5]*" Coal Combustion Source Emissions in US from 1999-2008"))
dev.off()

# Answer:
# From the histogram, we see that the Coal combustion source emissions slightly decline from 1999 to 2002.
# From 2002 to 2005 the emissions increased slightly.
# Finally, from 2005 to 2008, the emissions sharply decreased.