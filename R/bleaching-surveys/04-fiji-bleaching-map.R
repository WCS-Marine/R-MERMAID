#this code makes a map of percent bleaching over DHWs for 2019

library(here)
source(here::here("R", "bleaching-surveys", "02-bleach-summaries.R"))
source(here::here("R", "bleaching-surveys", "03-bleaching-histograms.R"))

data
nrow(data)
table(data$bleach.class)

summary(data$latitude)
summary(data$longitude)

#Setup Fiji base map dataframe from ggplot2 maps
fiji <- map_data("world2Hires", 
                 xlim = c(175,180), 
                 ylim = c(-19.5,-16))
fiji

fiji.map <- ggplot() +
  geom_polygon(data = fiji, 
               aes(x= long, y= lat, group = group)) +
  coord_equal() + 
  scale_x_continuous(limits = c(176.5,181.5)) + 
  geom_point(data = data,
             aes(x = longitude, y = latitude, fill = bleach.class), 
             size = 5, shape = 21, alpha = 0.5, 
             colour = "black", 
             position = position_jitter(width = 0.005, height = 0.005)) + 
  scale_fill_manual(values = c("olivedrab3","yellow","orange","red"), 
                    "Bleached colonies", 
                    labels = c("<4%", "5-20%", "20-40%", ">40%")) +
  theme_sleek(base_size = 18) + 
  #theme(legend.position = "none")
  guides(fill = guide_legend(override.aes = list(alpha = 1))) + 
  xlab("Longitude") + 
  ylab("Latitude")

fiji.map
ggsave(here::here("sample-outputs", "map-fiji.pdf"),
       height = 10, width = 10)




