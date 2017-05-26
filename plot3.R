#Downloading/Accessing the source Data
fileurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileurl, "Emissions.zip", method = "curl")
unzip(zipfile = "Emissions.zip")
unlink("Emissions.zip")
library(ggplot2)

#read files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Get sum of emissions by year & type
baltimore <- NEI[which(NEI$fips == "24510"),]
aggregated <- aggregate(baltimore$Emissions, by=list(baltimore$year,baltimore$type), FUN=sum, na.rm=T)

#Saving the plot thru ggplot2
plot3 <- ggplot(aggregated, aes(y = x, x = Group.1)) + geom_point(aes(color = factor(Group.2)),size = 4) + geom_line(aes(group=Group.2, color = Group.2)) + labs(title = expression('Baltimore PM'[2.5]* "Emissions by Year & Type"), x = "Year", y = expression('Baltimore PM'[2.5]*" Emissions in tons"))
ggsave("plot3.png")