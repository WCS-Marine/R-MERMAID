#this code makes histograms by bleaching 
library(here)
source(here::here("R", "bleaching-surveys", "02-bleach-summaries.R"))

data <- site.bleach
head(data)
table(data$observer)

#set bins based on cutoffs of bleaching intensity
data$bleach.class <- as.factor(ifelse(data$perc_bleach < 4, "0",
                                            ifelse(data$perc_bleach >= 4 & 
                                                     data$perc_bleach < 20, "1", 
                                                   ifelse(data$perc_bleach >= 20 & 
                                                            data$perc_bleach < 40, "2", "3"))))
table(data$bleach.class)

#use floor bleach_intensity to get integers for plot
bleach.histogram <- ggplot(data = data,
                           aes(x = floor(data$perc_bleach))) + 
  geom_histogram(aes(fill = bleach.class), 
                 colour = "black", binwidth = 2) + 
  theme_sleek(base_size = 14) +
  scale_fill_manual(values = c("olivedrab3","yellow","orange","red"), 
                    "Bleached colonies", 
                    labels = c("<4%", "5-20%", "20-40%", ">40%")) +
  xlab("Percent bleached colonies") +
  ylab("# of reefs") +
  scale_x_continuous(breaks = c(0,10,20,30,40,50,60,70,80), expand = c(0.05,0.5)) + 
  scale_y_continuous(expand = c(0,0), 
                     limits = c(0,15))

# bleach.histogram
# 
# ggsave(here::here("sample-outputs", "bleach-histogram.pdf"), 
#        height = 3, width = 6)

#summaries
names(data)
sum(data$total_cols, na.rm = TRUE)
sum(data$bleach_cols, na.rm = TRUE)

summary(data$perc_bleach)
summary(data$depth)

unique(data$reef_type)
unique(data$reef_zone)

nrow(data)
unique(data$observer)





