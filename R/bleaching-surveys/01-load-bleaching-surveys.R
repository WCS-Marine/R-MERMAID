#this file loads source data files
library(here)
source(here::here("R", "00-load-libraries.R"))


#load bleaching survey data
#two files from MERMAID export
# 1) - bleaching colony observations 
# 2) - percent cover quadrat estimate

#percent cover quadrat estimates
obsquadratbenthicpercent <- list.files(here::here("sample-data"), 
                                       pattern = "*obsquadratbenthicpercent*", 
                                       recursive = TRUE)
obsquadratbenthicpercent

quadrats <- fread(here::here("sample-data", obsquadratbenthicpercent[1])) %>% 
  as_tibble() %>% 
  clean_names() %>% 
  dplyr::select(country, site, date, depth, observer, 
                hard_coral_percent_cover, 
                soft_coral_percent_cover, 
                macroalgae_percent_cover) %>% 
  group_by(country, site, date, depth, observer) %>% 
  dplyr::summarize(mean_hardcoral = mean(hard_coral_percent_cover), 
                   mean_softcoral = mean(soft_coral_percent_cover), 
                   mean_macroalgae = mean(macroalgae_percent_cover),
                   n_quadrats = n())

quadrats

summary(quadrats$n_quadrats)
summary(quadrats$mean_hardcoral)
summary(quadrats$mean_softcoral)
summary(quadrats$mean_macroalgae)


#bleaching colony observations 
obscoloniesbleached <- list.files(here::here("sample-data"), 
                                  pattern = "*obscoloniesbleached*", 
                                  recursive = TRUE)
obscoloniesbleached
obscoloniesbleached[1]

cols <- fread(here::here("sample-data", obscoloniesbleached[1])) %>% 
  as_tibble() %>% 
  clean_names() 
cols

names(cols)
