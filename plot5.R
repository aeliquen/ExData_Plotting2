#Downloading/Accessing the source Data
fileurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileurl, "Emissions.zip", method = "curl")
unzip(zipfile = "Emissions.zip")
unlink("Emissions.zip")
library(ggplot2)

#read files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Filter motor vehicle-related-sources and prepare Data Frame
motorSCC <- SCC[grep("*vehicle*|*Vehicle*",SCC$Short.Name),]$SCC
filtered <- NEI[NEI$SCC %in% motorSCC,]
baltimore <- filtered[which(filtered$fips == "24510"),]
aggregated <- aggregate(baltimore$Emissions, by=list(baltimore$year), FUN=mean, na.rm=T)

#Saving the plot thru ggplot2
plot5 <- ggplot(aggregated, aes(y = x, x = Group.1), group = 1) + geom_point(aes(color = factor(Group.1))) + geom_line() + labs(title = expression('PM'[2.5]* "Motor Vehicle Emissions by Year"), x = "Year", y = expression('Average PM'[2.5]* "Motor Vehicle Emissions by Year")) 
ggsave("plot5.png")