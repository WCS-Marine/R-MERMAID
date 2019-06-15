#this file calculates genus and site-level bleaching summaries
library(here)
source(here::here("R", "00-load-libraries.R"))
source(here::here("R", "bleaching-surveys", "01-load-bleaching-surveys.R"))


#extract month from data
library(lubridate)
cols$date <- lubridate::ymd(cols$date)
summary(cols$date)

cols$month <- as.character(lubridate::month(cols$date))
table(cols$month)

cols <- cols %>% 
  mutate(month = fct_recode(month, 
                    "April" = "4", 
                    "May" = "5", 
                    "June" = "6"))
table(cols$month)

#calculate site-level bleaching
cols.bleach <- cols %>% 
  dplyr::select(country, site, month, latitude, longitude, 
                exposure, depth, reef_type, reef_zone, 
                management_name, management_rules,
                observer, 
                benthic_attribute, growth_form,
                normal_count:recently_dead_count) %>% 
  group_by(country, site, month, latitude, longitude, 
           exposure, depth, reef_type, reef_zone, 
           management_name, management_rules,
           observer, 
           benthic_attribute, growth_form) %>% 
  dplyr::summarize(total_cols = normal_count + pale_count + 
                     x0_20_percent_bleached_count + 
                     x20_50_percent_bleached_count + 
                     x50_80_percent_bleached_count + 
                     x80_100_percent_bleached_count + 
                     recently_dead_count,              
                   bleach_cols = total_cols - normal_count, 
                   perc_bleach = bleach_cols / total_cols * 100)

cols.bleach

hist(cols.bleach$perc_bleach)

#site-level bleaching
site.bleach <- cols.bleach %>% 
  group_by(country, site, month, latitude, longitude, 
           exposure, depth, reef_type, reef_zone, 
           management_name, management_rules,
           observer) %>% 
  dplyr::summarize(total_cols = sum(total_cols), 
                   bleach_cols = sum(bleach_cols), 
                   perc_bleach = bleach_cols / total_cols *100, 
                   n_genera = length(unique(benthic_attribute)))

site.bleach

table(site.bleach$reef_type)
table(site.bleach$reef_zone)
hist(site.bleach$depth)
table(site.bleach$management_rules)
table(site.bleach$management_name)

sum(site.bleach$total_cols)
length(unique(cols.bleach$benthic_attribute))

table(site.bleach$month)

