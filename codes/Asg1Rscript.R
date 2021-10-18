# load libraries
library(dplyr)
library(here)
library(readxl)

# importing each data set from nhanes_demo_12_18.xlsx separately
rawdata_demo_12<-read_xlsx(here("Data","nhanes_demo_12_18.xlsx"),sheet= "demo2012")
rawdata_demo_14<-read_xlsx(here("Data","nhanes_demo_12_18.xlsx"),sheet= "demo2014")
rawdata_demo_16<-read_xlsx(here("Data","nhanes_demo_12_18.xlsx"),sheet= "demo2016")
rawdata_demo_18<-read_xlsx(here("Data","nhanes_demo_12_18.xlsx"),sheet= "demo2018")

## importing each data set from nhanes_ohx_12_18.xlsx separately
rawdata_ohx_18<-read_xlsx(here("Data","nhanes_ohx_12_18.xlsx"),sheet= "oh2018")
rawdata_ohx_16<-read_xlsx(here("Data","nhanes_ohx_12_18.xlsx"),sheet= "oh2016")
rawdata_ohx_14<-read_xlsx(here("Data","nhanes_ohx_12_18.xlsx"),sheet= "oh2014")
rawdata_ohx_12<-read_xlsx(here("Data","nhanes_ohx_12_18.xlsx"),sheet= "oh2012")

#sanity check
rawdata_demo_12 %>% select("SEQN","RIDAGEYR") %>% sapply(FUN=unique)
rawdata_demo_14 %>% select("SEQN","RIDAGEYR") %>% sapply(FUN=unique)
rawdata_demo_16 %>% select("SEQN","RIDAGEYR") %>% sapply(FUN=unique)
rawdata_demo_18 %>% select("SEQN","RIDAGEYR") %>% sapply(FUN=unique)
#THEY APPEAR TO BE CODED THE SAME

rawdata_ohx_12 %>% select("SEQN","OHDEXSTS",ends_with("CTC")) %>% sapply(FUN=unique)
rawdata_ohx_14 %>% select("SEQN","OHDEXSTS",ends_with("CTC")) %>% sapply(FUN=unique)
rawdata_ohx_16 %>% select("SEQN","OHDEXSTS",ends_with("CTC")) %>% sapply(FUN=unique)
rawdata_ohx_18 %>% select("SEQN","OHDEXSTS",ends_with("CTC")) %>% sapply(FUN=unique)
#THEY APPEAR TO BE CODED THE SAME


#adding the variable "YEAR" into the dataset
rawdata_demo_12_year<- rawdata_demo_12 %>% mutate(YEAR=2012)
rawdata_demo_14_year<- rawdata_demo_14 %>% mutate(YEAR=2014)
rawdata_demo_16_year<- rawdata_demo_16 %>% mutate(YEAR=2016)
rawdata_demo_18_year<- rawdata_demo_18 %>% mutate(YEAR=2018)

#task 6.4: Create another data set with the demographic data from all the waves joined into a long 
#format. This new data set should only have variables related to id (SEQN), year of survey(year), 
#and age of the participant (RIDAGEYR)
retrieved_demo_12<-rawdata_demo_12_year %>% select("SEQN","YEAR","RIDAGEYR")
retrieved_demo_14<-rawdata_demo_14_year %>% select("SEQN","YEAR","RIDAGEYR")
retrieved_demo_16<-rawdata_demo_16_year %>% select("SEQN","YEAR","RIDAGEYR")
retrieved_demo_18<-rawdata_demo_18_year %>% select("SEQN","YEAR","RIDAGEYR")

#merging the above retrived demo datasets
merged_demo<-bind_rows(retrieved_demo_12,retrieved_demo_14,retrieved_demo_16,retrieved_demo_18)



#Create a single data set with the oral health examination data from all the waves joined into a 
#long format. This data set should only have data from participants who completed an oral examination 
#and only include variables related to id (SEQN), and crown caries (variables that end in CTC)

retrieved_ohx_12<-rawdata_ohx_12 %>% select("SEQN","OHDEXSTS",ends_with("CTC")) %>% filter(OHDEXSTS %in% 1)
retrieved_ohx_14<-rawdata_ohx_14 %>% select("SEQN","OHDEXSTS",ends_with("CTC")) %>% filter(OHDEXSTS %in% 1)
retrieved_ohx_16<-rawdata_ohx_16 %>% select("SEQN","OHDEXSTS",ends_with("CTC")) %>% filter(OHDEXSTS %in% 1)
retrieved_ohx_18<-rawdata_ohx_18 %>% select("SEQN","OHDEXSTS",ends_with("CTC")) %>% filter(OHDEXSTS %in% 1)

# merging the above retrieved ohx data
merged_ohx<-bind_rows(retrieved_ohx_12,retrieved_ohx_14,retrieved_ohx_16,retrieved_ohx_18)


# lets merge both merged_demo and merged_ohx
merged_data<- merge(merged_demo,merged_ohx)


