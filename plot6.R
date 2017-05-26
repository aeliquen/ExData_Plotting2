#Downloading/Accessing the source Data
fileurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileurl, "Emissions.zip", method = "curl")
unzip(zipfile = "Emissions.zip")
unlink("Emissions.zip")
library(ggplot2)

#read files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Filter motor vehicle-related-sources from LA & Baltimore and prepare Data Frame
motorSCC <- SCC[grep("*vehicle*|*Vehicle*",SCC$Short.Name),]$SCC
filtered <- NEI[NEI$SCC %in% motorSCC,]
subNEI <- filtered[which(filtered$fips == "06037"|filtered$fips == "24510"),]
aggregated <- aggregate(subNEI$Emissions, by=list(subNEI$year,subNEI$fips), FUN=mean, na.rm=T)
aggregated$Group.2[aggregated$Group.2=="06037"] <- "LA"
aggregated$Group.2[aggregated$Group.2=="24510"] <- "Baltimore"
names(aggregated) <- c("Year","City","Emission")

#Saving the plot thru ggplot2
plot6 <- ggplot(aggregated, aes(x=factor(Year),y=Emission, group = City)) + geom_point(aes(color = City), size = 4) + geom_line(aes(color=City)) + xlab("Year") + ylab(expression('Avg PM'[2.5]*"Emissions by City")) + ggtitle(expression('PM'[2.5]*"Emissions Comparison bet. LA & Baltimore"))
plot6 <- ggplot(aggregated, aes(y = x, x = Group.1)) + geom_point(aes(color = factor(Group.2))) + geom_line() + labs(title = expression('PM'[2.5]* "Motor Vehicle Emissions by City"), x = "Year", y = expression('Average PM'[2.5]* "Motor Vehicle Emissions by City")) 
ggsave("plot6.png")