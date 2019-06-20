#This file maps bleaching by month
library(here)
source(here::here("R", "bleaching-surveys", "02-bleach-summaries.R"))
source(here::here("R", "bleaching-surveys", "03-bleaching-histograms.R"))
source(here::here("R", "bleaching-surveys", "04-fiji-bleaching-map.R"))

head(data)
table(data$month)

map.by.month <- ggplot() +
  geom_polygon(data = fiji, 
               aes(long, lat, group = group)) +
  coord_equal() + 
  scale_x_continuous(limits = c(176.5,181.5)) + 
  geom_point(data = data,
             aes(x = longitude, y = latitude, fill = bleach.class), 
             size = 5, shape = 21, alpha = 0.5, 
             colour = "black", 
             position = position_jitter(width = 0.05, height = 0.05)) + 
  scale_fill_manual(values = c("olivedrab3","yellow","orange","red"), 
                    "Bleached colonies", 
                    labels = c("<4%", "5-20%", "20-40%", ">40%")) +
  theme_sleek(base_size = 16) + 
  #theme(legend.position = "none") + 
  guides(fill = guide_legend(override.aes = list(alpha = 1))) + 
  xlab("Longitude") + 
  ylab("Latitude") + 
  facet_wrap(~month, nrow = 1)

map.by.month
ggsave(here::here("sample-outputs", "map by month.pdf"),
       height = 10)
