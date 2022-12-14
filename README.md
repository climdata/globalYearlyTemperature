---
title: "Dwd Temperature"
author: "Kmicha71"
date: "19 8 2019"
output:
  html_document: 
    keep_md: true
  pdf_document: default
---



## GISS Global Temperature

https://data.giss.nasa.gov/gistemp/graphs_v4/#

Download the temperature data from nasa
https://data.giss.nasa.gov/gistemp/graphs_v4/graph_data/Hemispheric_Temperature_Change/graph.csv


```sh
serverName="https://data.giss.nasa.gov/gistemp/graphs_v4/graph_data" 
fileName="graph.csv"
for folderName in "Temperature_Anomalies_over_Land_and_over_Ocean" "Temperature_Change_for_Three_Latitude_Bands" "Hemispheric_Temperature_Change" 
do
 file="$folderName.csv"
 url="$serverName/$folderName/$fileName"
 echo "Download file: $file"
 [ -f ./download/$file ] && mv -f ./download/$file ./download/$file.bck
 wget -q -P download $url 
 ## Remove first line !!
 #tail -n +2 ./download/$fileName > ./download/$file.tmp && mv ./download/$file.tmp ./download/$file
 cat ./download/$fileName > ./download/$file.tmp && mv ./download/$file.tmp ./download/$file
 rm -f ./download/$fileName
done
```

```
## Download file: Temperature_Anomalies_over_Land_and_over_Ocean.csv
## Download file: Temperature_Change_for_Three_Latitude_Bands.csv
## Download file: Hemispheric_Temperature_Change.csv
```



```r
temp1 <- read.csv("./download/Temperature_Anomalies_over_Land_and_over_Ocean.csv", sep=",", skip = 1)
temp1 <- temp1[,c("Year","Land_Annual","Ocean_Annual")]

temp2 <- read.csv("./download/Hemispheric_Temperature_Change.csv", sep=",")
temp  <- merge(temp1,temp2, by=c("Year"))
names(temp)[names(temp) == "Year"] <- "year"
names(temp)[names(temp) == "Glob"] <- "global"
names(temp)[names(temp) == "Land_Annual"] <- "land"
names(temp)[names(temp) == "Ocean_Annual"] <- "ocean"
names(temp)[names(temp) == "NHem"] <- "north"
names(temp)[names(temp) == "SHem"] <- "south"
names(temp)[names(temp) == "X64N.90N"] <- "n72"
names(temp)[names(temp) == "X44N.64N"] <- "n54"
names(temp)[names(temp) == "X24N.44N"] <- "n34"
names(temp)[names(temp) == "EQU.24N"]  <- "n12"
names(temp)[names(temp) == "X24S.EQU"] <- "s12"
names(temp)[names(temp) == "X44S.24S"] <- "s34"
names(temp)[names(temp) == "X64S.44S"] <- "s54"
names(temp)[names(temp) == "X90S.64S"] <- "s72"



write.table(temp, file = "csv/yearly_temperature_global.csv", append = FALSE, quote = TRUE, sep = ",",
            eol = "\n", na = "NA", dec = ".", row.names = FALSE,
            col.names = TRUE, qmethod = "escape", fileEncoding = "UTF-8")
```




## Plot Temperature


```r
require("ggplot2")
```

```
## Loading required package: ggplot2
```

```r
temp <- read.csv("./csv/yearly_temperature_global.csv", sep=",")
mp <- ggplot() +
      geom_line(aes(y=temp$n72, x=temp$year), color="#ff0022") +
      geom_line(aes(y=temp$n54, x=temp$year), color="#bb0044") +
      geom_line(aes(y=temp$n34, x=temp$year), color="#880066") +
      geom_line(aes(y=temp$n12, x=temp$year), color="#440088") +
      geom_line(aes(y=temp$s12, x=temp$year), color="#004488") +
      geom_line(aes(y=temp$s34, x=temp$year), color="#008866") +
      geom_line(aes(y=temp$s54, x=temp$year), color="#00bb44") +
      geom_line(aes(y=temp$s72, x=temp$year), color="#00ff22") +
  
      xlab("Year") + ylab("Temperature ['C]")
mp
```

![](README_files/figure-html/plot-1.png)<!-- -->

```r
mp <- ggplot() +
      #geom_line(aes(y=temp$global, x=temp$year), color="cyan") +
      geom_line(aes(y=temp$ocean, x=temp$year), color="blue") +
      geom_line(aes(y=temp$land, x=temp$year), color="brown") +
      #geom_line(aes(y=temp$north, x=temp$year), color="red") +
      #geom_line(aes(y=temp$south, x=temp$year), color="green") +
  
      xlab("Year") + ylab("Temperature ['C]")
mp
```

![](README_files/figure-html/plot-2.png)<!-- -->




