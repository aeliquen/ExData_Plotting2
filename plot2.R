#Downloading/Accessing the source Data
fileurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileurl, "Emissions.zip", method = "curl")
unzip(zipfile = "Emissions.zip")
unlink("Emissions.zip")

#read files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Get sum of emissions by year for Baltimore
baltimore <- NEI[which(NEI$fips == "24510"),]
aggregated <- aggregate(baltimore$Emissions, by=list(baltimore$year), FUN=sum, na.rm=T)

#Saving the plot
png(file = "plot2.png")
barplot(aggregated[,2],aggregated[,1],names.arg = aggregated[,1], xlab = "Year", ylab = expression("Baltimore PM"[2.5]*"Emissions"), main = expression("Total PM"[2.5]*"Emissions by Year for Baltimore, Maryland"))
dev.off()